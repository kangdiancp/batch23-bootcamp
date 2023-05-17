create table categories(
    category_id smallint primary key,
    category_name varchar(15),
    description text,
    picture integer
)

create table supplier(
    supplier_id smallint primary key,
    company_name varchar(40),
    contact_name varchar(30),
    contact_title varchar(30),
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postal_code varchar(10),
    country varchar(15),
    phone varchar(24),
    fax varchar(24),
    homepage text
)

create table products(
    product_id smallint primary key,
    product_name varchar(40),
    quantity_per_unit varchar(20),
    unit_price real,
    units_in_stock smallint,
    units_in_order smallint,
    reorder_level smallint,
    discontinued integer,
    supplier_id smallint,
    category_id smallint,
    foreign key (supplier_id) references supplier(supplier_id),
    foreign key (category_id) references categories(category_id)
)

create table shippers(
    shipper_id smallint primary key,
    company_name varchar(40),
    phone varchar(24)
)

create table employees(
    employee_id smallint primary key,
    last_name varchar(20),
    first_name varchar(10),
    title varchar(30),
    title_of_courtesy varchar(25),
    birth_date date,
    hire_date date,
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postal_code varchar(10),
    country varchar(15),
    home_phone varchar(24),
    extension varchar(4),
    photo bytea,
    notes text,
    reports_to smallint,
    photo_path varchar(255)
)

create table customers(
    customer_id varchar(10) primary key,
    company_name varchar(40),
    contact_name varchar(30),
    contact_title varchar(30),
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postal_code varchar(10),
    country varchar(15),
    phone varchar(24),
    fax varchar(24)
)

create table orders(
    order_id smallint primary key,
    order_date date,
    required_date date,
    shipped_date date,
    freight real,
    ship_name varchar(40),
    ship_address varchar(60),
    ship_city varchar(15),
    ship_region varchar(15),
    ship_postal_code varchar(10),
    ship_country varchar(15),
    employee_id smallint,
    customer_id smallint,
    ship_via smallint,
    foreign key (employee_id) references employees(employee_id),
    foreign key (customer_id) references customers(customer_id),
    foreign key (ship_via) references shippers(shipper_id)
)

create table order_detail(
    order_id smallint,
    product_id smallint,
    unit_price real,
    quantity smallint,
    discount real,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id),
	constraint order_product_pk primary key (order_id, product_id)
)