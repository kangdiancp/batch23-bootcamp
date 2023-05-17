//Informasi jumlah department di tiap regions
select r.region_id, count (d.department_id) as total
from regions r
join countries c on r.region_id = c.region_id
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by r.region_id

//Informasi jumlah department tiap countries
select c.country_id, count (d.department_id) as total
from countries c
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by c.country_id

// Informasi jumlah employee tiap department
select d.department_id, count (e.employee_id) as total
from departments d
join employees e on d.department_id = e.department_id
group by d.department_id order by d.department_id asc;

//informasi jumlah employee tiap region
select r.region_id, count (e.employee_id) as total
from regions r
join countries c on r.region_id = c.region_id
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
join employees e on d.department_id = e.department_id
group by r.region_id order by r.region_id asc;

//informasi jumlah employee tiap countries
select c.country_id, count (e.employee_id) as total
from countries c
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
join employees e on d.department_id = e.department_id
group by c.country_id order by c.country_id asc;

//Informasi salary tertinggi tiap department
select department_id , max(salary) from employees
group by department_id order by department_id asc;

//Informasi salary terendah tiap department
select department_id , min(salary) from employees
group by department_id order by department_id asc;

// Informasi salary rata-rata tiap department
select department_id , avg(salary) from employees
group by department_id order by department_id asc;

//informasi jumlah mutasi pegawai tiap department
select d.department_name, count(*) as jumlah_mutasi
from departments d
join employees e on d.department_id = e.department_id
join job_history j on e.employee_id = j.employee_id
group by d.department_name

//Informasi jumlah mutasi pegawai berdasarkan role-jobs
select j.job_title, count(*) as jumlah_mutasi
from jobs j
join employees e on j.job_id = e.job_id
group by j.job_title

//Informasi jumlah employee yang sering dimutasi
select employee_id, count(*) as jumlah_kemunculan
from job_history
group by employee_id
order by jumlah_kemunculan desc limit 3;

//Informasi jumlah employee berdasarkan role jobs-nya
select j.job_title as role_jobs, count(e.employee_id) as employees from jobs as j 
join employees as e on j.job_id = e.job_id
group by j.job_title order by j.job_title asc;

//Informasi employee paling lama bekerja di tiap deparment
select d.department_id, d.department_name, age (end_date, start_date) as paling_lama_bekerja
from departments d 
join job_history jh on d.department_id = jh.department_id


//Informasi employee baru masuk kerja di tiap department
belum bisa

//Informasi lama bekerja tiap employee dalam tahun dan jumlah mutasi history-nya
belum bisa