select * from regions r inner join countries c on r.region_id = c.region_id

insert into regions(region_id, region_name) values (5, 'artic')

select * from regions

select * from regions r left join countries c on r.region_id = c.region_id

select * from countries c left join regions r on c.region_id = r.region_id

select * from regions r right join countries c on r.region_id = c.region_id

select * from countries r left join regions c on r.region_id = c.region_id
select c.country_id, country_name, r.region_id, region_name, location_id, street_address from regions r right join countries c on r.region_id = c.region_id join locations l on c.country_id = l.country_id

select manager_id, count (employee_id) from employees group by manager_id

select departments_id, sum (salary) from employees group by departments_id having sum (salary) >= 6500

select departments_id, max (salary) from employees group by departments_id

select departments_id, min (salary) from employees group by departments_id

select departments_id, avg (salary) from employees group by departments_id

select first_name from employees where first_name like '%a%'

select * from departments where location_id in (
	select location_id from locations l join countries c on 
	l.country_id = c.country_id where c.region_id = 1
)

select * from locations where country_id in (
	select country_id from countries c join regions r on c.region_id = r.region_id
	where r.region_id = 1
)