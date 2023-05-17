--SALES HR DB--
create table sales.shippers(
    ship_id int primary key,
    ship_name varchar(40),
    ship_phone varchar(24)
)

create table sales.employees(
    employee_id int primary key
)

create table sales.locations(
    location_id int primary key
)

create table sales.suppliers(
    supr_id int primary key,
    supr_name varchar(40),
    supr_contact_name varchar(30),
    supr_city varchar(15),
    supr_location_id int
)

create table sales.customers(
    cust_id varchar(10) primary key,
    cust_name varchar(40),
    cust_city varchar(15),
    cust_location_id int
)

create table sales.categories(
    cate_id int primary key,
    cate_name varchar(15),
    cate_description text
)

create table sales.products(
    prod_id int primary key,
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

create table sales.orders(
    order_id int primary key,
    order_date timestamp,
    order_required_date timestamp,
    order_shipped_date timestamp,
    order_freight money,
    order_subtotal money,
    order_total_qty smallint,
    order_ship_city varchar(15),
    order_ship_address varchar(60),
    order_status varchar(15),
    order_employee_id int,
    order_cust_id varchar(10),
    order_ship_id int,
    foreign key (order_cust_id) references sales.customers(cust_id),
    foreign key (order_ship_id) references sales.shippers(ship_id)
)

create table sales.orders_detail(
    ordet_order_id int,
    ordet_prod_id int,
    ordet_price money,
    ordet_quantity smallint,
    ordet_discount real,
    foreign key (ordet_order_id) references sales.orders(order_id),
    foreign key (ordet_prod_id) references sales.products(prod_id),
	constraint ordet_orderprod_pk primary key (ordet_order_id, ordet_prod_id)
)

--
--migrate data sales
--
create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost')

insert into sales.shippers (ship_id,ship_name,ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))
--
--shipper
insert into sales.shippers (ship_id,ship_name,ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))

--suppliers
insert into sales.suppliers (supr_id, supr_name, supr_contact_name, supr_city)
select * from dblink('localhost','select supplier_id,company_name,contact_name,city from supplier')
as data(supr_id integer,supr_name varchar (40),supr_contact_name varchar(30),supr_city varchar(15))

--customers
insert into sales.customers (cust_id, cust_name, cust_city)
select * from dblink('localhost','select customer_id, company_name, city from customers')
as data(cust_id varchar(10),cust_name varchar(40), cust_city varchar(15))

--categories
insert into sales.categories (cate_id, cate_name, cate_description)
select * from dblink('localhost','select category_id, category_name, description from categories')
as data(cate_id int, cate_name varchar(15), cate_description text)

--products
insert into sales.products (prod_id,prod_name,prod_quantity,prod_price,prod_in_stock,prod_on_order,prod_reorder_level,prod_discontinued,prod_cate_id,prod_supr_id)
select * from dblink('localhost','select product_id,product_name,quantity_per_unit,unit_price,units_in_stock,units_in_order,reorder_level,discontinued,category_id,supplier_id from products')
as data(prod_id int, prod_name varchar(40), prod_quantity varchar(20), prod_price money, prod_in_stock smallint,prod_on_order smallint,prod_reorder_level smallint,prod_discontinued bit,prod_cate_id int,prod_supr_id int,)

--orders
insert into sales.orders (order_id,order_date,order_required_date,order_shipped_date,order_freight,order_ship_city,order_ship_address,order_employee_id,order_cust_id,order_ship_id)
select * from dblink('localhost','select order_id,order_date,required_date,shipped_date,freight,ship_city,ship_address,employee_id,customer_id,ship_via from orders')
as data(order_id int,order_date timestamp,order_required_date timestamp,order_shipped_date timestamp,order_freight money,order_ship_city varchar(15),order_ship_address varchar(60),order_employee_id int,order_cust_id varchar(10),order_ship_id int)

--order_detail
insert into sales.orders_detail (ordet_order_id,ordet_prod_id,ordet_price,ordet_quantity,ordet_discount)
select * from dblink('localhost','select order_id,product_id,unit_price,quantity,discount from order_detail')
as data(ordet_order_id int,ordet_prod_id int,ordet_price money,ordet_quantity smallint,ordet_discount real)
