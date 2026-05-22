-- Optional: leisure area percentage in Dlhé diely

\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH dlhe_diely AS (
  SELECT way
  FROM planet_osm_polygon
  WHERE name = 'Dlhé diely'
    AND boundary = 'administrative'
  LIMIT 1
),
leisure AS (
  SELECT ST_Intersection(p.way, d.way) AS way
  FROM planet_osm_polygon p
  CROSS JOIN dlhe_diely d
  WHERE p.leisure IS NOT NULL
    AND ST_Intersects(p.way, d.way)
)
SELECT
  ROUND(ST_Area(d.way::geography)::numeric, 2) AS district_area_m2,
  ROUND(SUM(ST_Area(l.way::geography))::numeric, 2) AS leisure_area_m2,
  ROUND((100 * SUM(ST_Area(l.way::geography)) / ST_Area(d.way::geography))::numeric, 2) AS leisure_percent
FROM dlhe_diely d
CROSS JOIN leisure l
GROUP BY d.way;
