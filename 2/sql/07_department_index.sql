-- Department/customer query with index on department

\set ON_ERROR_STOP on
\pset pager off
\timing on

DROP INDEX IF EXISTS index_documents_on_department;
DROP INDEX IF EXISTS index_documents_on_department_customer;

CREATE INDEX index_documents_on_department
ON documents (department);

ANALYZE documents;

EXPLAIN ANALYZE
SELECT customer
FROM documents
WHERE department = 'Rozhlas a televizia Slovenska';
