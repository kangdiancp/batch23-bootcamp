create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname 'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres', password 'admin');

select dblink_connect ('localhost')

create table sales.suppliers(
	supr_id serial primary key,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15)
);

create table sales.customers(
	cust_id serial primary key,
	cust_name varchar(40),
	cust_city varchar(15),
	cust_location_id integer
);

create table sales.shippers(
	ship_id serial primary key,
	ship_name varchar(40),
	ship_phone varchar(25)
);

create table sales.categories(
	cate_id serial primary key,
	cate_name varchar(15),
	cate_description text
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
	prod_cate_id integer,
	prod_supr_id integer,
	foreign key (prod_cate_id) references sales.categories(cate_id),
	foreign key (prod_supr_id) references sales.suppliers(supr_id)
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

create table sales.orders_detail(
	order_order_id serial,
	order_prod_id serial,
	order_price money,
	order_quantity smallint,
	order_discount real,
	foreign key (order_order_id) references sales.orders(order_id),
	foreign key (order_prod_id) references sales.products(prod_id),
	constraint order_order_id primary key(order_order_id,order_prod_id)
);


--input databaselink dari dbnorthwind ke saleshrd
--bagian shippers
insert into sales.shippers (ship_id,ship_name,ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar(40),ship_phone varchar(24))

--bagian supplier
insert into sales.suppliers (supr_id,supr_name,supr_contact_name,supr_city)
select * from dblink('localhost','select supplier_id,company_name,contact_name,
					 contact_title,addres,city,region,postal_code,country,phone,fax,homepage from suppliers')
as data(supplier_id integer,company_name varchar (40),contact_name varchar(30),
		contact_title varchar(30),addres varchar(60),city varchar(15),
		region varchar(15),postal_code varchar(10),country varchar(15),
		phone varchar(24),fax varchar(24),homepage text)
	
--bagian customer
--insert into data diambil dari query saleshrd/dblink
--select diambil dari database northwind
insert into sales.customers(cust_id,cust_name,cust_city,cust_location_id)
select * from dblink('localhost','select customer_id,company_name,contact_name,
					 contact_title,address,city,region,postal_code,country,phone,fax from customers')
as data(customer_id char(10),company_name varchar(40),contact_name varchar(30),
		contact_title varchar(30),address varchar(60),city varchar(15),
		region varchar(15),postal_code varchar(10),country varchar(15),
		phone varchar(24),fax varchar(24))

--bagian categories
insert into sales.categories(cate_id,cate_name,cate_description)
select * from dblink('localhost','select category_id,category_name,description,picture from categories')
as data(category_id smallint,category_name varchar(15),description text,picture bytea)

--bagian products
insert into sales.products(prod_id,prod_name,prod_quantity,prod_price,prod_in_stock,prod_on_order,
						  prod_reorder_level,prod_discountinued,prod_cate_id,prod_supr_id)
select * from dblink('localhost','select product_id,product_name,quantity_per_unit,unit_price,
					 unit_in_stock,unit_in_order,reorder_level,discontinued,supplier_id,
					 category_id from products')
as data(product_id smallint,product_name varchar(40),quantity_per_unit varchar(20),
		unit_price real,unit_in_stock smallint,unit_in_order smallint,reorder_level smallint,
		discontinued integer,supplier_id smallint,category_id smallint)
		
--bagian orders
insert into sales.orders(order_id,order_date,order_required_date,order_shipped_date,
						 order_freight,order_subtotal,order_total_qty,order_ship_city,
						 order_ship_address,order_status,order_employee_id,order_cust_id,order_ship_id)
select * from dblink('localhost','select order_id,order_date,required_date,shipped_date,freight,
					 ship_name,ship_address,ship_city,ship_region,ship_postal_code,ship_country,
					 employee_id,customer_id,ship_via from orders')
as data(order_id smallint,order_date date,required_date date,shipped_date date,freight real,
		ship_name varchar(40),ship_address varchar(60),ship_city varchar(15),ship_region varchar(15),
		ship_postal_code varchar(10),ship_country varchar(15),employee_id smallint,customer_id varchar(10),
		ship_via smallint)

--bagian order_detail
insert into sales.order_detail(order_order_id,order_prod_id,order_price,order_quantity,order_discount)
select * from dblink('localhost','select order_id,product_id,unit_price,quantity,discount from order_detail')
as data(order_id smallint,product_id smallint,unit_price real,quantity smallint,discount real)

