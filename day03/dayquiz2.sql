-- Create DB
create table category(
    cateid serial primary key,
    catename varchar(15)
);

create table product(
    prodid serial primary key,
    prodname varchar(40),
    prodperunit varchar(20),
    prodprice money,
    prodstock smallint,
    prodstockavailable bit,
    prodcateid int,
    foreign key (prodcateid) references category(cateid)
);

create table customer(
    custid serial primary key,
    custname varchar(35),
    custaddress varchar(60),
    custcity varchar(15),
    custcountry varchar(15)
);

create table orders(
    ordername varchar(25) primary key,
    ordercreated timestamp,
    ordershipname varchar(40),
    ordershipaddress varchar(60),
    ordershipcity varchar(15),
    ordershipcountry varchar(15),
    orderqty smallint,
    ordersubtotal money,
    ordersubdiscount money,
    ordertax money,
    ordertotal money,
    orderstatus varchar(15),
    orderidtemp int,
    ordercustid int,
    foreign key (ordercustid) references customer(custid)
);

create table lineitems(
    liteid serial primary key,
    liteprice money,
    liteqty smallint,
    litediscount real,
    liteprodid int,
    liteordername varchar(25),
    foreign key (liteprodid) references product(prodid),
    foreign key (liteordername) references orders(ordername)
);

create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost');



--1. LoadCategory

create or replace function loadcategory()
    returns void as $$
begin
    insert into category (catename)
    SELECT catename
    FROM dblink('localhost', 'select category_name from categories')
        as data(catename VARCHAR(15));
end;$$
language plpgsql;

select loadcategory();
select * from category


--2. LoadCustomer
create or replace function loadcustomer()
    returns void as $$
begin
    insert into customer(custname,custaddress,custcity,custcountry)
    select *
    from dblink('localhost', 'select contact_name,address,city,country from customers')
        as data(custname varchar(35),custaddress varchar(60),custcity varchar(15),custcountry varchar(15));
end;$$
language plpgsql;

select loadcustomer();
select * from customer

--3. LoadProduct
create or replace function loadproduct()
    returns void as $$
begin
    insert into product(prodname,prodperunit,prodprice,prodstock,prodstockavailable, prodcateid)
    select *
    from dblink('localhost', 'select product_name,quantity_per_unit,unit_price,units_in_stock,discontinued,category_id from products')
        as data(prodname varchar(40),prodperunit varchar(20),prodprice money,prodstock smallint,prodstockavailable bit, prodcateid int);
end;$$
language plpgsql;

select loadproduct();
select * from product


--4. LoadOrder
CREATE SEQUENCE seq_ord_number
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

create or replace function GetOrderName () 
returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql

--set default ordername
ALTER TABLE orders
ALTER COLUMN orderName SET DEFAULT CONCAT('ORD-', TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-', nextval('seq_ord_number')),
ALTER COLUMN orderName SET NOT NULL

---
---
---contoh
create or replace function loadorder()
    returns void as $$
begin
    insert into orders(ordershipname,ordershipaddress,ordershipcity,ordershipcountry,orderidtemp)
    select *
    from dblink('localhost', 'select ship_name,ship_address,ship_city,ship_country,order_id from orders')
        as data(ordershipname varchar(40),ordershipaddress varchar(60),ordershipcity varchar(15),ordershipcountry varchar(15),orderidtemp int);
end;$$
language plpgsql;

select loadorder();
select * from orders;



--5. LoadLineItems
create or replace function loadlineitems()
    returns void as $$
begin
    insert into lineitems(liteprice,liteqty,litediscount,liteprodid)
    select *
    from dblink('localhost', 'select unit_price,quantity,discount,product_id from order_detail')
        as data(liteprice money,liteqty smallint,litediscount real,liteprodid int);
end;$$
language plpgsql;

select loadlineitems();
select * from lineitems

--6. GetOrderName()

create or replace function getordername()
    returns table( ordercreated timestamp, ordershipname varchar, ordershipaddress varchar, ordershipcity varchar, ordershipcountry varchar, orderqty smallint,ordersubtotal money, ordersubdiscount money, ordertax money,ordertotal money, orderstatus varchar,orderidtemp smallint,ordercustid varchar) as $$
	
declare
    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost',
        'SELECT o.ship_name, o.ship_address, o.ship_city, o.ship_country, od.quantity, od.unit_price, od.discount, o.ship_region, o.order_id, o.customer_id
        from orders as o
        JOIN order_detail as od 
		on o.order_id = od.order_id ') 
		as data(ordershipname varchar(40), ordershipaddress varchar(60), ordershipcity varchar(15), ordershipcountry varchar(15), orderqty smallint,  ordersubtotal money, ordersubdiscount money, orderstatus varchar, orderidtemp smallint, ordercustid varchar(10));

begin
    open cur_emp;
    loop
        fetch cur_emp into rec_emp;
        exit when not found;
        ordercreated := now();
        ordershipname := rec_emp.ordershipname;
        ordershipaddress := rec_emp.ordershipaddress;
        ordershipcity := rec_emp.ordershipcity;
        ordershipcountry := rec_emp.ordershipcountry;
        orderqty := rec_emp.orderqty;
        ordersubtotal  := rec_emp.ordersubtotal;
        ordersubdiscount := rec_emp.ordersubdiscount;
        ordertax := 0.1;
        ordertotal := (ordersubtotal-ordersubdiscount) + ordertax;
        
	
		
		CASE
			WHEN rec_emp.orderstatus IS NULL
				THEN orderstatus = 'NEW';
			WHEN rec_emp.orderstatus = 'AK'
				THEN orderstatus = 'CANCELLED';
			WHEN rec_emp.orderstatus = 'OR'
				then orderstatus = 'CLOSED';
			ELSE orderstatus = 'SHIPPING';
		END CASE;
		
		
		
        orderidtemp := rec_emp.orderidtemp;
        ordercustid := rec_emp.ordercustid;


		insert into orders(ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus,orderidtemp, ordercustid) 
        values (ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus, orderidtemp, ordercustid);
        return next;
        end loop;
        close cur_emp;

end;$$
language plpgsql;

select getordername()
select * from orders



--7. ClearTableTarget()
create or replace function cleartabletarget()
returns void as $$
begin
    delete from category;
end;$$
language plpgsql;

select cleartabletarget();

select * from category
---
---
create or replace function cleartabletarget(table_name varchar)
returns void as $$
begin
    execute 'delete from ' || table_name;
end;$$
language plpgsql;

select cleartabletarget('category');


--8. updatesumorder()
