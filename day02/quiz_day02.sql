-- Tabel "supplier"
CREATE TABLE supplier (
  supplier_id smallint PRIMARY KEY,
  company_name varchar(40),
  contact_name varchar(30),
  contact_title varchar(30),
  region varchar(15),
  phone varchar(24),
  address varchar(60),
  city varchar(15),
  postal_code varchar(10),
  country varchar(15),
  fax varchar(24),
  homepage text
);

-- Tabel "products"
CREATE TABLE products (
  product_id smallint PRIMARY KEY,
  product_name varchar(40),
  quantity_per_unit varchar(20),
  unit_price real,
  units_in_stock smallint,
  units_on_order smallint,
  reorder_level smallint,
  discontinued integer,
  supplier_id smallint REFERENCES supplier(supplier_id),
  category_id smallint REFERENCES categories(category_id)
);

-- Tabel "categories"
CREATE TABLE categories (
  category_id smallint PRIMARY KEY,
  category_name varchar(15),
  description text,
  picture bytea
);

-- Tabel "order_detail"
CREATE TABLE order_detail (
  order_id smallint REFERENCES orders(order_id),
  product_id smallint REFERENCES products(product_id),
  unit_price real,
  quantity smallint,
  discount real,
  PRIMARY KEY (order_id, product_id)
);

-- Tabel "orders"
CREATE TABLE orders (
  order_id smallint PRIMARY KEY,
  order_date date,
  required_date date,
  shipped_date date,
  freight real,
  ship_name varchar(40),
  ship_address varchar(60),
  ship_city varchar(15),
  ship_region varchar(15),
  ship_postal_code varchar(10),
  ship_country varchar(15),
  emp	loyee_id smallint REFERENCES employees(employee_id),
  customer_id char(10) REFERENCES customers(customer_id),
  ship_via smallint REFERENCES shippers(shipper_id)
);

-- Tabel "shippers"
CREATE TABLE shippers (
  shipper_id smallint PRIMARY KEY,
  company_name varchar(40),
  phone varchar(24)
);

-- Tabel "employees"
CREATE TABLE employees (
  employee_id smallint PRIMARY KEY,
  last_name varchar(20),
  first_name varchar(10),
  title varchar(30),
  title_of_courtesy varchar(25),
  birth_date date,
  hire_date date,
  address varchar(60),
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
);

-- Tabel "customers"
CREATE TABLE customers (
  customer_id char(10) PRIMARY KEY,
  company_name varchar(40),
  contact_name varchar(30),
  contact_title varchar(30),
  city varchar(15),
  region varchar(15),
  country varchar(15),
  postal_code varchar(10),
  phone varchar(24),
  fax varchar(24)
);
alter table customers add column address varchar(60)

SELECT * FROM supplier;
SELECT * FROM products;
SELECT * FROM categories;
SELECT * FROM order_detail;
SELECT * FROM orders;
SELECT * FROM shippers;
SELECT * FROM employees;
SELECT * FROM customers;

create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname 'NorthwinDB');
create user mapping for postgres server localhost options (user 'postgres', password 'admin');
select dblink_connect ('localhost')

create schema sales

-- Membuat tabel suppliers
CREATE TABLE sales.suppliers (
  supr_id SERIAL PRIMARY KEY,
  supr_name VARCHAR(40),
  supr_contact_name VARCHAR(30),
  supr_city VARCHAR(15),
  supr_location_id INT
);

-- Membuat tabel customers
CREATE TABLE sales.customers (
  cust_id SERIAL PRIMARY KEY,
  cust_name VARCHAR(40),
  cust_city VARCHAR(15),
  cust_location_id INT
);

-- Membuat tabel shippers
CREATE TABLE sales.shippers (
  ship_id SERIAL PRIMARY KEY,
  ship_name VARCHAR(40),
  ship_phone VARCHAR(24)
);

-- Membuat tabel categories
CREATE TABLE sales.categories (
  cate_id SERIAL PRIMARY KEY,
  cate_name VARCHAR(15),
  cate_description TEXT
);

-- Membuat tabel products
CREATE TABLE sales.products (
  prod_id SERIAL PRIMARY KEY,
  prod_name VARCHAR(40),
  prod_quantity VARCHAR(20),
  prod_price MONEY,
  prod_in_stock SMALLINT,
  prod_on_order SMALLINT,
  prod_reorder_level SMALLINT,
  prod_discontinued BIT,
  prod_cate_id INT REFERENCES sales.categories(cate_id),
  prod_supr_id INT REFERENCES sales.suppliers(supr_id)
);

-- Membuat tabel orders
CREATE TABLE sales.orders (
  order_id SERIAL PRIMARY KEY,
  order_date TIMESTAMP,
  order_required_date TIMESTAMP,
  order_shipped_date TIMESTAMP,
  order_freight MONEY,
  order_total_qty SMALLINT,
  order_ship_city VARCHAR(15),
  order_ship_address VARCHAR(60),
  order_status VARCHAR(15),
  order_employee_id INT,
  order_cust_id INT,
  order_ship_id INT
);

-- Membuat tabel orders_detail
CREATE TABLE sales.orders_detail (
  order_order_id INT REFERENCES sales.orders(order_id),
  order_prod_id INT REFERENCES sales.products(prod_id),
  order_price MONEY,
  order_quantity SMALLINT,
  order_discount REAL,
  PRIMARY KEY (order_order_id, order_prod_id)
);

-- input databaselink dari NorthwinDB ke SalesHRDB

-- INSERT customers
insert into sales.customers(cust_id,cust_name,cust_city,cust_location_id)
select * from dblink('localhost','select customer_id,company_name,contact_name,
					 contact_title,city,region,country,postal_code,phone,
					 fax,address from customers')
as data(customer_id char(10),company_name varchar(40),contact_name varchar(30),
		contact_title varchar(30),region varchar(15),
		country varchar(15),postal_code varchar(10),
		phone varchar(24),fax varchar(24),address varchar(60))

-- INSERT suppliers
insert into sales.suppliers (supr_id,supr_name,supr_contact_name,supr_city)
select * from dblink('localhost','select supplier_id,company_name,contact_name,
					 contact_title,region,phone,address,city,postal_code,country,
					 fax,homepage from supplier')
as data(supplier_id integer,company_name varchar(40),contact_name varchar(30),
		contact_title varchar(30),region varchar(15),phone varchar(24),address varchar(60),
		city varchar(15),postal_code varchar(10),country varchar(15),fax varchar(24),
		homepage text)

--INSERT shippers
insert into sales.shippers (ship_id,ship_name,ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))

--INSERT categories
insert into sales.categories (cate_id,ship_name,cate_description)
select * from dblink('localhost','select category_id,category_name,description,picture from categories')
as data(category_id integer,category_name varchar(15),description text,picture bytea)

--INSERT products
insert into sales.products (prod_id,prod_name,prod_quantity,prod_price,prod_in_stock,prod_on_order,prod_reorder_level,prod_discontinued,prod_cate_id,prod_supr_id)
select * from dblink('localhost','select product_id,product_name,quantity_per_unit,
					 unit_price,units_in_stock,units_on_order,reorder_level,discontinued, 
					 supplier_id,category_id from products')
as data(product_id integer,product_name varchar(40),quantity_per_unit varchar(20),
		unit_price real,units_in_stock smallint,units_on_order smallint,reorder_level smallint,
		discontinued integer,supplier_id smallint,category_id smallint)

--INSERT orders
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
		
--INSERT order_detail
insert into sales.order_detail(order_order_id,order_prod_id,order_price,order_quantity,order_discount)
select * from dblink('localhost','select order_id,product_id,unit_price,
					 quantity,discount from order_detail')
as data(order_id smallint,product_id smallint,unit_price real,
		quantity smallint,discount real)
