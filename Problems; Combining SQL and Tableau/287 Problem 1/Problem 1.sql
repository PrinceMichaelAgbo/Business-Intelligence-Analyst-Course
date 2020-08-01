use employees_mod;
select year(de.from_date) as calendar_year, e.gender, count(e.emp_no) as num_of_employees
from t_employees e join t_dept_emp de on e.emp_no = de.emp_no
Group by calendar_year, e.gender having calendar_year >= 1990 order by calendar_year, e.gender;

