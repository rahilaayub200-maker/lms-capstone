# Query Optimization Evidence

## Query

SELECT *
FROM enrollments
WHERE course_id = 1;

## Before Index

The index `idx_enrollments_course_id` was temporarily removed.

EXPLAIN ANALYZE showed:

Seq Scan on enrollments
Execution Time: 0.287 ms

## Change

The index was recreated:

CREATE INDEX idx_enrollments_course_id
ON enrollments(course_id);

## After Index

EXPLAIN ANALYZE showed:

Seq Scan on enrollments
Execution Time: 0.297 ms

## Result

PostgreSQL continued to use a sequential scan because the query returned approximately half of the rows in the table.

This demonstrates that adding an index does not always improve a query. PostgreSQL's query planner chooses the execution plan based on the estimated cost.

The index remains available for queries where filtering by course_id is more selective.
