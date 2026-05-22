-- Experiment 01: supplier filter without an index

\set ON_ERROR_STOP on
\pset pager off
\timing on

\echo === Experiment 01: supplier = 'SPP' without supplier index ===

DROP INDEX IF EXISTS index_documents_on_supplier;
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
