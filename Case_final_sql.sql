--Categorize each order as 'Bulk' if quantity > 1, else 'Single'. Show customer name, product name, quantity, and category label.

SELECT c.customer_name,
	   p.product_name,
	   o.quantity,
	   p.category,
	   CASE 
	   		WHEN o.quantity > 1 THEN 'Bulk'
			ELSE 'Single'
			END AS order_quantity
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
JOIN products AS p 
ON o.product_id = p.product_id;


--Show total revenue split into two columns — electronics_revenue and furniture_revenue — per customer.

SELECT c.customer_name,
	   SUM(	
	   CASE WHEN p.category='Electronics'
	   THEN p.price*o.quantity
	   ELSE 0
	   END
	   ) AS electronics_revenue,
	   SUM(
	   CASE WHEN p.category='Furniture'
	   THEN p.price*o.quantity
	   ELSE 0
	   END
	   ) AS furniture_revenue
FROM customers AS c 
JOIN orders AS o 
ON c.customer_id = o.customer_id
JOIN products AS p 
ON o.product_id = p.product_id
GROUP BY c.customer_name;


--Add a price_tier label to products: 'Premium' if price ≥ 50000, 'Mid Range' if ≥ 5000, else 'Budget'.

SELECT product_name,
	   CASE 
	   		WHEN price >= 50000 THEN 'Premium'
			WHEN price >= 5000 AND price < 50000 THEN 'Mid range'
			ELSE 'Budget'
			END AS price_tier
FROM products ;

--Show each customer with count of Bulk orders and Single orders as separate columns.


SELECT c.customer_name,
	   SUM(
	    CASE
		WHEN o.quantity > 1 THEN 1 
		ELSE 0
		END
	   ) AS Bluk_order,
	   SUM(
	    CASE
		WHEN o.quantity = 1 THEN 1
		ELSE 0
		END
	   ) AS single_order
FROM customers AS c 
JOIN orders AS o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_name;



--Q11. Categorize appointments by fee: 'High' if fee ≥ 1800, 'Medium' if ≥ 1400, else 'Low'.
SELECT appointment_id,
   	   CASE 
		  	WHEN fee >= 1800 THEN 'High'
			WHEN fee >=1400 AND fee <1800 THEN 'Medium'
			ELSE 'Low'
			END AS category
FROM appointments ;

--Show total fees split into columns per specialization — cardiology_fees, neurology_fees, orthopedics_fees

SELECT d.doctor_name,
	 SUM(
	 	CASE WHEN specialization ='Cardiology' THEN a.fee 
		 ELSE 0 
		 END) AS cardiology_fees,
		 SUM(
	 	CASE WHEN specialization ='Neurology' THEN a.fee 
		 ELSE 0 
		 END) AS neurology_fees,
		 SUM(
	 	CASE WHEN specialization ='Orthopedics' THEN a.fee
		 ELSE 0 
		 END) AS orthopedics_fees
FROM doctors AS d
JOIN appointments AS a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name;



		 
--Show each doctor with count of High, Medium, Low fee appointments as separate columns.

SELECT d.doctor_name,
	   COUNT(
			CASE 
				WHEN a.fee >= 1800 
				THEN 1
				END
	   ) AS High,
	   COUNT(
			CASE 
			    WHEN a.fee >= 1400 and a.fee < 1800
				THEN 1
				END
	   ) AS Medium,
	   COUNT(
			CASE 
				WHEN a.fee < 1400
				THEN 1
				END 
	   ) AS Low
FROM doctors AS d 
JOIN appointments AS a 
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name;



--Label each doctor as 'High Demand' if they have 3 or more appointments, else 'Low Demand'.

SELECT d.doctor_name,
 		COUNT(appointment_id) AS appointment_count,
		CASE 
			WHEN COUNT(appointment_id) >= 3 THEN 'High Demand'
			ELSE 'Low Demand'
			END AS demand
FROM doctors AS d 
JOIN appointments AS a 
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name;

--Q15. Show each account holder's total credited and total debited as separate columns. (The pivot pattern — must get this right)

SELECT a.holder_name,
	   SUM(
			CASE WHEN t.txn_type ='Credit' THEN t.amount
			ELSE 0 
			END
	   ) AS Credited,
	   SUM(
			CASE WHEN t.txn_type ='Debit' THEN t.amount
			ELSE 0
			END
	   ) AS Debited
FROM account_holders AS a 
JOIN transactions AS t 
ON a.holder_id = t.holder_id
GROUP BY a.holder_id;
	 


--Q16. Categorize each transaction: 'Large' if amount ≥ 40000, 'Medium' if ≥ 15000, else 'Small'.

SELECT amount,
	CASE 
		WHEN amount >= 40000 THEN 'Large'
		WHEN amount >= 15000 AND amount < 40000 THEN 'Medium'
		ELSE 'Small'
	END AS category
FROM transactions;


--Show count of Large, Medium, Small transactions per account holder as separate columns.

SELECT a.holder_name,
		COUNT (
			CASE WHEN t.amount >= 40000 THEN 1 
			END 
		) AS large,
		COUNT(
			CASE WHEN t.amount >=15000 AND t.amount < 40000 THEN 1 
			END 
		) AS Medium,
		COUNT(
			CASE WHEN t.amount < 15000 THEN 1
			END
		) AS Small
FROM account_holders AS a 
JOIN transactions AS t
ON a.holder_id = t.holder_id
GROUP BY a.holder_name;


--Label each enrollment: 'Distinction' if score ≥ 90, 'Merit' if ≥ 75, 'Pass' if ≥ 50, else 'Fail'.


SELECT 
		CASE WHEN score >= 90 THEN 'Distinction'
		WHEN score >=75 AND score < 90 THEN 'Merit'
		WHEN score >= 50 AND score < 75 THEN 'pass'
		ELSE 'fail'
		END AS Label
FROM enrollments;


--Q19. Show total Distinction, Merit, and Pass count per course as separate columns.

SELECT c.course_name,
	  COUNT(CASE WHEN e.score >= 90 THEN 1 END ) AS Distinction,
		COUNT (CASE WHEN e.score >=75 AND e.score < 90 THEN 1 END ) AS Merit,
		COUNT (CASE WHEN e.score >= 50 AND e.score < 75 THEN 1 END ) AS pass,
		COUNT (CASE WHEN e.score <50 THEN 1 END ) AS fail
FROM courses AS c 
JOIN enrollments AS e
ON c.course_id = e.course_id
GROUP BY c.course_name;



--Show each student's highest score and label it: 'Excellent' if ≥ 90, 'Good' if ≥ 75, else 'Needs Work'


SELECT s.student_name,
	MAX(e.score) AS highest_score,
	CASE 
		WHEN MAX(e.score) >=90 THEN 'Excellent'
		WHEN MAX(e.score) >=75 AND MAX(e.score) < 90 THEN 'Good'
		ELSE 'Needs Work'
		END AS socre_label
FROM students AS s 
JOIN enrollments AS e 
ON s.student_id = e.student_id
GROUP BY s.student_name;

