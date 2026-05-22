
\set ON_ERROR_STOP on
\pset pager off
\timing on

SELECT COUNT(*) AS document_count
FROM documents;

SELECT COUNT(DISTINCT supplier_ico) AS distinct_supplier_ico
FROM documents;

SELECT COUNT(*) AS suffix_5733_rows
FROM documents
WHERE supplier_ico LIKE '%5733';

SELECT COUNT(*) AS prefix_57_rows
FROM documents
WHERE supplier_ico LIKE '57%';

SELECT COUNT(*) AS department_rows
FROM documents
WHERE department = 'Rozhlas a televizia Slovenska';
