-- 1. Informasi jumlah department di tiap regions.
select r.region_id, r.region_name, count(department_id) 
from departments d join locations l on d.location_id = l.location_id 
join countries c on l.country_id = c.country_id 
join regions r on c.region_id = r.region_id
group by r.region_id

-- 2. Informasi jumlah department tiap countries.
select c.country_id, c.country_name,count(department_id) 
from departments d join locations l on d.location_id = l.location_id
join countries c on l.country_id = c.country_id
group by c.country_id

-- 3. Informasi jumlah employee tiap department.
select d.department_id, d.department_name, count(employee_id)
from employees e join departments d on e.employee_id = d.manager_id
group by d.department_id

-- 4. Informasi jumlah employee tiap region.
select r.region_id, r.region_name, count(employee_id)
from employees e join departments d on e.employee_id = d.manager_id
join locations l on d.location_id = l.location_id 
join countries c on l.country_id = c.country_id 
join regions r on c.region_id = r.region_id
group by r.region_id

-- 5. Informasi jumlah employee tiap countries.
select c.country_id, c.country_name,count(employee_id)
from employees e join departments d on e.employee_id = d.manager_id
join locations l on d.location_id = l.location_id
join countries c on l.country_id = c.country_id
group by c.country_id

-- 6. Informasi salary tertinggi tiap department.
select department_id,max(salary) from employees
group by department_id

-- 7. Informasi salary terendah tiap department.
select department_id,min(salary) from employees
group by department_id

-- 8. Informasi salary rata-rata tiap department.
select department_id,avg(salary) from employees
group by department_id

-- 9. Informasi jumlah mutasi pegawai tiap deparment.
select d.department_name, count(*) as jumlah_mutasi
from departments d join employees e on d.department_id = e.department_id
join job_history h on e.employee_id = h.employee_id
group by d.department_name

-- 10.Informasi jumlah mutasi pegawai berdasarkan role-jobs.
select j.job_title, count(*) as jumlah_mutasi from jobs j
join employees e on j.job_id = e.job_id
join job_history h on e.employee_id = h.employee_id
group by j.job_title

-- 11.Informasi jumlah employee yang sering dimutasi.
select employee_id, count(*) as jumlah_seringmutasi from job_history
group by employee_id
order by jumlah_seringmutasi desc
limit 1;

-- 12.Informasi jumlah employee berdasarkan role jobs-nya.
select j.job_title, count(*) as jumlah_employee from jobs j
join employees e on j.job_id = e.job_id
group by j.job_title


-- 13.Informasi employee paling lama bekerja di tiap deparment.
select department_id,min(hire_date) from employees
group by department_id

-- 14.Informasi employee baru masuk kerja di tiap department.
select department_id,max(hire_date) from employees
group by department_id

-- 15.Informasi lama bekerja tiap employee dalam tahun dan jumlah mutasi history-nya.
select department_id,min(hire_date) from employees
group by department_id