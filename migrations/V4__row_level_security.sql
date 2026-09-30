ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE grades ENABLE ROW LEVEL SECURITY;

CREATE POLICY users_self_access
ON users
FOR ALL
USING (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
)
WITH CHECK (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
);

CREATE POLICY profiles_self_access
ON profiles
FOR ALL
USING (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
)
WITH CHECK (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
);

CREATE POLICY courses_access
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

CREATE POLICY enrollments_self_access
ON enrollments
FOR ALL
USING (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
)
WITH CHECK (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
);

CREATE POLICY submissions_self_access
ON submissions
FOR ALL
USING (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
)
WITH CHECK (
    user_id = current_setting('app.user_id', true)::BIGINT
    OR current_setting('app.role', true) = 'admin'
);

CREATE POLICY grades_access
ON grades
FOR ALL
USING (
    current_setting('app.role', true) IN ('instructor', 'admin')
)
WITH CHECK (
    current_setting('app.role', true) IN ('instructor', 'admin')
);
