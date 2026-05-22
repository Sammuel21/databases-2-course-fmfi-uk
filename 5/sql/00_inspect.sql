\set ON_ERROR_STOP on
\pset pager off
\timing on

SELECT COUNT(*) AS product_parts_count
FROM product_parts;

SELECT COUNT(*) AS stops_count
FROM stops;

SELECT COUNT(*) AS connections_count
FROM connections;

SELECT id, name, part_of_id, price, shipping_time
FROM product_parts
ORDER BY id;

SELECT c.id, s1.name AS start_stop, s2.name AS end_stop, c.duration, c.line
FROM connections c
JOIN stops s1 ON s1.id = c.start_stop_id
JOIN stops s2 ON s2.id = c.end_stop_id
WHERE c.line = '39'
ORDER BY c.id;
