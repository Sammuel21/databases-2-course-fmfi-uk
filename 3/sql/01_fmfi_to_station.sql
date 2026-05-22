-- Air distance from FMFI UK to Bratislava main train station

\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH fmfi AS (
  SELECT way
  FROM planet_osm_point
  WHERE name ILIKE 'Fakulta matematiky%'
  LIMIT 1
),
station AS (
  SELECT way
  FROM planet_osm_point
  WHERE name = 'Bratislava hlavná stanica'
    AND railway = 'station'
  LIMIT 1
)
SELECT ROUND(ST_Distance(fmfi.way::geography, station.way::geography)) AS distance_m
FROM fmfi
CROSS JOIN station;
