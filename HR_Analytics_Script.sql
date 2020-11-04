# List of employees with the following information: First name, last name, gender, age, number of years spent in the company, department, the year they joined the department, and their current job title.
USE employees;
SELECT E.first_name AS "First Name", E.last_name AS "Last Name", E.gender AS "Gender", 
		YEAR(curdate())-YEAR(E.birth_date) AS "Age",
		YEAR(curdate())-YEAR(E.hire_date) AS "Experience", 
        D.dept_name AS "Department",
        YEAR(T.from_date) AS "Year Joined",
        T.title AS "Current Title"
FROM (titles T JOIN employees E USING(emp_no)) 
	JOIN (departments D JOIN dept_emp DE USING(dept_no)) 
	ON E.emp_no = DE.emp_no
    WHERE T.to_date='9999-01-01'
    AND DE.to_date='9999-01-01';
		
# The number of employees per department.
SELECT D.dept_name AS "Department Name", 
	COUNT(DISTINCT DE.emp_no) AS "No. of Employees" 
	FROM departments D INNER JOIN dept_emp DE ON D.dept_no=DE.dept_no 
    WHERE DE.to_date='9999-01-01'
    GROUP BY D.dept_no;
    
# List of the average salary of employees in each job position (title).
SELECT T.title, ROUND(AVG(S.salary),2) AS "Average Salary" FROM 
	titles T JOIN salaries S USING(emp_no)
    GROUP BY T.title
    ORDER BY AVG(S.salary) DESC;
    
# List of the average age of employees in (i) the company, (ii) each department, (iii) each job position.
# (i) the company
SELECT AVG(YEAR(curdate())-YEAR(E.birth_date)) AS "Average age"
	FROM Employees E;
    
# (ii) each department
SELECT D.dept_name AS "Department",
	ROUND(AVG(YEAR(curdate())-YEAR(E.birth_date)),2) AS "Average age"
	FROM (employees E JOIN dept_emp DE USING(emp_no)) 
    JOIN departments D ON D.dept_no=DE.dept_no
    GROUP BY D.dept_name
    ORDER BY AVG(YEAR(curdate())-YEAR(E.birth_date)) DESC;
    
# (iii) each job position
SELECT T.title AS "Job Title",
	ROUND(AVG(YEAR(curdate())-YEAR(E.birth_date)),2) AS "Average age"
	FROM (employees E JOIN titles T USING(emp_no)) 
    GROUP BY T.title
    ORDER BY AVG(YEAR(curdate())-YEAR(E.birth_date)) DESC;
	
# List of employees with (i) the lowest salary, (ii) the highest salary (iii) above average salary.
# (i) the lowest salary
SELECT MIN(S.salary) FROM salaries S;
SELECT E.emp_no, E.first_name AS "First Name", E.last_name AS "Last Name"
	FROM employees E JOIN salaries S USING(emp_no)
	WHERE S.salary=38623;
    
# (ii) the highest salary
SELECT MAX(S.salary) FROM salaries S;
SELECT E.emp_no, E.first_name AS "First Name", E.last_name AS "Last Name", S.salary
	FROM employees E JOIN salaries S USING(emp_no)
	WHERE to_date="9999-01-01" AND S.salary IN (SELECT MAX(S.salary) FROM salaries S);


# (iii) above average salary
SELECT AVG(S.salary) FROM salaries S;
SELECT DISTINCT (E.emp_no), E.first_name AS "First Name", E.last_name AS "Last Name"
	FROM employees E JOIN salaries S ON E.emp_no=S.emp_no
	WHERE S.salary>=63810.7448;
        
# List of employees who joined the company in December.
SELECT E.emp_no, E.first_name AS "First Name", E.last_name AS "Last Name"
	FROM employees E
    WHERE MONTH(E.hire_date)=12;

# List of the most experienced employees (by the number of years) in each department and the company as a whole.
# (i) Each department
SELECT MAX(YEAR('2002-08-01')-YEAR(E.hire_date)) AS "Experience", D.dept_name AS "Department Name"
	FROM (employees E JOIN dept_emp DE USING(emp_no))
    JOIN departments D ON DE.dept_no=D.dept_no
    GROUP BY D.dept_name;
    
SELECT E.first_name AS "First Name", E.last_name AS "Last Name", 
	T.title AS "Position", D.dept_name AS "Department Name", 
    YEAR('2002-08-01')-YEAR(E.birth_date) AS "Age",
    YEAR('2002-08-01')-YEAR(E.hire_date) AS "Experience"
	FROM ((employees E JOIN dept_emp DE USING(emp_no)) 
    JOIN titles T USING(emp_no)) 
    JOIN departments D ON D.dept_no=DE.dept_no
    WHERE (YEAR('2002-08-01')-YEAR(E.hire_date))=17 AND DE.to_date='9999-01-01' AND T.to_date='9999-01-01' AND D.dept_name='Development';


# (ii) the company

SELECT E.first_name AS "First Name", E.last_name AS "Last Name", T.title AS "Position", 
	D.dept_name AS "Department Name", YEAR('2002-08-01')-YEAR(E.birth_date) AS "Age",
	YEAR('2002-08-01')-YEAR(E.hire_date) AS "Experience"
	FROM ((employees E JOIN dept_emp DE USING(emp_no)) 
    JOIN titles T USING(emp_no)) 
    JOIN departments D ON D.dept_no=DE.dept_no
    WHERE (YEAR('2002-08-01')-YEAR(E.hire_date))=17 AND T.to_date='9999-01-01' AND DE.to_date='9999-01-01';
    

# List of the most recently hired employees (that is, the year the most recent employee was recruited).
SELECT MAX(YEAR(E.hire_date)) FROM employees E;
SELECT E.first_name AS "First Name", E.last_name AS "Last Name", T.title AS "Position", 
    YEAR('2002-08-01')-YEAR(E.birth_date) AS "Age", E.gender AS "Gender",
    TIMESTAMPDIFF(YEAR, E.hire_date, '2002-08-01') AS "Experience"
	FROM employees E JOIN titles T USING(emp_no)
    WHERE YEAR(E.hire_date) IN (SELECT MAX(YEAR(E.hire_date)) FROM employees E);


SELECT E.first_name AS "First Name", E.last_name AS "Last Name", T.title AS "Position", 
    YEAR('2002-08-01')-YEAR(E.birth_date) AS "Age", E.gender AS "Gender",
	T.to_date AS "Relieved date",
    TIMESTAMPDIFF(MONTH, E.hire_date, T.to_date) AS "Months Spent at company"
	FROM employees E JOIN titles T USING(emp_no)
    WHERE YEAR(E.hire_date)=1999 AND T.to_date!='9999-01-01';
    
# How many employees were hired every year and how manuy of them stay in the company now?
SELECT YEAR(E.hire_date) AS "Year" ,COUNT(DISTINCT E.emp_no) AS "No. of employees hired"
	FROM ((employees E JOIN dept_emp DE USING(emp_no)) 
    JOIN titles T USING(emp_no)) 
    JOIN departments D ON D.dept_no=DE.dept_no
    GROUP BY YEAR(E.hire_date);
    
SELECT YEAR(E.hire_date) AS "Year", COUNT(DISTINCT E.emp_no) AS "No. of employees hired(retained now)"
	FROM ((employees E JOIN dept_emp DE USING(emp_no)) 
    JOIN titles T USING(emp_no)) 
    JOIN departments D ON D.dept_no=DE.dept_no
    WHERE T.to_date='9999-01-01'
    GROUP BY YEAR(E.hire_date);
    
    
	SELECT e.last_name as 'Last', e.first_name as 'First', CONCAT('€ ',FORMAT(MAX(s.salary),0)) as 'Salary', d.dept_name as 'Dept', 
    t.title as 'Title', s.from_date as 'From', s.to_date as 'To', TIMESTAMPDIFF(YEAR,e.hire_date,CURDATE()) as 'Years in Company'
    FROM employees as e
	JOIN dept_emp as w ON w.emp_no = e.emp_no
	JOIN departments as d ON d.dept_no = w.dept_no
    JOIN titles as t ON t.emp_no = e.emp_no
    JOIN salaries as s ON s.emp_no = e.emp_no
    WHERE s.to_date > CURDATE()
    group by e.emp_no
    order by s.salary desc;


SELECT AVG(S.salary)
	FROM ((employees E JOIN dept_emp DE USING(emp_no)) 
    JOIN salaries S USING(emp_no)) 
    JOIN departments D ON D.dept_no=DE.dept_no
    WHERE S.to_date='9999-01-01' AND DE.to_date='9999-01-01';
    

SELECT E.emp_no AS "Employee No", E.first_name AS "First Name", E.last_name AS "Last Name", S.salary AS "Salary"
	FROM ((employees E JOIN dept_emp DE USING(emp_no)) 
    JOIN salaries S USING(emp_no)) 
    JOIN departments D ON D.dept_no=DE.dept_no
    WHERE DE.to_date='9999-01-01' AND S.to_date='9999-01-01' AND S.salary > 72012.2359;
    
    