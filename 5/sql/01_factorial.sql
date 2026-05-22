\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH RECURSIVE factorial(n, value) AS (
  SELECT 0, 1::bigint

  UNION ALL

  SELECT n + 1, value * (n + 1)
  FROM factorial
  WHERE n < 10
)
SELECT n, value AS factorial
FROM factorial
ORDER BY n;
