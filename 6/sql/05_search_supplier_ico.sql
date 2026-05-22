\set ON_ERROR_STOP on
\pset pager off
\timing on

EXPLAIN ANALYZE
SELECT id, name, identifier, department, customer, supplier, supplier_ico, published_on
FROM contracts
WHERE supplier_ico::text ILIKE '%31364381%'
ORDER BY published_on DESC
LIMIT 10;

SELECT id, name, identifier, department, customer, supplier, supplier_ico, published_on
FROM contracts
WHERE supplier_ico::text ILIKE '%31364381%'
ORDER BY published_on DESC
LIMIT 10;
