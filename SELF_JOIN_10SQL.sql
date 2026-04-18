--Q1. Show each employee and their manager's name. Employees with no manager show NULL in the manager column.
SELECT e.employee_name,
	   m.employee_name AS manager_name
FROM employees AS e 
LEFT JOIN employees AS m 
ON e.manager_id = m.employee_id;




--Q2. Show only employees who HAVE a manager. Display employee name, department, and manager name. (No NULLs in manager column)

SELECT e.employee_name,
	   e.department,
	   m.employee_name AS manager
FROM employees AS e 
INNER JOIN employees AS m 
ON e.manager_id = m.employee_id;



--Q3. Find all employees managed directly by 'Rajesh'. Show their names, department, and salary.


SELECT e.employee_name,
	   e.department,
	   e.salary
FROM employees AS e 
LEFT JOIN employees AS m 
ON e.manager_id = m.employee_id
WHERE m.employee_name = 'Rajesh';


--Q4. Show each employee's salary vs their manager's salary. Display employee name, employee salary, manager name, and manager salary.

SELECT e.employee_name,
	   e.salary AS employee_salary,
	   m.employee_name AS Manager_name,
	   m.salary AS Manager_salary
FROM employees AS e 
LEFT JOIN employees AS m 
ON e.manager_id = m.employee_id



SELECT * FROM EMPLOYEES;
--Q5. Find employees who earn MORE than their manager. Show employee name, their salary, and their manager's salary.

SELECT e.employee_name,
	   e.salary AS employee_salary,
	   m.salary AS Manager_salary
FROM employees AS e 
 JOIN employees AS m 
ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;


--Q6. Find employees who earn LESS than their manager. Show employee name, their salary, and manager's salary.

SELECT e.employee_name,
	   e.salary AS employee_salary,
	   m.salary AS Manager_salary
FROM employees AS e 
 JOIN employees AS m 
ON e.manager_id = m.employee_id
WHERE e.salary < m.salary;

--Q7. Count how many direct reports each manager has. Show manager name and report count, sorted highest first.

SELECT m.employee_name,
	   count(e.employee_name) AS report_count
FROM employees AS m 
LEFT JOIN employees AS e 
ON e.manager_id = m.employee_id
GROUP BY m.employee_name
ORDER BY report_count DESC;

--Q8. Show the average salary of direct reports for each manager. Display manager name and average report salary.

SELECT m.employee_name,
	   AVG(e.salary) AS Average_salary
FROM employees AS m 
LEFT JOIN employees AS e 
ON e.manager_id = m.employee_id
GROUP BY m.employee_name
ORDER BY Average_salary DESC;


--Q9. Find managers whose entire team (all direct reports) earns below ₹85,000. Show manager name and department.

SELECT m.employee_name,
	   e.department
FROM employees AS e 
JOIN employees AS m
ON e.manager_id = m.manager_id
GROUP BY m.employee_name,e.department
HAVING SUM(e.salary) < 850000;


