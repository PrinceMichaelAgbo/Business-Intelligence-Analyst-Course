#Subqueries#

#IN
select * from dept_manager;
select e.first_name, e.last_name from employees e where e.emp_no in
(select dm.emp_no from dept_manager dm);
select * from employees e where e.hire_date > "1990-01-01" and e.hire_date < "1995-01-01" and e.emp_no in
(select dm.emp_no from dept_manager dm);
SELECT * FROM dept_manager WHERE emp_no IN 
(SELECT emp_no FROM employees WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');

#Exists/Not Exists
select e.first_name, e.last_name from employees e where exists
(select * from dept_manager dm where dm.emp_no = e.emp_no);
select * from employees e where exists
(select * from titles t where title = "Assistant Engineer" and t.emp_no = e.emp_no);

#Select/From

select A.* from 
(select e.emp_no as employee_id, min(de.dept_no) as department_code, (select emp_no from dept_manager where emp_no=110022) as manager_id
from employees e join dept_emp de on e.emp_no = de.emp_no
where e.emp_no <= 10020 group by e.emp_no order by e.emp_no) as A
UNION
select B.* from 
(select e.emp_no as employee_id, min(de.dept_no) as department_code, (select emp_no from dept_manager where emp_no=110039) as manager_id
from employees e join dept_emp de on e.emp_no = de.emp_no
where e.emp_no > 10020 group by e.emp_no order by e.emp_no limit 20) as B
;
select * from dept_emp;
select * from employees;

DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (emp_no INT(11) NOT NULL, dept_no CHAR(4) NULL, manager_no INT(11) NOT NULL);

INSERT INTO emp_manager
SELECT u.* FROM
(
SELECT a.* FROM
(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code, (SELECT emp_no FROM dept_manager WHERE emp_no = 110022) AS manager_ID
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no WHERE e.emp_no <= 10020 GROUP BY e.emp_no ORDER BY e.emp_no) AS a 
UNION 
SELECT b.* FROM
(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code, (SELECT emp_no FROM dept_manager WHERE emp_no = 110039) AS manager_ID
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no WHERE e.emp_no > 10020 GROUP BY e.emp_no ORDER BY e.emp_no LIMIT 20) AS b 
UNION
SELECT c.* FROM
(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code, (SELECT emp_no FROM dept_manager WHERE emp_no = 110039) AS manager_ID
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no WHERE e.emp_no = 110022 GROUP BY e.emp_no) AS c
UNION
SELECT d.* FROM 
(SELECT e.emp_no AS employee_ID, MIN(de.dept_no) AS department_code, (SELECT emp_no FROM dept_manager WHERE emp_no = 110022) AS manager_ID
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no WHERE e.emp_no = 110039 GROUP BY e.emp_no) AS d
) as u;


#Stored Routines and SQL variables
DROP PROCEDURE IF EXISTS select_employees;
DELIMITER $$ 
CREATE PROCEDURE select_employees()
Begin
	Select * from employees
    limit 1000;
End$$
DELIMITER ;

call select_employees(); 

DROP PROCEDURE IF EXISTS avg_salary;
DELIMITER $$ 
CREATE PROCEDURE avg_salary()
Begin
	Select avg(salary) as average_salary from salaries;
End$$
DELIMITER ;

call emp_salary(11300);
call emp_avg_salary(11300);
call emp_avg_salary_out(11300);
set @v_avg_salary = 0;
call employees.emp_avg_salary_out(11300, @v_avg_salary);
select @v_avg_salary;
set @v_emp_no = 0;
call employees.emp_info("Aruna", "Journel", @v_emp_no);
select @v_emp_no;

#User-Defined Functions
#SET @@global.log_bin_trust_function_creators := 1;

USE employees;
Drop Function if exists f_emp_avg_salary;
DELIMITER $$
Create Function f_emp_avg_salary(p_emp_no INTEGER) Returns Decimal(10, 2) 
Deterministic Reads SQL Data
Begin
Declare v_avg_salary Decimal(10, 2);
Select avg(s.salary) into v_avg_salary from
employees e join salaries s on e.emp_no = s.emp_no
where e.emp_no = p_emp_no;
return v_avg_salary;
End$$
Delimiter ;

select f_emp_avg_salary(11300);

USE employees;
Drop Function if exists f_emp_info;
DELIMITER $$
Create Function f_emp_info(p_first_name varchar(14), p_last_name varchar(16)) Returns Decimal(10, 2) 
Deterministic Reads SQL Data
Begin
Declare v_max_from_date DATE;
Declare v_salary Decimal(10, 2);
SELECT MAX(from_date) INTO v_max_from_date 
FROM employees e JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.first_name = p_first_name AND e.last_name = p_last_name;
SELECT s.salary INTO v_salary FROM
employees e JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.first_name = p_first_name AND e.last_name = p_last_name AND s.from_date = v_max_from_date;
return v_salary;
End$$
Delimiter ;

select f_emp_info("Lillian", "Fontet");
select * from salaries where emp_no = 11300;

#CASE statement
Select emp_no, first_name, last_name, 
Case 
	When gender = "M" Then "Male"
    Else "Female"
End As gender
From employees;

Select emp_no, first_name, last_name, 
Case gender
	When "M" Then "Male"
    Else "Female"
End As gender
From employees;

Select e.emp_no, e.first_name, e.last_name, 
Case
	When dm.emp_no IS NOT NULL Then "Manager"
    Else "Employee"
End As is_manager
From employees e left join dept_manager dm on dm.emp_no = e.emp_no
where e.emp_no > 10990 order by is_manager desc;

Select emp_no, first_name, last_name, 
If(gender = "M", "Male", "Female") As gender
From employees;

Select e.emp_no, e.first_name, e.last_name, Max(s.salary) - Min(s.salary) As salary_difference,
Case
	When Max(s.salary) - Min(s.salary) > 30000 Then "Salary was raised by more than $30,000"
    When Max(s.salary) - Min(s.salary) Between 20000 and 30000 Then "Salary was raised by more than $20,000 but less than $30,000"
    Else "Salary was raised by less than $20,000"
End As salary_increase
From dept_manager dm join employees e on dm.emp_no = e.emp_no join salaries s on s.emp_no = dm.emp_no
Group by s.emp_no;

Select e.emp_no, e.first_name, e.last_name, Max(s.salary) - Min(s.salary) As salary_difference,
Case
	When Max(s.salary) - Min(s.salary) > 30000 Then "Salary was raised by more than $30,000"
    Else "Salary was raised by less than $30,000"
End As salary_increase
From dept_manager dm join employees e on dm.emp_no = e.emp_no join salaries s on s.emp_no = dm.emp_no
Group By s.emp_no;

Select e.emp_no, e.first_name, e.last_name, Max(s.salary) - Min(s.salary) As salary_difference,
if(Max(s.salary) - Min(s.salary) > 30000, "Salary was raised by more than $30,000", "Salary was NOT raised by more than $30,000") as salary_increase
From dept_manager dm join employees e on dm.emp_no = e.emp_no join salaries s on s.emp_no = dm.emp_no
Group By s.emp_no;

Select * from (SELECT e.emp_no, e.first_name, e.last_name,
CASE
	WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
    ELSE 'Not an employee anymore'
END AS current_employee
FROM employees e JOIN dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no LIMIT 100) as a where current_employee = "Not an employee anymore";

select * from dept_emp;



