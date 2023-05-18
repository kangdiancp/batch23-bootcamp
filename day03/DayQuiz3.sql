create table category(
	cateld serial primary key,
	catename varchar(15)
)
alter table category rename column cateld to cateid
create table product(
	prodid integer primary key,
	prodname varchar(40),
	prodperunit varchar(20),
	prodprice money,
	prodstock smallint,
	prodstockavailable bit,
	prodcateid integer,
	foreign key (prodcateid) references category(cateid)
)

create table customer(
	custid varchar primary key,
	custname varchar(40),
	custaddress varchar(60),
	custcity varchar(15),
	custcountry varchar(15)	
)
drop table customer cascade

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
	orderidtemp integer,
	ordercustid varchar,
	foreign key (ordercustid) references customer(custid)
)

create table lineitems (
	liteid serial primary key,
	liteprice money,
	liteqty smallint,
	litediscount real,
	liteprodid integer,
	liteordername varchar(25),
	foreign key (liteprodid) references product(prodid),
	foreign key (liteordername) references orders(ordername)
)

create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres',password 'admin');
select dblink_connect ('localhost')

create or replace function load_category ()
	returns table (
		cateid integer,
		catename varchar(15)
	) as $$
	
declare
	rec_emp record;
	cur_emp cursor
		for select *
		from dblink('localhost','select category_id, category_name from categories')
		as data(cateid integer, catename varchar(15));
begin
	open cur_emp;
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		cateid:= rec_emp.cateid;
		catename:= rec_emp.catename;
		insert into category values (rec_emp.cateid, rec_emp.catename);
		return next;
		end loop;
		close cur_emp;
end;$$
language plpgsql;
select * from category
select load_category()


select * from category

create or replace function get_customer ()
    returns table( custid varchar, custname varchar, custaddress varchar,custcity varchar, custcountry varchar) as $$
	
declare
    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost','select customer_id,company_name,address,city,country from customers') 
		as data(CustId varchar(10),CustName varchar (40), CustAddress varchar(80), CustCity varchar(15), CustCountry varchar(15));
begin
    open cur_emp;
    loop
        fetch cur_emp into rec_emp;
        exit when not found;
        custid := rec_emp.CustId;
        custname := rec_emp.CustName;
        custaddress := rec_emp.CustAddress;
        custcity := rec_emp. CustCity;
        custcountry := rec_emp.CustCountry;
		insert into customer(CustId, CustName, CustAddress, CustCity, CustCountry) 
        values (rec_emp.CustId, rec_emp.CustName, rec_emp.CustAddress, rec_emp. CustCity, rec_emp.CustCountry);
        return next;
        end loop;
        close cur_emp;
       
end;$$
language plpgsql;

select get_customer()

create or replace  function load_product()
	returns table(
	prodid integer,
	prodname varchar(40),
	prodperunit varchar(20),
	prodprice money,
	prodstock smallint,
	Prodstockavailable bit,
	prodcateid integer
	) as $$
declare
	rec_emp record;
	cur_emp cursor
		for select * from dblink('localhost','select product_id,product_name ,quantity_per_unit,unit_price,units_in_stock,discontinued,category_id from products')
		as data(prodid integer,prodname varchar (40),prodperunit varchar(20),prodprice money,prodstock smallint,Prodstockavailable bit,prodcateid integer);
begin

	open cur_emp;
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		prodid:= rec_emp.prodid;
		prodname:=rec_emp.prodname;
		prodperunit:=rec_emp.prodperunit;
		prodprice:=rec_emp.prodprice;
		prodstock:=rec_emp.prodstock;
		Prodstockavailable:= rec_emp.Prodstockavailable;
		prodcateid :=rec_emp.prodcateid;
		
		insert into product values(rec_emp.prodid,rec_emp.prodname,rec_emp.prodperunit,rec_emp.prodprice,rec_emp.prodstock,rec_emp.Prodstockavailable,rec_emp.prodcateid);
		return next;
		end loop;
		close cur_emp;
end;$$
language plpgsql;

select load_product()
CREATE SEQUENCE seq_ord_number
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

create or replace function GetOrderName () 
returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql

select GetOrderName()

--- start input data dummy ---
insert into orders(ordercreated,ordershipname,ordershipaddress,ordershipcity,ordershipcountry,orderqty,ordersubtotal,ordersubdiscount,ordertax,ordertotal,orderstatus,orderidtemp,ordercustid)
values('2001-05-22','Dharu','saya','aku','aku',3,4.5,4.4,4.5,4.4,'aku',4,'ANATR')
--- end input data dummy ---
select * from orders



create sequence seq_ord_number
increment 1
minvalue 1
maxvalue 9223372036854775807
start 1

create or replace function GetOrderName () returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql

insert into orders(ordercreated,ordershipname,ordershipaddress,ordershipcity,ordershipcountry,orderqty,ordersubtotal,ordersubdiscount,ordertax,ordertotal,orderstatus,orderidtemp,ordercustid)
values('2025-10-22','ani','kalideres','jakarta','indonesia',3,4.5,4.4,4.5,4.4,'aku',4,'ANATR');

ALTER TABLE orders
ALTER COLUMN orderName SET DEFAULT CONCAT('ORD-', TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-', nextval('seq_ord_number')),
ALTER COLUMN orderName SET NOT NULL

select * from orders

create or replace function get_orders()
    returns table( ordercreated timestamp, ordershipname varchar, ordershipaddress varchar, ordershipcity varchar, ordershipcountry varchar, orderqty smallint,ordersubtotal money, ordersubdiscount money, ordertax money,ordertotal money, orderstatus varchar,orderidtemp smallint,ordercustid varchar) as $$
	
declare
    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost',
        'SELECT o.ship_name, o.ship_address, o.ship_city, o.ship_country, od.quantity, od.unit_price, od.discount, o.ship_region, o.order_id, o.customer_id
        from orders as o
        JOIN order_detail as od 
		on o.order_id = od.order_id ') 
		as data(ordershipname varchar(40), ordershipaddress varchar(60), ordershipcity varchar(15), ordershipcountry varchar(15), orderqty smallint, ordersubtotal money, ordersubdiscount money, orderstatus varchar, orderidtemp smallint, ordercustid varchar(10));

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

select get_orders()
select * from orders

create or replace function get_lineitems()
    returns table(liteprice money, liteqty smallint, litediscount real, liteprodid integer, liteordername varchar) as $$
	
declare
    rec_data record;
	orderid smallint;
    rec_emp record;
	
    cur_emp cursor
        for select * from dblink('localhost','select unit_price, quantity, discount,product_id, order_id from order_detail ') 
		as data(liteprice money, liteqty smallint, litediscount real, liteprodid integer, orderid smallint);
begin
    open cur_emp;

    loop
        fetch cur_emp into rec_emp;
       
        exit when not found;
       
        liteprice := rec_emp.liteprice;
        liteqty:= rec_emp.liteqty;
        litediscount := rec_emp.litediscount;
        liteprodid := rec_emp.liteprodid;
		
		orderid := rec_emp.orderid;
		
		select ordername from orders where orderidtemp = orderid into rec_data;
		

 
		insert into lineitems(liteprice, liteqty, litediscount,  liteprodid, liteordername) 
        values (liteprice, liteqty, litediscount,  liteprodid, rec_data.ordername);
        return next;
        end loop;
      
        close cur_emp;
       
end;$$
language plpgsql;

select get_lineitems();

select * from lineitems

create or replace function delete_categories()
    returns void as $$
begin  
    delete from LineItems;
end;$$


language plpgsql;

select delete_categories()

