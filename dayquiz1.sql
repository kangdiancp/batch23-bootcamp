//nomor 1

select r.region_id, r.region_name,count (department_id) as total_department from regions r
join countries c on c.region_id = r.region_id
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
group by r.region_id

//nomor 2

select c.country_id, c.country_name,count (department_id) as total_department from countries c
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
group by c.country_id

//Nomor 3

select d.department_id, d.department_name,count (employee_id) as employee from departments d
join employees e on e.department_id = d.department_id
group by d.department_id

//Nomor4

select r.region_id, r.region_name,count (employee_id) as employee from regions r
join countries c on c.region_id = r.region_id
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
join employees e on e.department_id = d.department_id
group by r.region_id

///nomor 5

select c.country_id, c.country_id,count (employee_id) as employee from countries c
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
join employees e on e.department_id = d.department_id
group by c.country_id

//nomor 6

select department_id, max(salary)salary_tertinggi from employees
group by department_id

//nomor 7

select department_id, min(salary)salary_terendah from employees
group by department_id

//nomor 8

select department_id, avg(salary)salary_rata_rata from employees
group by department_id

nomor 9

select d.department_id, d.department_name,count (end_date) as mutasi from departments d
join job_history j on j.department_id = d.department_id
group by d.department_id

nomor 10

select j.job_title, count(*) as jumlah_mutasi
from jobs j
join employees e on j.job_id = e.job_id
group by j.job_title

nomor 11

select jh.employee_id,max(end_date), count(e.employee_id) as jumlah_employee from job_history jh
inner join employees e on e.employee_id = jh.employee_id
group by jh.employee_id

nomor 12