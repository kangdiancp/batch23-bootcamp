create table category(
	cateid serial primary key,
	catename varchar(15)
)

create table product(
	prodid serial primary key,
	prodname varchar(40),
	prodperunit varchar(20),
	prodprice money,
	prodstock smallint,
	Prodstockavailable bit,
	prodcateid integer,
	foreign key (prodcateid) references category (cateid)
)

create table customer(
	custid varchar primary key,
	custname varchar(40),
	custaddress varchar(60),
	custcity varchar(15),
	custcountry varchar(15)
)

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

create table lineitems(
	liteid serial primary key,
	liteprice money,
	liteqty smallint,
	litediscount real,
	liteprodid integer,
	liteordername varchar(25),
	foreign key (liteprodid) references product(prodid),
	foreign key (liteordername) references orders(ordername)	
)
select * from category
select * from product
select * from customer
select * from orders
select * from lineitems

//load_catagory

create or replace function load_category()
	returns table (
		cateid integer,
		catename varchar(15)
	) as $$
	
declare
	rec_emp record;
	cur_emp cursor
		for select *
		  from dblink('localhost','select category_id,category_name from categories') 
		  as data(cateid integer,catename varchar (15));
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

select load_category()

select * from category


//Load_costomer

create or replace function load_costomer()
	returns table(
	custid varchar,
	custname varchar (40),
	custaddress varchar(60),
	custcity varchar(15),
	custcountry varchar(15)
	) as $$
declare
	rec_emp record;
	cur_emp cursor
		for select * from dblink('localhost','select customer_id,company_name ,address,city,country from customers')
		as data(custid varchar,custname varchar (40),custaddress varchar(60),custcity varchar(15),custcountry varchar(15));
begin

	open cur_emp;
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		custid:= rec_emp.custid;
		custname:= rec_emp.custname;
		custaddress:= rec_emp.custaddress;
		custcity:= rec_emp.custcity;
		custcountry:= rec_emp.custcountry;
		insert into customer values(rec_emp.custid,rec_emp.custname,rec_emp.custaddress,rec_emp.custcity,rec_emp.custcountry);
		return next;
		end loop;
		close cur_emp;
end;$$
language plpgsql;

select load_costomer()

select * from customer


// Load_product

drop function load_product()
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

select * from product

// load_orders

CREATE SEQUENCE seq_ord_number
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

create or replace function GetOrderName () 
returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql

ALTER TABLE orders
ALTER COLUMN orderName SET DEFAULT CONCAT('ORD-', TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-', nextval('seq_ord_number')),
ALTER COLUMN orderName SET NOT NULL


create or replace function get_orders()
    returns table( ordercreated timestamp, ordershipname varchar, ordershipaddress varchar, ordershipcity varchar, ordershipcountry varchar, orderqty smallint,ordersubtotal money, ordersubdiscount money, ordertax money,ordertotal money, orderstatus varchar,orderidtemp smallint,ordercustid varchar) as $$
	
declare
    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost',
        'SELECT o.ship_name, o.ship_address, o.ship_city, o.ship_country, od.quantity, od.unit_price, od.discount, o.ship_region, o.order_id, o.customer_id
        from orders as o
        JOIN order_details as od 
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

select get_orders()
select * from orders


 
 
 
 
 create or replace function get_lineitems()
    returns table(liteprice money, liteqty smallint, litediscount real, liteprodid integer, liteordername varchar) as $$
	
declare
    rec_data record;
	orderid smallint;
    rec_emp record;
	
    cur_emp cursor
        for select * from dblink('localhost','select unit_price, quantity, discount,product_id, order_id from order_details ') 
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

-- clear table target
create or replace function delete_categories()
    returns void as $$
begin  
    delete from LineItems;
end;$$
language plpgsql;

select delete_categories()

