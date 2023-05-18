CREATE TABLE CATEGORY ( 
	CateId SERIAL  PRIMARY KEY,
	CateName varchar(15)
	
);

CREATE TABLE CUSTOMER (
	CustId SERIAL PRIMARY KEY,
	CustName varchar(35),
	CustAddress varchar(60),
	CustCity varchar(15),
	CustCountry varchar(15)
	
);

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
	OrderCustId integer,
	FOREIGN KEY (OrderCustId) REFERENCES CUSTOMER (CustId)
);

DROP TABLE ORDERS CASCADE

CREATE TABLE PRODUCT (
	ProdId SERIAL PRIMARY KEY,
	ProdName varchar(40),
	ProdPerUnit varchar(20),
	ProdPrice MONEY,
	ProdStock SMALLINT,
	ProdStockAvailable BIT,
	ProdCateId Integer,
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
										   
--1 										   
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
		insert into categories(cateId, cateName) values(rec_emp.cateId, rec_emp.cateName);
		return next;
		end loop;
end;$$
language plpgsql;

SELECT get_category();
commit;
begin;
