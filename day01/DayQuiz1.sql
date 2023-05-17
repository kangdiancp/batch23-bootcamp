
--1
select r.region_id, r.region_name, count(department_id) as department from regions r
join countries c on c.region_id = r.region_id
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
group by r.region_id

--2
select c.country_id, c.country_name, count(department_id) as department from countries c
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
group by c.country_id

--3
select d.department_id, d.department_name, count(employee_id) as employee from departments d
join employees e on e.department_id = d.department_id
group by d.department_id

--4
select r.region_id, r.region_name, count(employee_id) as employee from regions r
join countries c on c.region_id = r.region_id
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
join employees e on e.department_id = d.department_id
group by r.region_id

--5
select c.country_id, c.country_name, count(employee_id) as employee from countries c
join locations l on l.country_id = c.country_id
join departments d on d.location_id = l.location_id
join employees e on e.department_id = d.department_id
group by c.country_id

--6
select department_id, max(salary) as salary_tertinggi from employees
group by department_id

--7
select department_id, min(salary) as salary_terendah from employees
group by department_id

--8
select department_id, avg(salary) as ratarata_salary from employees
group by department_id

--9
select d.department_id, d.department_name, count(end_date) as mutasi from departments d
join job_history j on j.department_id = d.department_id
group by d.department_id

--10
select j.job_id, j.job_title, count(end_date) as mutasi from jobs j
join employees e on e.job_id = j.job_id
join job_history jh on jh.employee_id = e.employee_id
group by j.job_id

--11
select jh.employee_id,max(end_date), count(e.employee_id) as jumlah_employee from job_history jh
inner join employees e on e.employee_id = jh.employee_id
group by jh.employee_id

--12
select j.job_id, j.job_title, count(employee_id) as employee from jobs j
join employees e on e.job_id = j.job_id
group by j.job_id

--13
select d.department_name, age(end_date, start_date) as lama_bekerja from departments d
join job_history jh on d.department_id = jh.department_id

--14
select d.department_id, d.department_name, count(hire_date) as employee_baru from departments d
join employees e on e.department_id = d.department_id
group by d.department_id

--15
select a.employee_id, age(end_date, start_date) as lama_bekerja, b.start_date, b.end_date from employees a
left join job_history b on b.employee_id = a.employee_id