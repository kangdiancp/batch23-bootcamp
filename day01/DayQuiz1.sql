select * from regions
-- 1.
select r.region_id, r.region_name, count (departments_id)
	from departments d left join locations l
	on d.location_id = l.location_id left join countries c
	on l.country_id = c.country_id left join regions r
	on c.region_id = r.region_id
	group by r.region_id;
	
SELECT r.region_id, r.region_name, (
    SELECT COUNT(d.departments_id)
    FROM departments d
    LEFT JOIN locations l ON d.location_id = l.location_id
    LEFT JOIN countries c ON l.country_id = c.country_id
    WHERE c.region_id = r.region_id
) AS department_count
FROM regions r;

	
select * from countries
-- 2.
select c.country_id, c.country_name, c.region_id, count (departments_id)
	from departments d left join locations l
	on d.location_id = l.location_id left join countries c
	on l.country_id = c.country_id
	group by c.country_id;
	
select c.country_id, c.country_name, c.region_id, (
	select count (d.departments_id)
	from departments d
	left join locations l on d.location_id = l.location_id
	where l.country_id = c.country_id
) as department_count
from countries c;
	
	
select * from departments
-- 3.
select d.departments_id, d.departments_name, d.manager_id, d.location_id, count (employee_id)
	from employees e left join departments d
	on e.departments_id = d.departments_id
	group by d.departments_id;
	
select d.departments_id, d.departments_name, d.manager_id, d.location_id, (
	select count (e.employee_id)
	from employees e
	where e.departments_id = d.departments_id
) as employee_count
from departments d;
	
	
select * from regions
-- 4.
select r.region_id, r.region_name, count (employee_id)
	from employees e left join departments d
	on e.departments_id = d.departments_id left join locations l
	on d.location_id = l.location_id left join countries c
	on l.country_id = c.country_id left join regions r
	on c.region_id = r.region_id
	group by r.region_id;
	
select r.region_id, r.region_name, (
	select count (e.employee_id)
	from employees e
	left join departments d on e.departments_id = d.departments_id
	left join locations l on d.location_id = l.location_id
    left join countries c on l.country_id = c.country_id
	where c.region_id = r.region_id
) as employee_count
from regions r;
	
	
select * from countries
-- 5.
select c.country_id, c.country_name, c.region_id, count (employee_id)
	from employees e left join departments d
	on e.departments_id = d.departments_id left join locations l
	on d.location_id = l.location_id left join countries c
	on l.country_id = c.country_id
	group by c.country_id;
	
select c.country_id, c.country_name, c.region_id, (
	select count (e.employee_id)
	from employees e
	left join departments d on e.departments_id = d.departments_id
	left join locations l on d.location_id = l.location_id
	where l.country_id = c.country_id
) as employee_count
from countries c;
	
	
select * from departments
-- 6.
select d.departments_id, d.departments_name, d.manager_id, d.location_id, max (salary)
	from employees e left join departments d
	on e.departments_id = d.departments_id
	group by d.departments_id;
	
select d.departments_id, d.departments_name, d.manager_id, d.location_id, (
	select max (e.salary)
	from employees e
	where e.departments_id = d.departments_id
) as max_salary
from departments d;
	
	
select * from departments
-- 7.
select d.departments_id, d.departments_name, d.manager_id, d.location_id, min (salary)
	from employees e left join departments d
	on e.departments_id = d.departments_id
	group by d.departments_id;
	
select d.departments_id, d.departments_name, d.manager_id, d.location_id, (
	select min (e.salary)
	from employees e
	where e.departments_id = d.departments_id
) as min_salary
from departments d;


select * from departments
-- 8.
select d.departments_id, d.departments_name, d.manager_id, d.location_id, avg (salary)
	from employees e left join departments d
	on e.departments_id = d.departments_id
	group by d.departments_id;
	
select d.departments_id, d.departments_name, d.manager_id, d.location_id, (
	select avg (e.salary)
	from employees e
	where e.departments_id = d.departments_id
) as avg_salary
from departments d;


select * from departments
-- 9.
select d.departments_id, d.departments_name, d.manager_id, d.location_id, count (*) as count_mutation
	from departments d join employees e
	on d.departments_id = e.departments_id join job_history h
	on e.employee_id = h.employee_id
	group by d.departments_id;
	
select * from job_history

select d.departments_id, d.departments_name, d.manager_id, d.location_id, (
	select count (*)
	from employees e
	where e.departments_id = d.departments_id
) as count_mountain
from departments d;


select * from jobs
-- 10.
select j.job_title, count (*) as count_mutation
	from jobs j join employees e
	on j.job_id = e.job_id join job_history h
	on e.employee_id = h.employee_id
	group by j.job_title;
	
select * from job_history
-- 11.
select e.employee_id, count (*) as count_employee
	from job_history h join employees e
	on h.employee_id = e.employee_id
	group by e.employee_id
		order by count_employee desc
		limit 3;
		
select * from jobs
-- 12.
select j.job_title, count (*) as count_employee
	from jobs j join employees e
	on j.job_id = e.job_id
	group by j.job_title;
	
select * from departments
-- 13.
select d.departments_id, d.departments_name, d.manager_id, d.location_id, age (end_date, start_date) as duration_work
	from departments d join job_history h
	on d.departments_id = h.departments_id
	order by duration_work desc
	limit 1;
	
select * from departments
-- 14.
select d.departments_id, d.departments_name, d.manager_id, d.location_id, count (start_date) as new_working
	from departments d join job_history h
	on d.departments_id = h.departments_id
	group by d.departments_id
	order by new_working asc
select * from job_history

select * from job_history
-- 15.
select e.departments_id, age (end_date, start_date) as duration_work, count ...
	from employees e join job_history h
	on e.departments_id = h.departments_id
	order by duration_work desc
	
	