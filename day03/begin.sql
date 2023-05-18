begin;
declare s1 cursor for select * from employees;

fetch backward all from s1
commit
/*
NEXT
PRIOR
FIRST
LAST
ABSOLUTE count
RELATIVE count
ALL
FORWARD
FORWARD count
FORWARD ALL
BACKWARD
BACKWARD count
BACKWARD ALL
*/

-- FUNCTION

create or replace function get_profile (years integer)
	returns text as $$
declare
	profiles text default '';
	rec_emp record;
	cur_emp cursor (years integer)
		for select first_name, last_name, salary, hire_date
		from employees where extract (year from age(now(), hire_date)) = years;
begin
	open cur_emp(years);
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		profiles := profiles || ',' || concat(rec_emp.first_name,
					rec_emp.last_name) || ':' || rec_emp.salary;
		end loop;
		close cur_emp;
		return profiles;
end;$$
language plpgsql;

select get_profile (19)

drop function get_profile(integer)


create or replace function get_profile (years integer)
	returns table (
		names varchar,
		salaries money
	) as $$
declare
	rec_emp record;
	cur_emp cursor (years integer)
		for select first_name, last_name, salary, hire_date
		from employees where extract (year from age(now(), hire_date)) = years;
begin
	open cur_emp(years);
	loop
		fetch cur_emp into rec_emp;
		exit when not found;
		
		names := concat(rec_emp.first_name, rec_emp.last_name);
		salaries := rec_emp.salary;
		return next;
		end loop;
		close cur_emp;
end;$$
language plpgsql;

select get_profile (19)


create or replace function get_profile (years integer)
	returns table (
		names varchar,
		salaries money
	) as $$
declare
	rec_emp record;
begin
		for rec_emp in select *
		from employees where extract (year from age(now(), hire_date)) = years
		loop
		names := concat (rec_emp.first_name, rec_emp.last_name);
		salaries := rec_emp.salary;
		return next;
		end loop;
end;$$
language plpgsql;

select get_profile (19)


create or replace function insert_region_countries (regname varchar, countryId char, countryName varchar)
	returns void as $$
begin
		insert into regions (region_name) values (regname);
		perform (select setval ('"regions_region_id_seq"', (select max (region_id) from regions)));
		insert into countries (country_id, country_name, region_id)
		values (countryId, countryName, currval ('"regions_region_id_seq"'));
end;$$
language plpgsql;

select insert_region_countries (...)


create or replace function edit_countries (regionId int, countryId char)
	returns void as $$
begin
		update countries set region_id = regionId where country_id = countryId;
end;$$
language plpgsql;

select edit_countries (...)


create or replace function delete_countries (countryId char)
	returns void as $$
begin
		delete from countries where country_id = countryId;
end;$$
language plpgsql;

select delete_countries (...)


create or replace function insert_regcount (regionName varchar, countryId char, countryName varchar)
	returns void as $$
declare
	rec_data record;
begin
		select region_name from regions where region_name = regionName into rec_data;
		perform (select setval ('regions_region_id_seq', (select max (region_id) from regions)));
		if rec_data.region_name = regionName
		then null;
		else
			insert into regions (region_name) values (regionName);
		end if;
		
		select country_id from countries where country_id = countryId into rec_data;
		if rec_data.country_id = countryId
		then null;
		else
		insert into countries (country_id, country_name, region_id)
		values (countryId, countryName, currval('regions_region_id_seq'));
		end if;
end;$$
language plpgsql;

select function insert_regcount (...)


create or replace procedure insert_data (
	regionName varchar,
	countryId varchar,
	countryName varchar
)
language plpgsql
as $$

declare
	rec_data record;
begin
		select region_name from regions where region_name = regionName into rec_data;
		perform (select setval ('regions_region_id_seq', (select max (region_id) from regions)));
		if rec_data.region_name = regionName
		then null;
		else
			insert into regions (region_name) values (regionName);
		end if;
		
		select country_id from countries where country_id = countryId into rec_data;
		if rec_data.country_id countryId
		then null;
		else
		insert into countries (country_id, country_name, region_id)
		values (countryId, countryName, currval ('regions_region_id_seq'));
		end if;
end;$$

select function insert_data (...)