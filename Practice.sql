SELECT first_name, last_name FROM employees; 
SELECT dept_no FROM departments; 
SELECT * FROM departments; 

SELECT * FROM employees WHERE first_name LIKE ("Mark%");
SELECT * FROM employees WHERE hire_date LIKE ("2000%");
SELECT * FROM employees WHERE emp_no LIKE ("1000_");

SELECT * FROM employees WHERE first_name LIKE ("%Jack%");
SELECT * FROM employees WHERE first_name NOT LIKE ("%Jack%");

SELECT * FROM employees WHERE hire_date BETWEEN "1990-01-01" AND "2000-01-01" order by hire_date;
SELECT * FROM employees WHERE hire_date NOT BETWEEN "1990-01-01" AND "2000-01-01" order by hire_date;

SELECT * FROM salaries WHERE salary BETWEEN "60000" AND "70000" order by salary;
SELECT * FROM employees WHERE emp_no NOT BETWEEN "10004" AND "100012" order by emp_no;
Select * from departments WHERE dept_no BETWEEN "d003" AND "d006" order by dept_no;

Select * from employees WHERE first_name IS NOT NULL;
Select * from employees WHERE first_name IS NULL;
Select dept_name from departments WHERE dept_no IS NOT NULL order by dept_no;

select * from employees where first_name <> "Mark";
select * from employees where hire_date >= "2000-01-01" order by hire_date;
select * from employees where hire_date <= "1985-02-01" order by hire_date;

select * from employees where gender = "F" AND hire_date >= "2000-01-01" order by hire_date;
select * from salaries where salary > "150000" order by salary;

select distinct gender from employees;
select distinct hire_date from employees;

select count(emp_no) from employees;
select count(first_name) from employees;
select count(distinct first_name) from employees;
select count(*) from salaries where salary >= "100000";
select count(*) from titles where title = "Manager";
select count(*) from dept_manager;
select dept_name from departments;
select count(*) from dept_emp;

select * from employees order by first_name desc;
select * from employees order by emp_no desc;
select * from employees order by first_name desc, last_name desc;
select * from employees order by hire_date desc;

select first_name from employees group by first_name order by first_name;
select distinct first_name from employees order by first_name;
select first_name, count(first_name) from employees group by first_name order by first_name Desc; 

#Aliases
select first_name, count(first_name) as name_count from employees group by first_name order by first_name Desc; 
select salary, count(emp_no) as emps_with_same_salary from salaries where salary > "80000" group by salary order by salary;

#having
select * from employees Having hire_date >= '2000-01-01';
select first_name, count(first_name) as name_count from employees 
where count(first_name) > 250 group by first_name order by first_name Desc; 
select first_name, count(first_name) as name_count from employees 
group by first_name having count(first_name) > 250 order by first_name Desc; 
select *, avg(salary) as avg_salary from salaries group by emp_no having avg(salary) > "120000";
SELECT *, AVG(salary) FROM salaries WHERE salary > 120000 GROUP BY emp_no ORDER BY emp_no;
SELECT *, AVG(salary) FROM salaries GROUP BY emp_no HAVING AVG(salary) > 120000;

#Using WHERE vs HAVING
select first_name, count(first_name) as name_count from employees where hire_date > "1999-01-01" 
Group by first_name having count(first_name) < 200 order by first_name desc;
select * from employees where first_name = "zvonko" AND hire_date > "1999-01-01";

select emp_no, count(emp_no) as num_contracts from dept_emp where from_date > "2000-01-01" 
Group by emp_no Having num_contracts > 1 order by emp_no;
SELECT emp_no FROM dept_emp WHERE from_date > '2000-01-01' GROUP BY emp_no HAVING COUNT(from_date) > 1 ORDER BY emp_no;
select * from dept_emp;

#Limit
select * from salaries order by salary desc limit 10;
select * from dept_emp limit 100;

#Expanding on aggregate functions
select * from salaries order by salary desc limit 10;
select count(salary) from salaries;
select count(distinct from_date) from salaries; 
select count(*) from salaries; 
select count(distinct dept_no) from dept_emp;

select sum(salary) from salaries;
select sum(salary) from salaries where from_date > "1997-01-01";

select max(salary) from salaries;
select min(salary) from salaries;
select min(emp_no) from employees;
select max(emp_no) from employees;

select avg(salary) from salaries;
select avg(salary) from salaries where from_date > "1997-01-01";

select Round(avg(salary), 2) from salaries;
select Round(avg(salary), 2) from salaries where from_date > "1997-01-01";

#JOINS
DROP TABLE IF EXISTS departments_dup;
CREATE TABLE departments_dup (dept_no CHAR(4) NULL, dept_name VARCHAR(40) NULL);
INSERT INTO departments_dup (dept_no, dept_name) SELECT * FROM departments;
INSERT INTO departments_dup (dept_name) VALUES ('Public Relations');
DELETE FROM departments_dup WHERE dept_no = 'd002'; 
INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');

DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (emp_no int(11) NOT NULL, dept_no char(4) NULL, from_date date NOT NULL, to_date date NULL);
INSERT INTO dept_manager_dup select * from dept_manager;
INSERT INTO dept_manager_dup (emp_no, from_date) VALUES (999904, '2017-01-01'), (999905, '2017-01-01'), (999906, '2017-01-01'), (999907, '2017-01-01');
DELETE FROM dept_manager_dup WHERE dept_no = 'd001';

#Inner join
select * from dept_manager_dup order by dept_no;
select * from departments_dup order by dept_no;
select m.dept_no, m.emp_no, d.dept_name from dept_manager_dup m inner join departments_dup d on m.dept_no = d.dept_no order by m.dept_no;
select m.emp_no, m.dept_no, e.first_name, e.last_name, e.hire_date from dept_manager m 
inner join employees e on m.emp_no = e.emp_no order by m.emp_no;
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date FROM employees e 
JOIN dept_manager dm ON e.emp_no = dm.emp_no order by dm.emp_no;

#Extra info on joins
select m.dept_no, m.emp_no, m.from_date, m.to_date, d.dept_name from dept_manager_dup m 
inner join departments_dup d on m.dept_no = d.dept_no order by m.dept_no;

#duplicate rows
insert into dept_manager_dup values ("110228", "d003", "1992-03-21", "9999--01-01");
insert into departments_dup values ("d009", "Customer Service");
select * from dept_manager_dup order by dept_no;
select * from departments_dup order by dept_no;
select m.dept_no, m.emp_no, d.dept_name from dept_manager_dup m
inner join departments_dup d on m.dept_no = d.dept_no GROUP by m.emp_no order by m.dept_no;

#Left Join
Delete from dept_manager_dup where emp_no = "110228";
Delete from departments_dup where dept_no = "d009";
insert into dept_manager_dup values ("110228", "d003", "1992-03-21", "9999--01-01");
insert into departments_dup values ("d009", "Customer Service");
select * from dept_manager_dup order by dept_no;
select * from departments_dup order by dept_no;
select m.dept_no, m.emp_no, d.dept_name from dept_manager_dup m
left join departments_dup d on m.dept_no = d.dept_no GROUP by m.emp_no order by m.dept_no;
select d.dept_no, m.emp_no, d.dept_name from departments_dup d
left outer join dept_manager_dup m on d.dept_no = m.dept_no order by d.dept_no;
select m.dept_no, m.emp_no, d.dept_name from dept_manager_dup m
left join departments_dup d on m.dept_no = d.dept_no where dept_name is null order by m.dept_no;
select e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date from employees e
left join dept_manager dm on e.emp_no = dm.emp_no where e.last_name = "Markovitch" order by dept_no desc, emp_no;
select * from dept_manager;

#Right Join
select d.dept_no, m.emp_no, d.dept_name from dept_manager_dup m
right join departments_dup d on m.dept_no = d.dept_no order by dept_no;

#Old and New Join Syntax
select m.dept_no, m.emp_no, d.dept_name from dept_manager_dup m
join departments_dup d on m.dept_no = d.dept_no order by dept_no;
select m.dept_no, m.emp_no, d.dept_name from dept_manager_dup m, departments_dup d 
where m.dept_no = d.dept_no order by dept_no;
select e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date from employees e, dept_manager dm
where e.emp_no = dm.emp_no order by emp_no;
SELECT e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no; 

#Join and Where together
SELECT e.emp_no, e.first_name, e.last_name, s.salary FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no where s.salary > "145000"; 
SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, t.title FROM employees e
JOIN titles t ON e.emp_no = t.emp_no where e.first_name = "Margareta" and e.last_name = "Markovitch";

#To prevent error code: 1055
select @@global.sql_mode;
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');
#set @@global.sql_mode := concat('ONLY_FULL_GROUP_BY,', @@global.sql_mode); to change it back

#cross Join
select dm.*, d.* from dept_manager dm cross join departments d order by dm.emp_no, d.dept_no;
select dm.*, d.* from dept_manager dm, departments d order by dm.emp_no, d.dept_no;
select dm.*, d.* from dept_manager dm join departments d order by dm.emp_no, d.dept_no;

select dm.*, d.* from departments d cross join dept_manager dm where dm.dept_no != d.dept_no order by dm.emp_no, d.dept_no;
select e.*, d.*, dm.* from departments d cross join dept_manager dm join employees e on dm.emp_no = e.emp_no
where dm.dept_no != d.dept_no order by dm.emp_no, d.dept_no;

select dm.*, d.* from dept_manager dm cross join departments d
where d.dept_no = "d009" order by dm.emp_no, d.dept_no;
select e.*, d.* from employees e cross join departments d
where e.emp_no < "10011" order by e.emp_no, d.dept_no;

#Aggregate functions with joins
select e.gender, AVG(salary) AS average_salary from employees e
join salaries s on e.emp_no = s.emp_no group by gender;

#Join more than two tables
select e.first_name, e.last_name, e.hire_date, m.from_date, d.dept_name from employees e
join dept_manager m on e.emp_no = m.emp_no join departments d on m.dept_no = d.dept_no;
select e.first_name, e.last_name, e.hire_date, m.from_date, d.dept_name from departments d
join dept_manager m on d.dept_no = m.dept_no join employees e on m.emp_no = e.emp_no;

select e.first_name, e.last_name, e.hire_date, t.title, dm.from_date, d.dept_name from employees e
join titles t on e.emp_no = t.emp_no join dept_manager dm on t.emp_no = dm.emp_no join departments d on d.dept_no = dm.dept_no
where t.title ="Manager";

#Tips for joins
select d.dept_name, avg(salary) as average_salary from departments d join dept_manager m on d.dept_no = m.dept_no
join salaries s on m.emp_no = s.emp_no group by d.dept_name having average_salary > 60000 order by average_salary desc;
select e.gender, count(dm.emp_no) as gender_count from employees e join dept_manager dm on e.emp_no = dm.emp_no
group by gender;

#Union vs Union All
drop table if exists employees_dup;
create table employees_dup (
	emp_no int(11),
    birth_date date,
    first_name varchar(14),
    last_name varchar(16),
    gender enum("M", "F"),
    hire_date date);
insert into employees_dup select e.* from employees e limit 20;
select * from employees_dup;

insert into employees_dup values ("10001", "1953-09-02", "Georgi", "Facello", "M", "1986-06-26");
select * from employees_dup order by emp_no;

select e.emp_no, e.first_name, e.last_name, NULL as dept_no, null as from_date
from employees_dup e where e.emp_no = "10001" Union all select null as emp_no, 
null as first_name, null as last_name, m.dept_no, m.from_date from dept_manager m;
select e.emp_no from employees_dup e Union all select  m.emp_no from dept_manager m;
select * from employees_dup;
select * from dept_manager;
select e.emp_no, e.first_name, e.last_name, NULL as dept_no, null as from_date
from employees_dup e where e.emp_no = "10001" Union select null as emp_no, 
null as first_name, null as last_name, m.dept_no, m.from_date from dept_manager m;

SELECT * FROM (SELECT e.emp_no, e.first_name, e.last_name, NULL AS dept_no, NULL AS from_date
FROM employees e WHERE last_name = 'Denis' UNION SELECT NULL AS emp_no, NULL AS first_name, NULL AS last_name,
dm.dept_no, dm.from_date FROM dept_manager dm) as a ORDER BY -a.emp_no DESC;





