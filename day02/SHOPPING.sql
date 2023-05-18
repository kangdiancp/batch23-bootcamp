create table category (
	cateid serial primary key,
	catename varchar(15)
)

create table product (
	prodid smallint primary key,
	prodname varchar(40),
	prodperunit varchar(20),
	prodprice money,
	prodstock smallint,
	prodstockavaible smallint,
	prodcateid integer,
	foreign key (prodcateid) references category(cateid)
)

drop table product cascade

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
)

create table customer (
	custid varchar primary key,
	custname varchar(40),
	custaddress varchar(60),
	custcity varchar(15),
	custcountry varchar(15)
)

drop table customer cascade

create table linelitems (
	liteid serial primary key,
	liteprice money,
	liteqty smallint,
	litediscount real,
	liteprodid integer,
	foreign key (liteprodid) references product(prodid),
	liteordername varchar(25),
	foreign key (liteordername) references orders(ordername)
)

drop table linelitems cascade

create extension dblink;

create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost')


//Function Loadcategory
create or replace function load_category ()
	returns table (
		cateid integer,
		catename varchar(15)
	) as $$
	
declare
	rec_emp record;
	cur_emp cursor
	for select * from dblink('localhost','select category_id,category_name from categories') 
	as data (cateid integer,catename varchar(15));
begin
	open cur_emp;
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
				 
		cateid := rec_emp.cateid;
		catename := rec_emp.catename;
		insert into category values (rec_emp.cateid, rec_emp.catename);
		return next;
		end loop;
		close cur_emp;
end;$$
language plpgsql;

select load_category();

//Function Loadcustomer
create or replace function load_customer ()
	returns table (	
	custid varchar,
	custname varchar,
	custaddress varchar,
	custcity varchar,
	custcountry varchar
) as $$
	
declare
	rec_emp record;
	cur_emp cursor
		for select * from dblink('localhost','select customer_id,company_name ,address,city,country from customers')
		as data(prodid smallint primary key,prodname varchar(40),prodperunit varchar(20),prodprice money,prodstock smallint,prodstockavaible bit,prodcateid integer,);
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

select load_customer();
drop function load_customer

//Function LoadProduct
create or replace function load_product ()
	returns table (	
	prodid smallint,
	prodname varchar,
	prodperunit varchar,
	prodprice money,
	prodstock smallint,
	prodstockavaible smallint,
	prodcateid integer
) as $$
	
declare
	rec_emp record;
	cur_emp cursor
		for select * from dblink('localhost','select product_id,product_name ,quantity_per_unit,unit_price,units_in_stock,discontinued,category_id from products')
		as data(prodid smallint,prodname varchar(40),prodperunit varchar(20),prodprice money,prodstock smallint,prodstockavaible smallint,prodcateid integer);
begin
	open cur_emp;
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		prodid:= rec_emp.prodid;
		prodname:= rec_emp.prodname;
		prodperunit:= rec_emp.prodperunit;
		prodprice:= rec_emp.prodprice;
		prodstock:= rec_emp.prodstock;
		prodstockavaible:= rec_emp.prodstockavaible;	
		prodcateid:= rec_emp.prodcateid;
		insert into product values(rec_emp.prodid,rec_emp.prodname,rec_emp.prodperunit,rec_emp.prodprice,rec_emp.prodstock,rec_emp.prodstockavaible,rec_emp.prodcateid);
		return next;
		end loop;
		close cur_emp;
end;$$
language plpgsql;


select load_product();
drop function load_product

//Function LoadOrder
create sequence seq_ord_number
increment 1
minvalue 1
maxvalue 9223372036854775807
start 1

create or replace function GetOrderName () 
returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql


--- start input data dummy ---
insert into orders(ordercreated,ordershipname,ordershipaddress,ordershipcity,ordershipcountry,orderqty,ordersubtotal,ordersubdiscount,ordertax,ordertotal,orderstatus,orderidtemp,ordercustid)
values('2023-04-13','wahyu','aku','aku','aku',3,3.4,4.5,4.5,4.4,'aku',5,'BTM')
--- end input data dummy ---
select * from orders


alter table orders alter column ordername set default getordername()
select GetOrderName()

create or replace function loadorder()
    returns table( 
		ordercreated timestamp, 
		ordershipname varchar,
		ordershipaddress varchar,
		ordershipcity varchar,
		ordershipcountry varchar,
		orderqty smallint,
		ordersubtotal money,
		ordersubdiscount money,
		ordertax money,
		ordertotal money,
		orderstatus varchar,
		orderidtemp smallint,
		ordercustid varchar
	) as $$
	
declare
    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost','SELECT o.ship_name, o.ship_address, o.ship_city, 
		o.ship_country, od.quantity, od.unit_price, od.discount, o.ship_region, 
		o.order_id, o.customer_id
        from orders as o
        JOIN order_detail as od 
		on o.order_id = od.order_id ') 
		as data(ordershipname varchar(40), ordershipaddress varchar(60), 
		ordershipcity varchar(15), ordershipcountry varchar(15), orderqty smallint,  
		ordersubtotal money, ordersubdiscount money, orderstatus varchar, orderidtemp smallint, 
		ordercustid varchar(10));

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
        
		case
			when rec_emp.orderstatus is null
				then orderstatus = 'NEW';
			when rec_emp.orderstatus = 'AK'
				then orderstatus = 'cancelled';
			when rec_emp.orderstatus = 'OR'
				then orderstatus = 'CLOSED';
			else orderstatus = 'SHIPPING';
		end case;
			
        orderidtemp := rec_emp.orderidtemp;
        ordercustid := rec_emp.ordercustid;

		insert into orders(ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus,orderidtemp, ordercustid) 
        values (ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus, orderidtemp, ordercustid);
        return next;
        end loop;
      close cur_emp;
end;$$
language plpgsql;

select loadorder()


//Function LoadLineItems
create or replace function loadlineitems()
    returns table(
		liteprice money, 
		liteqty smallint, 
		litediscount real, 
		liteprodid integer, 
		liteordername varchar
	) as $$
	
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
        liteqty := rec_emp.liteqty;
        litediscount := rec_emp.litediscount;
        liteprodid := rec_emp.liteprodid;
		
		orderid := rec_emp.orderid;
		
		select ordername from orders where orderidtemp = orderid into rec_data;
		
		insert into linelitems(liteprice, liteqty, litediscount,  liteprodid, liteordername) 
        values (liteprice, liteqty, litediscount,  liteprodId, rec_data.ordername);
        return next;
        end loop;     
        close cur_emp;     
end;$$
language plpgsql;

select loadlineitems();

select * from linelitems

----- clear table target---

--delete tabel target--
create or replace function delete_categories()
    returns void as $$
begin  
    delete from linelitems;
end;$$
language plpgsql;

select delete_categories()


//Function Update
create or replace function updatesumorder()
return




