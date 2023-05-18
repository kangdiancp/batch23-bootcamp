create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres',password 'admin');
select dblink_connect ('localhost')

create table category(
	cateid serial primary key,
	catename varchar(15)
)
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
	custid varchar(15) primary key,
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
	ordercustid varchar(15),
	foreign key (ordercustid)references customer(custid)
)
create table lineitems(
	liteid serial primary key,
	liteprice money,
	liteqyt smallint,
	litediscount real,
	liteprodid integer,
	liteordername varchar(25),
	foreign key (liteprodid) references product(prodid),
	foreign key (liteordername) references orders(ordername)
)

--load category 
create or replace function load_category ()
	returns table (
		cateid integer,
		catename varchar(15)
	) as $$
declare
	rec_cate record;
	cur_cate cursor
		for select *
		from dblink('localhost','select category_id, category_name from categories')
		as data(cateid integer, catename varchar(15));
begin
	open cur_cate;
	loop
		fetch cur_cate into rec_cate;
		exit when not found;
		
		cateid:= rec_cate.cateid;
		catename:= rec_cate.catename;
		insert into category values (rec_cate.cateid, rec_cate.catename);
		return next;
		end loop;
		close cur_cate;
end;$$
language plpgsql;
select load_category()
select * from category

--load customer
create or replace function load_customer()
returns table(
	custid varchar(15),
	custname varchar(40),
	custaddress varchar(60),
	custcity varchar(15),
	custcountry varchar(15)
)as $$
declare 
	rec_cust record;
	cur_cust cursor
		for select *
		from dblink('localhost','select customer_id,company_name, address,city,country from customers')
		as data(custid varchar(15),custname varchar(40),custaddress varchar(60),custcity varchar(15),custcountry varchar(15));
begin
	open cur_cust;
	loop
		fetch cur_cust into rec_cust;
		exit when not found;
		custid:= rec_cust.custid;
		custname:= rec_cust.custname;
		custaddress:= rec_cust.custaddress;
		custcity:= rec_cust.custcity;
		custcountry:= rec_cust.custcountry;
		insert into customer values (rec_cust.custid, rec_cust.custname,rec_cust.custaddress,
									 rec_cust.custcity,rec_cust.custcountry);
		return next;
		end loop;
		close cur_cust;
end;$$
language plpgsql;
select load_customer()
select * from customer

--load product
create or replace function load_product()
returns table(
	prodid integer,
	prodname varchar(40),
	prodperunit varchar(20),
	prodprice money,
	prodstock smallint,
	prodstockavailable bit,
	prodcateid integer
)as $$
declare 
	rec_prod record;
	cur_prod cursor
		for select *
		from dblink('localhost','select product_id,product_name,quantity_per_unit,unit_price,units_in_stock
					,discontinued, category_id from products')
		as data(prodid integer,prodname varchar(40),prodperunit varchar(20),prodprice money,prodstock smallint,
			   prodstockavailable bit,prodcateid integer);
begin
	open cur_prod;
	loop
		fetch cur_prod into rec_prod;
		exit when not found;
		prodid:= rec_prod.prodid;
		prodname:= rec_prod.prodname;
		prodperunit:= rec_prod.prodperunit;
		prodprice:= rec_prod.prodprice;
		prodstock:= rec_prod.prodstock;
		prodstockavailable:= rec_prod.prodstockavailable;
		prodcateid:= rec_prod.prodcateid;
		insert into product values (rec_prod.prodid, rec_prod.prodname,rec_prod.prodperunit,
				rec_prod.prodprice,rec_prod.prodstock,rec_prod.prodstockavailable,rec_prod.prodcateid);
		return next;
		end loop;
		close cur_prod;
end;$$
language plpgsql;
select load_product()
select * from product
	
--sequence order name
CREATE SEQUENCE seq_ord_number
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

--getOrderName
create or replace function GetOrderName () 
returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql

--set ordername
alter table orders
alter column orderName set default CONCAT('ORD-', TO_CHAR(current_date, 'YYYYMMDD'), '-', nextval('seq_ord_number')),
alter column orderName set not NULL

create or replace function load_order()
returns table (
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
	ordercustid varchar(15)
)as $$
declare
	rec_ord record;
	cur_ord cursor
	for select * from dblink('localhost','select o.ship_name,o.ship_address,o.ship_city,o.ship_country,
						od.quantity,od.unit_price, od.discount,o.ship_region,o.order_id, o.customer_id 
						from orders as o join order_details as od on o.order_id = od.order_id ')
	as data (ordershipname varchar(40),ordershipaddress varchar(60),ordershipcity varchar(15),
			 ordershipcountry varchar(15),orderqty smallint,ordersubtotal money,ordersubdiscount money,
			 orderstatus varchar, orderidtemp smallint, ordercustid varchar(10));
begin
	open cur_ord;
	loop
		fetch cur_ord into rec_ord;
		exit when not found;
		ordercreated:= now();
		ordershipname:=rec_ord.ordershipname;
		ordershipaddress:=rec_ord.ordershipaddress; 
		ordershipcity:=rec_ord.ordershipcity;
		ordershipcountry:=rec_ord.ordershipcountry; 
		orderqty:=rec_ord.orderqty; 
		ordersubtotal:=rec_ord.ordersubtotal; 
		ordersubdiscount:=rec_ord.ordersubdiscount; 
		ordertax:=0.1;
		ordertotal:=(ordersubtotal-ordersubdiscount)+ordertax;	
	case
	when rec_ord.orderstatus is NULL
		then orderstatus = 'new';
	when rec_ord.orderstatus = 'ak'
		then orderstatus = 'canceled';
	when rec_ord.orderstatus = 'or'
		then orderstatus = 'closed';
	else orderstatus = 'shipping';
	end case;
	
	orderidtemp := rec_ord.orderidtemp;
    ordercustid := rec_ord.ordercustid;
	insert into orders(ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, 
	orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus,orderidtemp, ordercustid); 
	values (ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,
	ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus, orderidtemp, ordercustid);
    return next;
    end loop;
    close cur_ord;     
end;$$	
language plpgsql;

select load_order()
select * from orders
	
	
--load lineitems
create or replace function load_lineitem()
returns table(
	liteprice money,
	liteqyt smallint,
	litediscount real,
	liteprodid integer,
	liteordername varchar
)as $$
declare
    rec_data record;
	orderid smallint;
    rec_lite record;
    cur_lite cursor
		for select *
		from dblink('localhost','select unit_price, quantity, discount, product_id,order_id from order_details')
		as data(liteprice money,liteqyt smallint,litediscount real,liteprodid integer,orderid smallint);
begin
	open cur_lite;
	loop
		fetch cur_lite into rec_lite;
		exit when not found;
		liteprice:=rec_lite.liteprice;
		liteqyt:=rec_lite.liteqyt;
		litediscount:=rec_lite.litediscount;
		liteprodid:=rec_lite.liteprodid;
		orderid := rec_lite.orderid;
		select ordername from orders where orderidtemp = orderid into rec_data;
		insert into lineitems (liteprice, liteqyt, litediscount,  liteprodid, liteordername) 
		values (liteprice, liteqyt, litediscount, liteprodid, rec_data.ordername);
		return next;
		end loop;
		close cur_lite;
end;$$
language plpgsql;
select load_lineitem();
select * from lineitems
	
	
--clear table target
create or replace function delete_categories()
    returns void as $$
begin  
    delete from LineItems;
end;$$
language plpgsql;
select delete_categories()
	