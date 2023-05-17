create or replace view total_employee_by_country as
select t.country_name,t.city,d.department_id,d.department_name,count(employee_id)total_employee
from employees as e, departments as d,
(select r.region_id,region_name,c.country_id,country_name,city,l.location_id
from regions as r, countries as c, locations as l
where r.region_id = c.region_id
and c.country_id = l.country_id)as t
where e.department_id = d.department_id
and d.location_id = t.location_id
group by t.country_name,t.city,d.department_id,d.department_name

select *from total_employee_by_country
where city = 'Seattle'