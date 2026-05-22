-- Basic inspection of the documents table

\set ON_ERROR_STOP on
\pset pager off
\timing on

SELECT COUNT(*) AS document_count
FROM documents;

SELECT pg_size_pretty(pg_relation_size('documents')) AS table_size;

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'documents';