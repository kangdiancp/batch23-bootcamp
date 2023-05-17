/*SCHEMA*/

CREATE SCHEMA SALES

CREATE EXTENSION DBLINK;

CREATE FOREIGN DATA WRAPPER POSTGRES;
CREATE SERVER LOCALHOST FOREIGN DATA WRAPPER POSTGRES OPTIONS(hostaddr '127.0.0.1', dbname 'NorthwindDB');
CREATE USER MAPPING FOR POSTGRES SERVER LOCALHOST OPTIONS (USER 'postgres', PASSWORD 'admin');

SELECT DBLINK_CONNECT ('localhost')

create table sales.shippers(
	ship_id serial primary key,
	ship_name varchar(40),
	ship_phone varchar(25)
);

create table sales.employees(
	employee_id serial primary key
);

create table sales.locations(
	location_id serial primary key
);

create table sales.suppliers(
	supr_id serial primary key,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15),
	supr_location_id integer
);

create table sales.customers(
	cust_id serial primary key,
	cust_name varchar(40),
	cust_city varchar(15),
	cust_location_id integer
);

create table sales.categories(
	cate_id serial primary key,
	cate_name varchar(15),
	cate_description text
);

create table sales.order_detail(
	order_id integer,
	prod_id integer,
	ordet_price money,
	ordet_quantity smallint,
	ordet_discount real,
	foreign key (order_id) references sales.orders(order_id),
	foreign key (prod_id) references sales.products(prod_id),
	constraint ordet_order_prod_pk primary key (order_id, prod_id)
);

create table sales.products(
	prod_id serial primary key,
	prod_name varchar(40),
	prod_quantity varchar(20),
	prod_price money,
	prod_in_stock smallint,
	prod_on_order smallint,
	prod_reorder_level smallint,
	prod_discontinued bit,
	cate_id integer,
	supr_id integer,
	foreign key (cate_id) references sales.categories(cate_id),
	foreign key (supr_id) references sales.suppliers(supr_id)
);

create table sales.orders(
	order_id serial primary key,
	order_date timestamp,
	order_required_date timestamp,
	order_shipped_date timestamp,
	order_freight money,
	order_subtotal money,
	order_total_qty smallint,
	order_ship_city varchar(15),
	order_ship_address varchar(60),
	order_status varchar(15),
	order_employee_id integer,
	order_cust_id integer,
	order_ship_id integer
);

insert into sales.shippers (ship_id,ship_name,ship_phone)
select * from dblink('localhost','select shipper_id, company_name, phone from shippers')
as data(ship_id integer, ship_name varchar(40), ship_phone varchar(24))

insert into sales.suppliers(supr_id, supr_name, supr_contact_name, supr_city)
select * from dblink('localhost','select supplier_id, company_name, contact_name, city from supplier')
as data(supr_id integer, supr_name varchar(40), supr_contact_name varchar(30), supr_city varchar(30))

insert into sales.products(prod_id, prod_name, prod_quantity, prod_price, prod_in_stock, prod_on_order, prod_reorder_level, prod_discontinued, cate_id, supr_id)
select * from dblink('localhost','select product_id, product_name, quantity_per_unit, unit_price, units_in_stock, units_in_order, reorder_level, discontinued, supplier_id, category_id from products')
as data(prod_id smallint, prod_name varchar(40), prod_quantity varchar(20), prod_price money, prod_in_stock smallint, prod_on_order smallint, prod_reorder_level smallint, prod_discontinued bit, cate_id integer, supr_id integer)

insert into sales.customers(cust_id, cust_name, cust_city)
select * from dblink('localhost','select customer_id, company_name, city from customers')
as data(cust_id character varying, cust_name varchar(40), cust_city varchar(15))




