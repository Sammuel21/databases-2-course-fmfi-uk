\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH q AS (
  SELECT plainto_tsquery('sk', 'zmluva') AS query
)
SELECT COUNT(*) AS zmluva_results
FROM contracts c
CROSS JOIN q
WHERE c.search_vector @@ q.query;

WITH q AS (
  SELECT plainto_tsquery('sk', 'sro') AS query
)
SELECT COUNT(*) AS sro_results
FROM contracts c
CROSS JOIN q
WHERE c.search_vector @@ q.query;

WITH q AS (
  SELECT plainto_tsquery('sk', 'OIaMIS') AS query
)
SELECT COUNT(*) AS oiamis_fulltext_results
FROM contracts c
CROSS JOIN q
WHERE c.search_vector @@ q.query;
