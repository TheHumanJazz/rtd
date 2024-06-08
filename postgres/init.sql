create schema if not exists app;

create table if not exists app.my_table (
    id SERIAL primary key,
    created_at TIMESTAMP default current_timestamp,
    data JSON
);

CREATE USER my_user WITH PASSWORD 'my_password';
GRANT USAGE ON SCHEMA app TO my_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE app.my_table TO my_user;
GRANT USAGE, SELECT ON SEQUENCE app.my_table_id_seq TO my_user;

create user dbt with password 'postgres';
grant CREATE on DATABASE postgres to dbt;
grant SELECT on TABLE app.my_table to dbt;
GRANT USAGE ON SCHEMA app TO dbt;
GRANT USAGE, SELECT ON SEQUENCE app.my_table_id_seq TO dbt;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
