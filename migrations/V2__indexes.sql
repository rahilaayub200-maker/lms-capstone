CREATE INDEX idx_courses_instructor_id
ON courses(instructor_id);

CREATE INDEX idx_enrollments_user_id
ON enrollments(user_id);

CREATE INDEX idx_enrollments_course_id
ON enrollments(course_id);

CREATE INDEX idx_lessons_course_id
ON lessons(course_id);

CREATE INDEX idx_assignments_course_id
ON assignments(course_id);

CREATE INDEX idx_submissions_assignment_id
ON submissions(assignment_id);

CREATE INDEX idx_submissions_user_id
ON submissions(user_id);

CREATE INDEX idx_grades_submission_id
ON grades(submission_id);
