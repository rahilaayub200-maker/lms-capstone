-- LMS Demo Data

INSERT INTO users (username, email, role)
VALUES
    ('amina', 'amina@example.com', 'student'),
    ('brian', 'brian@example.com', 'student'),
    ('grace', 'grace@example.com', 'instructor'),
    ('admin', 'admin@example.com', 'admin');

INSERT INTO profiles (user_id, bio, age)
SELECT user_id, 'LMS student and learner', 22
FROM users
WHERE username = 'amina';

INSERT INTO profiles (user_id, bio, age)
SELECT user_id, 'LMS student and learner', 24
FROM users
WHERE username = 'brian';

INSERT INTO profiles (user_id, bio, age)
SELECT user_id, 'LMS instructor', 30
FROM users
WHERE username = 'grace';

INSERT INTO profiles (user_id, bio, age)
SELECT user_id, 'LMS administrator', 35
FROM users
WHERE username = 'admin';

INSERT INTO courses (instructor_id, title, description)
SELECT user_id, 'PostgreSQL Basics', 'Introduction to PostgreSQL databases'
FROM users
WHERE username = 'grace';

INSERT INTO courses (instructor_id, title, description)
SELECT user_id, 'Digital Skills', 'Introduction to practical digital skills'
FROM users
WHERE username = 'grace';

INSERT INTO enrollments (user_id, course_id)
SELECT u.user_id, c.course_id
FROM users u
JOIN courses c ON c.title = 'PostgreSQL Basics'
WHERE u.username IN ('amina', 'brian');

INSERT INTO enrollments (user_id, course_id)
SELECT u.user_id, c.course_id
FROM users u
JOIN courses c ON c.title = 'Digital Skills'
WHERE u.username IN ('amina', 'brian');

INSERT INTO lessons (course_id, title, content, lesson_order)
SELECT course_id, 'Introduction to PostgreSQL', 'PostgreSQL fundamentals and database concepts', 1
FROM courses
WHERE title = 'PostgreSQL Basics';

INSERT INTO lessons (course_id, title, content, lesson_order)
SELECT course_id, 'SQL Queries', 'Basic SELECT, INSERT, UPDATE and DELETE queries', 2
FROM courses
WHERE title = 'PostgreSQL Basics';

INSERT INTO lessons (course_id, title, content, lesson_order)
SELECT course_id, 'Digital Communication', 'Introduction to digital communication tools', 1
FROM courses
WHERE title = 'Digital Skills';

INSERT INTO lessons (course_id, title, content, lesson_order)
SELECT course_id, 'Online Collaboration', 'Using digital tools for collaboration', 2
FROM courses
WHERE title = 'Digital Skills';

INSERT INTO assignments (course_id, title, description)
SELECT course_id, 'PostgreSQL Practice', 'Write basic SQL queries'
FROM courses
WHERE title = 'PostgreSQL Basics';

INSERT INTO assignments (course_id, title, description)
SELECT course_id, 'Digital Skills Exercise', 'Complete a digital skills exercise'
FROM courses
WHERE title = 'Digital Skills';

INSERT INTO submissions (assignment_id, user_id, content)
SELECT a.assignment_id, u.user_id, 'My PostgreSQL practice submission'
FROM assignments a
JOIN users u ON u.username = 'amina'
WHERE a.title = 'PostgreSQL Practice';

INSERT INTO submissions (assignment_id, user_id, content)
SELECT a.assignment_id, u.user_id, 'My digital skills exercise submission'
FROM assignments a
JOIN users u ON u.username = 'brian'
WHERE a.title = 'Digital Skills Exercise';

INSERT INTO grades (submission_id, score, feedback, graded_at)
SELECT submission_id, 88.00, 'Good work', CURRENT_TIMESTAMP
FROM submissions
WHERE content = 'My PostgreSQL practice submission';

INSERT INTO grades (submission_id, score, feedback, graded_at)
SELECT submission_id, 92.00, 'Excellent work', CURRENT_TIMESTAMP
FROM submissions
WHERE content = 'My digital skills exercise submission';
