create table sales.locations(
	location_id serial primary key
)
create table sales.suppliers(
	supr_id serial primary key,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15)
)
insert into sales.suppliers (supr_id,supr_name,supr_contact_name,supr_city)
select * from dblink('localhost','select supplier_id,company_name,contact_name, city from supplier')
as data(supr_id integer,supr_name varchar (40),supr_contact_name varchar(30),supr_city varchar(15))
select * from sales.suppliers

create table sales.customers(
	cust_id varchar(10) primary key,
	cust_name varchar(40),
	cust_city varchar(15)
)
insert into sales.customers (cust_id,cust_name,cust_city)
select * from dblink('localhost','select customer_id, company_name, city from customers')
as data(cust_id varchar(10),cust_name varchar (40),cust_city varchar(15))
select * from sales.customers

create table sales.employees(
	employee_id serial primary key
)
insert into sales.employees (employee_id)
select * from dblink('localhost','employee_id from employees')
as data(employee_id integer)
select * from sales.employees

create table sales.shippers(
	ship_id serial primary key,
	ship_name varchar(40),
	ship_phone varchar(24)
)
insert into sales.shippers (ship_id,ship_name,ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))
select * from sales.shippers

create table sales.categories(
	cate_id serial primary key,
	cate_name varchar(15),
	cate_description text
)
insert into sales.categories (cate_id,cate_name,cate_description)
select * from dblink('localhost','select category_id, category_name, description from categories')
as data(cate_id smallint, cate_name varchar(15), cate_description text)
select * from sales.categories

create table sales.products(
	prod_id serial primary key,
	prod_name varchar(40),
	prod_quantity varchar(20),
	prod_price real,
	prod_in_stock smallint,
	prod_on_order smallint,
	prod_reorder_level smallint,
	prod_discontinued bit,
	prod_cate_id integer,
	prod_supr_id integer,
	foreign key (prod_cate_id) references sales.categories(cate_id),
	foreign key (prod_supr_id) references sales.suppliers(supr_id)
)
insert into sales.products (prod_id,prod_name,prod_quantity,prod_price,prod_in_stock,prod_on_order
							,prod_reorder_level,prod_discontinued,prod_cate_id,prod_supr_id)
select * from dblink('localhost','select product_id, product_name, quantity_per_unit,unit_price,
					 units_in_stock, units_in_order, reorder_level,discontinued, category_id,
					 supplier_id from products')
as data(prod_id integer, prod_name varchar(40), prod_quantity varchar(20),prod_price real,
		prod_in_stock smallint,prod_on_order smallint,prod_reorder_level smallint,
	   prod_discontinued bit,prod_cate_id integer,prod_supr_id integer)
select * from sales.products

create table sales.orders(
	order_id serial primary key,
	order_date timestamp,
	order_required_date timestamp,
	order_shipped_date timestamp,
	order_freiht real,
	order_subtotel money,
	order_total_qty smallint,
	order_ship_city varchar(15),
	order_ship_address varchar(60),
	order_status varchar(15),
	order_employee_id integer,
	order_cust_id varchar,
	order_ship_id integer,
	foreign key (order_cust_id) references sales.customers(cust_id),
	foreign key (order_ship_id) references sales.shippers(ship_id)
)

insert into sales.orders (order_id, order_date, order_required_date, order_shipped_date,order_freiht 
	,order_ship_city, order_ship_address,order_employee_id, order_cust_id,order_ship_id)
select * from dblink('localhost','select order_id, order_date, required_date, shipped_date, freight,
	ship_city,ship_address, employee_id, customer_id, shipper_id from orders')
as data(order_id integer, order_date timestamp, order_required_date timestamp,order_shipped_date timestamp,
		order_freiht real, order_ship_city varchar(15), order_ship_address varchar(60), 
	order_employee_id integer, order_cust_id varchar, order_ship_id integer)
select * from sales.orders

create table sales.orders_detail(
	order_order_id integer,
	order_prod_id integer,
	order_price real,
	order_quantity smallint,
	order_discount real,
	foreign key (order_order_id) references sales.orders(order_id),
	foreign key (order_prod_id) references sales.products(prod_id),
	constraint detail_pk primary key (order_order_id,order_prod_id)
)
insert into sales.orders_detail (order_order_id,order_prod_id,order_price, order_quantity,order_discount)
select * from dblink('localhost','select order_id,product_id, unit_price,quantity,discount from order_details')
as data(order_order_id integer,order_prod_id integer,order_price real,
		order_quantity smallint,order_discount real)
select * from sales.orders_detail

