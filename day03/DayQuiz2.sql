create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', port '5433', dbname'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost')


-- MEMBUAT TABEL
create table customer(
	CustId varchar(10) primary key,
	CustName varchar(40),
	CustAddress varchar(60),
	CustCity varchar(15),
	CustCountry varchar(15)
);
select * from customer
drop table customer
alter table customer alter column custid type varchar(10)


create table category(
	cateid serial primary key,
	catename varchar(15)
);
select * from category
drop table category

create table product(
	prodid serial primary key,
	prodname varchar(40),
	prodperunit varchar(20),
	prodprice real,
	prodstock smallint,
	prodstockavailable integer,
	prodcateid integer,
	foreign key (prodcateid) references category (cateid)
);
select * from product
drop table product

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
	orderidtemp smallint,
	ordercustid varchar(10),
	foreign key (ordercustid) references customer (custid)
);
select * from orders
drop table orders

create table lineitems(
	liteid serial primary key,
	liteprice real,
	liteqty smallint,
	litediscount real,
	liteprodid smallint,
	liteordername varchar(25),
	foreign key (liteprodid) references product (prodid),
	foreign key (liteordername) references orders (ordername)
);
select * from lineitems
drop table lineitems



-- FUNGSI
-- load category
create or replace function loadcategory ()
	returns table(
		ids integer,
		names varchar
	) as $$
declare
	rec_cate record;
	cur_cate cursor for select * from dblink('localhost','select category_id, category_name from categories')
	as data(cateid integer, catename varchar);
begin
	open cur_cate;
	loop
		fetch cur_cate into rec_cate;
		exit when not found;
		ids := rec_cate.cateid;
		names := rec_cate.catename;
		insert into category(cateid, catename)
		values(ids, names);
		return next;
		end loop;
		close cur_cate;
end;$$
language plpgsql;

select loadcategory()
select * from category
drop function loadcategory()


-- load customer
create or replace function loadcustomer ()
	returns table(
		ids varchar,
		names varchar,
		addresss varchar,
		citys varchar,
		countrys varchar
	) as $$
declare
	rec_cust record;
	cur_cust cursor for select * from dblink('localhost','select customer_id, company_name, address, city, country from customers')
	as data(CustId varchar, CustName varchar, CustAddress varchar, CustCity varchar, CustCountry varchar);
begin
	open cur_cust;
	loop
		fetch cur_cust into rec_cust;
		exit when not found;
		ids := rec_cust.custid;
		names := rec_cust.custname;
		addresss := rec_cust.custaddress;
		citys := rec_cust.custcity;
		countrys := rec_cust.custcountry;
		insert into customer(custid, custname, custaddress, custcity, custcountry)
		values(ids, names, addresss, citys, countrys);
		return next;
	end loop;
	close cur_cust;
end;$$
language plpgsql;

select loadcustomer()
select * from customer
drop function loadcustomer()



-- load product
create or replace function loadproduct ()
	returns table(
		ids integer,
		names varchar,
		units varchar,
		prices real,
		stocks smallint,
		availables integer,
		cateids integer
	) as $$
declare
	rec_prod record;
	cur_prod cursor for select * from dblink('localhost','select product_id, product_name, quantity_per_unit,unit_price, units_in_stock, discontinued, category_id from products')
	as data(prodid integer,prodname varchar,prodperunit varchar,prodprice real,prodstock smallint,prodstockavailable integer,prodcateid integer);
begin
	open cur_prod;
	loop
		fetch cur_prod into rec_prod;
		exit when not found;
		ids := rec_prod.prodid;
		names := rec_prod.prodname;
		units := rec_prod.prodperunit;
		prices := rec_prod.prodprice;
		stocks := rec_prod.prodstock;
		availables := rec_prod.prodstockavailable;
		cateids := rec_prod.prodcateid;
		insert into product(prodid,prodname,prodperunit,prodprice,prodstock,prodstockavailable,prodcateid)
		values(ids, names, units, prices, stocks, availables, cateids);
		return next;
		end loop;
		close cur_prod;
end;$$
language plpgsql;

select loadproduct()
select * from product
drop function loadproduct()



--- LOAD_ORDER

CREATE SEQUENCE seq_ord_number
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

create or replace function GetOrderName () 
returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql

--- start input data dummy
insert into orders(ordercreated,ordershipname,ordershipaddress,ordershipcity,ordershipcountry,orderqty,ordersubtotal,ordersubdiscount,ordertax,ordertotal,orderstatus,orderidtemp,ordercustid)
values('2022-05-18','reza','tess','tess','tess',3,2.4,3.4,4.3,3.4,'tess',1,'VICTE')

select * from orders
alter table orders alter column ordername set default GetOrderName ()

--set default ordername
ALTER TABLE orders
ALTER COLUMN orderName SET DEFAULT CONCAT('ORD-', TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-', nextval('seq_ord_number')),
ALTER COLUMN orderName SET NOT NULL

create or replace function get_orders()
    returns table(ordercreated timestamp, ordershipname varchar, ordershipaddress varchar, ordershipcity varchar, ordershipcountry varchar, orderqty smallint,ordersubtotal money, ordersubdiscount money, ordertax money,ordertotal money, orderstatus varchar,orderidtemp smallint,ordercustid varchar) as $$
	
declare
    rec_ord record;
    cur_ord cursor
        for select * from dblink('localhost',
        'SELECT o.ship_name, o.ship_address, o.ship_city, o.ship_country, od.quantity, od.unit_price, od.discount, o.ship_region, o.order_id, o.customer_id
        from orders as o
        JOIN order_detail as od 
		on o.order_id = od.order_id ') 
		as data(ordershipname varchar(40), ordershipaddress varchar(60), ordershipcity varchar(15), ordershipcountry varchar(15), orderqty smallint,  ordersubtotal money, ordersubdiscount money, orderstatus varchar, orderidtemp smallint, ordercustid varchar(10));

begin
    open cur_ord;
    loop
        fetch cur_ord into rec_ord;
        exit when not found;
        ordercreated := now();
        ordershipname := rec_ord.ordershipname;
        ordershipaddress := rec_ord.ordershipaddress;
        ordershipcity := rec_ord.ordershipcity;
        ordershipcountry := rec_ord.ordershipcountry;
        orderqty := rec_ord.orderqty;
        ordersubtotal  := rec_ord.ordersubtotal;
        ordersubdiscount := rec_ord.ordersubdiscount;
        ordertax := 0.1;
        ordertotal := (ordersubtotal-ordersubdiscount) + ordertax;
        
		CASE
			WHEN rec_ord.orderstatus IS NULL
				THEN orderstatus = 'NEW';
			WHEN rec_ord.orderstatus = 'AK'
				THEN orderstatus = 'CANCELLED';
			WHEN rec_ord.orderstatus = 'OR'
				then orderstatus = 'CLOSED';
			ELSE orderstatus = 'SHIPPING';
		END CASE;
		
        orderidtemp := rec_ord.orderidtemp;
        ordercustid := rec_ord.ordercustid;

		insert into orders(ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus,orderidtemp, ordercustid) 
        values (ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus, orderidtemp, ordercustid);
        return next;
        end loop;
        close cur_ord;
end;$$
language plpgsql;

select get_orders()
select * from orders
select * from orders where ordershipname = 'reza'
drop function get_orders()



-- load lineitems
create or replace function loadlineitems()
	returns table(
		liteprice real,
		liteqty smallint,
		litediscount real,
		liteprodid smallint,
		liteordername varchar
	)as $$
declare
	rec_lineitems record;
	rec_data record;
	orderid smallint;
	cur_lineitems cursor for select * from dblink('localhost','select unit_price, quantity, discount, product_id, order_id from order_detail')
	as data(liteprice real, liteqty smallint, litediscount real, liteprodid smallint, orderid smallint);
begin
	open cur_lineitems;
	loop
		fetch cur_lineitems into rec_lineitems;
		exit when not found;
		liteprice := rec_lineitems.liteprice;
		liteqty := rec_lineitems.liteqty;
		litediscount := rec_lineitems.litediscount;
		liteprodid := rec_lineitems.liteprodid;
		orderid := rec_lineitems.orderid;
		
		select ordername from orders where orderidtemp = orderid into rec_data;
		
		insert into lineitems(liteprice,liteqty,litediscount,liteprodid,liteordername)
		values(liteprice,liteqty,litediscount,liteprodid,rec_data.ordername);
		return next;
		end loop;
		close cur_lineitems;
end;$$
language plpgsql;

select loadlineitems()
select * from lineitems
drop function loadlineitems()




-- delete tabel
create or replace function delete_lineitems()
	returns void as $$
begin
	delete from lineitems;
end;$$
language plpgsql;

select delete_lineitems()
select * from lineitems













