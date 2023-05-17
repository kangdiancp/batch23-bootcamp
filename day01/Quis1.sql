Nomor 1
select r.region_id, count(department_id) as departments from regions r join countries c 
on c.region_id = r.region_id join locations l on l.country_id = c.country_id 
join departments d on d.location_id = l.location_id group by r.region_id 

Nomor 2
select c.country_id, count(department_id) as departments from countries c join locations l
on c.country_id = l.country_id join departments d on l.location_id = d.location_id group by c.country_id

Nomor 3
select department_id, count(employee_id) from employees group by department_id

Nomor 4
select r.region_id, count(employee_id) as employees from regions r join countries c 
on c.region_id = r.region_id join locations l on l.country_id = c.country_id join departments d
on d.location_id = l.location_id join employees e on e.department_id = d.department_id group by
r.region_id

Nomor 5
select c.country_id, count(employee_id) as employees from countries c join locations l
on c.country_id = l.country_id join departments d on l.location_id = d.location_id join employees e
on e.department_id = d.department_id group by c.country_id

Nomor 6 
select department_id, max(salary)as Tertinggi from employees group by department_id 

Nomor 7
select department_id, min(salary)as Terendah from employees group by department_id

Nomor 8 
select department_id, avg(salary)as Ratarata from employees group by department_id

Nomor 9 
select department_name, count(*) as mutasi from departments d join employees e 
on d.department_id = e.department_id join job_history j on e.employee_id = j.employee_id
group by d.department_id

Nomor 10
select j.job_id, count(*) as job from jobs j join employees e on e.job_id = j.job_id 
join job_history jh on jh.employee_id = e.employee_id group by j.job_id

Nomor 11
select employee_id, count(end_date) from job_history group by employee_id

Nomor 12
select job_id, count(employee_id) from employees group by job_id

Nomor 13
select d.department_name, age(end_date,start_date) as longjob from departments d join job_history jh on
d.department_id = jh.department_id

Nomor 14
select d.department_id, d.department_name, count(hire_date)from departments d join employees e
on e.department_id = d.department_id group by d.department_id

Nomor 15
select e.employee_id, age(end_date) as long from employees e join job_history jh on
e.employee_id = jh.employee_id





