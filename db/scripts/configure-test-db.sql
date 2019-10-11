ALTER USER awesome_table_admin CREATEDB;
GRANT ALL PRIVILEGES ON DATABASE awesome_table_test to awesome_table_admin;
ALTER DATABASE awesome_table_test OWNER TO awesome_table_admin;

-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO awesome_table_admin;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO awesome_table_admin;
-- GRANT ALL ON DATABASE awesome_table_test TO awesome_table_admin;
-- ALTER USER awesome_table_admin CREATEDB;
