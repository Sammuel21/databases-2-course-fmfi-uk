\set ON_ERROR_STOP on
\pset pager off
\timing on

EXPLAIN ANALYZE
SELECT id, name, identifier, department, customer, supplier, published_on
FROM contracts
WHERE identifier::text ILIKE '%OIaMIS%'
ORDER BY published_on DESC
LIMIT 10;

SELECT id, name, identifier, department, customer, supplier, published_on
FROM contracts
WHERE identifier::text ILIKE '%OIaMIS%'
ORDER BY published_on DESC
LIMIT 10;
