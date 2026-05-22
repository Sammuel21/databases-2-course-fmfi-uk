-- ST_Distance vs ST_DWithin

\set ON_ERROR_STOP on
\pset pager off
\timing on

\echo === ST_Distance filter ===
EXPLAIN ANALYZE
WITH station AS (
  SELECT way
  FROM planet_osm_point
  WHERE name = 'Bratislava hlavná stanica'
    AND railway = 'station'
  LIMIT 1
)
SELECT COUNT(*)
FROM planet_osm_point p
CROSS JOIN station s
WHERE ST_Distance(p.way, s.way) < 0.01;

\echo === ST_DWithin filter ===
EXPLAIN ANALYZE
WITH station AS (
  SELECT way
  FROM planet_osm_point
  WHERE name = 'Bratislava hlavná stanica'
    AND railway = 'station'
  LIMIT 1
)
SELECT COUNT(*)
FROM planet_osm_point p
CROSS JOIN station s
WHERE ST_DWithin(p.way, s.way, 0.01);
