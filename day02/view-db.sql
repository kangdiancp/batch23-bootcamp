create or replace view total_employee_by_country as
select t.country_name, t.city, d.departments_id, d.departments_name, 
count (employee_id) total_employee from employees as e, departments as d, (
	select r.region_id, region_name, c.country_id, country_name, city, l.location_id
	from regions as r, countries as c, locations as l
	where r.region_id = c.region_id
	and c.country_id = l.country_id
) as t where e.departments_id = d.departments_id
	and d.location_id = t.location_id
	group by t.country_name, t.city, d.departments_id, d.departments_name;
		
select * from total_employee_by_country
where city = 'London'

drop view total_employee_by_country

select masa_kerja, sum (bonus) bonus_per_masa_kerja from (
	select employee_id, first_name, last_name, last_name, salary, extract (year from age (now(), hire_date)) as masa_kerja,
	case when extract (year from age (now(), hire_date)) >= 25 then salary * 5
		when extract (year from age (now(), hire_date)) < 25 then salary * 2 end bonus
from employees) as t
	group by masa_kerja
	order by masa_kerja;
	
select sum (mk_satu) "8 <= masa kerja <= 13",
sum (mk_dua) "14 <= masa kerja <= 17",
sum (mk_tiga) "18 <= masa kerja <= 22"
from (
	select
		case when extract (year from age (now(), hire_date)) >= 8
			and extract (year from age (now(), hire_date)) <= 13
				then count (employees) end mk_satu,
		case when extract (year from age (now(), hire_date)) >= 13
			and extract (year from age (now(), hire_date)) <= 17
				then count (employees) end mk_dua,
		case when extract (year from age (now(), hire_date)) >= 17
			and extract (year from age (now(), hire_date)) <= 22
				then count (employees) end mk_tiga
	from employees
	group by hire_date
) as t;

create extension dblink;
create foreign data wrapper postgres;
create server localhost foreign data wrapper postgres options (hostaddr '127.0.0.1', dbname 'NorthwindDB');
create user mapping for postgres server localhost options (user 'postgres', password 'admin');

select dblink_connect ('localhost')

insert into sales.shippers (ship_id, ship_name, ship_phone)
select * from dblink('localhost','select shipper_id,company_name,phone from shippers')
as data(ship_id integer,ship_name varchar (40),ship_phone varchar(24))