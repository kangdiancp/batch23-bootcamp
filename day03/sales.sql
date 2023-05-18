CREATE SCHEMA SALES

CREATE EXTENSION DBLINK

create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost')

create table sales.shippers(
	ship_id serial primary key,
	ship_name varchar(40),
	ship_phone varchar(24)
)

select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))

create table sales.customers (
	cust_id varchar(10),
	cust_name varchar(40),
	cust_city varchar(15)
)

drop table sales.customers cascade 

select * from dblink('localhost','select customer_id,company_name,city from customers')
as data(cust_id varchar(10),cust_name varchar (40), cust_city varchar(15))


create table sales.suppliers (
	supr_id serial primary key,
	supr_name varchar(40),
	supr_contact_name varchar(30),
	supr_city varchar(15)
)


select * from dblink('localhost','select supplier_id,company_name,contact_name,city from supplier')
as data(supr_id integer,supr_name varchar (40), supr_contact_name varchar(30), supr_city varchar(15))


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
	prod_surp_id int,
	foreign key (prod_cate_id) references sales.categories(cate_id),
	foreign key (prod_surp_id) references sales.suppliers(supr_id)
)


select * from dblink('localhost','select product_id,product_name,quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued from products')
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
	foreign key (order_ship_id) references sales.shippers(ship_id)
)


select * from dblink('localhost','select order_id,order_date,required_date, shipped_date, freight, ship_city, ship_address from orders')
as data(order_id integer, order_date timestamp,
	order_required_date timestamp,
	order_shipped_date timestamp,
	order_freight money,
	order_ship_city varchar(15),
	order_ship_address varchar(60)
	)


create table sales.categories (
	cate_id serial primary key,
	cate_name varchar(15),
	cate_description text
)


select * from dblink('localhost','select category_id,category_name,description from categories')
as data(cate_id integer,cate_name varchar (15), cate_description text)


create table sales.orders_detail (
	ordet_order_id integer,
	ordet_prod_id integer,
	ordet_price money,
	ordet_quantity smallint,
	ordet_discount real,
	constraint sales_ordet_pk primary key (ordet_order_id, ordet_prod_id),
	foreign key (ordet_order_id) references sales.orders(order_id),
	foreign key(ordet_prod_id) references sales.products(prod_id)
)


select * from dblink('localhost','select order_id,unit_price,quantity, discount from order_detail')
as data(ordet_order_id integer,ordet_price money,ordet_quantity smallint,ordet_discount real
)


----- // DAY 03 // -----

begin;
declare  s1 cursor for select * from employees;

fetch 10 from s1
commit
/*
NEXT
PRIOR
FIRST
LAST
ABSOLUTE count
RELATIVE count
ALL
FORWARD
FORWARD ALL
BACKWARD
BACKWARD count
BACKWARD ALL
*/

//function 1
create or replace function get_profile (year integer)
	returns text as $$
declare
	profiles text default '';
	rec_emp record;
	cur_emp cursor(year integer)
		for select fist_name,last_name,salary,hire_date
		from employees where extract(year from age(now(),hire_date)) = year;
begin
	open cur_emp(year);
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		profiles := profiles || ',' || concat(rec_emp.fist_name,
		rec_emp.last_name) || ':' || rec_emp.salary;
		end loop;
		close cur_emp;
		return profiles;
end;$$
language plpgsql;

//Function 2
create or replace function get_profile (year integer)
	returns table (
		names varchar,
		salarys money
	) as $$ 
declare
	rec_emp record;
	cur_emp cursor(year integer)
		for select fist_name,last_name,salary,hire_date
		from employees where extract(year from age(now(),hire_date)) = year;
begin
	open cur_emp(year);
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		names:= concat(rec_emp.fist_name,rec_emp.last_name);
		salarys:= rec_emp.salary;
		return next;
		end loop;
		close cur_emp;
end;$$
language plpgsql;

//Function 3 (tanpa cursor)
create or replace function get_profile (year integer)
	returns table (
		names varchar,
		salarys money
	) as $$ 
declare
	rec_emp record;
begin
	for rec_emp in select *
	from employees where extract(year from age(now(),hire_date)) = year
	loop
		names:= concat(rec_emp.fist_name,rec_emp.last_name);
		salarys:= rec_emp.salary;
		return next;
		end loop;
end;$$
language plpgsql;

//Function insert
create or replace function insert_region_countries (regname varchar,countryid char, countryname varchar)
	returns void as $$
begin
	insert into regions (region_name) values (regname);
	perform(select setval('"regions_region_id_seq"',(select max(region_id) from regions)));
	insert into countries (country_id,country_name,region_id)
	values (countryid,countryname,currval('"regions_region_id_seq"'));
end;$$
language plpgsql;

//Function edit
create or replace function edit_countries (regionid int,countryid char)
	returns void as $$
begin
	update countries set region_id = region_id where country_id = countryid;
end;$$
language plpgsql;


//Function delete
create or replace function delete_countries (countryid char)
	returns void as $$
begin
	update countries set region_id = region_id where country_id = countryid;
end;$$
language plpgsql;

//Function insert_regcount 
create or replace function insert_regcount (regionname varchar, countryid char, countryname varchar)
	returns void as $$
declare
	rec_data record;
begin
	
	select region_name from regions where region_name = regionname into rec_data;
	perform(select setval('regions_region_id_seq',(select max(region_id) from regions)));
	if rec_data.region_name = regionname
	then null;
	else
		insert into regions(region_name) values (regionname);
	end if;
		select country_id from countries where country_id = countryid into rec_data;
		if rec_data.country_id = countryid
		then null;
		else
		insert into countries (country_id,country_name,region_id)
		values (countryid,countryname,currval('regions_region_id_seq'));
		end if;
end;$$
language plpgsql

select insert_regcount ('MIDLEWAYS','BZ','BRAZIL')

select * from regions
select * from countries


create or replace procedure insert_data (regionname varchar, countryid char, countryname varchar)
language plpgsql
as $$
declare
	rec_data record;
begin
	
	select region_name from regions where region_name = regionname into rec_data;
	perform(select setval('regions_region_id_seq',(select max(region_id) from regions)));
	if rec_data.region_name = regionname
	then null;
	else
		insert into regions(region_name) values (regionname);
	end if;
		select country_id from countries where country_id = countryid into rec_data;
		if rec_data.country_id = countryid
		then null;
		else
		insert into countries (country_id,country_name,region_id)
		values (countryid,countryname,currval('regions_region_id_seq'));
		end if;
end;$$

select insert_data ('AWS','BQ','ENGLAND')

select * from regions
select * from countries


select insert_region_countries ('ASEAN','WH','Philipina')

select edit_countries (2, 'BE')

select delete_countries ('AU')

select * from regions
select * from countries

select get_profile(19)

drop function get_profile(integer)

commit







