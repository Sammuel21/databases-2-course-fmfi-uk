\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH q AS (
  SELECT plainto_tsquery('sk', 'socialna poistovna') AS query
)
SELECT
  c.id,
  c.name,
  c.identifier,
  c.department,
  c.customer,
  c.supplier,
  c.published_on,
  round(ts_rank_cd(c.search_vector, q.query)::numeric, 6) AS text_rank
FROM contracts c
CROSS JOIN q
WHERE c.search_vector @@ q.query
ORDER BY text_rank DESC, c.published_on DESC
LIMIT 10;
