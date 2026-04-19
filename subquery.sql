--Q1. Find all employees who earn above the company average salary.
SELECT
	EMPLOYEE_NAME,
	SALARY
FROM
	EMPLOYEES
WHERE
	SALARY > (
		SELECT
			AVG(SALARY)
		FROM
			EMPLOYEES
	)
	--Q2. Find employees who earn above their own department's average. (Correlated)
SELECT
	EMPLOYEE_NAME,
	DEPARTMENT,
	SALARY
FROM
	EMPLOYEES AS E
WHERE
	SALARY > (
		SELECT
			AVG(SALARY) AS AVERAGE_SALARY
		FROM
			EMPLOYEES
		WHERE
			DEPARTMENT = E.DEPARTMENT
	);

--Q3. Show each employee, their salary, and the highest salary in their department as a separate column. (SELECT subquery)
SELECT
	EMPLOYEE_NAME,
	SALARY,
	DEPARTMENT,
	(
		SELECT
			MAX(SALARY)
		FROM
			EMPLOYEES
		WHERE
			DEPARTMENT = E.DEPARTMENT
	) AS DEPT_MAX_SALARY
FROM
	EMPLOYEES AS E;

--Q4. Find the department with the highest total payroll.
SELECT
	DEPARTMENT,
	SUM(SALARY) AS HIGHEST_SALARY
FROM
	EMPLOYEES
GROUP BY
	DEPARTMENT
HAVING
	SUM(SALARY) = (
		SELECT
			MAX(TOTAL_SALARY)
		FROM
			(
				SELECT
					SUM(SALARY) AS TOTAL_SALARY
				FROM
					EMPLOYEES
				GROUP BY
					DEPARTMENT
			) T
	);

--Q5. Show employees who earn the maximum salary in their department. (Correlated)
SELECT
	EMPLOYEE_NAME,
	DEPARTMENT,
	SALARY
FROM
	EMPLOYEES AS E
WHERE
	SALARY = (
		SELECT
			MAX(SALARY)
		FROM
			EMPLOYEES
		WHERE
			DEPARTMENT = E.DEPARTMENT
	);

--Q6. Find employees whose salary is above the average salary of the Finance department specifically.


SELECT
	EMPLOYEE_NAME,
	SALARY,
	DEPARTMENT
FROM
	EMPLOYEES
WHERE
	SALARY > (
		SELECT
			AVG(SALARY) AS AVERAGE_SALARY
		FROM
			EMPLOYEES
		WHERE
			DEPARTMENT = 'Finance'
	);


--Q7. Find customers who have spent more than the average spending across all customers.


SELECT c.customer_name,
		AVG(p.price*o.quantity) as Average_
FROM customers AS c 



SELECT AVG(p.price*o.quantity) AS avr_spent
FROM products AS p 
JOIN orders AS O 
ON p.product_id = o.product_id



