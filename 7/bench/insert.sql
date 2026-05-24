\setrandom name 1 1000000000
\setrandom amount 1 1000000
INSERT INTO documents(name, type, created_at, department, contracted_amount) VALUES ('Generated doc ' || :name, 'MyType', now(), 'Department ' || :name, :amount);
