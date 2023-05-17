--QUIZ DAY 01--

-- Nomor 1  Informasi jumlah department di tiap regions.
select r.region_id as region, count(d.department_id) as department 
from regions as r join countries as c on r.region_id = c.region_id 
join locations as l on c.country_id = l.country_id join departments as d on l.location_id = d.location_id
group by r.region_id
order by r.region_id asc

-- Nomor 2 Informasi jumlah department tiap countries
select c.country_id as country, count(d.department_id) as departments from countries as c 
join locations as l on c.country_id = l.country_id 
join departments as d on l.location_id = d.location_id
group by c.country_id
order by c.country_id asc

-- Nomor 3 Informasi jumlah employee tiap department.
select d.department_id as department, count(e.employee_id) as employees from departments as d 
join employees as e on d.department_id = e.department_id
group by d.department_id
order by d.department_id asc

-- Nomor 4 Informasi jumlah employee tiap region
select r.region_id as region, count(e.employee_id) as employees from regions as r 
join countries as c on r.region_id = c.region_id 
join locations as l on c.country_id = l.country_id 
join departments as d on l.location_id = d.location_id
join employees as e on d.department_id = e.department_id
group by r.region_id
order by r.region_id asc

-- Nomor 5 Informasi jumlah employee tiap countries.
select c.country_id as countries, count(e.employee_id) as employees from countries as c 
join locations as l on c.country_id = l.country_id 
join departments as d on l.location_id = d.location_id
join employees as e on d.department_id = e.department_id
group by c.country_id
order by c.country_id asc

-- Nomor 6 Informasi salary tertinggi tiap department.
select department_id as department, max(salary) from employees
group by department_id
order by department_id asc

-- Nomor 7 Informasi salary terendah tiap department.
select department_id as department, min(salary) from employees
group by department_id
order by department_id asc

-- Nomor 8 Informasi salary rata-rata tiap department.
select department_id as department, avg(salary) from employees
group by department_id
order by department_id asc

-- Nomor 9 Informasi jumlah mutasi pegawai tiap department.
select d.department_id, d.department_name, count(*) as jumlah_mutasi from departments as d 
join employees as e on d.department_id = e.department_id
join job_history as jy on e.employee_id = jy.employee_id
group by d.department_id
order by d.department_id asc

-- Nomor 10 Informasi jumlah mutasi pegawai berdasarkan role-jobs.
select j.job_id, j.job_title, count(*) as jumlah_mutasi from jobs as j 
join employees as e on j.job_id = e.job_id
join job_history as jy on e.employee_id = jy.employee_id
group by j.job_id
order by j.job_id asc

-- Nomor 11 Informasi jumlah employee yang sering dimutasi.
select employee_id, count(*) as jumlah_employee from job_history where jumlah_employee > 1
group by employee_id
order by employee_id asc


-- Nomor 12 Informasi jumlah employee berdasarkan role jobs-nya.
select j.job_title as role_jobs, count(e.employee_id) as employees from jobs as j 
join employees as e on j.job_id = e.job_id
group by j.job_title
order by j.job_title asc


-- Nomor 13 Informasi employee paling lama bekerja di tiap department.
select d.department_id, d.department_name, min(e.hire_date) as paling_lama_bekerja 
from departments as d 
join employees as e on d.department_id = e.department_id
group by d.department_id
order by d.department_id asc

-- Nomor 14 Informasi employee baru masuk kerja di tiap department.
select d.department_id, d.department_name, max(e.hire_date) as baru_masuk_kerja
from departments as d 
join employees as e on d.department_id = e.department_id
group by d.department_id
order by d.department_id asc

-- Nomor 15 Informasi lama bekerja tiap employee dalam tahun dan jumlah mutasi history-nya.
-- Not yet -- 