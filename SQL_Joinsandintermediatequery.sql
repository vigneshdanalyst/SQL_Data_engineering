--TOPIC 2: JOINS (INNER, LEFT, RIGHT, FULL, CROSS, SELF, ANTI, SET OPERATORS)

USE practice;

--Q1.** Join orders with customers. Show customer first_name, last_name, order_id, order_date, order_status for all 'Delivered' orders.

SELECT 
	c.first_name,
	c.last_name,
	o.order_id,
	o.order_date,
	o.order_status
FROM ecom_orders o 
LEFT JOIN ecom_customers c 
ON o.customer_id=c.customer_id
WHERE o.order_status ='Delivered';

--Q2.** Join order_items with products. Show product_name, category, quantity sold, and unit_price for all items.

SELECT 
	p.product_name,
	p.category,
	o.quantity,
	o.unit_price
FROM ecom_order_items o
LEFT JOIN ecom_products p
ON o.product_id = p.product_id;

--Q3.** Find all customers who have NEVER placed an order. (LEFT ANTI JOIN)

SELECT 
	c.first_name,
	c.last_name,
	c.status,
	o.order_id,
	o.order_date
FROM ecom_customers c 
LEFT JOIN ecom_orders o 
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


--	Q4.** Join orders → order_items → products. Show each order with the count of distinct products in it.

SELECT 
	o.order_id,
	p.product_name,
	o.order_date,
	COUNT(DISTINCT(ot.product_id)) product_distinct
FROM ecom_orders o 
LEFT JOIN ecom_order_items ot
ON o.order_id = ot.order_id
LEFT JOIN ecom_products p
ON ot.product_id = p.product_id
GROUP BY o.order_id,p.product_name,o.order_date;

--Q5.** Find products that have been ordered at least once. (INNER JOIN products and order_items, DISTINCT product_id)

SELECT 
	DISTINCT p.product_id
FROM ecom_products p
INNER JOIN ecom_order_items ot
ON p.product_id = ot.product_id;


--**Q6.** Left join customers with orders. Show all customers with their total order count (including 0 if no orders).


SELECT 
	c.customer_id
	--COUNT(COALESCE(o.order_id,0)) as total_count
FROM ecom_customers c 
LEFT JOIN ecom_orders  o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

--*Q7.** Find all products that have NEVER been ordered. (LEFT ANTI JOIN products vs order_items)

SELECT 
p.product_id,
p.category,
o.order_id
FROM ecom_products p 
LEFT JOIN ecom_order_items o 
ON  p.product_id = o.product_id 
WHERE o.order_id IS NULL;


--Q8.** Join customers + orders + order_items. For customer_id 101 to 110, show all their orders and what products they bought.

SELECT 
	c.customer_id,
	ot.order_id,
	ot.product_id
FROM ecom_customers c 
LEFT JOIN ecom_orders o
ON c.customer_id = o.customer_id
LEFT JOIN ecom_order_items ot
ON o.order_id = ot.order_id 
WHERE c.customer_id BETWEEN 101 AND 110;

SELECT * FROM ecom_orders;
SELECT * FROM ecom_order_items;
SELECT * FROM ecom_products;


--Q9.** FULL OUTER JOIN ecom_orders and ecom_order_items on order_id. How many order records have no matching items?

SELECT 
	COUNT(*) AS orders_without_items
FROM ecom_orders o
LEFT JOIN ecom_order_items ot
ON o.order_id = ot.order_id
WHERE ot.order_item_id IS NULL;

--**Q10.** SELF JOIN on ecom_customers: Find pairs of customers from the same city who registered in the same year. (Hint: join on city AND YEAR(registration_date), customer_id <> customer_id)

SELECT
    ec.customer_id,
    --ec.customer_name,
    ec.city,
    ec1.customer_id,
	YEAR(ec.registration_date) YEAR,
	YEAR(ec1.registration_date) YEAR
    --ec1.customer_name
FROM ecom_customers ec
JOIN ecom_customers ec1
    ON ec.customer_id < ec1.customer_id
    AND ec.city = ec1.city
    AND YEAR(ec.registration_date) = YEAR(ec1.registration_date);


--Q11.** Join admissions with patients. Show patient_name, age, gender, diagnosis, and total_bill.

USE practice;

SELECT 
	p.patient_name,
	p.age,
	p.gender,
	a.diagnosis,
	a.total_bill
FROM health_admissions a
LEFT JOIN health_patients p
ON a.patient_id = p.patient_id;

--Q12.** Join admissions with doctors. Show doctor_name, specialty, and count of admissions they handled.

SELECT 
	d.doctor_name,
	d.specialty,
	count(a.admission_id) total_count_specialty
FROM health_doctors d
LEFT JOIN health_admissions a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name,
		d.specialty
ORDER BY total_count_specialty DESC;

--Q13.** Find patients who have been admitted MORE than 3 times. (JOIN + GROUP BY + HAVING)

SELECT 
	p.patient_id,
	count(a.admission_id) totalnoadmissions
FROM health_patients p
LEFT JOIN health_admissions a 
ON p.patient_id = a.patient_id
GROUP BY p.patient_id
HAVING count(a.admission_id) > 3 
ORDER BY totalnoadmissions DESC;

--Q14.** LEFT JOIN doctors with admissions. Find doctors who have NO admissions recorded.

SELECT 
	d.doctor_id
FROM health_doctors d 
LEFT JOIN health_admissions a 
ON d.doctor_id = a.doctor_id 
WHERE a.doctor_id IS NULL;

--*Q15.** Join all 3 tables (patients, admissions, doctors). Find the highest-billed admission per doctor.

SELECT 
	d.doctor_id,
	--p.patient_id,
	--a.admission_id,
	MAX(total_bill) highest_bill
FROM health_patients p 
JOIN health_admissions a 
ON p.patient_id = a.patient_id 
JOIN health_doctors d 
ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id
	--p.patient_id,
	--a.admission_id
ORDER BY highest_bill DESC;

--Q16.** For each specialty, show the total revenue (SUM of total_bill) generated by admissions handled by doctors of that specialty.


SELECT 
	d.specialty,
	SUM(a.total_bill) Total_bill_generated
FROM health_doctors d 
JOIN health_admissions a 
ON d.doctor_id = a.doctor_id 
GROUP BY d.specialty
ORDER BY Total_bill_generated;
	

--Q17.** SELF JOIN health_patients: Find pairs of patients from the same city with the same blood_group.

SELECT 
	p.patient_id,
	p1.patient_id,
	p.city,
	p.blood_group 
FROM health_patients p 
JOIN health_patients p1 
ON p.city = p1.city 
AND p.blood_group = p1.blood_group 
AND p.patient_id < p1.patient_id;


--Q18.** Find all admissions where the patient's city matches the doctor's… wait 
-- doctors don't have a city column. Instead, 
--join patients + admissions and find admissions where the patient is from 'Delhi'.


SELECT 
	p.patient_id,
	p.city,
	a.admission_id
FROM health_admissions a 
JOIN health_patients p 
ON a.patient_id = p.patient_id 
WHERE p.city = 'Delhi'
	


--Q19.** UNION: Combine a list of 'Active' patients (registered after 2020) and a list of patients with 'Recovered' outcome. Show patient_id only, deduplicated.

SELECT 
	patient_id
FROM health_patients
WHERE year(registered_on) > 2020
UNION 
SELECT 
	patient_id
FROM health_admissions
WHERE treatment_outcome='Recovered';



--Q20.** INTERSECT: Find patient_ids who appear BOTH in the health_patients table AND have at least one admission. (Use subquery or JOIN + INTERSECT approach)

SELECT patient_id FROM health_admissions 
INTERSECT 
SELECT patient_id FROM health_patients


	








