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


--**Q21.** Join bank_accounts with bank_customers. Show customer name, account_type, balance for all active accounts.

SELECT 
	c.name,
	a.account_type,
	a.balance 
FROM bank_customers c 
JOIN bank_accounts a
ON c.customer_id = a.customer_id
WHERE is_active = 1


--**Q22.** Join bank_transactions with bank_accounts. Show account_type, sum of transaction amounts for 'Credit' transactions.

SELECT 
	a.account_type,
	SUM(t.amount) total_amount
FROM bank_transactions t
JOIN bank_accounts a 
ON t.account_id = a.account_id 
WHERE txn_type = 'credit'
GROUP BY a.account_type;

SELECT * FROM bank_transactions;


--**Q23.** Join bank_loans with bank_customers. Show customer name, loan_type, loan_amount, status.

SELECT 
	c.name,
	l.loan_type,
	l.loan_amount,
	l.status
FROM bank_loans l
JOIN bank_customers c 
ON l.customer_id = c.customer_id 

--**Q24.** LEFT JOIN bank_customers with bank_loans. Find customers who have NO loan.

SELECT 
	c.customer_id,
	c.name
FROM bank_customers c 
LEFT JOIN bank_loans l
ON c.customer_id = l.customer_id 
WHERE l.customer_id IS NULL;

--**Q25.** Join transactions with accounts with customers. Find the customer with the highest single transaction.

SELECT TOP 1
	c.customer_id,
	MAX(t.amount) highest_transaction
FROM bank_transactions t 
JOIN bank_accounts a 
ON t.account_id = a.account_id 
JOIN bank_customers c 
ON a.customer_id = c.customer_id 
GROUP BY c.customer_id 
ORDER BY highest_transaction DESC;

--**Q26.** Find customers who have BOTH a savings account AND a loan. (Use JOIN or INTERSECT)

SELECT customer_id FROM bank_loans 
INTERSECT 
SELECT customer_id FROM bank_accounts WHERE account_type = 'savings';


--**Q27.** UNION ALL: Combine Credit and Debit transactions into one result with a label column. 
--Show account_id, amount, txn_type, txn_date.

SELECT 
    account_id, 
    CAST(amount AS VARCHAR(50)) AS col2, 
    txn_type AS col3, 
    CAST(txn_date AS VARCHAR(50)) AS col4 
FROM bank_transactions 
UNION ALL 
SELECT 
    account_id, 
    CAST(account_type AS VARCHAR(50)), 
    CAST(balance AS VARCHAR(50)), 
    CAST(is_active AS VARCHAR(50)) 
FROM bank_accounts

SELECT * FROM bank_transactions;
SELECT * FROM bank_accounts;
	


--**Q28.** EXCEPT: Find account_ids that appear in bank_accounts but NOT in bank_transactions (no transaction history).

SELECT account_id FROM bank_accounts 
EXCEPT 
SELECT account_id FROM bank_transactions


--**Q29.** SELF JOIN bank_loans: Find customers who have more than one loan. Show customer_id and count of loans.

SELECT 
	l.customer_id,
	COUNT(*) count_of_loans
FROM bank_loans l
JOIN bank_loans l1 
ON l.customer_id = l1.customer_id 
GROUP BY l.customer_id
HAVING COUNT(*) > 1;

--**Q30.** Join accounts with customers. For each employment_type, find the average account balance.

SELECT 
	c.employment_type,
	AVG(a.balance) account_balance_average
FROM bank_customers c 
JOIN bank_accounts a 
ON c.customer_id = a.customer_id 
GROUP BY c.employment_type;

--**Q31.** Join hr_employees with hr_performance. Show employee first_name, department, review_year, rating, score.

SELECT 
	e.first_name,
	e.department,
	p.review_year,
	p.rating,
	p.score
FROM hr_employees e
JOIN hr_performance p 
ON e.employee_id = p.employee_id;


--**Q32.** Join hr_employees with hr_attendance. For each employee, count total 'Absent' days.

SELECT * FROM hr_attendance ; 

SELECT 
	e.employee_id,
	COUNT(a.status) total_absent_days 
FROM hr_employees e 
JOIN hr_attendance a
ON e.employee_id = a.employee_id 
WHERE a.status = 'absent'
GROUP BY e.employee_id
ORDER BY total_absent_days DESC;

--**Q33.** SELF JOIN hr_employees: Show each employee alongside their manager's name. (employee.manager_id = manager.employee_id)

SELECT 
	e.employee_id,
	e.first_name,
	e1.first_name,
	e1.manager_id,
	e1.first_name
FROM hr_employees e 
JOIN hr_employees e1 
ON e.manager_id = e1.manager_id

--**Q34.** LEFT JOIN hr_employees with hr_performance. Find employees with NO performance review on record.

SELECT 
	e.employee_id 
FROM hr_employees e 
LEFT JOIN hr_performance p
ON e.employee_id = p.employee_id 
WHERE p.employee_id IS NULL;

--**Q35.** Join employees + performance. Find top 5 employees by average performance score across all years.

SELECT TOP 5
	e.employee_id,
	AVG(p.score) average_score_years
FROM hr_employees e
JOIN hr_performance p 
ON e.employee_id = p.employee_id 
GROUP BY e.employee_id 
ORDER BY average_score_years DESC;


SELECT * FROM hr_performance;


--**Q36.** Join employees + attendance. Show all employees who were absent more than 20 times.

SELECT 
	e.employee_id,
	COUNT(a.status) total_absent_days
FROM hr_employees e 
JOIN hr_attendance a 
ON e.employee_id = a.employee_id 
GROUP BY e.employee_id 
HAVING COUNT(a.status) > 20;

	SELECT * FROM hr_attendance ; 
--**Q37.** Find departments where ALL employees have a manager (manager_id IS NOT NULL). (Tricky — think GROUP BY + HAVING COUNT)


--**Q38.** UNION: Combine the list of employees who received 'Outstanding' rating with employees who got promoted. Show employee_id only, deduplicated.

SELECT employee_id FROM hr_employees 
UNION 
SELECT employee_id FROM hr_performance WHERE rating ='outstanding' AND promotion=1;


--**Q39.** Join performance with employees. Show average salary_hike_pct per department.

SELECT * FROM hr_performance;
SELECT * FROM hr_employees;

SELECT	
	e.department,
	AVG(p.salary_hike_pct) as salary_hike
FROM hr_employees e 
JOIN hr_performance p 
ON e.employee_id = p.employee_id 
GROUP BY e.department

--**Q40.** EXCEPT: Find employee_ids in hr_employees who do NOT appear in hr_performance (never reviewed).

SELECT employee_id FROM hr_employees
EXCEPT 
SELECT employee_id FROM hr_performance

--**Q41.** Join shipments with warehouses. Show warehouse city, carrier, count of shipments dispatched.

SELECT 
	w.city,
	s.carrier,
	COUNT(*) countofshipments
FROM logistics_warehouses w 
JOIN logistics_shipments s 
ON w.warehouse_id = s.warehouse_id 
GROUP BY w.city,
	s.carrier
ORDER BY countofshipments DESC;

--**Q42.** Join logistics_inventory with logistics_warehouses. Show warehouse_name, product_id, quantity, reorder_level.

SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_NAME ='logistics_warehouses'
ORDER BY ORDINAL_POSITION

SELECT 
	w.warehouse_name,
	i.product_id,
	i.quantity,
	i.reorder_level
FROM logistics_warehouses w
JOIN logistics_inventory i
ON w.warehouse_id = i.warehouse_id ;


--**Q43.** Find warehouses that have NO inventory records. (LEFT ANTI JOIN warehouses vs inventory)

SELECT 
	w.warehouse_id,
	i.inventory_id
FROM logistics_warehouses w
LEFT JOIN logistics_inventory i 
ON w.warehouse_id = i.warehouse_id
WHERE i.warehouse_id IS NULL;



--**Q44.** Join shipments with ecom_orders (shared order_id). Show order_status, shipment status, freight_cost.

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'logistics_inventory'
ORDER BY ORDINAL_POSITION;

SELECT 
	o.order_status,
	s.status,
	s.freight_cost
FROM ecom_orders o
JOIN logistics_shipments s 
ON o.order_id = s.order_id ;



--**Q45.** Join inventory with warehouses. Find warehouses with total inventory value (quantity * unit_cost) above ₹5 lakhs.

SELECT 
	w.warehouse_id,
	SUM(i.quantity*i.unit_cost) Total_inventory_value 
FROM logistics_warehouses w 
JOIN logistics_inventory i 
ON w.warehouse_id=i.warehouse_id
GROUP BY w.warehouse_id
ORDER BY Total_inventory_value DESC;

--**Q46.** SELF JOIN logistics_shipments: Find order_ids that have more than one shipment (re-shipments / splits).

SELECT
	s.shipment_id
FROM logistics_shipments s
JOIN logistics_shipments s1
ON s.shipment_id = s1.shipment_id
GROUP BY s.shipment_id
HAVING count(*) >1;


--**Q47.** UNION ALL: Combine dispatched shipments from 2022 and 2023 into one dataset with a year label.

SELECT shipment_id,YEAR(dispatch_date) YEAR FROM logistics_shipments WHERE YEAR(dispatch_date)=2022
UNION ALL 
SELECT shipment_id,YEAR(dispatch_date) YEAR FROM logistics_shipments WHERE YEAR(dispatch_date)=2023

--**Q48.** Find suppliers (from logistics_suppliers) whose city is not present in logistics_warehouses cities. (EXCEPT or LEFT ANTI JOIN)

SELECT city FROM logistics_suppliers 
EXCEPT 
SELECT city FROM logistics_warehouses


--**Q49.** Join shipments with warehouses. For each carrier, find the warehouse city they most frequently dispatch from.

SELECT 
	s.carrier,
	w.city,
	count(city) as most_frequent_dispatch 
FROM logistics_warehouses w
JOIN logistics_shipments s
ON w.warehouse_id = s.warehouse_id
GROUP BY s.carrier,
			w.city
ORDER BY most_frequent_dispatch DESC;



--**Q50.** Join inventory + warehouses + suppliers (use warehouse_id as bridge). Show supplier_id, warehouse city, total inventory quantity. (Note: add supplier_id to inventory in your head or use logistics_suppliers as a standalone reference domain.)


SELECT 
	s.supplier_id,
	w.city,
	SUM(i.quantity) 
FROM logistics_inventory i 
JOIN logistics_warehouses w
ON i.warehouse_id = w.warehouse_id 
JOIN logistics_suppliers s
ON w.warehouse_id = s.warehouse_id;

SELECT * FROM logistics_suppliers;
SELECT * FROM logistics_inventory;
SELECT * FROM logistics_warehouses;







