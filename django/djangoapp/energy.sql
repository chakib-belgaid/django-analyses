--
-- SQL script to create postgres database and user for energy project
--

CREATE DATABASE "energy" ;
CREATE USER "energy" WITH PASSWORD 'energy';
GRANT ALL PRIVILEGES ON DATABASE "energy" to "energy";
ALTER USER "energy" CREATEDB ;

-- eof
