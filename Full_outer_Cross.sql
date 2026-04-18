--FULL OUTER JOIN — E-Commerce
--Q1. Show all customers and all orders using FULL OUTER JOIN. NULLs should appear on both sides where unmatched.

SELECT c.*,
	   o.*
FROM customers AS c 
FULL OUTER JOIN orders AS o 
ON c.customer_id = o.customer_id;

--Q2. Find all unmatched records — customers with no orders AND orders with no customer — in a single query.
SELECT c.*,
	   o.*
FROM customers AS c 
FULL OUTER JOIN orders AS o 
ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL OR 
	   order_id IS NULL;


--Q3. Show all products and all orders using FULL OUTER JOIN. Include products never ordered and orders with no product match.

SELECT p.*,
	   o.*
FROM products AS p 
FULL OUTER JOIN orders AS o 
ON p.product_id =  o.product_id;



--Q4. Using FULL OUTER JOIN, show total revenue per customer. Customers with no orders show 0, orphan orders show NULL for customer name.

SELECT c.customer_name,
	   COALESCE(SUM(p.price*o.quantity),0) AS total_revenue
FROM customers AS c 
FULL OUTER JOIN orders AS o
ON c.customer_id = o.customer_id
FULL OUTER JOIN products AS p 
ON o.product_id = p.product_id 
GROUP BY c.customer_name;



--FULL OUTER JOIN — Healthcare
--Q14. Show all doctors and all appointments using FULL OUTER JOIN. Display doctor name, specialization, patient name, and fee.
SELECT d.doctor_name,
	   d.specialization,
	   a.patient_name,
	   a.fee
FROM doctors AS d 
FULL OUTER JOIN appointments AS a 
ON d.doctor_id = a.doctor_id;

--Q15. Find doctors with no appointments AND appointments with no matching doctor — in one query. Display doctor name and appointment ID.

SELECT d.doctor_name,
       a.appointment_id
FROM doctors AS d
FULL OUTER JOIN appointments AS a 
ON d.doctor_id = a.doctor_id 
WHERE d.doctor_id IS NULL OR a.appointment_id IS NULL;

--Q16. Show total fees per doctor using FULL OUTER JOIN. Doctors with no appointments show 0.

SELECT d.doctor_name,
	  COALESCE(SUM(a.fee),0) AS total_fees 
FROM doctors AS d 
FULL OUTER JOIN appointments AS a 
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name
ORDER BY total_fees DESC;





--FULL OUTER JOIN — Banking
--Q20. Show all account holders and all transactions using FULL OUTER JOIN. Display holder name, transaction type, amount, and date.

SELECT a.holder_name,
	   t.txn_type,
	   t.amount,
	   t.txn_date
FROM account_holders AS a 
FULL OUTER JOIN transactions AS t 
ON a.holder_id = t.holder_id;

--Q21. Find unmatched records — holders with no transactions AND transactions with no matching holder — in one query.

SELECT a.holder_name,
	   t.txn_type,
	   t.amount,
	   t.txn_date
FROM account_holders AS a 
FULL OUTER JOIN transactions AS t 
ON a.holder_id = t.holder_id
WHERE a.holder_id IS NULL OR t.holder_id IS NULL;

--Q25. Using FULL OUTER JOIN across customers and orders — find the month with the highest number of unmatched records 
--(orphan orders + customers with no orders combined). Display month and unmatched count.

SELECT EXTRACT(MONTH FROM o.order_date) AS Month,
		COUNT(O.*) AS unmatched_count
FROM  customers AS c
FULL OUTER JOIN  orders AS o
ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL OR o.order_id IS NULL
GROUP BY Month
ORDER BY unmatched_count DESC
LIMIT 1;




--CROSS JOIN — E-Commerce
--Q5. Generate every possible combination of customers and products. Show customer name and product name. How many rows do you get?
SELECT c.customer_name,
	   p.product_name
FROM customers AS c 
CROSS JOIN products AS p;


--Q6. From the CROSS JOIN of customers and products, show only combinations where the product price is above ₹10,000.


SELECT c.customer_name,
	   p.product_name
FROM customers AS c 
CROSS JOIN products AS p
WHERE p.price > 10000;


--Q7. Count how many product combinations each customer theoretically has. Show customer name and combination count.

SELECT c.customer_name,
       COUNT(p.*) AS combination_count
FROM customers AS c 
CROSS JOIN products AS p 
GROUP BY c.customer_name;


--CROSS JOIN — Education
--Q17. Generate every possible student-course combination using CROSS JOIN. Show student name and course name. How many rows total?

SELECT s.student_name,
	   c.course_name
	   --count(c.*) AS total
FROM students AS s 
CROSS JOIN courses AS c;



--Q18. From that CROSS JOIN, show only combinations where the student is NOT already enrolled in that course. 
--(Hint: NOT IN or LEFT JOIN + IS NULL)


SELECT s.student_name,
	   c.course_name
FROM students AS s 
CROSS JOIN courses AS c 
LEFT JOIN enrollments AS e 
ON s.student_id = e.student_id
AND c.course_id =  e.course_id 
WHERE e.enrollment_id IS NULL;


