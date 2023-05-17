select * from regions
select * from locations
select * from jobs
select * from job_history
select * from employess
select * from departments
select * from countrries

//nomor1
select r.region_id,count(d.department_id) as total_department
from regions as r
join countries c on r.region_id = c.region_id
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by r.region_id order by r.region_id asc;

//nomor2
select c.country_id,count(d.department_id) as total_department
from countries as c
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by c.country_id order by c.country_id asc;

//nomor3
select d.department_id,count(e.employee_id) as total_employee
from departments as d
join employees e on d.department_id = e.department_id
group by d.department_id order by d.department_id asc;

//nomor4
select r.region_id as region, count(e.employee_id) as employees from regions as r 
join countries as c on r.region_id = c.region_id 
join locations as l on c.country_id = l.country_id 
join departments as d on l.location_id = d.location_id
join employees as e on d.department_id = e.department_id
group by r.region_id order by r.region_id asc;

//nomor5
select c.country_id as countries, count(e.employee_id) as employees from countries as c 
join locations as l on c.country_id = l.country_id 
join departments as d on l.location_id = d.location_id
join employees as e on d.department_id = e.department_id
group by c.country_id order by c.country_id asc;

//nomor6
select department_id as department, max(salary) from employees
group by department_id order by department_id asc;

//nomor7
select department_id as department, min(salary) from employees
group by department_id order by department_id asc;

//nomor8
select department_id as department, avg(salary) from employees
group by department_id order by department_id asc;

//nomor9
select d.department_name, count(*) as jumlah_mutasi
from departments d
join employees e on d.department_id = e.department_id
join job_history j on e.employee_id = j.employee_id
group by d.department_name;

//nomor10
select j.job_title, count(*) as jumlah_mutasi
from jobs j
join employees e on j.job_id = e.job_id
join job_history jh on e.employee_id = jh.employee_id
group by j.job_title;

//nomor11
select employee_id, count(*) as jumlah_kemunculan
from job_history
group by employee_id
order by jumlah_kemunculan desc
limit 1;

//nomor12
select j.job_title, count(*) as jumlah_employee
from jobs j
join employees e on j.job_id = e.job_id
group by j.job_title

//nomor13

//nomor14
select d.department_name, max(hire_date) as max_date
from departments d
join employees e on d.department_id = e.department_id
group by d.department_name

//nomor15
