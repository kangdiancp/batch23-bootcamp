CREATE SCHEMA SALES

CREATE EXTENSION DBLINK


create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost')

CREATE TABLE SALES.SHIPPERS (
	ship_id serial PRIMARY KEY,
	ship_name varchar(40),
	ship_phone varchar(24)
)

CREATE TABLE SALES.SUPPLIERS (
	supr_id serial PRIMARY KEY,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15),
	supr_location_id int
)
DROP TABLE SALES.SUPPLIERS

CREATE TABLE SALES.CUSTOMERS (
	cust_id serial PRIMARY KEY,
	cust_name varchar(40),
	cust_city varchar(15),
	cust_location integer
)

CREATE TABLE SALES.CATEGORIES (
	cate_id serial PRIMARY KEY,
	cate_name varchar(15),
	cate_description text
)

CREATE TABLE SALES.PRODUCTS (
	prod_id serial PRIMARY KEY,
	prod_name varchar(40),
	prod_quantity varchar(20),
	prod_price MONEY,
	prod_in_stock SMALLINT,
	prod_on_order SMALLINT,
	prod_reorder_level SMALLINT,
	prod_discontinued BIT,
	prod_cate_id integer,
	prod_supr_id integer,
	FOREIGN KEY (prod_cate_id) REFERENCES SALES.CATEGORIES (cate_id),
	FOREIGN KEY (prod_supr_id) REFERENCES SALES.SUPPLIERS (supr_id)
)

CREATE TABLE SALES.ORDERS (
	order_id serial PRIMARY KEY,
	order_date TIMESTAMP,
	order_required_date TIMESTAMP,
	order_shipped_date TIMESTAMP,
	order_freight MONEY,
	order_subtotal MONEY,
	order_total_qty SMALLINT,
	order_ship_cty varchar(15),
	order_ship_address varchar(60),
	order_sttus varchar(15),
	order_employee_id integer,
	order_cust_id integer,
	order_ship_id integer	
)

CREATE TABLE SALES.ORDERS_DETAIL (
	ordet_order_id integer,
	ordet_prod_id integer,
	ordet_price MONEY,
	ordet_quantity SMALLINT,
	ordet_discount REAL,
	FOREIGN KEY (ordet_order_id) REFERENCES SALES.ORDERS (order_id),
	FOREIGN KEY (ordet_prod_id) REFERENCES SALES.PRODUCTS (prod_id),
	CONSTRAINT ra_od_pk PRIMARY KEY (ordet_order_id, ordet_prod_id)	
)
