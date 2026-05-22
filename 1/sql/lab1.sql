-- Lab 1: Query plans and indexing

\pset pager off
\timing on

-- 1. Basic table inspection
SELECT COUNT(*) AS document_count
FROM documents;

SELECT pg_size_pretty(pg_relation_size('documents')) AS table_size;

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'documents';

-- 2. First query before creating a custom index
EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE supplier = 'SPP';