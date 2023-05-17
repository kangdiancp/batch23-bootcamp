create table regions (
	region_id serial primary key,
	region_name varchar(255)
);
create table countries (
	country_id char(2),
	country_name varchar(255),
	region_id integer,
	foreign key (region_id) references regions(region_id)
);
create table locations(
	location_id serial primary key,
	street_address varchar(40),
	postal_code varchar(12),
	city varchar(30),
	state_province varchar(25),
	country_id char(2),
	foreign key(country_id) references countries(country_id)
);
create table departments(
	department_id serial primary key,
	department_name varchar(30),
	manager_id integer,
	location_id integer,
	foreign key (location_id) references locations(location_id)
);
create table employees(
	employee_id serial primary key,
	first_name varchar(20),
	last_name varchar(25),
	email varchar(25),
	phone_number varchar(20),
	hire_date timestamp,
	salary decimal(8,2),
	commision_pct decimal(2,2),
	job_id varchar(10),
	foreign key (job_id) references jobs(job_id),
	manager_id integer,
	foreign key(manager_id) references employees(employee_id),
	department_id integer,
	foreign key(department_id) references departments(department_id)
);
create table jobs(
 	job_id varchar(10),
	job_title varchar(35) unique,
	min_salary decimal(8,2),
	max_salary decimal(8,2)
)
create table job_history(
	employee_id integer,
	start_date timestamp,
	end_date timestamp,
	job_id varchar(10),
	department_id integer,
	constraint employee_id primary key(employee_id, start_date),
	foreign key (employee_id) references employees(employee_id),
	foreign key (job_id) references jobs(job_id),
	foreign key (department_id) references departments(department_id)
);

select * from regions;
select * from countries;
select * from locations;
select * from departments;
select * from employees;
select * from jobs;
select * from job_history;

drop table regions cascade;
drop table countries;
drop table job_history;

alter table regions add region_x varchar(255);
alter table regions rename column region_x to region_xx;
alter table regions alter column region_xx type integer using region_xx::integer;
alter table regions drop column region_xx;
alter table countries add constraint country_id primary key(country_id); 
alter table countries add constraint region_id 
foreign key (region_id) references regions(region_id);

alter table employees drop column xemp_id

alter table  departments add constraint manager_id
foreign key (manager_id) references employees(employee_id);

alter table jobs add constraint job_id primary key(job_id);



update regions set region_name = 'Medan' where region_id = 2

insert into regions (region_name) values('Medan'), ('Jakarta'), ('Bogor') 
insert into regions (region_name) values('Middle east and afrik');

insert into countries (country_id, country_name, region_id) values
('AR', 'Argentina', 2),
('AU', 'Australia', 3),
('BE', 'Belgium', 1),
('BR', 'Brazil', 2),
('CA', 'Canada', 2),
('CH', 'Switzerland', 1),
('CN', 'China', 3),
('DE', 'Germany', 1),
('DK', 'Denmark', 1),
('EG', 'Egypt', 4),
('FR', 'France', 1),
('IL', 'Israel', 4),
('IN', 'India', 3),
('IT', 'Italy', 1),
('JP', 'Japan', 3),
('KW', 'Kuwait', 4),
('ML', 'Malaysia', 3),
('MX', 'Mexico', 2),
('NG', 'Nigeria', 4),
('NL', 'Netherlands', 1),
('SG', 'Singapore', 3),
('UK', 'United Kingdom', 1),
('US', 'United States of America', 2),
('ZM', 'Zambia', 4),
('ZW', 'Zimbabwe', 4)

insert into locations (street_address, postal_code, city, state_province, country_id) values
('1297 Via Cola di Rie', '00989', 'Roma','', 'IT'),
('93091 Calle della Testa', '10934', 'Venice','', 'IT'),
('2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP'),
('9450 Kamiya-cho', '6823', 'Hiroshima','', 'JP'),
('2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US'),
('2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US'),
('2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US'),
('2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US'),
('147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA'),
('6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA'),
('40-5-12 Laogianggen', '190518', 'Beijing','', 'CN'),
('1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN'),
('12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU'),
('198 Clementi North', '540198', 'Singapore','', 'SG'),
('8204 Arthur St','', 'London','', 'UK'),
('Magdalen Centre The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK'),
('9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK'),
('Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE'),
('Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR'),
('20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH'),
('Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH'),
('Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL'),
('Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal', 'MX')

insert into jobs (job_id, job_title, min_salary, max_salary) values
('AC_ACCOUNT', 'Public Accountant', 4200.00, 9000.00),
('AC_MGR', 'Accounting Manager', 8200.00, 16000.00),
('AD_ASST', 'Administration Assistant', 3000.00, 6000.00),
('AD_PRES', 'President', 20080.00, 40000.00),
('AD_VP', 'Admiistration Vice President', 15000.00, 30000.00),
('FI_ACCOUNT', 'Accountant', 4200.00, 9000.00),
('FI_MGR', 'Finance Manager', 8200.00, 16000.00),
('HR_REP', 'Human Resources Representative', 4000.00, 9000.00),
('IT_PROG', 'Programmer', 4000.00, 10000.00),
('MK_MAN', 'Marketing Manager', 9000.00, 15000.00),
('MK_REP', 'Marketing Representative', 4000.00, 9000.00),
('PR_REP', 'Public Relations Representative', 4500.00, 10500.00),
('PU_CLERK', 'Purchasing Clerk', 2500.00, 5500.00),
('PU_MAN', 'Purchasing Manager', 8000.00, 15000.00),
('SA_MAN', 'Sales Manager', 10000.00, 20080.00),
('SA_REP', 'Sales Representative', 6000.00, 12008.00),
('SH_CLERK', 'Shipping Clerk', 2500.00, 5500.00),
('ST_CLERK', 'Stock Clerk', 2008.00, 5000.00),
('ST_MAN', 'Stock Manager', 5500.00, 8500.00)

insert into employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) values
(100, 'Steven', 'King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000.00,NULL , NULL, 90,NULL ),
(101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '2005-09-21', 'AD_VP', 17000.00, NULL, 100, 90,NULL),
(102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', '2001-01-13', 'AD_VP', 17000.00, NULL, 100, 90,NULL),
(103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '2006-01-03', 'IT_PROG', 9000.00, NULL, 102, 60,NULL),
(104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', '2007-05-21', 'IT_PROG', 6000.00, NULL, 103, 60,NULL),
(105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', '2005-06-25', 'IT_PROG', 4800.00, NULL, 103, 60,NULL), 
(106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', '2006-02-05', 'IT_PROG', 4800.00, NULL, 103, 60,NULL),
(107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', '2007-02-07', 'IT_PROG', 4200.00, NULL, 103, 60,NULL),
(108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', '2002-08-17', 'FI_MGR', 12008.00, NULL, 101, 100,NULL), 
(109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '2002-08-16', 'FI_ACCOUNT', 9000.00, NULL, 108, 100,NULL),
(110, 'John', 'Chen', 'JCHEN', '515.124.4269', '2005-09-28', 'FI_ACCOUNT', 8200.00, NULL, 108, 100,NULL),
(111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', '2005-09-30', 'FI_ACCOUNT', 7700.00, NULL, 108, 100,NULL),
(112, 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', '2006-03-07', 'FI_ACCOUNT', 7800.00, NULL, 108, 100,NULL),
(113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', '2007-12-07', 'FI_ACCOUNT', 6900.00, NULL, 108, 100,NULL),
(114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', '2002-12-07', 'PU_MAN', 11000.00, NULL, 100, 30,NULL), 
(115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', '2003-05-18', 'PU_CLERK', 3100.00, NULL, 114, 30,NULL),
(116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', '2005-12-24', 'PU_CLERK', 2900.00, NULL, 114, 30,NULL),
(117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', '2005-07-24', 'PU_CLERK', 2800.00, NULL, 114, 30,NULL),
(118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', '2006-11-15', 'PU_CLERK', 2600.00, NULL, 114, 30,NULL),
(119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', '2007-08-10', 'PU_CLERK', 2500.00, NULL, 114, 30,NULL),
(120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', '2004-07-18', 'ST_MAN', 8000.00, NULL, 100, 50,NULL),
(121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', '2005-04-10', 'ST_MAN', 8200.00, NULL, 100, 50,NULL),
(122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', '2003-05-01', 'ST_MAN', 7900.00, NULL, 100, 50,NULL), 
(123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', '2005-10-10', 'ST_MAN', 6500.00, NULL, 100, 50,NULL),
(124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', '2007-11-16', 'ST_MAN', 5800.00, NULL, 100, 50,NULL),
(125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', '2005-07-16', 'ST_CLERK', 3200.00, NULL, 120, 50,NULL),
(126, 'Irene', 'Mikkilineni', 'IMIKKILI', '650.124.1224', '2006-09-28', 'ST_CLERK', 2700.00, NULL, 120, 50,NULL),
(127, 'James', 'Landry', 'JLANDRY', '650.124.1334', '2007-01-14', 'ST_CLERK', 2400.00, NULL, 120, 50,NULL),
(128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', '2008-03-08', 'ST_CLERK', 2200.00, NULL, 120, 50,NULL),
(129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', '2005-08-20', 'ST_CLERK', 3300.00, NULL, 121, 50,NULL),
(130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', '2005-10-30', 'ST_CLERK', 2800.00, NULL, 121, 50,NULL),
(131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', '2005-02-16', 'ST_CLERK', 2500.00, NULL, 121, 50,NULL),
(132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', '2007-04-10', 'ST_CLERK', 2100.00, NULL, 121, 50,NULL),
(133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', '2004-06-14', 'ST_CLERK', 3300.00, NULL, 122, 50,NULL),
(134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', '2006-08-26', 'ST_CLERK', 2900.00, NULL, 122, 50,NULL), 
(135, 'Ki', 'Gee', 'KGEE', '650.127.1734', '2007-12-12', 'ST_CLERK', 2400.00, NULL, 122, 50,NULL),
(136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', '2008-02-06', 'ST_CLERK', 2200.00, NULL, 122, 50,NULL),
(137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', '2003-07-14', 'ST_CLERK', 3600.00, NULL, 123, 50,NULL),
(138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', '2005-10-26', 'ST_CLERK', 3200.00, NULL, 123, 50,NULL),
(139, 'John', 'Seo', 'JSEO', '650.121.2019', '2006-02-12', 'ST_CLERK', 2700.00, NULL, 123, 50,NULL),
(140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', '2006-04-06', 'ST_CLERK', 2500.00, NULL, 123, 50,NULL),
(141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', '2003-10-17', 'ST_CLERK', 3500.00, NULL, 124, 50,NULL),
(142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', '2005-01-29', 'ST_CLERK', 3100.00, NULL, 124, 50,NULL),
(143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', '2006-03-15', 'ST_CLERK', 2600.00, NULL, 124, 50,NULL),
(144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', '2006-07-09', 'ST_CLERK', 2500.00, NULL, 124, 50,NULL),
(145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', '2004-10-01', 'SA_MAN', 14000.00, 0.40, 100, 80,NULL),
(146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', '2005-01-05', 'SA_MAN', 13500.00, 0.30, 100, 80,NULL),
(147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.429278', '2005-03-10', 'SA_MAN', 12000.00, 0.30, 100, 80,NULL),
(148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.619268', '2007-10-15', 'SA_MAN', 11000.00, 0.30, 100, 80,NULL),
(149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', '2008-01-29', 'SA_MAN', 10500.00, 0.20, 100, 80,NULL),
(150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.129268', '2005-01-30', 'SA_REP', 10000.00, 0.30, 145, 80,NULL),
(151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.345268', '2005-03-24', 'SA_REP', 9500.00, 0.25, 145, 80,NULL),
(152, 'Peter', 'Hall', 'PHALL', '011.44.1344.478968', '2005-08-20', 'SA_REP', 9000.00, 0.25, 145, 80,NULL),
(153, 'Christopher', 'Olsen', 'COLSEN', '011.44.1344.498718', '2006-03-30', 'SA_REP', 8000.00, 0.20, 145, 80,NULL),
(154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.987668', '2006-12-09', 'SA_REP', 7500.00, 0.20, 145, 80,NULL), 
(155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.486508', '2007-11-23', 'SA_REP', 7000.00, 0.15, 145, 80,NULL),
(156, 'Janette', 'King', 'JKING', '011.44.1345.429268', '2004-01-30', 'SA_REP', 10000.00, 0.35, 146, 80,NULL),
(157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.929268', '2004-03-04', 'SA_REP', 9500.00, 0.35, 146, 80,NULL),
(158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.829268', '2004-08-01', 'SA_REP', 9000.00, 0.35, 146, 80,NULL),
(159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.729268', '2005-03-10', 'SA_REP', 8000.00, 0.30, 146, 80,NULL),
(160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.629268', '2005-12-15', 'SA_REP', 7500.00, 0.30, 146, 80,NULL),
(161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.529268', '2006-11-03', 'SA_REP', 7000.00, 0.25, 146, 80,NULL),
(162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.129268', '2005-11-11', 'SA_REP', 10500.00, 0.25, 147, 80,NULL),
(163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.229268', '2007-03-19', 'SA_REP', 9500.00, 0.15, 147, 80,NULL),
(164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.329268', '2008-01-24', 'SA_REP', 7200.00, 0.10, 147, 80,NULL),
(165, 'David', 'Lee', 'DLEE', '011.44.1346.529268', '2008-02-23', 'SA_REP', 6800.00, 0.10, 147, 80,NULL),
(166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.629268', '2008-03-24', 'SA_REP', 6400.00, 0.10, 147, 80,NULL),
(167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.729268', '2008-04-21', 'SA_REP', 6200.00, 0.10, 147, 80,NULL),
(168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.929268', '2005-03-11', 'SA_REP', 11500.00, 0.25, 148, 80,NULL),
(169, 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.829268', '2006-03-23', 'SA_REP', 10000.00, 0.20, 148, 80,NULL),
(170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.729268', '2006-01-24', 'SA_REP', 9600.00, 0.20, 148, 80,NULL),
(171, 'William', 'Smith', 'WSMITH', '011.44.1343.629268', '2007-02-23', 'SA_REP', 7400.00, 0.15, 148, 80,NULL),
(172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.529268', '2007-03-24', 'SA_REP', 7300.00, 0.15, 148, 80,NULL),
(173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.329268', '2008-04-21', 'SA_REP', 6100.00, 0.10, 148, 80,NULL),
(174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.429267', '2004-05-11', 'SA_REP', 11000.00, 0.30, 149, 80,NULL),
(175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.429266', '2005-03-19', 'SA_REP', 8800.00, 0.25, 149, 80,NULL), 
(176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', '2006-03-24', 'SA_REP', 8600.00, 0.20, 149, 80,NULL),
(177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.429264', '2006-04-23', 'SA_REP', 8400.00, 0.20, 149, 80,NULL),
(178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.429263', '2007-05-24', 'SA_REP', 7000.00, 0.15, 149, NULL,NULL),
(179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.429262', '2008-01-04', 'SA_REP', 6200.00, 0.10, 149, 80,NULL),
(180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', '2006-01-24', 'SH_CLERK', 3200.00, NULL, 120, 50,NULL),
(181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', '2006-02-23', 'SH_CLERK', 3100.00, NULL, 120, 50,NULL),
(182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', '2007-06-21', 'SH_CLERK', 2500.00, NULL, 120, 50,NULL),
(183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', '2008-02-03', 'SH_CLERK', 2800.00, NULL, 120, 50,NULL),
(184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', '2004-01-27', 'SH_CLERK', 4200.00, NULL, 121, 50,NULL),
(185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', '2005-02-20', 'SH_CLERK', 4100.00, NULL, 121, 50,NULL),
(186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', '2006-06-24', 'SH_CLERK', 3400.00, NULL, 121, 50,NULL),
(187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', '2007-02-07', 'SH_CLERK', 3000.00, NULL, 121, 50,NULL),
(188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', '2005-06-14', 'SH_CLERK', 3800.00, NULL, 122, 50,NULL),
(189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', '2005-08-13', 'SH_CLERK', 3600.00, NULL, 122, 50,NULL),
(190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', '2006-07-11', 'SH_CLERK', 2900.00, NULL, 122, 50,NULL),
(191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', '2007-12-19', 'SH_CLERK', 2500.00, NULL, 122, 50,NULL),
(192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', '2004-02-04', 'SH_CLERK', 4000.00, NULL, 123, 50,NULL),
(193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', '2005-03-03', 'SH_CLERK', 3900.00, NULL, 123, 50,NULL),
(194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', '2006-07-01', 'SH_CLERK', 3200.00, NULL, 123, 50,NULL),
(195, 'Vance', 'Jones', 'VJONES', '650.501.4876', '2007-03-17', 'SH_CLERK', 2800.00, NULL, 123, 50,NULL),
(196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', '2006-04-24', 'SH_CLERK', 3100.00, NULL, 124, 50,NULL),
(197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', '2006-05-23', 'SH_CLERK', 3000.00, NULL, 124, 50,NULL), 
(198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', '2007-06-21', 'SH_CLERK', 2600.00, NULL, 124, 50,NULL),
(199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', '2008-01-13', 'SH_CLERK', 2600.00, NULL, 124, 50,NULL),
(200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', '2003-09-17', 'AD_ASST', 4400.00, NULL, 101, 10,NULL), 
(201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', '2004-02-17', 'MK_MAN', 13000.00, NULL, 100, 20,NULL),
(202, 'Pat', 'Fay', 'PFAY', '603.123.6666', '2005-08-17', 'MK_REP', 6000.00, NULL, 201, 20,NULL),
(203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', '2002-07-06', 'HR_REP', 6500.00, NULL, 101, 40,NULL),
(204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', '2002-07-06', 'PR_REP', 10000.00, NULL, 101, 70,NULL),
(205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', '2002-07-06', 'AC_MGR', 12008.00, NULL, 101, 110,NULL),
(206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', '2002-07-06', 'AC_ACCOUNT', 8300.00, NULL, 205, 110,NULL),
(216, 'Nancy', 'Davolio', NULL, NULL, '2012-05-01', 'SA_REP', 6000.00, NULL, NULL, 80, 1),
(217, 'Andrew', 'Fuller', NULL, NULL, '2012-08-14', 'AD_VP', 15000.00, NULL, NULL, 90, 2),
(218, 'Janet', 'Leverling', NULL, NULL, '2012-04-01', 'SA_REP', 6000.00, NULL, NULL, 80, 3),
(219, 'Margaret', 'Peacock', NULL, NULL, '2013-05-03', 'SA_REP', 6000.00, NULL, NULL, 80, 4),
(220, 'Steven', 'Buchanan', NULL, NULL, '2013-10-17', 'AC_MGR', 8200.00, NULL, NULL, 110, 5),
(221, 'Michael', 'Suyama', NULL, NULL, '2013-10-17', 'SA_REP', 6000.00, NULL, NULL, 80, 6),
(222, 'Robert', 'King', NULL, NULL, '2014-01-02', 'SA_REP', 6000.00, NULL, NULL, 80, 7),
(223, 'Laura', 'Callahan', NULL, NULL, '2014-03-05', 'SH_CLERK', 2500.00, NULL, NULL, 50, 8),
(224, 'Anne', 'Dodsworth', NULL, NULL, '2014-11-15', 'SA_REP', 6000.00, NULL, NULL, 80, 9)

insert into job_history (employee_id, start_date, end_date, job_id, department_id) values
(101, '1997-09-21', '2001-10-27', 'AC_ACCOUNT', 110),
(101, '2001-10-28', '2005-03-15', 'AC_MGR', 110),
(102, '2001-01-13', '2006-07-24', 'IT_PROG', 60),
(114, '2006-03-24', '2007-12-31', 'ST_CLERK', 50),
(122, '2007-01-01', '2007-12-31', 'ST_CLERK', 50),
(176, '2006-03-24', '2006-12-31', 'SA_REP', 80),
(176, '2007-01-01', '2007-12-31', 'SA_MAN', 80),
(200, '1995-09-17', '2001-06-17', 'AD_ASST', 90),
(200, '2002-07-01', '2006-12-31', 'AC_ACCOUNT', 90),
(201, '2004-02-17', '2007-12-19', 'MK_REP', 20)

select * from countries r left join regions c on r.region_id = c.region_id
select c.country_id,country_name,r.region_id,r.region_name,location_id_street_address from regions r

//Nomor 1 Informasi jumlah departement di tiap regions

select r.region_id, count(d.department_id) as total_department
from regions as r	
join countries c on r.region_id = c.region_id
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by r.region_id order by r.region_id asc;

select r.region_id, (
	select count(d.department_id) 
	from countries c
	join locations l on c.country_id = l.country_id
	join departments d on l.location_id = d.location_id
	where c.region_id = r.region_id
) as total_department
from regions r;

//Nomor 2
select c.country_id, count(d.department_id) as total
from countries	c
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by c.country_id order by c.country_id asc;

select c.country_id, (
	select count(d.department_id)
	from locations l
	join departments d on  l.location_id = d.location_id
	where l.country_id = c.country_id
) as total_department
from countries c;

//Nomor 3
select d.department_id, count(e.employee_id) as total_employee
from departments as d 
join employees e on d.department_id = e.department_id
group by d.department_id order by d.department_id asc;

//Nomor 4
select r.region_id as region, count(e.employee_id) as employees
from regions r
join countries c on r.region_id = c.region_id 
join locations l on c.country_id = l.country_id 
join departments d on l.location_id = d.location_id
join employees e on d.department_id = e.department_id
group by r.region_id order by r.region_id asc

//Nomor 5
select c.country_id, count(e.employee_id) as employees 
from countries c
join locations as l on c.country_id = l.country_id 
join departments as d on l.location_id = d.location_id
join employees as e on d.department_id = e.department_id
group by c.country_id order by c.country_id asc

//Nomor 6
select department_id, max(salary) 
from employees
group by department_id order by department_id asc;

//Nomor 7
select department_id, min(salary)
from employees
group by department_id order by department_id asc;

//Nomor 8
select d.department_id, avg(e.salary) as Rerata_Salary
from departments d
join employees e on d.department_id = e.department_id
group by d.department_id order by d.department_id asc;

//Nomor 9
select d.department_name, count(*) as jumlah_mutasi
from departments d
join employees e on d.department_id = e.department_id
join job_history j on e.employee_id = j.employee_id
group by d.department_name;

//Nomor10
select j.job_title, count(*) as jumlah_mutasi
from jobs j
join employees e on j.job_id = e.job_id
join job_history jh on e.employee_id = jh.employee_id
group by j.job_title;

//Nomor 11
select employee_id, count(*) as jumlah_muncul
from job_history
group by employee_id
order by jumlah_muncul desc
LIMIT 1;

//Nomor12
select j.job_title, count(*) as jumlah_employee
from jobs j
join employees e on j.job_id = e.job_id
group by j.job_title;

//Nomor 13
select a.department_name, age(end_date, start_date) as lama_bekerja
 from departments a left join job_history b
 on a.department_id =b.department_id;

//Nomor 14
select d.department_name, max(e.hire_date) as max_date
from departments d
join employees e on d.department_id = e.department_id
group by d.department_name;

//Nomor 15
