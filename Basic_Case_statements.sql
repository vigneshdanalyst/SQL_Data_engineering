--Q1. Add a level column to all employees: 'Senior' if salary ≥ 100000, 'Mid' if ≥ 80000, else 'Junior'.

SELECT employee_name,
	   salary,
	   CASE 
	   	   WHEN salary >= 100000 THEN 'Senior'
		   WHEN salary >= 80000 THEN 'Mid'
		   ELSE 'Junior'
		END AS level
FROM employees;

--Q2. Show total payroll per level (Senior/Mid/Junior). Display level and total salary.

SELECT CASE 
	   	   WHEN salary >= 100000 THEN 'Senior'
		   WHEN salary >= 80000 THEN 'Mid'
		   ELSE 'Junior'
		END AS level,
		SUM(salary) AS total_salary
FROM employees 
GROUP BY level


--Q3. Show each department with count of Senior, Mid, and Junior employees as separate columns.

SELECT department,
	   COUNT(CASE WHEN salary >= 100000 THEN 1 END ) AS senior,
	   COUNT (CASE WHEN salary >= 80000 AND salary < 100000 THEN 1 END)  AS Mid,
	   COUNT (CASE WHEN salary < 80000 THEN 1  END) AS Junior
FROM employees
GROUP BY department;


--Q4. Show each employee with a 'High Earner' label if they earn above their department's average, else 'Average Earner'. (SELF JOIN + CASE WHEN)

SELECT e.employee_name,
	   e.department,
	   e.salary,
	   AVG(d.salary) AS Department_Average_salary,
	   CASE 
	   		WHEN e.salary >= AVG(d.salary) THEN 'High Earner'
			ELSE 'Average Earner'
			END AS earning_level
FROM employees e
JOIN employees d 
ON e.department = d.department
GROUP BY e.department,
		  e.employee_name,
		  e.salary
		  
ORDER BY e.department;
	   


--Q5. Show total salary per department split into two columns — manager_payroll (employees with no manager) and team_payroll (employees with a manager).

SELECT department,
	   SUM(
			CASE 
				WHEN manager_id IS NULL
				THEN salary
				ELSE 0 
				END 
	   ) AS manager_payroll,
	   SUM(
			CASE 
				WHEN manager_id IS NOT NULL
				THEN salary
				ELSE 0 
				END 
	   ) AS team_payroll
FROM employees 
GROUP BY department;



--Q6. Add a retention_risk column: 'High Risk' if salary < 75000, 'Medium Risk' if between 75000–89999, 'Low Risk' if ≥ 90000.



SELECT employee_name,
	 CASE 
	 	WHEN salary < 75000 THEN 'High Risk'
		WHEN salary BETWEEN 75000 AND 89999 THEN 'Medium Risk'
		WHEN salary >= 90000 THEN 'Low Risk'
		END AS risk_retention
FROM employees;




