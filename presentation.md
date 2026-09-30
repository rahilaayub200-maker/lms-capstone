# LMS Capstone - Final Walkthrough

## Slide 1 - Project Overview

### Learning Management System (LMS)

The LMS helps students and instructors manage:

- Courses
- Lessons
- Assignments
- Submissions
- Grades

---

## Slide 2 - Requirements

### Main Users

- Students
- Instructors
- Administrators

### Core Features

- User profiles
- Course management
- Enrollment
- Lessons
- Assignments
- Submissions
- Grading
- Audit logging

---

## Slide 3 - Database Design

PostgreSQL is the primary structured database.

### Main Entities

- users
- profiles
- courses
- enrollments
- lessons
- assignments
- submissions
- grades
- audit_log

The database uses:

- Primary keys
- Foreign keys
- Unique constraints
- CHECK constraints
- Timestamps

An ER diagram was created to show the relationships between the main entities.

---

## Slide 4 - Versioned Migrations

Six migration stages were created:

- V1 - Core tables
- V2 - Indexes
- V3 - Audit logging and triggers
- V4 - Row-Level Security
- V5 - Demo data
- V6 - Security fixes

The migrations provide a versioned history of the database structure and security changes.

---

## Slide 5 - NoSQL Integration

### Redis

Redis is used as a caching layer for frequently accessed course information.

Example cache key:

`lms:course:1`

PostgreSQL remains the primary source of truth.

Redis provides fast access to frequently requested data and can be repopulated if the cache is cleared.

---

## Slide 6 - Query Optimization

A query filtering enrollments by `course_id` was tested before and after adding an index.

### Result

PostgreSQL continued to use a sequential scan.

The query returned approximately half of the enrollment table, so PostgreSQL determined that a sequential scan was appropriate.

### Key Lesson

Adding an index does not always make a query faster.

PostgreSQL chooses an execution plan based on estimated cost and query selectivity.

---

## Slide 7 - Backup and Recovery

A PostgreSQL custom-format backup was created:

`backups/capstone_backup.dump`

The backup was successfully restored into:

`capstone_restore`

### Restore Verification

- Users: 1,004
- Courses: 2
- Enrollments: 2,004
- Lessons: 4
- Assignments: 2
- Submissions: 2
- Grades: 2

The restored data matched the expected data from the original database.

---

## Slide 8 - Security

### Security Controls

- Least-privilege application role
- Row-Level Security
- Role-based access
- Role-escalation protection
- Audit logging
- Foreign keys and constraints
- Backup and restore testing

The application role `lms_app` was tested and confirmed not to be a superuser or RLS-bypass role.

---

## Slide 9 - Security Testing

### Student Testing

Student `user_id = 1` was tested.

The student:

- Could see their own user record.
- Could view courses.
- Could see only their own submission.
- Could view their own grade.

### Instructor Testing

Instructor `user_id = 3` was tested.

The instructor could view submissions associated with the instructor's courses.

### Role Escalation Testing

A student attempted to change their role to `admin`.

The database rejected the operation:

`ERROR: Only admin can change user roles`

This confirms that unauthorized role escalation is blocked.

---

## Slide 10 - Conclusion

The LMS capstone demonstrates practical database development using:

- Relational database design
- Versioned migrations
- PostgreSQL security
- Row-Level Security
- Redis integration
- Query analysis
- Audit logging
- Backup and restore
- Security testing

The system provides a foundation for future features such as:

- Notifications
- Progress tracking
- Certificates
- Payments
