-- Experiment 02: supplier filter with a B-tree index

\set ON_ERROR_STOP on
\pset pager off
\timing on

\echo === Experiment 02: supplier = 'SPP' with supplier index ===

DROP INDEX IF EXISTS index_documents_on_supplier;
CREATE INDEX index_documents_on_supplier ON documents(supplier);
ANALYZE documents;

\echo === Current indexes on documents ===
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'documents'
ORDER BY indexname;

\echo === Matching rows ===
SELECT COUNT(*) AS spp_rows
FROM documents
WHERE supplier = 'SPP';

\echo === Query plan, run 1 ===
EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE supplier = 'SPP';

\echo === Query plan, run 2 ===
EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE supplier = 'SPP';

\echo === Query plan, run 3 ===
EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE supplier = 'SPP';
