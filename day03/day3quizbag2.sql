CREATE TABLE CATEGORY ( 
	CateId SERIAL  PRIMARY KEY,
	CateName varchar(15)
	
);

CREATE TABLE CUSTOMER (
	CustId varchar(60) PRIMARY KEY,
	CustName varchar(35),
	CustAddress varchar(60),
	CustCity varchar(15),
	CustCountry varchar(15)
);
drop table customer cascade

CREATE TABLE ORDERS (
	OrderName varchar(25) PRIMARY KEY,
	OrderCreated TIMESTAMP,
	OrderShipName varchar(40),
	OrderShipAddress varchar(60),
	OrderShipCity varchar(15),
	OrderShipCountry varchar(15),
	OrderQty SMALLINT,
	OrderSubTotal MONEY,
	OrderSubDiscount MONEY,
	OrderTax MONEY,
	OrderTotal MONEY,
	OrderStatus varchar(15),
	OrderIdTemp integer,
	OrderCustId varchar(40),
	FOREIGN KEY (OrderCustId) REFERENCES CUSTOMER (CustId)
);



DROP TABLE ORDERS CASCADE
drop table product cascade

CREATE TABLE PRODUCT (
	ProdId smallint PRIMARY KEY,
	ProdName varchar(40),
	ProdPerUnit varchar(20),
	ProdPrice real,
	ProdStock SMALLINT,
	ProdStockAvailable smallint,
	ProdCateId smallint,
	FOREIGN KEY (ProdCateId) REFERENCES CATEGORY (CateId)
	
);

CREATE TABLE LineItems (
	LiteId SERIAL PRIMARY KEY,
	LitePrice MONEY,
	LiteQty SMALLINT,
	LiteDiscount REAL,
	LiteProdId integer,
	LiteOrdername varchar(25),
	FOREIGN KEY (LiteProdId) REFERENCES PRODUCT (ProdId),
	FOREIGN KEY (LiteOrderName) REFERENCES ORDERS (OrderName)
);

create extension dblink;

create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options (hostaddr '127.0.0.1', dbname 'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres', password 'admin');

select dblink_connect ('localhost')


begin;
declare s1 cursor for select * from dblink ('localhost', 'select category_id, category_name from categories')
as data (cateId integer, cateName varchar(40));

fetch backward all from s1
commit
										   
--1.LoadCategory								   
create function get_category ()
    returns table(
        cateId integer,
        cateName varchar
    ) as $$
declare
    rec_emp record;
begin
        for rec_emp in select *
        from dblink('localhost','select category_id,category_name from categories') as data(CateId integer,CateName varchar(15))
    loop
        cateId := rec_emp.cateId;
		cateName := rec_emp.cateName;
		insert into category(cateId, cateName) values(rec_emp.cateId, rec_emp.cateName);
		return next;
		end loop;
end;$$
language plpgsql;



SELECT get_category();
commit;
begin;


--2LoadCustomer

create or replace function get_customer ()
    returns table( custid varchar, custname varchar, custaddress varchar,custcity varchar, custcountry varchar) as $$
	
declare
    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost','select customer_id,company_name,address,city,country from customers') 
		as data(CustId varchar,CustName varchar, CustAddress varchar, CustCity varchar, CustCountry varchar);
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

delete from customer
select get_customer()
select * from customer where custid = 'ANTON'
commit

--3 LoadProduct

create or replace function load_product()
	returns table(
	prodId smallint,
	prodName varchar (40),
	prodPerUnit varchar(20),
	prodPrice real,
	prodStock smallint,
	prodStockAvailable smallint,
	prodCateId smallint
	) as $$
declare
	rec_emp record;
	cur_emp cursor
		for select * from dblink('localhost','select product_id,product_name ,quantity_per_unit,unit_price,units_in_stock,units_in_order,category_id from products')
		as data(prodId smallint,prodName varchar (40),prodPerUnit varchar(20),prodPrice real,prodStock smallint,prodStockAvailable smallint,prodCateId smallint);
begin

	open cur_emp;
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		prodId:= rec_emp.prodId;
		prodName:= rec_emp.prodName;
		prodPerUnit:= rec_emp.prodPerUnit;
		prodPrice:= rec_emp.prodPrice;
		prodStock:= rec_emp.prodStock;
		prodStockAvailable:= rec_emp.prodStockAvailable;
		prodCateId:=rec_emp.prodCateId;
		insert into product values(rec_emp.prodId,rec_emp.prodName,rec_emp.prodPerUnit,rec_emp.prodPrice,rec_emp.prodStock,rec_emp.prodStockAvailable,rec_emp.prodCateId);
		return next;
		end loop;
		close cur_emp;
end;$$
language plpgsql;

drop function load_product

select load_product()
SELECT * FROM PRODUCT

--4 LoadOrder

-- CREATE SEQUENCE seq_ord_number
-- INCREMENT 1
-- MIN VALUE 1
-- MAX 9223372036854775807
-- START 1

-- CREATE or REPLACE FUNCTION ord_id () 
-- RETURNS varchar as $$
-- SELECT CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-
-- ',lpad(''||nextval('seq_ord_number'),4,'0'))
-- $$ language plpgsql

-- --bikin fungsi loadorder
-- CREATE FUNCTION LoadOrder ()
-- 	returns table (
-- 		OrderName varchar,
-- 		OrderCreated TIMESTAMP,
-- 		OrderShipName varchar,
-- 		OrderShipAddress varchar,
-- 		OrderShipCity varchar,
-- 		OrderShipCountry varchar,
-- 		OrderQty SMALLINT,
-- 		OrderSubTotal MONEY,
-- 		OrderSubDiscount MONEY,
-- 		OrderTax MONEY,
-- 		OrderTotal MONEY,
-- 		OrderStatus varchar,
-- 		OrderIdTemp integer,
-- 		OrderCustId integer,
-- ) as $$

-- -- bikin declare
-- declare 
-- 	rec_emp record;
	
-- begin
-- 	for rec_emp in select *
-- 	from dblink(
-- 	'localhost',
-- 	'select order_date,
-- 		ship_name,
-- 		ship_address,
-- 		ship_city,
-- 		ship_country
-- 			from orders',
	
-- 	)

CREATE SEQUENCE order_name
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

create or replace function order_id () returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('order_name'),4,'0'))
$$ language sql

ALTER TABLE orders
ALTER COLUMN orderName SET DEFAULT CONCAT('ORD-', TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-', nextval('order_name')),
ALTER TABLE ORDERS
ALTER COLUMN orderName SET DEFAULT order_id()

create function get_order()
    returns table(ordercreated timestamp, ordershipname varchar, 
				  ordershipaddress varchar, ordershipcity varchar, ordershipcountry varchar, 
				  orderqty smallint,ordersubtotal money, ordersubdiscount money, ordertax money, 
				  ordertotal money, orderstatus varchar,orderidtemp smallint,ordercustid varchar) as $$
	
declare
    rec_emp record;
    cur_emp cursor
        for select * 
		from dblink('localhost','select o.ship_name, o.ship_address, o.ship_city, 
						o.ship_country, o.ship_region, o.order_id, o.customer_id, od.quantity, 
						od.unit_price, od.discount from orders o join order_detail od on od.order_id = o.order_id')
		as data(ordershipname varchar, ordershipaddress varchar, ordershipcity varchar, ordershipcountry varchar,
				orderstatus varchar, orderidtemp smallint, ordercustid varchar, orderqty smallint, 
				ordersubtotal money, ordersubdiscount money); 
begin
    open cur_emp;
    loop
        fetch cur_emp into rec_emp;
        exit when not found;
		orderCreated := now();
		orderShipName := rec_emp.orderShipName;
        orderShipAddress :=  rec_emp.orderShipAddress;
		orderShipCity := rec_emp.orderShipCity;
		orderShipCountry := rec_emp.orderShipCountry;
		orderQty := rec_emp.orderQty;
		orderSubTotal := rec_emp.orderSubTotal;
		orderSubDiscount := rec_emp.orderSubDiscount;
		orderTax := 0.1;
		orderTotal := (ordersubtotal - ordersubdiscount) + ordertax;
		CASE
			WHEN rec_emp.orderstatus IS NULL
				THEN orderstatus = 'NEW';
			WHEN rec_emp.orderstatus = 'AK'
				THEN orderstatus = 'CANCELLED';
			WHEN rec_emp.orderstatus = 'OR'
				then orderstatus = 'CLOSED';
			ELSE orderstatus = 'SHIPPING';
		END CASE;
		orderIdTemp := rec_emp.orderIdTemp;
		orderCustId := rec_emp.orderCustId;
		insert into orders(ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus,orderidtemp, ordercustid) 
        values (ordercreated, ordershipname, ordershipaddress, ordershipcity, ordershipcountry, orderqty,ordersubtotal, ordersubdiscount, ordertax,ordertotal, orderstatus, orderidtemp, ordercustid);return next;
        end loop;
        close cur_emp;
end;$$
language plpgsql;

select get_order()
select * from orders


--load_lineitems
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

--ClearTableTarget
create or replace function delete_categories()
    returns void as $$
begin  
    delete from LineItems;
end;$$

language plpgsql;

select delete_categories()



