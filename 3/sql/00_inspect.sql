-- Lab 3 inspect

\set ON_ERROR_STOP on
\pset pager off
\timing on

SELECT PostGIS_Version();

SELECT f_table_name, f_geometry_column, srid, type
FROM geometry_columns
WHERE f_table_name LIKE 'planet_osm_%'
ORDER BY f_table_name;

SELECT 'planet_osm_point' AS table_name, COUNT(*) FROM planet_osm_point
UNION ALL
SELECT 'planet_osm_line', COUNT(*) FROM planet_osm_line
UNION ALL
SELECT 'planet_osm_polygon', COUNT(*) FROM planet_osm_polygon
UNION ALL
SELECT 'planet_osm_roads', COUNT(*) FROM planet_osm_roads;

SELECT name, railway, amenity
FROM planet_osm_point
WHERE name ILIKE '%Fakulta matematiky%'
   OR name = 'Bratislava hlavná stanica'
ORDER BY name;

SELECT name, boundary, admin_level, ROUND(ST_Area(way::geography)) AS area_m2
FROM planet_osm_polygon
WHERE name IN ('Karlova Ves', 'Dlhé diely')
ORDER BY name, admin_level;
