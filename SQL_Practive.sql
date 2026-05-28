--initaite the DB 
USE practice;

-- Basic Table checkings using SELECT  

SELECT * FROM bank_accounts;
SELECT * FROM bank_customers;
SELECT * FROM bank_loans;
SELECT * FROM bank_transactions;
SELECT * FROM ecom_customers;
SELECT * FROM ecom_order_items;
SELECT * FROM ecom_orders;
SELECT * FROM ecom_products;
SELECT * FROM health_admissions;
SELECT * FROM health_doctors;
SELECT * FROM health_patients;
SELECT * FROM hr_attendance;
SELECT * FROM hr_performance;
SELECT * FROM logistics_inventory;
SELECT * FROM logistics_shipments;
SELECT * FROM logistics_suppliers;
SELECT * FROM logistics_warehouses;


-- Solving Problems 


-- TOPIC 1: SELECT, WHERE, ORDER BY, GROUP BY, HAVING, DISTINCT, TOP

--Q1.** List all unique cities from which customers have registered. Sort them alphabetically.

SELECT 
	DISTINCT(CITY) as Unique_city 
FROM ecom_customers
ORDER BY Unique_city DESC;

--Q2.** Show the top 10 most expensive products currently active (is_active = 1). Display product_name, category, and price.

SELECT TOP 10
	product_name,
	category,
	price
FROM ecom_products
WHERE is_active=1
ORDER BY price DESC;

--Q3.** Find all orders placed in the year 2022 with order_status = 'Delivered'. How many such orders exist?

SELECT 
	COUNT(*) total_orders_count
FROM ecom_orders
WHERE order_status='Delivered' 
AND order_date BETWEEN '2022-01-01' AND '2022-12-31';

--Q4.** Show each category and the total number of products in it. Sort by count descending.

SELECT 
	category,
	COUNT(*) totalnoofproducts
FROM ecom_products
GROUP BY category 
ORDER BY totalnoofproducts DESC;

--Q5.** List all customers from 'Bengaluru' who registered after 2021-01-01 and have 'Active' status.


SELECT 
	*
FROM ecom_customers
WHERE city='Bengaluru'
AND registration_date > '2021-01-01'
AND status='active';

--Q6.** Find the top 5 customers by total order amount (total_amount in orders table). Show customer_id and their sum.

SELECT TOP 5
	 customer_id,
	 ROUND(SUM(total_amount),1) totalorderamount
FROM ecom_orders
GROUP BY customer_id
ORDER BY totalorderamount DESC;

--Q7.** Show all products where price > cost * 2 (profit margin > 100%). List product_name, price, cost.

SELECT 
	product_name,
	price,
	cost
FROM ecom_products
WHERE price > cost * 2;

--Q8.** Count how many orders were placed per payment_method. Order by count descending.

SELECT 
	payment_method,
	COUNT(*) totalordersperpayment
FROM ecom_orders
GROUP BY payment_method
ORDER BY totalordersperpayment DESC;

--Q9.** Show order counts per order_status. Filter to show only statuses with more than 1000 orders.
SELECT 
	order_status,
	COUNT(*) totalorderstatus
FROM ecom_orders
GROUP BY order_status
HAVING COUNT(*) > 1000
ORDER BY totalorderstatus DESC;

--Q10.** Find all distinct payment methods used for orders above ₹50,000.

SELECT 
	DISTINCT(payment_method)
FROM ecom_orders
WHERE total_amount > 50000;

--Q11.** List all doctors with more than 20 years of experience. Show doctor_name, specialty, experience_years.

SELECT 
	doctor_name,
	specialty,
	experience_years
FROM health_doctors
WHERE experience_years > 20
ORDER BY experience_years DESC;

--Q12.** Find the top 3 most common diagnoses across all admissions.

SELECT * FROM health_admissions;

SELECT TOP 3
	diagnosis,
	COUNT(*) diagnosiscount
FROM health_admissions
GROUP BY diagnosis
ORDER BY diagnosiscount DESC;
	

--Q13.** How many patients were admitted per year? Extract year from admission_date.

SELECT 
	YEAR(admission_date) yearofadmission,
	count(*) totalcountadmission
FROM health_admissions
GROUP BY YEAR(admission_date)
ORDER BY totalcountadmission DESC;

--Q14.** Show each ward and the total billing amount for that ward. Sort by total_bill descending

SELECT	
	ward,
	SUM(total_bill) Totalbilling
FROM health_admissions
GROUP BY ward
ORDER BY totalbilling DESC;

--Q15.** Find all admissions where insurance_covered > total_bill. (Investigate data anomalies!)

SELECT
	*
FROM health_admissions
WHERE  insurance_covered > total_bill;

--Q16.** Count distinct patients admitted in 2023.

SELECT 
	COUNT(DISTINCT patient_id) uniquepatients
FROM health_admissions
WHERE YEAR(admission_date) = 2023;

SELECT * FROM health_patients;

--Q17.** Show the average consultation_fee per specialty. Filter to specialties with avg fee > ₹1,000.

SELECT 
	specialty,
	AVG(consultation_fee) average_fee
FROM health_doctors
GROUP BY specialty
HAVING AVG(consultation_fee) > 1000
ORDER BY AVG(consultation_fee) DESC;

--18.** List all patients (from health_patients) who are above age 60 from 'Chennai'.

SELECT 
	*
FROM health_patients
WHERE city='chennai'
AND age > 60;

--Q19.** Find the top 5 most expensive admissions (by total_bill). Show patient_id, diagnosis, total_bill.

SELECT TOP 5
	patient_id,
	diagnosis,
	total_bill
FROM health_admissions
ORDER BY total_bill DESC;

--Q20.** How many admissions resulted in 'Deceased' treatment outcome per year?

SELECT 
	YEAR(admission_date) yearofadmission,
	COUNT(*) totalcount
FROM health_admissions
WHERE treatment_outcome = 'Deceased'
GROUP BY YEAR(admission_date) 
ORDER BY totalcount DESC;

--Q21.** Find all bank customers with a credit_score above 750. How many are there?


SELECT 
	COUNT(credit_score) customersmore750
FROM bank_customers
WHERE credit_score > 750;

--Q22.** Show total balance by account_type across all active accounts.

SELECT
	account_type,
	SUM(balance) totalbalance
FROM bank_accounts
GROUP BY account_type
ORDER BY totalbalance DESC;

--Q23.** List all transactions above ₹1,00,000. Show txn_id, account_id, amount, txn_date.

SELECT 
	txn_id,
	account_id,
	amount,
	txn_date
FROM bank_transactions
WHERE amount > 100000;

--Q24.** Count total Credit vs Debit transactions. Show txn_type and count.

SELECT 
	txn_type,
	COUNT(*) totalcount
FROM bank_transactions
GROUP BY txn_type;

--Q25.** Show top 5 accounts by current balance (is_active = 1).

SELECT 
	TOP 5
	account_id,
	customer_id,
	account_type,
	balance
FROM bank_accounts
WHERE is_active=1
ORDER BY balance DESC;

--Q26.** Find how many loans of each loan_type are currently 'Active'.

SELECT 
	loan_type,
	COUNT(*) total_loans
FROM bank_loans 
WHERE status = 'active'
GROUP BY loan_type
ORDER BY total_loans DESC;

--Q27.** Show average loan amount by loan_type. Sort descending.

SELECT 
	loan_type,
	AVG(loan_amount) average_amount
FROM bank_loans
GROUP BY loan_type
ORDER BY average_amount DESC;

--Q28.** List all transactions made via 'UPI' channel in 2023. Count them.

SELECT * FROM bank_transactions;

SELECT *
FROM bank_transactions
WHERE channel ='UPI'
AND txn_date > = '2023-01-01' 
AND txn_date <= '2023-12-31';


SELECT COUNT(*) as total_count
FROM bank_transactions
WHERE channel ='UPI'
AND txn_date > = '2023-01-01' 
AND txn_date <= '2023-12-31';

--Q29.** Find all customers with income above ₹20 lakhs (2,000,000). Show name, income, employment_type.

SELECT 
	name,
	income,
	employment_type
FROM bank_customers
WHERE income > 2000000;

--Q30.** Show the month-wise count of transactions in 2022 (extract month from txn_date).

SELECT 
	MONTH(txn_date) AS monthwise,
	COUNT(*) as total_transactions
FROM bank_transactions
WHERE txn_date >= '2022-01-01' AND txn_date <= '2022-12-31'
GROUP BY MONTH(txn_date)
ORDER BY monthwise;

--Q31.** List all employees in the 'Engineering' department currently active (termination_date IS NULL).

SELECT * FROM hr_employees;

SELECT 
	*
FROM hr_employees
WHERE department='Engineering'
AND termination_date IS NULL;

--Q32.** Find the top 10 highest-paid employees. Show first_name, department, role, salary.

SELECT TOP 10
	first_name,
	department,
	role,
	salary
FROM hr_employees
ORDER BY salary DESC;

--Q33.** Count how many employees are in each department. Sort by count descending.

SELECT 
	department,
	COUNT(*) totalcount
FROM hr_employees
GROUP BY department
ORDER BY totalcount DESC;

--Q34.** Show average salary per department. Filter departments with avg salary > ₹8,00,000.

SELECT 
	department,
	AVG(salary) Averagesalaryperdepartment
FROM hr_employees 
GROUP BY department
HAVING AVG(salary) > 800000
ORDER BY Averagesalaryperdepartment  DESC;

--Q35.** Find all employees hired between 2015 and 2019.
SELECT * FROM hr_employees;

SELECT 
	*
FROM hr_employees
WHERE hire_date >= '2015-01-01' AND hire_date <= '2019-12-31'
ORDER BY hire_date desc;

--Q36.** Count the attendance status breakdown (Present, Absent, WFH, etc.) across all records.
SELECT * FROM hr_attendance;

SELECT 
	status,
	COUNT(*) total_count
FROM hr_attendance
GROUP BY status
ORDER BY total_count desc;

--Q37.** How many employees received a 'Promotion' (promotion = 1) in each review_year?

SELECT * FROM hr_performance;

SELECT 
	review_year,
	COUNT(promotion) as total_count
FROM hr_performance
WHERE promotion > 0
GROUP BY review_year
ORDER BY total_count DESC;

--Q38.** Show distinct roles present in the company. How many unique roles exist?

SELECT 
	DISTINCT(role)
FROM hr_employees;

SELECT 
COUNT(DISTINCT(role)) disticntcount
FROM hr_employees;

--Q39.** Find all employees where salary > ₹30 lakhs AND role LIKE '%Manager%'

SELECT 
	*
FROM hr_employees
WHERE salary > 3000000
AND role LIKE '%Manager%';

--Q40.** Show total salary outflow (SUM of salary) per city. Order by total descending.

SELECT 
	city,
	SUM(salary) total_salary
FROM hr_employees
GROUP BY city
ORDER BY total_salary DESC;

--Q41.** Count shipments by status. Show each status and count.

SELECT 
	status,
	COUNT(*) total_count
FROM logistics_shipments
GROUP BY status
ORDER BY total_count;

--Q42.** Find all shipments where actual_delivery > estimated_delivery (delayed deliveries).

SELECT 
	*
FROM logistics_shipments
WHERE  actual_delivery > estimated_delivery;

--Q43.** Show total freight_cost per carrier. Sort by total descending.

SELECT 
	carrier,
	SUM(freight_cost) total_cost
FROM logistics_shipments
GROUP BY carrier
ORDER BY total_cost DESC;

--Q44.** List all inventory items where quantity < reorder_level (restock needed).

SELECT 
	*
FROM logistics_inventory
WHERE quantity < reorder_level;

--*Q45.** How many shipments were made per year? Extract year from dispatch_date.

SELECT 
	YEAR(dispatch_date) Yearofshipment,
	COUNT(*) total_shipments
FROM logistics_shipments
GROUP BY YEAR(dispatch_date);

--Q46.** Show top 5 destination cities by number of shipments received.

SELECT TOP 5
	destination_city,
	COUNT(*) total_shipments
FROM logistics_shipments
GROUP BY destination_city
ORDER BY total_shipments DESC;

--Q47.** Find warehouses where current_stock > capacity (data quality check!).

SELECT 
	* 
FROM logistics_warehouses
WHERE current_stock > capacity;

--Q48.** Count active suppliers (is_active = 1) by city.

SELECT * FROM logistics_suppliers;

SELECT 
	city,
	COUNT(*) total_count
FROM logistics_suppliers
WHERE is_active=1
GROUP BY city
ORDER BY total_count DESC;

--Q49.** Show average freight_cost per carrier. Filter to carriers with avg > ₹1,000.

SELECT 
	carrier,
	AVG(freight_cost) costofeach
FROM logistics_shipments
GROUP BY carrier
HAVING AVG(freight_cost) > 1000
ORDER BY costofeach DESC;

--Q50.** List distinct carriers that shipped to 'Mumbai'. Order alphabetically.
SELECT 
	DISTINCT(carrier)
FROM logistics_shipments
WHERE destination_city = 'Mumbai'
ORDER BY carrier ASC;

