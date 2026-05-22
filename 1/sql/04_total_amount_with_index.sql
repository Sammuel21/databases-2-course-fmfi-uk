-- Experiment 04: total_amount range filter with a B-tree index

\set ON_ERROR_STOP on
\pset pager off
\timing on

\echo === Experiment 04: total_amount range with total_amount index ===

DROP INDEX IF EXISTS index_documents_on_supplier;
DROP INDEX IF EXISTS index_documents_on_total_amount;
CREATE INDEX index_documents_on_total_amount ON documents(total_amount);
ANALYZE documents;

\echo === Current indexes on documents ===
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'documents'
ORDER BY indexname;

\echo === Matching rows ===
SELECT COUNT(*) AS range_rows
FROM documents
WHERE total_amount > 100000
  AND total_amount <= 999999999;

\echo === Query plan, run 1 ===
EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE total_amount > 100000
  AND total_amount <= 999999999;

\echo === Query plan, run 2 ===
EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE total_amount > 100000
  AND total_amount <= 999999999;

\echo === Query plan, run 3 ===
EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE total_amount > 100000
  AND total_amount <= 999999999;
