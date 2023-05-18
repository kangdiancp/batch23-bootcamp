<<<<<<< HEAD
--nomor 1
=======
//nomor 1
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54

SELECT r.region_id, (
	SELECT count(d.department_id) 
    FROM countries c
    	JOIN locations l ON c.country_id = l.country_id
    		JOIN departments d ON l.location_id = d.location_id
    			WHERE c.region_id = r.region_id
) AS jumlah_department
FROM regions r;


<<<<<<< HEAD
--nomor 2
=======
//nomor 2
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54

SELECT c.country_id, (
    SELECT count(d.department_id) 
    FROM locations l
    	JOIN departments d ON l.location_id = d.location_id
    		WHERE l.country_id = c.country_id
) AS total_department
FROM countries c;


<<<<<<< HEAD
--nomor 3
=======
//nomor 3
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54

select d.department_id, (
	select count(e.employee_id)
		FROM employees e
			WHERE e.department_id = d.department_id
) AS jumlah_employee
FROM departments d;



<<<<<<< HEAD
--nomor 4
=======
//nomor 4
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54

SELECT r.region_id, (
    SELECT count(e.employee_id) 
    FROM countries c
    JOIN locations l ON c.country_id = l.country_id
    JOIN departments d ON l.location_id = d.location_id
    JOIN employees e ON d.department_id = e.department_id
    WHERE c.region_id = r.region_id
) AS jumlah_employee
FROM regions r;


<<<<<<< HEAD
--nomor 5
=======
//nomor 5
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54

SELECT c.country_id, (
    SELECT count(e.employee_id) 
    FROM locations l
    	JOIN departments d ON l.location_id = d.location_id
    		JOIN employees e ON d.department_id = e.department_id
    			WHERE l.country_id = c.country_id
) AS total_employee
FROM countries c;


<<<<<<< HEAD
--nomor 6
=======
//nomor 6
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54

select d.department_id, max(e.salary) as salary_tertinggi from departments d
JOIN employees e ON d.department_id = e.department_id
group by d.department_id order by d.department_id ASC;


<<<<<<< HEAD
--nomor 7
=======
//nomor 7
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54
select d.department_id, min(e.salary) as salary_terendah from departments d
JOIN employees e ON d.department_id = e.department_id
group by d.department_id order by d.department_id ASC;


<<<<<<< HEAD
--nomor 8
=======
//nomor 8
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54
select d.department_id, avg(e.salary) as Rerata_Salary from departments d
JOIN employees e ON d.department_id = e.department_id
group by d.department_id order by d.department_id ASC;


<<<<<<< HEAD
--nomor 9
=======
//nomor 9
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54
SELECT d.department_name, COUNT(*) AS jumlah_mutasi
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN job_history j ON e.employee_id = j.employee_id
GROUP BY d.department_name;


<<<<<<< HEAD
--nomor 10
=======

//nomor 10
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54
SELECT j.job_title, COUNT(*) AS jumlah_mutasi
FROM jobs j
JOIN employees e ON j.job_id = e.job_id
JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY j.job_title;


<<<<<<< HEAD
--nomor 11
SELECT employee_id, COUNT(*) AS jumlah_kemunculan
FROM job_history
GROUP BY employee_id
LIMIT 1;


--nomor 12
=======
//nomor 11
SELECT employee_id, COUNT(*) AS jumlah_kemunculan
FROM job_history
GROUP BY employee_id
order by jumlah_kemunculan DESC
LIMIT 1


//nomor 12
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54
SELECT j.job_title, COUNT(*) AS jumlah_employee
from jobs j
join employees e ON j.job_id = e.job_id
Group by j.job_title


<<<<<<< HEAD
--nomor 13
Belum Bisa


--nomor 14
=======
//nomor 13
belum bisa
select d.department_name, age(end_date, start_date) as lama_bekerja from departments d
join job_history jh on d.department_id = jh.department_id


//nomor 14
>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54
SELECT d.department_name, MAX(e.hire_date) AS max_date
FROM departments d 
join employees e ON d.department_id = e.department_id 
group by d.department_name


<<<<<<< HEAD
--nomor 15
Belum Bisa
=======

//nomor 15
Belum Bisa
select e.employee_id, age(end_date) as long from employees e 
join job_history jh on
e.employee_id = jh.employee_id

>>>>>>> 7f00c4c47ca80ae9795a7c894534075105e45f54
