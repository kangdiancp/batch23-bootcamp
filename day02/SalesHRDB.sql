CREATE TABLE SALES.SHIPPERS(
	SHIP_ID INTEGER PRIMARY KEY,
	SHIP_NAME VARCHAR(40),
	SHIP_PHONE VARCHAR(24)
);

CREATE TABLE SALES.CUSTOMERS(
	CUST_ID INTEGER PRIMARY KEY,
	CUST_NAME VARCHAR(40),
	CUST_CITY VARCHAR(15),
	CUST_LOCATION_ID INTEGER
);

CREATE TABLE SALES.SUPPLIERS(
	SUPR_ID INTEGER PRIMARY KEY,
	SUPR_NAME VARCHAR(40),
	SUPR_CONTACT_NAME VARCHAR(30),
	SUPR_CITY VARCHAR(15),
	SUPR_LOCATION_ID INTEGER
);

CREATE TABLE SALES.ORDERS(
	ORDER_ID INTEGER PRIMARY KEY,
	ORDER_DATE TIMESTAMP,
	ORDER_REQUIRED_DATE TIMESTAMP,
	ORDER_SHIPPED_DATE TIMESTAMP,
	ORDER_FREIGHT MONEY,
	ORDER_SUBTOTAL MONEY,
	ORDER_TOTAL_QTY SMALLINT,
	ORDER_SHIP_CITY VARCHAR(15),
	ORDER_SHIP_ADDRESS VARCHAR(60),
	ORDER_STATUS VARCHAR(15),
	ORDER_EMPLOYEE_ID INTEGER,
	ORDER_CUST_ID INTEGER,
	ORDER_SHIP_ID INTEGER,
	FOREIGN KEY (ORDER_CUST_ID) REFERENCES SALES.CUSTOMERS (CUST_ID),
	FOREIGN KEY (ORDER_SHIP_ID) REFERENCES SALES.SHIPPERS (SHIP_ID)
);

CREATE TABLE SALES.PRODUCTS(
	PROD_ID INTEGER PRIMARY KEY,
	PROD_NAME VARCHAR(40),
	PROD_QUANTITY VARCHAR(20),
	PROD_PRICE MONEY,
	PROD_IN_STOCK SMALLINT,
	PROD_ON_ORDER SMALLINT,
	PROD_REORDER_LEVEL SMALLINT,
	PROD_DISCONTINUED BIT,
	PROD_CATE_ID INTEGER,
	PROD_SUPR_ID INTEGER,
	FOREIGN KEY (PROD_CATE_ID) REFERENCES SALES.CATEGORIES (CATE_ID),
	FOREIGN KEY (PROD_SUPR_ID) REFERENCES SALES.SUPPLIERS (SUPR_ID)
);

CREATE TABLE SALES.ORDERS_DETAIL(
	ORDET_ORDER_ID INTEGER,
	ORDET_PROD_ID INTEGER,
	ORDET_PRICE MONEY,
	ORDET_QUANTITY SMALLINT,
	ORDET_DISCOUNT REAL,
	FOREIGN KEY (ORDET_ORDER_ID) REFERENCES SALES.ORDERS (ORDER_ID),
	FOREIGN KEY (ORDET_PROD_ID) REFERENCES SALES.PRODUCTS (PROD_ID),
	CONSTRAINT ORPROD_ID_PK PRIMARY KEY (ORDET_ORDER_ID,ORDET_PROD_ID)
);

CREATE TABLE SALES.CATEGORIES(
	CATE_ID INTEGER PRIMARY KEY,
	CATE_NAME VARCHAR(15),
	CATE_DESCRIPTION TEXT
);










create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', port '5433', dbname'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost')



-- shippers
insert into sales.shippers (ship_id,ship_name,ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))

SELECT * FROM SALES.SHIPPERS


-- suppliers
insert into sales.suppliers (supr_id,supr_name,supr_contact_name,supr_city)
select * from dblink('localhost','select supplier_id,company_name,contact_name,city from supplier')
as data(supr_id integer,supr_name varchar (40),supr_contact_name varchar(30),supr_city varchar(15))

SELECT * FROM SALES.SUPPLIERS


-- categories
insert into sales.categories (cate_id,cate_name,cate_description)
select * from dblink('localhost','select category_id,category_name,description from categories')
as data(cate_id integer,cate_name varchar(15),cate_description text)

SELECT * FROM SALES.CATEGORIES


--customers
insert into sales.customers (cust_id, cust_name, cust_city)
select * from dblink('localhost','select customer_id, company_name, city from customers')
as data(cust_id varchar(10),cust_name varchar(40), cust_city varchar(15))


--products
insert into sales.products (prod_id,prod_name,prod_quantity,prod_price,prod_in_stock,prod_on_order,prod_reorder_level,prod_discontinued,prod_cate_id,prod_supr_id)
select * from dblink('localhost','select product_id,product_name,quantity_per_unit,unit_price,units_in_stock,units_in_order,reorder_level,discontinued,category_id,supplier_id from products')
as data(prod_id integer, prod_name varchar(40), prod_quantity varchar(20), prod_price money, prod_in_stock smallint,prod_on_order smallint,prod_reorder_level smallint,prod_discontinued bit,prod_cate_id integer,prod_supr_id integer)


--orders
insert into sales.orders (order_id,order_date,order_required_date,order_shipped_date,order_freight,order_ship_city,order_ship_address,order_employee_id,order_cust_id,order_ship_id)
select * from dblink('localhost','select order_id,order_date,required_date,shipped_date,freight,ship_city,ship_address,employee_id,customer_id,ship_via from orders')
as data(order_id int,order_date timestamp,order_required_date timestamp,order_shipped_date timestamp,order_freight money,order_ship_city varchar(15),order_ship_address varchar(60),order_employee_id int,order_cust_id varchar(10),order_ship_id int)


--order_detail
insert into sales.orders_detail (ordet_order_id,ordet_prod_id,ordet_price,ordet_quantity,ordet_discount)
select * from dblink('localhost','select order_id,product_id,unit_price,quantity,discount from order_detail')
as data(ordet_order_id int,ordet_prod_id int,ordet_price money,ordet_quantity smallint,ordet_discount real)
