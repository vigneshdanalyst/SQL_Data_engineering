--E-Commerce---

--1)Show all customers and their orders. If a customer has no orders, still show them with NULL in the order columns.

SELECT c.customer_name,
	   o.order_id
FROM customers as c 
LEFT JOIN orders as o 
ON c.customer_id = o.customer_id;

--2)Find customers who have never placed an order. Show only their names and cities.
SELECT c.customer_name,
	   c.city
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


--3) Show all products and how many times each has been ordered. Include products with zero orders.


SELECT p.product_name,
	   COUNT(o.order_id) AS No_of_orders
FROM orders AS o
RIGHT JOIN products AS p 
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY No_of_orders DESC;


--4) Show all customers with their total revenue spent. Customers with no orders should show 0, not NULL. (Hint: COALESCE)


SELECT c.customer_name,
       COALESCE(SUM(p.price * o.quantity),0) AS total_revenue
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
LEFT JOIN products AS p
ON o.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_revenue DESC;


--5)Show all orders including the one with no matching customer. Display order_id, customer_name (NULL if missing), and order_date.

SELECT o.order_id,
	   c.customer_name,
	   o.order_date
FROM customers AS c
RIGHT JOIN  orders AS o
ON o.customer_id = c.customer_id;


--6) Find products that have never been ordered. Show product name and category.

SELECT p.product_name,
	   p.category
FROM products AS p
LEFT JOIN orders AS o 
ON p.product_id = o.product_id
WHERE o.order_id IS NULL;


--7) Show all customers and their most recent order date. Customers with no orders show NULL.

SELECT c.customer_name,
	   MAX(o.order_date) AS Most_recent_order
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id 
GROUP BY c.customer_name
ORDER BY Most_recent_order DESC;


--8) Show all customers and count of orders placed. Include customers with zero orders.

SELECT c.customer_name,
 	   COALESCE(COUNT(O.*),0) AS No_of_orders
FROM customers AS c
LEFT JOIN orders AS o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id 
ORDER BY no_of_orders DESC;


--9) Show all products with total revenue generated. Sort by revenue descending, include unordered products as 0.

SELECT p.product_name,
	   COALESCE(SUM(p.price*o.quantity),0) AS total_revenue
FROM products AS p
LEFT JOIN orders AS o
ON p.product_id = o.product_id 
GROUP BY p.product_name
ORDER BY total_revenue DESC;


--10) Find customers who ordered only Electronics. Show customer name and count of Electronics orders.

SELECT c.customer_name,
	   COALESCE(COUNT(O.order_id),0) AS No_of_orders
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
LEFT JOIN products AS P
ON o.product_id = p.product_id 
WHERE p.category = 'Electronics'
GROUP BY c.customer_name
ORDER BY No_of_orders DESC;



--HOSPITAL--

--11. Show all doctors and their appointments. Doctors with no appointments should still appear.
SELECT d.doctor_name,
	   a.appointment_date
FROM doctors AS d
LEFT JOIN appointments AS a
ON d.doctor_id = a.doctor_id ;


--12. Find doctors who have never had an appointment. Show doctor name and specialization.

SELECT d.doctor_name,
	   d.specialization
FROM doctors AS d
LEFT JOIN appointments AS a 
ON d.doctor_id = a.doctor_id
WHERE a.doctor_id IS NULL;

--13. Show all doctors with total fees collected. Doctors with no appointments show 0.

SELECT d.doctor_name,
	 COALESCE(SUM(a.fee),0) AS total_fees
FROM doctors AS d 
LEFT JOIN appointments AS a 
ON d.doctor_id = a.doctor_id 
GROUP BY d.doctor_name
ORDER BY total_fees DESC;

--14. Show all appointments including any with no matching doctor record. Display appointment_id, patient_name, doctor_name (NULL if missing).

SELECT a.appointment_id,
	   a.patient_name,
	   d.doctor_name
FROM appointments AS a 
LEFT JOIN doctors AS d
ON a.doctor_id =  d.doctor_id;


--15. Count appointments per hospital. Include hospitals with zero appointments.


SELECT d.hospital,
	   COUNT(a.appointment_id) AS total_counts 
FROM  doctors  AS d
LEFT JOIN appointments AS a 
ON d.doctor_id = a.doctor_id
GROUP BY d.hospital
ORDER BY total_counts DESC;



---Education (5 questions)
--16. Show all students and the courses they're enrolled in. Students with no enrollments still appear.

SELECT s.student_name,
	   c.course_name
FROM students AS s 
LEFT JOIN enrollments AS e 
ON s.student_id = e.student_id
LEFT JOIN courses AS c 
ON e.course_id = c.course_id;


--17. Find students who are not enrolled in any course.

SELECT s.student_name
FROM students AS s 
LEFT JOIN enrollments AS e 
ON s.student_id = e.student_id
WHERE e.student_id IS NULL;


--18. Show all courses with the number of students enrolled. Include courses with zero enrollments.

SELECT c.course_name,
		COUNT(s.student_name) AS no_students_enrolled
FROM courses AS c 
LEFT JOIN enrollments AS e 
ON c.course_id = e.course_id 
LEFT JOIN students AS s 
ON e.student_id = s.student_id
GROUP BY c.course_name;


--19. Show all students with their average score. Students with no enrollments show NULL.

SELECT s.student_name,
       AVG(e.score) AS Average_score
FROM students AS s 
LEFT JOIN enrollments AS e 
ON s.student_id = e.student_id 
GROUP BY s.student_id;


--20. Show all courses and total credits assigned to enrolled students. Courses with no students show 0.

SELECT c.course_name,
       SUM(c.credits) AS total_credits 
FROM courses AS c 
LEFT JOIN enrollments AS e 
ON c.course_id = e.course_id 
LEFT JOIN students AS s 
ON e.student_id = s.student_id 
GROUP BY c.course_name
ORDER BY total_credits DESC;




---Banking (5 questions)
--21. Show all account holders and their transactions. Holders with no transactions still appear.

SELECT a.holder_name,
	   t.*
FROM account_holders AS a
LEFT JOIN transactions AS t
ON a.holder_id = t.holder_id;

--22. Find account holders who have no transactions at all.

SELECT a.holder_name
FROM account_holders AS a 
LEFT JOIN transactions AS t 
ON a.holder_id = t.holder_id
WHERE t.holder_id IS NULL;
	   

--23. Show all transactions including any with no matching account holder. Display txn_id, amount, holder_name (NULL if missing).

SELECT t.txn_id,
	   t.amount,
	   a.holder_name
FROM  transactions AS t
LEFT JOIN  account_holders AS a
ON a.holder_id = t.holder_id;


--24. Show all account holders with total amount transacted. Holders with no transactions show 0.

SELECT a.holder_name,
	  COALESCE(SUM(t.amount),0) AS total_amount
FROM account_holders AS a 
LEFT JOIN transactions AS t
ON a.holder_id =  t.holder_id 
GROUP BY a.holder_name
ORDER BY total_amount DESC;

--25. Count transactions per city. Include cities with zero transactions.


SELECT a.city,
	   COUNT(t.txn_id) AS total_count
FROM account_holders AS a 
LEFT JOIN transactions AS t
ON a.holder_id = t.holder_id
GROUP BY a.city
ORDER BY total_count DESC;






--Mixed Domain — Harder (5 questions)
--26. Show all customers and all products — but only show order details where a customer actually ordered that product. (3 table LEFT JOIN)

SELECT c.customer_name,
	   p.product_name
FROM customers AS c 
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id 
LEFT JOIN products AS p 
ON o.product_id = p.product_id
WHERE o.order_id IS NOT NULL;


--27. Find doctors who have collected more than ₹3000 in total fees. Show doctor name, hospital, and total fees. (Use HAVING with LEFT JOIN)


SELECT d.doctor_name,
	   d.hospital,
	   COALESCE(SUM(a.fee),0) AS total_fees
FROM doctors AS d 
LEFT JOIN appointments AS a 
ON d.doctor_id = a.doctor_id 
GROUP BY d.doctor_name,
	     d.hospital
HAVING SUM(a.fee) > 3000 
ORDER BY total_fees DESC;
	  




--28. Show all students along with their highest score. If no enrollments, show NULL. Sort by highest score descending, NULLs at the bottom.

SELECT s.student_name,
	   MAX(e.score) AS Highest_score
FROM students AS s 
LEFT JOIN enrollments AS e 
ON s.student_id = e.student_id 
GROUP BY s.student_name 
ORDER BY highest_score DESC;


--29. Show each account holder's Credit total and Debit total side by side. 
--Holders with no transactions show 0 for both. (COALESCE + CASE WHEN + LEFT JOIN)

SELECT a.holder_name,
	   t.txn_type,
	   SUM(t.amount) AS total_amount
FROM account_holders AS a 
LEFT JOIN transactions AS t
ON a.holder_id = t.holder_id
GROUP BY a.holder_name,
	     t.txn_type
ORDER BY total_amount DESC;






--30. Find customers who have placed orders but never ordered a Furniture item. Show customer name and total orders placed.



SELECT c.customer_name,
	   COUNT(o.order_id) AS total_orders 
FROM customers AS c 
LEFT JOIN orders AS o 
ON c.customer_id = o.customer_id 
LEFT JOIN products AS p 
ON o.product_id = p.product_id 
WHERE p.category = 'Furniture'
GROUP BY c.customer_name;



