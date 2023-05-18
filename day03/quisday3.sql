create table category(
    CateId serial primary key,
    CateName varchar(15)
)
create table product(
    ProdId integer primary key,
    ProdName varchar(40),
    ProdPerUnit varchar(20),
    ProdPrice money,
    ProdStock smallint,
    ProdStockAvailables bit,
    ProdCateId integer,
    foreign key (ProdCateId) references category(CateId)
)
create table customer(
    CustId varchar(10) primary key,
    CustName varchar(35),
    CustAddress varchar(80),
    CustCity varchar(15),
    CustCountry varchar(15)
)

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
    OrderidTemp integer,
    OrderCustId varchar(10),
    foreign key (OrderCustId) references customer(CustId)
)

create table LineItems(
    LiteId serial primary key,
    LitePrice money,
    LiteQty smallint,
    LiteDiscount real,
    LiteProdId integer,
    LiteOrderName varchar(25),
    foreign key (LiteProdId) references product(ProdId),
    foreign key (LiteOrderName) references orders(OrderName)
)

select * from category
select * from customer
select * from lineitems
select * from orders
select * from product

create extension dblink;

create foreign data wrapper postgres;

create server localhost foreign data wrapper postgres options(hostaddr '127.0.0.1', dbname'NorthwindDB');

create user mapping for postgres server localhost options (user 'postgres',password 'admin');

select dblink_connect ('localhost')



begin;
declare s1 cursor for select * from dblink('localhost','select category_id,category_name from categories') as data(CateId integer,CateName varchar (15));
fetch all from s1;
commit



--function Memindahkan menggunakan cursor --
-- Load Category --
create or replace function get_category ()
    returns table( cateid integer, catename varchar) as $$
	
declare
    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost','select category_id,category_name from categories') as data(CateId integer,CateName varchar (15));
begin
    open cur_emp;
    loop
        fetch cur_emp into rec_emp;
        exit when not found;
        cateid := rec_emp.CateId;
        catename := rec_emp.CateName;
		insert into category(CateId, CateName) values (rec_emp.CateId, rec_emp.CateName);
        return next;
        end loop;
        close cur_emp;
       
end;$$
language plpgsql;

select get_category()


begin;
declare s1 cursor
        for select * from dblink('localhost','select customer_id,company_name,address,city,country from customers') 
		as data(CustId varchar(10),CustName varchar (40), CustAddress varchar(80), CustCity varchar(15), CustCountry varchar(15));
fetch all from s1
commit




-- Load Customer--
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
select * from customer


--load Product--
create or replace function get_product()
    returns table( prodid integer, prodname varchar, prodperlimit varchar,prodprice money, prodstock smallint,prodstockavailable bit, prodcateid integer) as $$
	
declare
    
    rec_emp record;
    cur_emp cursor
        for select * from dblink('localhost','select product_id,product_name,quantity_per_unit,unit_price,units_in_stock, discontinued, category_id from products') 
		as data(ProdId integer,ProdName varchar (40), ProdPerUnit varchar(20), ProdPrice money, ProdStock smallint, ProdStockAvalilable bit, ProdCateId integer);
begin
    open cur_emp;
    loop
        fetch cur_emp into rec_emp;
        exit when not found;
        prodid := rec_emp.ProdId;
        prodname := rec_emp.ProdName;
        prodperlimit := rec_emp.ProdPerUnit;
        prodprice := rec_emp.ProdPrice;
        prodstock := rec_emp.ProdStock;
        prodstockavailable := rec_emp.ProdStockAvalilable;
        prodcateid := rec_emp.ProdCateId;
		insert into product(ProdId, ProdName, ProdPerUnit, ProdPrice, ProdStock, ProdStockAvailables, ProdCateId) 
        values (rec_emp.ProdId, rec_emp.ProdName, rec_emp.ProdPerUnit, rec_emp.ProdPrice, rec_emp.ProdStock, rec_emp.ProdStockAvalilable, rec_emp.ProdCateId);
        return next;
        end loop;
        close cur_emp;
       
end;$$
language plpgsql;

select get_product();

select * from product







--- load orders --

CREATE SEQUENCE seq_ord_number
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1

create or replace function GetOrderName () 
returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'-',lpad(''||nextval('seq_ord_number'),4,'0'))
$$ language sql

--- start input data dummy ---
insert into orders(ordercreated,ordershipname,ordershipaddress,ordershipcity,ordershipcountry,orderqty,ordersubtotal,ordersubdiscount,ordertax,ordertotal,orderstatus,orderidtemp,ordercustid)
values('2022-05-14','yuda','aku','aku','aku',3,4.5,4.4,4.5,4.4,'aku',4,'ANATR')
--- end input data dummy ---
select * from orders


--set default ordername--
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

select get_orders()
select * from orders





--load Line Items---

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



--cleare tabel target--
create or replace function delete_categories()
    returns void as $$
begin  
    delete from LineItems;
end;$$


language plpgsql;

select delete_categories()







---update table quantity--
create or replace function UpdateSumOrder()
    return void as $$
begin
    select sum(quantity) as SumQty, sum(unit_price) as SumPrice, sum(discount) as SumDisc from dblink('localhost','select  quantity, unit_price, discount from order_detail') 
		as data(quantity money, unit_price smallint, discount real);

    update orders set orderqty = SumQty, ordersubtotal = SumPrice, ordersubdiscount = SumDisc where country_id = countryid;
end;$$
language plpgsql;
select UpdateSumOrder()
select * from orders
