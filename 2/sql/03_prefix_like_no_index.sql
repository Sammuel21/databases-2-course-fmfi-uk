-- LIKE with trailing pattern, no index

\set ON_ERROR_STOP on
\pset pager off
\timing on

DROP INDEX IF EXISTS index_documents_on_supplier_ico_like;
DROP INDEX IF EXISTS index_documents_on_reverse_supplier_ico;

ANALYZE documents;

EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE supplier_ico LIKE '57%';
