create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname 'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres', password 'admin');

select dblink_connect ('localhost')

create schema sales

create table supplier(
	supplier_id smallint primary key,
	company_name varchar(40),
	contact_name varchar(30),
	contact_title varchar(30),
	address varchar(60),
	city varchar(15),
	region varchar(15),
	postal_code varchar(10),
	country varchar(15),
	phone varchar(24),
	fax varchar(24),
	homepage text
)

create table categories (
	category_id smallint primary key,
	category_name varchar(15),
	description text,
	picture bytea
)

create table products(
	product_id smallint primary key,
	product_name varchar(40),
	quantity_per_unit varchar(20),
	unit_price real,
	units_in_stock smallint,
	units_in_order smallint,
	reorder_level smallint,
	discontinued integer,
	supplier_id smallint,
	category_id smallint,
	foreign key (supplier_id) references supplier (supplier_id),
	foreign key (category_id) references categories (category_id)
)

create table shippers(
	shipper_id smallint primary key,
	company_name varchar(40),
	phone varchar(24)
)

create table employees(
	employee_id smallint primary key,
	last_name varchar(20),
	first_name varchar(10),
	title varchar(30),
	title_of_courtesy varchar(25),
	birth_date date,
	hire_date date,
	address varchar(20),
	city varchar(15),
	region varchar(15),
	postal_code varchar(10),
	country varchar(15),
	home_phone varchar(24),
	extension varchar(4),
	photo bytea,
	notes text,
	reports_to smallint,
	photo_path varchar(255)
)

create table customers(
	customer_id varchar(10) primary key,
	company_name varchar(40),
	contact_name varchar(30),
	contact_title varchar(30),
	address varchar(60),
	city varchar(15),
	region varchar(15),
	postal_code varchar(10),
	country varchar(15),
	phone varchar(24),
	fax varchar(24)
)
drop table customers

create table orders(
	order_id smallint primary key,
	order_date date,
	required_date date,
	shipped_date date,
	freight real,
	ship_name varchar(40),
	ship_address varchar(40),
	ship_city varchar(15),
	ship_region varchar(15),
	ship_postal_code varchar(10),
	ship_country varchar(15),
	employee_id smallint,
	costumer_id varchar(10),
	shipper_id smallint,
	foreign key (employee_id) references employees(employee_id),
	foreign key (shipper_id) references shippers(shipper_id)
)

drop table orders

alter table orders add constraint costumer_id_fk foreign key costumer_id references customers(costumer_id)

create table order_detail(
	order_id smallint,
	product_id smallint,
	unit_price real,
	quantity smallint,
	discount real,
	constraint order_id primary key (order_id,product_id),
	foreign key (order_id) references orders (order_id),
	foreign key (product_id) references products (product_id)
)

drop table order_detail
drop table categories cascade
drop table supplier cascade
drop table products
drop table shippers cascade
drop table orders
drop table employees
drop table customers cascade

select *from table categories
select *from table supplier,
select *from table products,
select *from table shippers,
select *from table orders,
select *from table employees,
select *from table customers,
select *from table order_detail