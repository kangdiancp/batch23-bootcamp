create schema sales

create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options (hostaddr '127.0.0.1', dbname 'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres', password 'admin');

select dblink_connect ('localhost')

create table sales.shippers (
	ship_id serial primary key,
	ship_name varchar(40),
	ship_phone varchar(24)
)

drop table customers

create table sales.suppliers (
	supr_id serial primary key,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15),
	supr_location_id int
)

drop table suppliers

create table sales.customers (
	cust_id serial primary key,
	cust_name varchar(40),
	cust_city varchar(15),
	cust_location int
)

create table sales.categories (
	cate_id serial primary key,
	cate_name varchar(15),
	cate_description text
)

create table sales.products (
	prod_id serial primary key,
	prod_name varchar(40),
	prod_quantity varchar(20),
	prod_price money,
	prod_in_stock smallint,
	prod_on_order smallint,
	prod_reorder_level smallint,
	prod_discontinued bit,
	prod_cate_id int,
	prod_supr_id int,
	foreign key (prod_cate_id) references sales.categories(cate_id),
	foreign key (prod_supr_id) references sales.suppliers(supr_id)
)

create table sales.orders (
	order_id serial primary key,
	order_date timestamp,
	order_required_date timestamp,
	order_shipped_date timestamp,
	order_freight money,
	order_subtotal money,
	order_total_qty smallint,
	order_ship_qty varchar(15),
	order_ship_address varchar(60),
	order_status varchar(15),
	order_employee_id int,
	order_cust_id int,
	order_ship_id int
)

create table sales.orders_detail (
	ordet_order_id int,
	ordet_prod_id int,
	ordet_price money,
	ordet_quantity smallint,
	ordet_discount real,
	foreign key (ordet_order_id) references sales.orders(order_id),
	foreign key (ordet_prod_id) references sales.products(prod_id),
	constraint ordet_orderProdId_pk primary key (ordet_order_id, ordet_prod_id)
)

insert into sales.shippers (ship_id, ship_name, ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))