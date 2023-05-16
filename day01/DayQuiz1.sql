//nomor1
select r.region_id, r.region_name, count(department_id) 
from departments d join locations l
on d.location_id = l.location_id join countries c 
on l.country_id = c.country_id join regions r
on c.region_id = r.region_id
group by r.region_id

//nomor2
select c.country_id, c.country_name, count(department_id) 
from departments d join locations l
on d.location_id = l.location_id join countries c 
on l.country_id = c.country_id
group by c.country_id

//nomor3
select d.department_id, d.department_name, count(employee_id) 
from employees e join departments d
on e.department_id = d.department_id
group by d.department_id

//nomor4
select r.region_id, r.region_name, count(employee_id) 
from employees e join departments d
on e.department_id = d.department_id join locations l
on d.location_id = l.location_id join countries c
on l.country_id = c.country_id join regions r
on c.region_id = r.region_id
group by r.region_id

//nomor5
select c.country_id, c.country_name, count(employee_id) 
from employees e join departments d
on e.department_id = d.department_id join locations l
on d.location_id = l.location_id join countries c
on l.country_id = c.country_id
group by c.country_id

//nomor6
select d.department_id, d.department_name, max(salary) 
from employees e join departments d
on e.department_id = d.department_id
group by d.department_id

//nomor7
select d.department_id, d.department_name, min(salary) 
from employees e join departments d
on e.department_id = d.department_id
group by d.department_id

//nomor8
select d.department_id, d.department_name, avg(salary) 
from employees e join departments d
on e.department_id = d.department_id
group by d.department_id

//nomor9

//nomor10

//nomor11

//nomor12
select j.job_title, count(employee_id)
from employees e join jobs j
on e.job_id = j.job_id
group by j.job_title
order by j.job_title asc

//nomor13
select e.first_name, e.department_id, max(end_date) as lama
from job_history j join employees e
on j.department_id = e.department_id
group by e.first_name, e.department_id
order by lama desc

//nomor14
select e.first_name, e.department_id, max(hire_date) as tgl_masuk
from departments d join employees e
on d.department_id = e.department_id
group by e.first_name, e.department_id
order by tgl_masuk desc

//nomor15














