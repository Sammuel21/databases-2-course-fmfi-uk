-- Department/customer query without index

\set ON_ERROR_STOP on
\pset pager off
\timing on

DROP INDEX IF EXISTS index_documents_on_department;
DROP INDEX IF EXISTS index_documents_on_department_customer;

ANALYZE documents;

EXPLAIN ANALYZE
SELECT customer
FROM documents
WHERE department = 'Rozhlas a televizia Slovenska';
