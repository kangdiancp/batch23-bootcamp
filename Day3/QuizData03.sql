create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname 'NorthwindDB');
create user mapping for postgres server localhost options(user 'postgres', password 'admin');

select dblink_connect('localhost');

create table category(
	CateId serial primary key,
	CateName varchar(15)
)

create or replace function LoadCategory()
	returns table(
	cateid integer,
	catename varchar
	) as $$
declare 
	rec_cate record;
	cur_cate cursor
		for select * from dblink('localhost','select category_id,category_name from categories')
		as data(CateId integer, CateName varchar(15));
begin 
	open cur_cate;
	loop
		fetch cur_cate into rec_cate;
		exit when not found;
		cateid := rec_cate.CateId;
		catename := rec_cate.CateName;
		insert into category(CateId, CateName) values(cateid, catename);
		return next;
	end loop;
	close cur_cate;
end; $$
language plpgsql;

drop function LoadCategory()

select LoadCategory()
select * from category

--customerr
create table customer(
	CustId varchar(10) primary key,
	CustName varchar(40),
	CustAddress varchar(60),
	CustCity varchar(15),
	CustCountry varchar(15)
)
drop table customer cascade
create or replace function LoadCustomer()
	returns table(
	custid varchar,
	custname varchar,
	custaddress varchar,
	custcity varchar,
	custcountry varchar
	) as $$
declare 
	rec_cust record;
	cur_cust cursor
		for select * from dblink('localhost','select customer_id,company_name, address, city, country 
		from customers') as data(CustId varchar(10),CustName varchar (40), CustAddress varchar(60),
		CustCity varchar(15), CustCountry varchar(15));
begin 
	open cur_cust;
	loop
		fetch cur_cust into rec_cust;
		exit when not found;
		custid := rec_cust.CustId;
		custname:= rec_cust.CustName;
		custaddress:= rec_cust.CustAddress;
		custcity:= rec_cust.CustCity;
		custcountry:= rec_cust.custcountry;
		insert into customer(CustId, CustName, CustAddress, CustCity, CustCountry) 
		values(custid, custname, custaddress, custcity, custcountry);
		return next;
	end loop;
	close cur_cust;
end; $$
language plpgsql;
drop function LoadCustomer()

select LoadCustomer()
select * from customer

create table product(
	ProdId integer primary key,
	ProdName varchar(40),
	ProdPerUnit varchar(20),
	ProdPrice money,
	ProdStock smallint,
	ProdStockAvailable smallint,
	ProdCateId integer,
	foreign key (ProdCateId) references category(CateId)
)
drop table product cascade
create or replace function LoadProduct()
	returns table(
		prodid integer,
		prodname varchar,
		produnit varchar,
		prodprice money,
		prodstock smallint,
		prodstockava smallint,
		prodcateid integer
	) as $$
declare
	rec_prod record;
	cur_prod cursor
		for select * from dblink('localhost', 'select product_id, product_name, quantity_per_unit, 
		unit_price, units_in_stock, units_in_order, category_id from products') 
		as data(ProdId integer, ProdName varchar(40), ProdPerUnit varchar(20), ProdPrice money, 
		ProdStock smallint, ProdStockAvailable smallint, ProdCateId integer);
begin 
	open cur_prod;
	Loop
		fetch cur_prod into rec_prod;
		exit when not found;
		prodid:= rec_prod.ProdId;
		prodname:= rec_prod.ProdName;
		produnit:=rec_prod.ProdPerUnit;
		prodprice:= rec_prod.ProdPrice;
		prodstock:= rec_prod.ProdStock;
		prodstockava:= rec_prod.ProdStockAvailable;
		prodcateid:= rec_prod.ProdCateId;
		insert into product(ProdId, ProdName, ProdPerUnit, ProdPrice, ProdStock, ProdStockAvailable, ProdCateId) 
		values (prodid, prodname, produnit, prodprice, prodstock, prodstockava, prodcateid);
		return next;
	end loop;
	close cur_prod;
end;$$
language plpgsql;

drop function LoadProduct();

select LoadProduct();
select * from product;


create table orders(
	OrderName varchar(25) primary key,
	OrderCreated timestamp,
	OrderShipName varchar(40),
	OrderShipAddress varchar(60),
	OrderShipCity varchar(15),
	OrderShipCountry varchar(15),
	OrderQty smallint,
	OrderSubTotal money,
	OrderSubDiscount money,
	OrderTax money,
	OrderTotal money,
	OrderStatus varchar(15),
	OrderIdTemp int,
	OrderCustId varchar(10),
	foreign key (OrderCustId) references customer(CustId)
)
drop table orders cascade

--function sequence number of order name
CREATE SEQUENCE seq_order_number
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1

create or replace function OrderName() 
	returns varchar as $$
	select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_order_number'),4,'0'))
end;$$ 
language sql

alter table orders alter column OrderName set default OrderName()

select OrderName();

create or replace function LoadOrder()
	returns table(
		ordername varchar,
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
        orderidtemp int,
        ordercustid varchar
	) as $$
declare
	rec_ord record;
	cur_ord cursor
		for select * from dblink('localhost', 'select o.ship_name, 
		o.ship_address, o.ship_city, o.ship_country, od.quantity, od.unit_price, od.discount, 
		o.ship_region, o.order_id, o.customer_id from orders as o
		join order_detail as od on o.order_id = od.order_id') 
		as data(OrderShipName varchar(40), OrderShipAddress varchar(60), OrderShipCity varchar(15), 
		OrderShipCountry varchar(15), OrderQty smallint, OrderSubTotal money, OrderSubDiscount money,
		OrderStatus varchar, OrderIdTemp smallint, OrderCustId varchar(10));
begin 
	open cur_ord;
	Loop
		fetch cur_ord into rec_ord;
		exit when not found;
		ordercreated:= now();
		ordershipname:=rec_ord.OrderShipName;
		ordershipaddress:= rec_ord.OrderShipAddress;
		ordershipcity:= rec_ord.OrderShipCity;
		ordershipcountry:= rec_ord.OrderShipCountry;
       	orderqty := rec_ord.OrderQty;
		ordersubtotal:= rec_ord.OrderSubTotal;
		ordersubdiscount:= rec_ord.OrderSubDiscount;
		ordertax:= 0.1;
		ordertotal:=(ordersubtotal-ordersubdiscount) + ordertax;
		
		case
			when rec_ord.OrderStatus is NULL
				then orderstatus := 'NEW';
			when rec_ord.OrderStatus = 'AK'
				then orderstatus := 'CANCELLED';
			when rec_ord.OrderStatus = 'OR'
				then orderstatus := 'CLOSED';
			else orderstatus := 'SHIPPING';
		end case;
		
        orderidtemp := rec_ord.OrderIdTemp;
        ordercustid := rec_ord.OrderCustId;
		
		insert into orders(OrderCreated, OrderShipName, OrderShipAddress, OrderShipCity, 
		OrderShipCountry, OrderQty,OrderSubTotal, OrderSubDiscount, OrderTax,OrderTotal, 
		OrderStatus,OrderIdTemp, OrderCustId) values (ordercreated, ordershipname, ordershipaddress, 
		ordershipcity, ordershipcountry, orderqty, ordersubtotal, ordersubdiscount, ordertax,ordertotal,
		orderstatus, orderidtemp, ordercustid);
		return next;
	end loop;
	close cur_ord;
end;$$
language plpgsql;

select LoadOrder(); 
select * from orders;
drop function LoadOrder();


create table lineitems(
	LiteId serial primary key,
	LitePrice money,
	LiteQty smallint,
	LiteDiscount real,
	LiteProdId integer,
	LiteOrderName varchar(25),
	foreign key (LiteProdId) references product(ProdId),
	foreign key (LiteOrderName) references orders(OrderName)
)
drop table lineitems

create or replace function LoadLineItems()
	returns table(
		liteprice money,
		liteqty smallint,
		litediscount real,
		liteprodid integer,
		liteordername varchar,
		liteorderid smallint
	) as $$
declare
	rec_lit record;
	rec_data record;
	order_id smallint;
	cur_lit cursor
		for select * from dblink('localhost', 'select unit_price, quantity, discount,product_id, 
		order_id from order_detail ') 
		as data(LitePrice money, LiteQty smallint, LiteDiscount real, LiteProdId integer, 
		LiteOrderId smallint);
begin
	open cur_lit;
	loop
		fetch cur_lit into rec_lit;
		exit when not found;
		liteprice:= LitePrice;
		liteqty:= LiteQty;
		litediscount:= LiteDiscount;
		liteprodid:= LiteProdId;
		liteorderid:= LiteOrderId;
		
		select OrderName from orders where OrderIdTemp = liteorderid into rec_data;
		insert into lineitems(LitePrice, LiteQty, LiteDiscount, LiteProdId, LiteOrderName) 
		values(liteprice, liteqty, litediscount, liteprodid, rec_data.OrderName);
		return next;
	end loop;
	close cur_lit;
end;$$
language plpgsql;

select LoadLineItems()
select * from lineitems
drop function LoadLineItems()
		
		
		