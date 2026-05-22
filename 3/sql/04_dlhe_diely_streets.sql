-- Streets in Dlhé diely

\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH dlhe_diely AS (
  SELECT way
  FROM planet_osm_polygon
  WHERE name = 'Dlhé diely'
    AND boundary = 'administrative'
  LIMIT 1
)
SELECT DISTINCT l.name
FROM planet_osm_line l
CROSS JOIN dlhe_diely d
WHERE l.highway IS NOT NULL
  AND l.name IS NOT NULL
  AND ST_Intersects(l.way, d.way)
ORDER BY l.name;
