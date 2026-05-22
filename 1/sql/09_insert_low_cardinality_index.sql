-- INSERT benchmark: one low-cardinality index

\set ON_ERROR_STOP on
\pset pager off
\timing on
\set n 10000

DROP INDEX IF EXISTS index_documents_on_supplier;
DROP INDEX IF EXISTS index_documents_on_total_amount;
DROP INDEX IF EXISTS index_documents_on_published_on;
DROP INDEX IF EXISTS index_documents_on_type;
DROP INDEX IF EXISTS index_documents_on_lower_supplier;

CREATE INDEX index_documents_on_type ON documents(type);
ANALYZE documents;

SELECT COUNT(DISTINCT type) AS distinct_type_values
FROM documents;

BEGIN;

EXPLAIN ANALYZE
INSERT INTO documents
SELECT *
FROM documents
LIMIT :n;

ROLLBACK;
