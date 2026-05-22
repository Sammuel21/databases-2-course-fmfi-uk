\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH RECURSIVE fibonacci(position, value, next_value) AS (
  SELECT 1, 1::bigint, 2::bigint

  UNION ALL

  SELECT position + 1, next_value, value + next_value
  FROM fibonacci
  WHERE position < 20
)
SELECT position, value AS fibonacci
FROM fibonacci
ORDER BY position;
