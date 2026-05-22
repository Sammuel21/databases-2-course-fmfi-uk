-- Bridges crossing the Danube river

\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH danube AS (
  SELECT ST_Union(way) AS way
  FROM planet_osm_line
  WHERE waterway = 'river'
    AND name IN ('Dunaj', 'Donau - Dunaj')
),
bridges AS (
  SELECT name, ST_Union(way) AS way
  FROM planet_osm_line
  WHERE bridge IS NOT NULL
    AND name IS NOT NULL
  GROUP BY name
)
SELECT b.name
FROM bridges b
CROSS JOIN danube d
WHERE ST_Intersects(b.way, d.way)
ORDER BY b.name;
