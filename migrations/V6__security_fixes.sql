-- LMS Security Fixes

ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS courses_access ON courses;
DROP POLICY IF EXISTS enrollments_self_access ON enrollments;
DROP POLICY IF EXISTS submissions_self_access ON submissions;
DROP POLICY IF EXISTS grades_access ON grades;

CREATE POLICY courses_select_all
ON courses
FOR SELECT
USING (
    current_setting('app.role', true) IN ('student', 'instructor', 'admin')
);

CREATE POLICY courses_modify_own
ON courses
FOR ALL
USING (
    instructor_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
)
WITH CHECK (
    instructor_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
);

CREATE POLICY lessons_access
ON lessons
FOR SELECT
USING (
    current_setting('app.role', true) IN ('student', 'instructor', 'admin')
);

CREATE POLICY assignments_access
ON assignments
FOR SELECT
USING (
    current_setting('app.role', true) IN ('student', 'instructor', 'admin')
);

CREATE POLICY submissions_access
ON submissions
FOR SELECT
USING (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
    OR (
        current_setting('app.role', true) = 'instructor'
        AND EXISTS (
            SELECT 1
            FROM assignments a
            JOIN courses c ON c.course_id = a.course_id
            WHERE a.assignment_id = submissions.assignment_id
            AND c.instructor_id = current_setting('app.user_id', true)::BIGINT
        )
    )
);

CREATE POLICY submissions_insert_own
ON submissions
FOR INSERT
WITH CHECK (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
);

CREATE POLICY submissions_update_own
ON submissions
FOR UPDATE
USING (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
)
WITH CHECK (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
);

CREATE POLICY submissions_delete_own
ON submissions
FOR DELETE
USING (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
);

CREATE POLICY grades_select
ON grades
FOR SELECT
USING (
    current_setting('app.role', true) = 'admin'
    OR EXISTS (
        SELECT 1
        FROM submissions s
        WHERE s.submission_id = grades.submission_id
        AND s.user_id = current_setting('app.user_id', true)::BIGINT
    )
    OR (
        current_setting('app.role', true) = 'instructor'
        AND EXISTS (
            SELECT 1
            FROM submissions s
            JOIN assignments a ON a.assignment_id = s.assignment_id
            JOIN courses c ON c.course_id = a.course_id
            WHERE s.submission_id = grades.submission_id
            AND c.instructor_id = current_setting('app.user_id', true)::BIGINT
        )
    )
);

CREATE OR REPLACE FUNCTION prevent_non_admin_role_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.role IS DISTINCT FROM OLD.role
       AND current_setting('app.role', true) IS DISTINCT FROM 'admin' THEN
        RAISE EXCEPTION 'Only admin can change user roles';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_prevent_role_change ON users;

CREATE TRIGGER trg_prevent_role_change
BEFORE UPDATE OF role ON users
FOR EACH ROW
EXECUTE FUNCTION prevent_non_admin_role_change();
