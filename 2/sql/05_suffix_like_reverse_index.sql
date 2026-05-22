-- Fast suffix search with reverse() functional index

\set ON_ERROR_STOP on
\pset pager off
\timing on

DROP INDEX IF EXISTS index_documents_on_supplier_ico_like;
DROP INDEX IF EXISTS index_documents_on_reverse_supplier_ico;

CREATE INDEX index_documents_on_reverse_supplier_ico
ON documents (reverse(supplier_ico) text_pattern_ops);

ANALYZE documents;

EXPLAIN ANALYZE
SELECT *
FROM documents
WHERE reverse(supplier_ico) LIKE reverse('5733') || '%';
