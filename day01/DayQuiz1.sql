//nomor 1

SELECT r.region_id, (
	SELECT count(d.department_id) 
    FROM countries c
    	JOIN locations l ON c.country_id = l.country_id
    		JOIN departments d ON l.location_id = d.location_id
    			WHERE c.region_id = r.region_id
) AS jumlah_department
FROM regions r;


//nomor 2

SELECT c.country_id, (
    SELECT count(d.department_id) 
    FROM locations l
    	JOIN departments d ON l.location_id = d.location_id
    		WHERE l.country_id = c.country_id
) AS total_department
FROM countries c;


//nomor 3

select d.department_id, (
	select count(e.employee_id)
		FROM employees e
			WHERE e.department_id = d.department_id
) AS jumlah_employee
FROM departments d;



//nomor 4

SELECT r.region_id, (
    SELECT count(e.employee_id) 
    FROM countries c
    JOIN locations l ON c.country_id = l.country_id
    JOIN departments d ON l.location_id = d.location_id
    JOIN employees e ON d.department_id = e.department_id
    WHERE c.region_id = r.region_id
) AS jumlah_employee
FROM regions r;


//nomor 5

SELECT c.country_id, (
    SELECT count(e.employee_id) 
    FROM locations l
    	JOIN departments d ON l.location_id = d.location_id
    		JOIN employees e ON d.department_id = e.department_id
    			WHERE l.country_id = c.country_id
) AS total_employee
FROM countries c;


//nomor 6

select d.department_id, max(e.salary) as salary_tertinggi from departments d
JOIN employees e ON d.department_id = e.department_id
group by d.department_id order by d.department_id ASC;


//nomor 7
select d.department_id, min(e.salary) as salary_terendah from departments d
JOIN employees e ON d.department_id = e.department_id
group by d.department_id order by d.department_id ASC;


//nomor 8
select d.department_id, avg(e.salary) as Rerata_Salary from departments d
JOIN employees e ON d.department_id = e.department_id
group by d.department_id order by d.department_id ASC;


//nomor 9
SELECT d.department_name, COUNT(*) AS jumlah_mutasi
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN job_history j ON e.employee_id = j.employee_id
GROUP BY d.department_name;



//nomor 10
SELECT j.job_title, COUNT(*) AS jumlah_mutasi
FROM jobs j
JOIN employees e ON j.job_id = e.job_id
JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY j.job_title;


//nomor 11
SELECT employee_id, COUNT(*) AS jumlah_kemunculan
FROM job_history
GROUP BY employee_id
order by jumlah_kemunculan DESC
LIMIT 1


//nomor 12
SELECT j.job_title, COUNT(*) AS jumlah_employee
from jobs j
join employees e ON j.job_id = e.job_id
Group by j.job_title


//nomor 13
belum bisa
select d.department_name, age(end_date, start_date) as lama_bekerja from departments d
join job_history jh on d.department_id = jh.department_id


//nomor 14
SELECT d.department_name, MAX(e.hire_date) AS max_date
FROM departments d 
join employees e ON d.department_id = e.department_id 
group by d.department_name



//nomor 15
Belum Bisa
select e.employee_id, age(end_date) as long from employees e 
join job_history jh on
e.employee_id = jh.employee_id

