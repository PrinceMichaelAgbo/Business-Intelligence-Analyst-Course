use employees_mod;
Select d.dept_name, ee.gender, dm.emp_no, dm.from_date, dm.to_date, e.calendar_year,
Case
When Year(dm.from_date) <= e.calendar_year and Year(dm.to_date) >= e.calendar_year Then 1
Else 0
End As active_d
From (Select Year(hire_date) as calendar_year from t_employees Group By calendar_year) e 
	Cross Join t_dept_manager dm join t_departments d On dm.dept_no = d.dept_no join t_employees ee on dm.emp_no = ee.emp_no
order by dm.emp_no, calendar_year;
