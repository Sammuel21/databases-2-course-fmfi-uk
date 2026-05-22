\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH q AS (
  SELECT plainto_tsquery('sk', 'oracle socialna poistovna') AS query
)
SELECT
  c.id,
  c.name,
  c.identifier,
  c.department,
  c.customer,
  c.supplier,
  c.published_on,
  round(ts_rank_cd(c.search_vector, q.query)::numeric, 6) AS text_rank,
  round((ts_rank_cd(c.search_vector, q.query) * (1 + 1.0 / (1 + extract(epoch from (now() - coalesce(c.published_on, date '1900-01-01'))) / 86400)))::numeric, 6) AS boosted_rank
FROM contracts c
CROSS JOIN q
WHERE c.search_vector @@ q.query
ORDER BY boosted_rank DESC, c.published_on DESC
LIMIT 10;
