create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost')

create schema sales