create table regions (
	region_id integer primary key,
	region_name varchar(25)
);
select * from regions;

create table countries(
	country_id char(2),
	country_name varchar(40),
	foreign key (region_id) references regions(region_id)
);
select * from countries;

create table locations(
	location_id integer primary key,
	street_address varchar(40),
	postal_code varchar(12),
	city varchar(25),
	state_province varchar(25),
	foreign key (country_id) references countries(country_id)
);
select * from locations;

create table jobs(
	job_id varchar(10) primary key,
	job_title varchar(35) unique,
	min_salary decimal(8,2),
	max_salary decimal(8,2)
);
select * from jobs;

create table departments(
	department_id integer primary key,
	department_name varchar(30),
	manager_id integer,
	location_id integer,
	foreign key (manager_id) references employess(employee_id),
	foreign key (location_id) references locations(location_id)
);
select * from departments;

create table employees (
	employee_id integer primary key,
	first_name varchar(20),
	last_name varchar(25),
	email varchar(25),
	phone_number varchar(20),
	hire_date timestamp,
	salary decimal(8,2),
	commision_pct decimal(2,2),
	job_id varchar(10),
	manager_id integer,
	department_id integer,
	foreign key (job_id) references jobs(job_id),
	foreign key (manager_id) references employees(employee_id),
	foreign key (department_id) references departments(department_id)
);

alter table employees add column xemp_id integer
select * from employees;

create table job_history(
	employee_id integer,
	start_date timestamp,
	end_date timestamp,
	job_id varchar(10),
	department_id integer,
	constraint employee_id primary key (employee_id,start_date),
	foreign key (employee_id) references employees(employee_id),
	foreign key (job_id) references jobs(job_id),
	foreign key (department_id) references departments(department_id)
);
drop table job_history

alter table departments add column manager_id integer
alter table employees add column manager_id integer


--join
select * from regions r inner join countries c on r.region_id = c.region_id
select * from countries r left join regions c on r.region_id = c.region_id

select country_id,country_name,r.region_id,region_name from regions r
right join countries c on r.region_id = c.region_id

select c.country_id,country_name,r.region_id,region_name,location_id,street_address 
from regions r right join countries c on r.region_id=c.region_id join locations l on c.country_id=l.country_id

select manager_id,count(employee_id) from employees group by manager_id

select department_id,sum(salary) from employees group by department_id having sum(salary) >=6500

select department_id,avg(salary) from employees group by department_id

select first_name from employees where first_name like 'D%'
select first_name from employees where first_name like '%a'

--subquery
select * from departments where location_id in
(select location_id from locations l join countries c 
 on l.country_id=c.country_id
 where c.region_id=1
)

select * from locations where country_id in(
select country_id from countries as c join regions as r 
on c.region_id=r.region_id
where r.region_id=1)

--tugas1
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