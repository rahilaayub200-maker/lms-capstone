# NoSQL Integration - Redis

## Purpose

Redis is integrated into the LMS as a caching layer for frequently accessed course information.

## Why Redis?

PostgreSQL is the primary database because the LMS has structured data and relationships between users, courses, enrollments, lessons, assignments, submissions, and grades.

Redis is used for temporary and frequently accessed data because it provides fast in-memory access.

## Use Case

Course information can be stored in Redis after being retrieved from PostgreSQL.

Example cache key:

lms:course:1

The cached course data can be returned quickly without querying PostgreSQL every time.

## Benefit

Redis can reduce repeated database queries and improve response time for frequently requested course information.

## Data Persistence

PostgreSQL remains the source of truth. Redis only stores temporary cached copies of data.

If Redis is cleared, the LMS can retrieve the original data again from PostgreSQL.
