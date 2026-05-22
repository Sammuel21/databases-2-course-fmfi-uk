-- Direct neighbours of Karlova Ves

\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH karlova_ves AS (
  SELECT way
  FROM planet_osm_polygon
  WHERE name = 'Karlova Ves'
    AND boundary = 'administrative'
    AND admin_level = '9'
  LIMIT 1
)
SELECT DISTINCT p.name
FROM planet_osm_polygon p
CROSS JOIN karlova_ves kv
WHERE p.boundary = 'administrative'
  AND p.admin_level = '9'
  AND p.name <> 'Karlova Ves'
  AND ST_Touches(p.way, kv.way)
ORDER BY p.name;
