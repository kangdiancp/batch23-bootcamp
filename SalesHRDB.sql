create scheme sales
create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres',password 'admin');


create table sales.shipper(
	ship_id serial primary key,
	ship_name varchar(40),
	ship_phone varchar(24)
)


select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))

create table sales.suppliers(
	supr_id serial primary key,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15),
	supr_location_id integer
)
select * from dblink('localhost','select supplier_id,company_name,contact_name,city from suppliers')
as data(supr_id integer,supr_name varchar (40), supr_contact_name varchar(30), supr_city varchar(15))

create table sales.customers(
	cust_id serial primary key,
	cust_name varchar(40),
	cust_city varchar(15),
	cust_location_id integer
)

select * from dblink('localhost','select customer_id,company_name,city from customers')
as data(cust_id integer,cust_name varchar (40), cust_city varchar(15))

create table sales.categories(
	cate_id serial primary key,
	cate_name varchar(15),
	cate_description text
)

select * from dblink('localhost','select category_id,category_name,description from categories')
as data(cate_id integer,cate_name varchar (15), cate_description text)

create table sales.products(
	prod_id serial primary key,
	prod_name varchar(40),
	prod_quantity varchar(20),
	prod_price money,
	prod_in_stock smallint,
	prod_in_order smallint,
	prod_reorder_level smallint,
	prod_discontinued bit,
	prod_cate_id integer,
	prod_supr_id integer,
	foreign key (prod_cate_id) references sales.categories(cate_id),
	foreign key (prod_supr_id) references sales.suppliers(supr_id)
	
)
select * from dblink('localhost','select product_id,product_name,quantity_per_unit, unit_price, units_in_stock, units_in_order, reorder_level, discontinued from products')
as data(prod_id integer, prod_name varchar(40), prod_quantity varchar(20), prod_price money, prod_in_stock smallint,
	prod_in_order smallint,
	prod_reorder_level smallint,
	prod_discontinued bit)

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
	order_cust_id integer,
	order_ship_id integer,
	foreign key (order_cust_id) references sales.customers(cust_id),
	foreign key (order_ship_id) references sales.shipper(ship_id)
)

select * from dblink('localhost','select order_id,order_date,required_date, shipped_date, freight, ship_city, ship_address from orders')
as data(order_id integer, order_date timestamp,
	order_required_date timestamp,
	order_shipped_date timestamp,
	order_freight money,
	order_ship_city varchar(15),
	order_ship_address varchar(60)
	)

create table sales.orders_detail(
	ordet_order_id integer,
	ordet_prod_id integer,
	ordet_price money,
	ordet_quantity smallint,
	ordet_discount real,
	constraint pk_sales_ordet primary key(ordet_order_id, ordet_prod_id),
	foreign key (ordet_order_id) references sales.orders(order_id),
	foreign key (ordet_prod_id) references sales.products(prod_id)
	
)
select * from dblink('localhost','select order_id,unit_price,quantity, discount from order_detail')
as data(ordet_order_id integer,
	ordet_price money,
	ordet_quantity smallint,
	ordet_discount real
	)

