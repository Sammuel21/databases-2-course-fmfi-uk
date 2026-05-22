\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH RECURSIVE chair_parts(id, name, part_of_id, path) AS (
  SELECT p.id, p.name, p.part_of_id, ARRAY[p.id]
  FROM product_parts p
  JOIN product_parts root ON root.id = p.part_of_id
  WHERE root.name = 'chair'

  UNION ALL

  SELECT p.id, p.name, p.part_of_id, cp.path || p.id
  FROM product_parts p
  JOIN chair_parts cp ON cp.id = p.part_of_id
)
SELECT name
FROM chair_parts
ORDER BY path;
