# LMS Security

## 1. Least-Privilege Application Role

The LMS uses a separate PostgreSQL application role:

`lms_app`

The role is not a superuser and does not have the `BYPASSRLS` privilege.

The application role was tested using:

- `user_id = 1`
- `role = student`

The test confirmed that Row-Level Security limits the data visible to the application user.

## 2. Row-Level Security

Row-Level Security (RLS) is enabled on sensitive LMS tables.

Protected tables include:

- users
- profiles
- courses
- enrollments
- lessons
- assignments
- submissions
- grades

RLS policies use the application context:

- `app.user_id`
- `app.role`

Students are restricted to their own user records, submissions and grades.

Instructors can access submissions and grades associated with their courses.

Administrators have broader access.

## 3. Security Tests

### Student user access

Student `user_id = 1` was tested.

Result:

- Student saw only 1 user record.
- Student could view the available courses.
- Student saw only their own submission.
- Student could view their own grade.

### Instructor access

Instructor `user_id = 3` was tested.

Result:

- Instructor could view submissions associated with the instructor's courses.

### Role escalation protection

A student attempted to change their own role from `student` to `admin`.

The database rejected the operation with:

`ERROR: Only admin can change user roles`

This confirms that unauthorized role escalation is blocked by the database trigger.

## 4. Audit Logging

An `audit_log` table records important changes to users.

The audit system records:

- table name
- operation
- record ID
- timestamp
- user making the change
- old data
- new data

A trigger automatically records INSERT, UPDATE and DELETE operations on the `users` table.

## 5. Database Constraints

The database uses:

- Primary keys
- Foreign keys
- Unique constraints
- CHECK constraints
- NOT NULL constraints

These constraints help maintain data integrity.

## 6. Backup and Recovery

A PostgreSQL custom-format backup was created:

`backups/capstone_backup.dump`

The backup was restored into:

`capstone_restore`

Restore verification confirmed:

- Users: 1,004
- Courses: 2
- Enrollments: 2,004
- Lessons: 4
- Assignments: 2
- Submissions: 2
- Grades: 2

## 7. Security Summary

The LMS demonstrates:

- Least-privilege application access
- Row-Level Security
- Role-based access control
- Role-escalation protection
- Audit logging
- Database constraints
- Backup and restore testing

These controls provide a security foundation for the LMS and can be extended as the application grows.
