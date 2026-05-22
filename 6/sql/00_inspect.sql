\set ON_ERROR_STOP on
\pset pager off
\timing on

SELECT COUNT(*) AS contracts_count
FROM contracts;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'contracts'
ORDER BY ordinal_position;

SELECT id, name, identifier, department, customer, supplier, supplier_ico, published_on
FROM contracts
LIMIT 5;

SELECT COUNT(*) AS oracle_rows
FROM contracts
WHERE lower(name) LIKE '%oracle%'
   OR lower(supplier) LIKE '%oracle%';

SELECT COUNT(*) AS oiamis_rows
FROM contracts
WHERE identifier ILIKE '%OIaMIS%';
