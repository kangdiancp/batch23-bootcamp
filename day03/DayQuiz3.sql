create table category (
	cateId serial primary key,
	cateName varchar(15)
)

create table product (
	prodId serial primary key,
	prodName varchar(40),
	prodPerUnit varchar(20),
	prodPrice money,
	prodStock smallint,
	prodStockAvailable smallint,
	prodCateId integer,
	foreign key (prodCateId) references category(cateId)
)

create table customer (
	custId varchar(10) primary key,
	custName varchar(60),
	custAddress varchar(60),
	custCity varchar(30),
	custCountry varchar(30)
)

create table orders (
	orderName varchar(25) primary key,
	orderCreated timestamp,
	orderShipName varchar(40),
	orderShipAddress varchar(60),
	orderShipCity varchar(15),
	orderShipCountry varchar(15),
	orderQty smallint,
	orderSubTOtal money,
	orderSubDiscount money,
	orderTax money,
	orderTotal money,
	orderStatus varchar(15),
	orderIdTemp integer,
	orderCustId varchar(10),
	foreign key (orderCustId) references customer(custId)
)

create table lineItems (
	liteId serial primary key,
	litePrice money,
	liteQty smallint,
	liteDiscount real,
	liteProdId integer,
	liteOrderName varchar(25),
	foreign key (liteProdId) references product(prodId),
	foreign key (liteOrderName) references orders(orderName)
)

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


-- 1. Stored Procedure: LoadCategory
create function loadCategory ()
	returns table (
		cateId integer,
		cateName varchar
	) as $$
declare
	rec_emp record;
begin
		for rec_emp in select *
		from dblink ('localhost', 'select category_id, category_name from categories')
		as data (cateId integer, cateName varchar(40))
	loop
		insert into category (cateId, cateName) values (rec_emp.cateId, rec_emp.cateName);
		return next;
	end loop;
end;$$
language plpgsql;

drop function loadCategory
select loadCategory ()
select * from category

-- 2. Stored Procedure: LoadCustomer
create function loadCustomer ()
	returns table (
		custId varchar,
		custName varchar,
		custAddress varchar,
		custCity varchar,
		custCountry varchar
	) as $$
declare
	rec_emp record;
begin
		for rec_emp in select *
		from dblink ('localhost', 'select customer_id, contact_name, address, city, country from customers')
		as data (custId varchar(10), custName varchar(60), custAddress varchar(60), custCity varchar(30), custCountry varchar(30))
	loop
		insert into customer (custId, custName, custAddress, custCity, custCountry)
		values (rec_emp.custId, rec_emp.custName, rec_emp.custAddress, rec_emp.custCity, rec_emp.custCountry);
		return next;
	end loop;
end;$$
language plpgsql;

drop function loadCustomer()
select loadCustomer()
select * from customer

-- 3. Stored Procedure: LoadProduct
create function loadProduct ()
	returns table (
		prodId integer,
		prodName varchar,
		prodPerUnit varchar,
		prodPrice money,
		prodStock smallint,
		prodStockAvailable smallint,
		prodCateId integer
	) as $$
declare
	rec_emp record;
begin
		for rec_emp in select *
		from dblink ('localhost', 'select product_id, product_name, quantity_per_unit, unit_price, unit_in_stock, unit_in_order, category_id from products')
		as data (prodId integer, prodName varchar(40), prodPerUnit varchar(20), prodPrice money, prodStock smallint, prodStockAvailable smallint, prodCateId integer)
	loop
		insert into product (prodId, prodName, prodPerUnit, prodPrice, prodStock, prodStockAvailable, prodCateId)
		values (rec_emp.prodId, rec_emp.prodName, rec_emp.prodPerUnit, rec_emp.prodPrice, rec_emp.prodStock, rec_emp.prodStockAvailable, rec_emp.prodCateId);
		return next;
	end loop;
end;$$
language plpgsql;

drop function loadProduct()
select loadProduct()
select * from product

-- 4. Stored Procedure: LoadOrder
-- Membuat sequence untuk orderName
create sequence seq_ord_number
increment 1
minvalue 1
maxvalue 9223372036854775807
start 1;

select * from seq_ord_number

-- Membuat fungsi untuk menghasilkan orderName dengan format yang diinginkan
create function orderName () 
	returns varchar as $$
begin
    return concat('ORD', to_char (now(), 'YYYYMMDD'), '-', lpad ('' || nextval ('seq_ord_number'), 4, '0'));
end;$$
language plpgsql;

select orderName()

ALTER TABLE orders
ALTER COLUMN orderName SET DEFAULT CONCAT('ORD-', TO_CHAR(CURRENT_DATE, 'YYYYMMDD'), '-', nextval('seq_ord_number')),
ALTER COLUMN orderName SET NOT NULL

-- Membuat fungsi LoadOrder
create function loadOrder ()
	returns table (
		orderCreated timestamp,
		orderShipName varchar,
		orderShipAddress varchar,
		orderShipCity varchar,
		orderShipCountry varchar,
		orderQty smallint,
		orderSubTotal money,
		orderSubDiscount money,
		orderTax money,
		orderTotal money,
		orderStatus varchar,
		orderIdTemp integer,
		orderCustId varchar
	) as $$
declare
	rec_emp record;
	cur_emp cursor
		for SELECT *
FROM dblink('localhost',
    'SELECT
        o.ship_name,
        o.ship_address,
        o.ship_city,
        o.ship_country,
        od.quantity,
        od.unit_price,
        od.discount,
        o.ship_region,
        o.order_id,
        o.customer_id
    FROM orders AS o
    JOIN order_detail AS od ON o.order_id = od.order_id'
) AS data (
    orderShipName varchar(40),
    orderShipAddress varchar(60),
    orderShipCity varchar(15),
    orderShipCountry varchar(15),
    orderQty smallint,
    orderSubTotal money,
    orderSubDiscount money,
    orderStatus varchar,
    orderIdTemp integer,
    orderCustId varchar(10)
);

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
        ordertotal := (ordersubtotal - ordersubdiscount) + ordertax;
			case
				when rec_emp.orderstatus is NULL
					then orderstatus = 'NEW';
				when rec_emp.orderstatus = 'AK'
					then orderstatus = 'CANCELLED';
				when rec_emp.orderstatus = 'OR'
					then orderstatus = 'CLOSED';
				else orderstatus = 'SHIPPING';
			end case;
		orderidtemp := rec_emp.orderidtemp;
        ordercustid := rec_emp.ordercustid;
		insert into orders (orderCreated, orderShipName, orderShipAddress, orderShipCity, orderShipCountry, orderQty, orderSubTotal, orderSubDiscount, orderTax, orderTotal, orderStatus, orderIdTemp, orderCustId)
		values (orderCreated, orderShipName, orderShipAddress, orderShipCity, orderShipCountry, orderQty, orderSubTotal, orderSubDiscount, orderTax, orderTotal, orderStatus, orderIdTemp, orderCustId);
		return next;
	end loop;
	close cur_emp;
end;$$
language plpgsql;

drop function loadOrder
select loadOrder()
select * from orders

-- 5. Stored Procedure: LoadLineItems
create function loadLineItems()
    returns table(
		liteprice money, liteqty smallint, litediscount real, liteprodid integer, liteordername varchar) as $$
	
declare
    rec_data record;
	orderid smallint;
    rec_emp record;
	
    cur_emp cursor
        for select * from dblink ('localhost','select unit_price, quantity, discount,product_id, order_id from order_detail ') 
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

drop function loadLineItems
select loadLineItems();
select * from lineitems


-- 6. GetOrderName()
-- Sudah

-- 7. ClearTableTarget()
create or replace function delete_categories()
    returns void as $$
begin  
    delete from LineItems;
end;$$


language plpgsql;

select delete_categories()			
		
		
		
