\set ON_ERROR_STOP on
\pset pager off
\timing on

CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

DROP INDEX IF EXISTS contracts_search_vector_idx;
DROP INDEX IF EXISTS contracts_supplier_ico_trgm_idx;
DROP INDEX IF EXISTS contracts_identifier_trgm_idx;

DROP TEXT SEARCH CONFIGURATION IF EXISTS sk;
CREATE TEXT SEARCH CONFIGURATION sk (COPY = simple);
ALTER TEXT SEARCH CONFIGURATION sk
ALTER MAPPING FOR word, hword, hword_part
WITH unaccent, simple;

ALTER TABLE contracts DROP COLUMN IF EXISTS search_vector;
ALTER TABLE contracts ADD COLUMN search_vector tsvector;

UPDATE contracts
SET search_vector = to_tsvector(
  'sk',
  coalesce(name, '') || ' ' ||
  coalesce(department, '') || ' ' ||
  coalesce(customer, '') || ' ' ||
  coalesce(supplier, '')
);

CREATE INDEX contracts_search_vector_idx
ON contracts USING gin(search_vector);

CREATE INDEX contracts_supplier_ico_trgm_idx
ON contracts USING gin((supplier_ico::text) gin_trgm_ops);

CREATE INDEX contracts_identifier_trgm_idx
ON contracts USING gin((identifier::text) gin_trgm_ops);

ANALYZE contracts;

SELECT COUNT(*) AS indexed_contracts
FROM contracts
WHERE search_vector IS NOT NULL;
