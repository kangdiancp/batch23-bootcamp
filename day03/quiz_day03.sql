
--NOMOR 1 membuat tabel SHOPPING

-- Membuat tabel Category
create table Category(
    CateId serial primary key,
    CateName varchar(15)
)
select * from Category

-- Membuat tabel Customer
create table Customer(
    CustId varchar(10) primary key,
    CustName varchar(35),
    CustAddress varchar(60),
    CustCity varchar(15),
    CustCountry varchar(15)
)
select * from Customer
drop table Customer cascade

-- Membuat tabel Product
create table Product(
    ProdId smallint PRIMARY KEY,
	ProdName VARCHAR(40),
	ProdPerUnit VARCHAR(20),
	ProdPrice real,
	ProdStock SMALLINT,
	ProdStockAvailable smallint,
	ProdCateId smallint,
    foreign key (ProdCateId) references Category(CateId)
)
select * from Product
drop table Product cascade

-- Membuat tabel Orders
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
    OrderCustId integer,
    foreign key (OrderCustId) references Customer(CustId)
)
select * from Orders

ALTER TABLE Orders ADD COLUMN OrderShipAddress VARCHAR(60);

-- Membuat tabel LineItems
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


--NOMOR 2 Store Procedure untuk memindahkan data dari tabel Northwind ke tabel target di database SHOPPING
create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname 'NorthwinDB');
create user mapping for postgres server localhost options (user 'postgres', password 'admin');
select dblink_connect ('localhost')

-- 2.1 
//load_category
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
select load_category()

-- 2.2
//load_customer
create or replace function load_customer ()
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

select * from customer
select load_customer()
drop function load_customer()

-- 2.3
//load_product
create or replace function load_product()
	    returns table(
    	ProdId smallint,
    	ProdName varchar(40),
    	ProdPerUnit varchar(20),
    	ProdPrice real,
    	ProdStock smallint,
    	ProdStockAvaliable smallint,
    	ProdCateId smallint
	) as $$
declare
	rec_emp record;
begin
	for rec_emp in select * 
	from dblink('localhost','select product_id,product_name,quantity_per_unit,unit_price,
				units_in_stock,units_on_order,category_id from products')
	as data(ProdId smallint,ProdName varchar(40),ProdPerUnit varchar(20),
			ProdPrice real,ProdStock smallint,ProdStockAvaliable smallint,ProdCateId smallint)
	loop
		insert into Product values(rec_emp.ProdId,rec_emp.ProdName,rec_emp.ProdPerUnit,
								   rec_emp.ProdPrice,rec_emp.ProdStock,rec_emp.ProdStockAvaliable,
								   rec_emp.ProdCateId);
		return next;
		end loop;
end;$$
language plpgsql;

select * from Product
select load_product()
drop function load_product cascade

-- 2.4
//load_orders
CREATE SEQUENCE seq_ord_number
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

create or replace function GetOrderName () 
returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql

insert into orders(ordercreated,ordershipname,ordershipaddress,ordershipcity,ordershipcountry,orderqty,ordersubtotal,ordersubdiscount,ordertax,ordertotal,orderstatus,orderidtemp,ordercustid)
values('2022-05-18','novo','oim','oim','oim',3,4.5,4.4,4.5,4.4,'mio',4,'ANATR')

select * from orders

ALTER TABLE orders
ALTER COLUMN orderName SET DEFAULT CONCAT('ORD-', TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-', nextval('seq_ord_number')),
ALTER COLUMN orderName SET NOT NULL

create or replace function load_orders()
    returns table(
		OrderCreated timestamp, 
		OrderShipName varchar,
		OrderShipAddress varchar,
		OrderShipCity varchar,
		OrderShipCountry varchar,
		OrderQty smallint,
		OrderSubTotal money,
		OrderSubDiscount money,
		OrderTax money,
		OrderTotal money,
		OrderStatus varchar,
		OrderIdTemp smallint,
		OrderCustId varchar
	) as $$
declare
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost',
        'SELECT o.ship_name, o.ship_address, o.ship_city, o.ship_country, od.quantity,
		od.unit_price, od.discount, o.ship_region, o.order_id, o.customer_id
        from orders as o
        JOIN order_detail as od 
		on o.order_id = od.order_id') 
		as data(
			OrderShipName varchar(40),
			OrderShipAddress varchar(60),
			OrderShipCity varchar(15),
			OrderShipCountry varchar(15),
			OrderQty smallint,
			OrderSubTotal money,
			OrderSubDiscount money,
			OrderTax money,
			OrderTotal money,
			OrderStatus varchar,
			OrderIdTemp smallint,
			OrderCustId varchar(10));
begin
    open cur_emp;
    loop
        fetch cur_emp into rec_emp;
        exit when not found;
        OrderCreated := now();
        OrderShipName := rec_emp.OrderShipName;
        OrderShipAddress := rec_emp.OrderShipAddress;
        OrderShipCity := rec_emp.OrderShipCity;
        OrderShipCountry := rec_emp.OrderShipCountry;
        OrderQty  := rec_emp.OrderQty;
        OrderSubTotal  := rec_emp.OrderSubTotal;
        OrderSubDiscount := rec_emp.OrderSubDiscount;
        OrderTax := 0.1;
        OrderTotal  := (OrderSubTotal-OrderSubDiscount) + OrderTax;
        
		CASE
			WHEN rec_emp.OrderStatus IS NULL
				THEN OrderStatus = 'NEW';
			WHEN rec_emp.OrderStatus = 'AK'
				THEN OrderStatus = 'CANCELLED';
			WHEN rec_emp.OrderStatus = 'OR'
				then OrderStatus = 'CLOSED';
			ELSE OrderStatus = 'SHIPPING';
		END CASE;
		
        OrderIdTemp := rec_emp.OrderIdTemp;
        OrderCustId := rec_emp.OrderCustId;
		
		insert into Orders(OrderCreated,OrderShipName,OrderShipAddress,OrderShipCity,OrderShipCountry,OrderQty,OrderSubTotal,OrderSubDiscount,OrderTax,OrderTotal ,OrderStatus,OrderIdTemp,OrderCustId) 
        values (OrderCreated,OrderShipName,OrderShipAddress,OrderShipCity,OrderShipCountry,OrderQty,OrderSubTotal,OrderSubDiscount,OrderTax,OrderTotal ,OrderStatus,OrderIdTemp,OrderCustId);
        return next;
        end loop;
        close cur_emp;
end;$$
language plpgsql;

select load_orders()
select * from orders
drop function load_orders()

-- 2.5
//load_line_items
create or replace function load_line_items()
    returns table(
		LitePrice money,
		LiteQty smallint,
		LiteDiscount real,
		LiteProdId integer, 
		LiteOrderName varchar)
		as $$
declare
    rec_data record;
	order_id smallint;
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost','select unit_price, quantity, discount,product_id, order_id from order_detail ') 
		as data(LitePrice money, LiteQty smallint, LiteDiscount real, LiteProdId integer, order_id smallint);
begin
    open cur_emp;
    loop
        fetch cur_emp into rec_emp;
        exit when not found;
        LitePrice := rec_emp.LitePrice;
        LiteQty:= rec_emp.LiteQty;
        LiteDiscount := rec_emp.LiteDiscount;
        LiteProdId := rec_emp.LiteProdId;
		
		order_id := rec_emp.order_id;
		
		select OrderName from Orders where OrderIdTemp = order_id into rec_data;
	 
		insert into LineItems(LitePrice, LiteQty, LiteDiscount,  LiteProdId, LiteOrderName) 
        values (LitePrice, LiteQty, LiteDiscount,  LiteProdId, rec_data.OrderName);
        return next;
        end loop;
   
        close cur_emp;
       
end;$$
language plpgsql;

select loud_line_items();

select * from lineitems

-- 2.7
//ClearTableTarget
create or replace function delete_categories()
    returns void as $$
begin  
    delete from LineItems;
end;$$
language plpgsql;
select delete_categories()



