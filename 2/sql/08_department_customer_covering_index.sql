-- Department/customer query with covering index

\set ON_ERROR_STOP on
\pset pager off
\timing on

DROP INDEX IF EXISTS index_documents_on_department;
DROP INDEX IF EXISTS index_documents_on_department_customer;

CREATE INDEX index_documents_on_department_customer
ON documents (department, customer);

VACUUM ANALYZE documents;

EXPLAIN ANALYZE
SELECT customer
FROM documents
WHERE department = 'Rozhlas a televizia Slovenska';
