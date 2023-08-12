create table Category(
    CateId serial primary key,
    CateName varchar(15)
)
select * from Category

create table Customer(
    CustId varchar(10) primary key,
    CustName varchar(35),
    CustAddress varchar(60),
    CustCity varchar(15),
    CustCountry varchar(15)
)
select * from Customer

create table Product(
    ProdId serial primary key,
    ProdName varchar(40),
    ProdPerUnit varchar(20),
    ProdPrice money,
    ProdStock smallint,
    ProdStockAvaliable smallint,
    ProdCateId integer,
    foreign key (ProdCateId) references Category(CateId)
)
select * from Product
drop table Product 

create table Orders(
    OrderName varchar(25) primary key,
    OrderCreated timestamp,
    OrderShipName varchar(40),
    OrderShipCity varchar(15),
    OrderShipCountry varchar(15),
    OrderQty smallint,
    OrderSubTotal money,
    OrderTax money,
    OrderTotal money,
    OrderStatus varchar(15),
    OrderIdTemp integer,
    OrderCustId varchar(10),
    foreign key (OrderCustId) references Customer(CustId)
)
select * from Orders
alter table Orders add column OrderShipAddress varchar(60);
alter table Orders add column OrderSubDiscount money;

create table LineItems(
    LiteId serial primary key,
    LitePrice money,
    LiteQty smallint,
    LiteDiscount real,
    LiteProdId integer,
    LiteOrderName varchar(25),
    foreign key (LiteProdId) references Product(ProdId),
    foreign key (LiteOrderName) references Orders(OrderName)
)
select * from LineItems

create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1',dbname'NorthwindDB');
create user mapping for postgres server localhost options(user 'postgres', password 'admin');
select dblink_connect ('localhost');

--n0 2.a
create or replace function Load_Category()
	returns table (
		CateId integer,
		CateName varchar(15)
	) as $$
	
declare
	rec_emp record;
begin
	for rec_emp in select * 
	from dblink('localhost', 'select category_id,category_name from categories')
	as data(CateId integer, CateName varchar(15))
	loop
		insert into Category values(rec_emp.cateid,rec_emp.catename);
		return next;
		end loop;
end;$$
language plpgsql;
select * from Category
select Load_Category()

--no2.b
create or replace function Load_Customer()
	returns table(
		CustId varchar(10),
    	CustName varchar(35),
    	CustAddress varchar(60),
    	CustCity varchar(15),
    	CustCountry varchar(15)
	) as $$
declare
	rec_emp record;
begin
	for rec_emp in select * 
	from dblink('localhost','select customer_id,contact_name,
				address,city,country from customers')
	as data(CustId varchar(35), CustName varchar(35),CustAddress varchar(60),
			CustCity varchar(15),CustCountry varchar(15))
	loop
		insert into Customer values(rec_emp.CustId,rec_emp.CustName,rec_emp.CustAddress,
								   rec_emp.CustCity,rec_emp.CustCountry);
		return next;
		end loop;
end;$$
language plpgsql;
select * from Customer
select Load_Customer()
/*drop function Load_Customer() cascade*/

--n02.c Load_Product

drop function Load_Product()
create or replace function Load_Product()
	returns table(
    	ProdId integer,
    	ProdName varchar(40),
    	ProdPerUnit varchar(20),
    	ProdPrice money,
    	ProdStock smallint,
    	ProdStockAvaliable smallint,
    	ProdCateId integer
	) as $$
declare
	rec_emp record;
begin
	for rec_emp in select * 
	from dblink('localhost','select product_id,product_name,quantity_per_unit,unit_price,
				unit_in_stock,unit_in_order,category_id from products')
	as data(ProdId integer,ProdName varchar(40),ProdPerUnit varchar(20),
			ProdPrice money,ProdStock smallint,ProdStockAvaliable smallint,ProdCateId integer)
	loop
		insert into Product values(rec_emp.ProdId,rec_emp.ProdName,rec_emp.ProdPerUnit,
								   rec_emp.ProdPrice,rec_emp.ProdStock,rec_emp.ProdStockAvaliable,
								   rec_emp.ProdCateId);
		return next;
		end loop;
end;$$
language plpgsql;
select * from Product
select Load_Product()
drop function Load_Product() cascade

--n02.d Load_Order

CREATE SEQUENCE seq_ord_number
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

create or replace function GetOrderName () 
	returns varchar as $$
	select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',
				  lpad(''||nextval('seq_ord_number'),4,'0'))$$ language sql
	insert into orders(ordercreated,ordershipname,ordershipaddress,
				   ordershipcity,ordershipcountry,orderqty,ordersubtotal,
				   ordersubdiscount,ordertax,ordertotal,orderstatus,orderidtemp,ordercustid)
	values('2029-07-11','opet','kualalumpur','lumpur','malaysia',3,4.5,4.4,4.5,4.4,'aku',4,'zzzzz')


create or replace function Load_Order()
    returns table( ordercreated timestamp, ordershipname varchar, ordershipaddress varchar, 
				  ordershipcity varchar, ordershipcountry varchar, orderqty smallint,
				  ordersubtotal money, ordersubdiscount money, ordertax money,ordertotal money, 
				  orderstatus varchar,orderidtemp smallint,ordercustid varchar) as $$
declare    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost',
        'SELECT o.ship_name, o.ship_address, o.ship_city, o.ship_country,od.quantity, od.unit_price, od.discount, o.ship_region, o.order_id, o.customer_id
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
select Load_Order()
select * from Load_Order

--no2.e load Lineitem
create or replace function Load_Lineitems()
    returns table(liteprice money, liteqty smallint, litediscount real, 
				  liteprodid integer, liteordername varchar) as $$
declare
    rec_data record;
	orderid smallint;
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost','select unit_price, quantity, discount,
								 product_id, order_id from order_detail ') 
		as data(liteprice money,liteqty smallint, litediscount real, liteprodid integer, 
				orderid smallint);
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
select * from Lineitems
select Load_Lineitems()

--no2.e ClearTableTarget
create or replace function delete_categories()
    returns void as $$
begin  
    delete from LineItems;
end;$$

language plpgsql;

select delete_categories()
