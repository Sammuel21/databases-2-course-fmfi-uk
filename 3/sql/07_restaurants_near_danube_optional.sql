-- Optional: restaurants within 300 meters of the Danube river

\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH danube AS (
  SELECT ST_Union(way) AS way
  FROM planet_osm_line
  WHERE waterway = 'river'
    AND name IN ('Dunaj', 'Donau - Dunaj')
),
restaurants AS (
  SELECT name, way
  FROM planet_osm_point
  WHERE amenity = 'restaurant'
    AND name IS NOT NULL

  UNION ALL

  SELECT name, way
  FROM planet_osm_polygon
  WHERE amenity = 'restaurant'
    AND name IS NOT NULL
)
SELECT
  r.name,
  ROUND(MIN(ST_Distance(r.way::geography, d.way::geography))) AS distance_m
FROM restaurants r
CROSS JOIN danube d
WHERE ST_DWithin(r.way::geography, d.way::geography, 300)
GROUP BY r.name
ORDER BY distance_m, r.name;
