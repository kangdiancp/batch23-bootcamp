--no1/ jumlah department tiap region
select r.region_id, count(d.department_id) total_department
from regions r
join countries c on r.region_id = c.region_id
join locations l on c.country_id= l.country_id
join departments d on l.location_id = d.location_id
group by r.region_id order by r.region_id;

--no2/ jumlah department tiap countries
select c.country_id, count(d.department_id) total_department
from countries c
join regions r on r.region_id = r.region_id
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
group by c.country_id order by c.country_id;

--no3/ jumlah employee tiap departmen
select d.department_id, count(e.employee_id) total_employee
from departments d
join employees e on d.department_id = e.department_id
group by d.department_id order by d.department_id;

--no4/ jumlah employee tiap region
select r.region_id, count(e.employee_id) total_region
from regions r
join countries c on r.region_id = c.region_id
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
join employees e on d.department_id = e.department_id
group by r.region_id order by r.region_id;

--no5/ jumlah employee tiap countries
select c.country_id, count(e.employee_id) total_country
from countries c
join locations l on c.country_id = l.country_id
join departments d on l.location_id = d.location_id
join employees e on d.department_id = e.department_id
group by c.country_id order by c.country_id;

--no6/ salary tertinggi tiap department
select department_id, max(salary) salary_tertinggi from employees
group by department_id order by department_id;

--no7/ salary terendah tiap department
select department_id, min(salary) salary_terendah from employees
group by department_id;

--no8/ salary rata-rata tiap department
select department_id, avg(salary) salary_rata2 from employees
group by department_id;

--no9/ jumlah mutasi pegawai tiap department
select d.department_id, count(*) jumlah_mutasi
from departments d
join employees e on d.department_id = e.department_id
join job_history j on e.employee_id = j.employee_id
group by d.department_id order by department_id;

--no10/ jumlah mutasi pegawai berdasarkan role-jobs
select j.job_id, count(*) jumlah_mutasirolejobs
from jobs j
join employees e on j.job_id = e.job_id
join job_history jb on e.employee_id = jb.employee_id
group by j.job_id order by job_id;

--no11/ jumlah employee yang sering dimutasi
select employee_id, count(*) jumlah_employemutasi
from job_history
group by employee_id order by jumlah_employemutasi
limit 3;

--no12/ jumlah employe berdasarkan role jobsnya
select j.job_title, count(*) jumlah_employrolejobs
from jobs j
join employees e on j.job_id = e.job_id
group by j.job_title;

--no13/ employee paling lama bekerja ditiap department
select d.department_name, age(end_date, start_date) paling_lamabekerja
from departments d
left join job_history j on d.department_id = j.department_id;

--no14/ employee baru masuk kerja ditiap depatment
select d.department_name, max(hire_date) baru_masukkerja
from departments d 
left join employees e on d.department_id = e.department_id
group by d.department_name;

--n015/ lama bekerja tiap employee dalam tahun dan jumlah mutasi history-nya
select e.employee_id, count(*) jumlah_mutasihistory
from job_history
group by employee_id order by jumlah_mutasihistory