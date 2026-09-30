#!/bin/bash

echo "Storing LMS course in Redis..."

docker exec redis redis-cli SET "lms:course:1" '{"course_id":1,"title":"PostgreSQL Basics","description":"Introduction to PostgreSQL databases"}'

echo "Reading LMS course from Redis..."

docker exec redis redis-cli GET "lms:course:1"
