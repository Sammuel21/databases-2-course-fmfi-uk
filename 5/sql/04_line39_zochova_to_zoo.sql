\set ON_ERROR_STOP on
\pset pager off
\timing on

WITH RECURSIVE trip(stop_id, name, hop) AS (
  SELECT id, name, 0
  FROM stops
  WHERE name = 'Zochova'

  UNION ALL

  SELECT c.start_stop_id, s.name, trip.hop + 1
  FROM trip
  JOIN connections c ON c.end_stop_id = trip.stop_id
  JOIN stops s ON s.id = c.start_stop_id
  WHERE c.line = '39'
    AND trip.name <> 'Zoo'
)
SELECT name, hop
FROM trip
WHERE hop > 0
  AND name <> 'Zoo'
ORDER BY hop;
