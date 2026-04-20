
--Q1. Find all employees who earn above the company average salary.

SELECT
	EMPLOYEE_NAME,
	DEPARTMENT,
	SALARY
FROM
	EMPLOYEES
WHERE
	SALARY > (
		SELECT
			AVG(SALARY)
		FROM
			EMPLOYEES
	);



--Q2. Find employees who earn above their own department's average. (Correlated)

SELECT
	EMPLOYEE_NAME,
	DEPARTMENT,
	SALARY
FROM
	EMPLOYEES AS E 
WHERE SALARY > (
		SELECT
			AVG(SALARY)
		FROM
			EMPLOYEES
		WHERE
			DEPARTMENT = E.DEPARTMENT
	)

	
--Q3. Show each employee, their salary, and the highest salary in their department as a separate column. (SELECT subquery)

SELECT
	EMPLOYEE_NAME,
	SALARY,
	(
		SELECT
			MAX(SALARY)
		FROM
			EMPLOYEES
		WHERE
			DEPARTMENT = E.DEPARTMENT
	) AS HIGHEST_SALARY
FROM
	EMPLOYEES AS E;



--Q4. Find the department with the highest total payroll.

SELECT
	DEPARTMENT,
	SUM(SALARY) AS HIGHT_TOTAL_PAYROLL
FROM
	EMPLOYEES
GROUP BY
	DEPARTMENT
ORDER BY
	SUM(SALARY) DESC
LIMIT
	1;


--Q5. Show employees who earn the maximum salary in their department. (Correlated)

SELECT employee_name
FROM employees AS e
WHERE salary =
(SELECT MAX(salary)
FROM employees 
WHERE department = e.department );

--Q6. Find employees whose salary is above the average salary of the Finance department specifically.

SELECT employee_name,
salary
	FROM employees
	WHERE salary > (
SELECT AVG(salary)
FROM employees 
WHERE department ='Finance')




--Q7. Find customers who have spent more than the average spending across all customers.

SELECT
	C.CUSTOMER_NAME
FROM
	CUSTOMERS AS C
	LEFT JOIN ORDERS AS O ON C.CUSTOMER_ID = O.ORDER_ID
	LEFT JOIN PRODUCTS AS P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY
	C.CUSTOMER_NAME
HAVING
	SUM(P.PRICE * O.QUANTITY) > (
		SELECT
			AVG(P.PRICE * O.QUANTITY)
		FROM
			PRODUCTS AS P
			LEFT JOIN ORDERS AS O ON P.PRODUCT_ID = O.product_ID
	);


--Q8. Show products that have been ordered more than the average number of orders per product.

SELECT
    p.product_name,
    COUNT(o.order_id) AS no_orders
FROM
    products AS p
    LEFT JOIN orders AS o ON p.product_id = o.product_id
GROUP BY
    p.product_id, p.product_name
HAVING
    COUNT(o.order_id) > (
        SELECT AVG(product_orders)
        FROM (
            SELECT COUNT(*) AS product_orders
            FROM orders
            GROUP BY product_id
        ) AS avg_table
    );


-- Q9. Find the customer who placed the most recent order.


SELECT c.customer_name,
	   o.order_date
FROM customers AS c 
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_date = (
SELECT MAX(order_date) FROM orders)
ORDER BY o.order_date
LIMIT 1;



-- Q10. Show customers who have never ordered a product in the 'Furniture' category. (NOT IN subquery)


SELECT c.customer_name
FROM customers AS c
LEFT JOIN orders AS o 
ON c.customer_id = o.order_id 
LEFT JOIN products AS p 
ON p.product_id = o.product_id
WHERE p.category != 'Furniture';


-- Q11. Find products whose price is above the average price in their own category. (Correlated)



SELECT p.product_name
FROM products AS p 
LEFT JOIN orders AS o 
ON p.product_id = o.product_id
WHERE p.price >
(SELECT
	AVG(price)
FROM products
WHERE category = p.category)


-- 🏥 Healthcare (5 questions)

-- Q12. Find doctors who have collected more fees than the average fee collection across all doctors.

SELECT d.doctor_name,
	   d.specialization
	  FROM doctors AS d
JOIN appointments AS a
ON d.doctor_id = a.doctor_id
WHERE a.fee >
(SELECT AVG(fee)
FROM appointments AS a )


-- Q13. Show patients whose appointment fee was above the average fee for that doctor's specialization. (Correlated)


SELECT d.doctor_name,
	   d.specialization
	  FROM doctors AS d
JOIN appointments AS a
ON d.doctor_id = a.doctor_id
WHERE a.fee > (SELECT AVG(fee)
FROM appointments 
WHERE specialization = d.specialization)

-- Q14. Find the specialization with the highest average fee per appointment.


SELECT d.specialization, AVG(a.fee) AS avg_fee
FROM doctors AS d
JOIN appointments AS a ON d.doctor_id = a.doctor_id
GROUP BY d.specialization 
HAVING AVG(a.fee) = (
    SELECT MAX(avg_fee) 
    FROM (
        SELECT AVG(a2.fee) AS avg_fee
        FROM doctors AS d2
        JOIN appointments AS a2 ON d2.doctor_id = a2.doctor_id
        GROUP BY d2.specialization
    ) AS specialization_averages
);

-- Q15. Show doctors who have seen more patients than the average number of patients per doctor.

SELECT 
    d.doctor_name
FROM doctors d
JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY 
    d.doctor_name,
    d.doctor_id
HAVING 
    COUNT(a.appointment_id) > (SELECT AVG(patient_count)
FROM (
SELECT doctor_id,
COUNT(appointment_id) AS patient_count
FROM appointments 
GROUP BY doctor_id
ORDER BY patient_count) AS avg_table);


-- Q16. Find appointments where the fee is above the overall average appointment fee.


SELECT appointment_id 
FROM appointments 
WHERE fee >(
SELECT AVG(fee)
FROM appointments AS a )


-- 🎓 Education (5 questions)

-- Q17. Find students whose average score is above the overall average score across all enrollments.


SELECT s.student_id,s.student_name,
	AVG(e.score)
FROM students AS s 
JOIN enrollments AS e 
ON s.student_id = e.student_id
GROUP BY s.student_id,
s.student_name
HAVING AVG(e.score) > (
SELECT AVG(score)
FROM enrollments);

-- Q18. Show courses where the average score is above the overall course average. (FROM subquery)

SELECT course_name,AVG(e.score)
FROM enrollments AS e 
JOIN courses AS c 
ON e.course_id = c.course_id
GROUP BY course_name
HAVING AVG(e.score) > (
SELECT AVG(score)
FROM enrollments );


-- Q19. Find the student with the highest single score across all enrollments.


SELECT s.student_name,
	     MAX(e.score) AS Max_score
FROM students AS s 
JOIN enrollments AS e
ON s.student_id = e.student_id
GROUP BY s.student_name
ORDER BY Max_score DESC
LIMIT 1;


-- Q20. Show students who scored above the average score in every course they're enrolled in. (Correlated)


SELECT 
    s.student_name
FROM students s
WHERE NOT EXISTS (
    
    SELECT 1
    FROM enrollments e
    
    WHERE e.student_id = s.student_id
    
    AND e.score <= (
        
        SELECT AVG(score)
        FROM enrollments
        
        WHERE course_id = e.course_id
    )
);



-- Q21. Find courses where no student scored below 70.



-- 🏦 Banking (4 questions)

-- Q22. Find account holders whose total transaction amount is above the average total per holder.

-- Q23. Show transactions where the amount is above the average transaction amount for that holder's city. (Correlated)

-- Q24. Find the account holder with the highest single transaction.

-- Q25. Show account holders who have only Credit transactions and no Debit transactions. (NOT IN subquery)




