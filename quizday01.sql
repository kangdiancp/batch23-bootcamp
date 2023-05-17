--1.Informasi jumlah department di tiap regions 
SELECT r.region_id, count (d.department_id) as total
from regions r
join countries c on r.region_id = c.region_id
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by r.region_id
order by r.region_id asc;

--2.Informai jumlah department tiap countries
SELECT c.country_id, count (d.department_id) as total
from countries c
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by c.country_id
order by c.country_id; 

--3.Informasi jumlah employee tiap department
SELECT d.department_id, count (e.employee_id) as total
from departments d
join employees e on d.department_id = e.department_id
group by d.department_id
order by d.department_id;

--4.Informasi jumlah employee tiap region
SELECT r.region_id, count (e.employee_id) as total 
from regions r
join countries c on r.region_id = c.region_id
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
join employees e on d.department_id = e.department_id
group by r.region_id
order by r.region_id;

--5.Informasi jumlah employee tiap countries
SELECT c.country_id, count (e.employee_id) as total
from countries c
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
join employees e on d.department_id = e.department_id
group by c.country_id
order by c.country_id;

--6.Informasi salary tertinggi tiap department
select  d.department_id, d.department_name, max(salary) from employees e
join departments d on e.department_id = d.department_id
group by d.department_id
order by d.department_id asc;

--7.Informasi salary terendah tiap department
select  d.department_name, min(salary) from employees e
join departments d on e.department_id = d.department_id
group by d.department_id
order by d.department_id desc;

--8.Informasi salary rata-rata tiap department
select  d.department_name, avg(salary)
from employees e
join departments d on e.department_id = d.department_id
group by d.department_id
order by d.department_id asc;

--9.Informasi jumlah mutasi pegawai tiap deparment
select d.department_name, count(*) as jumlah_mutasi
from departments d 
join employees e on d.department_id = e.department_id
join job_history j on e.employee_id = j.employee_id
group by d.department_name

--10.informasi jumlah mutasi pegawai berdasarkan role-jobs
select  j.job_title, count(*) as jumlah_mutasi
from jobs j
join employees e on j.job_id = e.job_id
group by j.job_title

--11.Informasi jumlah employee yang sering dimutasi
select jh.employee_id,max(end_date), count(e.employee_id) as jumlah_employee
from job_history jh
inner join employees e on e.employee_id = jh.employee_id
group by jh.employee_id

--12.Informasi jumlah employee berdasarkan role jobs-nya
select j.job_id, j.job_title, count(employee_id) as employee 
from jobs j
join employees e on e.job_id = j.job_id
group by j.job_id

--13.Informasi employee paling lama bekerja di tiap deparment
select d.department_name, age(end_date, start_date) as lama_bekerja
from departments d
join job_history jh on d.department_id = jh.department_id

--14.Informasi employee baru masuk kerja di tiap department.
select d.department_id, d.department_name, count(hire_date) as employee_baru
from departments d
join employees e on e.department_id = d.department_id
group by d.department_id

insert into job_history (employee_id, start_date, end_date, job_id, department_id) values
(101, '1997-09-21', '2001-10-27', 'AC_ACCOUNT', 110),
(101, '2001-10-28', '2005-03-15', 'AC_MGR', 110),
(102, '2001-01-13', '2006-07-24', 'IT_PROG', 60),
(114, '2006-03-24', '2007-12-31', 'ST_CLERK', 50),
(122, '2007-01-01', '2007-12-31', 'ST_CLERK', 50),
(176, '2006-03-24', '2006-12-31', 'SA_REP', 80),
(176, '2007-01-01', '2007-12-31', 'SA_MAN', 80),
(200, '1995-09-17', '2001-06-17', 'AD_ASST', 90),
(200, '2002-07-01', '2006-12-31', 'AC_ACCOUNT', 90),
(201, '2004-02-17', '2007-12-19', 'MK_REP', 20)