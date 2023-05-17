create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname 'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres', password 'admin');

select dblink_connect ('localhost')

create table sales.suppliers (
	supr_id serial primary key,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15)
)

create table sales.customers (
	cust_id serial primary key,
	cust_name varchar(40),
	cust_city varchar(15)
)

drop table sales.customers cascade

create table sales.categories (
	cate_id serial primary key,
	cust_id integer,
	cate_name varchar(15),
	cate_description text
)

drop table sales.categories cascade

create table sales.shippers (
	ship_id serial primary key,
	ship_name varchar(40),
	ship_phone varchar(24)
)

insert into sales.shippers (ship_id,ship_name,ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))

create table sales.orders (
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
	order_cust_id integer,
	order_ship_id integer,
	foreign key(order_cust_id) references sales.customers(cust_id),
	foreign key(order_ship_id) references sales.shippers(ship_id)
)

create table sales.order_detail(
	order_order_id integer,
	order_prod_id integer,
	order_price money,
	order_quantity smallint,
	order_discount real,
	constraint order_id primary key (order_order_id, order_prod_id),
	foreign key (order_order_id) references sales.orders(order_id),
	foreign key (order_prod_id) references sales.products(prod_id)
)

create table sales.products(
	prod_id serial primary key,
	prod_name varchar(40),
	prod_quantity varchar(20),
	prode_price money,
	prod_in_stock smallint,
	prod_in_order smallint,
	prod_reorder_level smallint,
	prod_discontinued bit,
	prod_cate_id integer,
	prod_supr_id integer,
	foreign key (prod_cate_id) references sales.categories(cate_id),
	foreign key (prod_supr_id) references sales.suppliers(supr_id)
	
)



