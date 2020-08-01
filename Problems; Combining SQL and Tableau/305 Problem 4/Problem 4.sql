Select min(salary) from t_salaries;
Select max(salary) from t_salaries;

Drop procedure if exists salary_range;
Delimiter $$
Create Procedure salary_range(IN p_lower_bound FLOAT, IN p_upper_bound FLOAT)
Begin
	Select dept_name, gender, Round(Avg(salary), 2) as salary
    From t_employees e join t_salaries s on e.emp_no = s.emp_no join t_dept_emp de on e.emp_no = de.emp_no
	join t_departments d on de.dept_no = d.dept_no
	Where s.salary Between p_lower_bound And p_upper_bound
    Group by d.dept_no, e.gender
    Order by d.dept_no, e.gender;
End$$
Delimiter ;

call salary_range(50000, 90000);