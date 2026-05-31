--## Questions 1–10: E-Commerce Domain

--Q1. Find total revenue (SUM of total_amount) and total orders (COUNT) by order_status.

SELECT
	o.order_status,
	SUM(o.total_amount) as total_revenue,
	COUNT(o.order_id) AS total_orders
FROM ecom_orders o
--ON c.customer_id= o.customer_id
GROUP BY o.order_status
ORDER BY total_revenue,total_orders;


--Q2. Find the average order value by payment_method. Filter to payment methods with avg > ₹5,000.

SELECT 
	payment_method,
	AVG(total_amount) average_order_value
FROM ecom_orders
GROUP BY payment_method
HAVING AVG(total_amount) > 5000;


--Q3. Find the minimum and maximum product price in each category.

SELECT 
	category,
	MAX(price) maximum_price,
	MIN(price) minimum_price
FROM ecom_products
GROUP BY category
ORDER BY maximum_price,minimum_price;

--Q4. Find the total quantity sold per product (SUM of quantity from order_items). Top 10 by quantity.

SELECT TOP 10
	p.product_id,
	SUM(ot.quantity) total_quantity_per_product
FROM ecom_products p 
JOIN ecom_order_items ot 
ON p.product_id = ot.product_id 
GROUP BY p.product_id
ORDER BY total_quantity_per_product DESC;

--Q5. Count the number of orders per customer. Show customers who have placed more than 5 orders.

SELECT 
	c.customer_id,
	COUNT(o.order_id) as total_no_products
FROM ecom_customers c 
JOIN ecom_orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) >= 5
ORDER BY total_no_products DESC;

--Q6. Find the total revenue per year (extract year from order_date). Show year and total revenue.

SELECT 
	YEAR(o.order_date) as revenue_year,
	SUM(o.total_amount) as total_revenue
FROM ecom_orders o
GROUP BY YEAR(o.order_date)
ORDER BY total_revenue DESC;

--Q7. Find the category with the highest average product price.

SELECT TOP 1
	category,
	AVG(price) average_product_price
FROM ecom_products 
GROUP BY category
ORDER BY average_product_price DESC;
	
--Q8. How many distinct customers placed orders in 2023?

SELECT 
	COUNT(DISTINCT customer_id) No_distinct_customers
FROM ecom_orders
WHERE YEAR(order_date) = 2023;

--Q9. Find total discount given per month in 2023 (SUM of discount, GROUP BY month).


SELECT 
	month(o.order_date) as Month,
	SUM((ot.discount_pct / 100.0) * ot.unit_price * ot.quantity) AS total_discount
FROM ecom_orders o
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id
GROUP BY month(o.order_date)
ORDER BY month(o.order_date);


--Q10. Find which city generated the most total order revenue. Show top 5 cities.

SELECT TOP 5
	city,
	SUM(total_amount) AS total_order_revenue
FROM ecom_orders
GROUP BY city
ORDER BY total_order_revenue DESC;

--## Questions 11–20: Healthcare Domain

--Q11. Find total revenue (SUM of total_bill) per diagnosis. Sort by revenue descending.

SELECT 
	diagnosis,
	SUM(total_bill) AS total_revenue
FROM health_admissions
GROUP BY diagnosis
ORDER BY total_revenue DESC;

--Q12. Find the average total_bill per ward. Filter wards with avg bill > ₹50,000.

SELECT 
	ward,
	AVG(total_bill) average_total_bill
 FROM health_admissions
 GROUP BY ward
 HAVING AVG(total_bill) > 50000
 ORDER BY average_total_bill DESC;

--Q13. Find the minimum and maximum insurance_covered amounts across all admissions.

SELECT 
	MIN(insurance_covered) Min_insurance_covered,
	MAX(insurance_covered) Max_insurance_covered
FROM health_admissions;

--Q14. Count admissions per doctor. Find doctors with more than 100 admissions.

SELECT
	d.doctor_id,
	COUNT(a.admission_id) as count_per_doctors
FROM health_doctors d
JOIN health_admissions a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id;

--Q15. Find the total uncovered amount: SUM(total_bill - insurance_covered) per year.

SELECT 
	YEAR(admission_date) year,
	SUM(total_bill-insurance_covered) total_uncovered_amount
FROM health_admissions
GROUP BY YEAR(admission_date)
ORDER BY total_uncovered_amount;

--Q16. Count patients per blood_group from health_patients.

SELECT 
	blood_group,
	COUNT(*) count_of_patients
FROM health_patients
GROUP BY blood_group
ORDER BY count_of_patients DESC;

--Q17. Find average patient age per ward (join patients + admissions).

SELECT	
	a.ward,
	AVG(p.age) average_age
FROM health_admissions a
JOIN health_patients p
ON a.patient_id = p.patient_id
GROUP BY a.ward;

--Q18. Count admissions per treatment_outcome. Which outcome has the highest count?

SELECT TOP 1
	treatment_outcome,
	COUNT(patient_id) count_of_outcome
FROM health_admissions
GROUP BY treatment_outcome
ORDER BY count_of_outcome DESC;

--Q19. Find the total bills generated per specialty (join doctors + admissions).

SELECT 
	d.specialty,
	SUM(a.total_bill) total_revenue
FROM health_doctors d
JOIN health_admissions a 
ON d.doctor_id = a.doctor_id
GROUP BY d.specialty
ORDER BY total_revenue DESC;

--Q20. How many unique patients were admitted in each quarter of 2022?

SELECT 
	DATEPART(QUARTER,admission_date) each_quarter,
	COUNT(DISTINCT patient_id) count_of_pateints
FROM health_admissions
GROUP BY DATEPART(QUARTER,admission_date)
ORDER BY count_of_pateints DESC;


--## Questions 21–30: Banking Domain

--Q21. Find total transaction volume (SUM of amount) and count per channel (ATM, UPI, etc.).

SELECT 
	channel,
	SUM(amount) total_transaction_volume,
	COUNT(channel) count_per_channel
FROM bank_transactions
GROUP BY channel;

--Q22. Find average account balance per account_type for active accounts.

SELECT 
	account_type,
	AVG(balance) average_balance
FROM bank_accounts
WHERE is_active=1
GROUP BY account_type

--Q23. Find total loan disbursed per loan_type. Show loan_type and total amount.

SELECT 
	loan_type,
	SUM(loan_amount) total_amount
FROM bank_loans
GROUP BY loan_type;


--Q24. Find average credit_score by employment_type from bank_customers.

SELECT 
	employment_type,
	AVG(credit_score) average_score
FROM bank_customers
GROUP BY employment_type;

--Q25. Count number of defaulted loans per loan_type.

SELECT 
	loan_type,
	COUNT(loan_id) number_of_loans
FROM bank_loans
WHERE status='Defaulted'
GROUP BY loan_type;

--Q26. Find MAX and MIN balance across all active accounts.

SELECT 
	MIN(balance) Min_balance,
	MAX(balance) Max_balance
FROM bank_accounts;

--Q27. Show monthly transaction volume (SUM of amount) for the year 2023.

SELECT  
	DATEPART(month,txn_date) as Month,
	SUM(amount) total_monthly_transaction
FROM bank_transactions
WHERE YEAR(txn_date)=2023
GROUP BY DATEPART(month,txn_date)
ORDER BY Month ;

--Q28. Find total outstanding balance across all 'Active' loans.

SELECT 
	 loan_type,
	 SUM(outstanding_balance) total_outstanding_balance
FROM bank_loans
WHERE status='active'
GROUP BY loan_type
ORDER BY total_outstanding_balance DESC;

--Q29. Count customers with more than 2 accounts (join customers + accounts, GROUP BY customer_id HAVING).

SELECT 
	c.customer_id,
	COUNT(a.account_id) no_of_accounts
FROM bank_customers c
JOIN bank_accounts a 
ON c.customer_id = a.customer_id
GROUP BY c.customer_id
HAVING COUNT(a.account_id) > 2;

--Q30. Find average interest_rate per loan_type. Filter to loan types with avg rate > 10%.

SELECT 
	loan_type,
	AVG(interest_rate) average_int_rate
FROM bank_loans
GROUP BY loan_type
HAVING AVG(interest_rate) > 10;

--## Questions 31–40: HR Domain

--Q31. Find total salary expense per department. Sort descending.

SELECT 
	department,
	SUM(salary) total_salary
FROM hr_employees
GROUP BY department
ORDER BY total_salary DESC;

--Q32. Find average, min, max salary per role.

SELECT 
	role,
	MIN(salary) Min_salary,
	MAX(salary) Max_salary
FROM hr_employees
GROUP BY role;

--Q33. Count employees per gender per department.

SELECT 
	gender,
	COUNT(employee_id) count_of_gender
FROM hr_employees
GROUP BY gender
ORDER BY count_of_gender DESC;

--Q34. Find the department with the highest average performance score (join employees + performance).

SELECT 
	e.department,
	AVG(p.score) as average_score
FROM hr_employees e
JOIN hr_performance p 
ON e.employee_id = p.employee_id
GROUP BY e.department;

--Q35. Count total 'Absent' days per department (join employees + attendance).

SELECT	
	e.department,
	COUNT(a.employee_id) as count_of_absents
FROM hr_employees e
JOIN hr_attendance a 
ON e.employee_id = a.employee_id
GROUP BY e.department;

--Q36. Find total salary hike amount per department: SUM(salary  salary_hike_pct / 100).

SELECT 
	e.department,
	SUM(e.salary*p.salary_hike_pct/100) as salary_hike_amount
FROM hr_employees e 
JOIN hr_performance p
ON e.employee_id = p.employee_id
GROUP BY e.department
ORDER BY salary_hike_amount DESC;

--Q37. How many employees were promoted each year? GROUP BY review_year.

SELECT  
	review_year,
	COUNT(employee_id) as count_of_employees
FROM hr_performance
GROUP BY review_year
ORDER BY review_year;

--Q38. Find average tenure (years since hire_date) per department.

SELECT 
	department,
	AVG(DATEDIFF(day, hire_date, GETDATE()) / 365.25) AS average_tenure
FROM hr_employees
GROUP BY department;

--Q39. Count employees hired each year from 2010 to 2023.

SELECT 
	YEAR(hire_date) year_of_hire,
	COUNT(employee_id) as count_employees
FROM hr_employees 
WHERE YEAR(hire_date) BETWEEN 2010 AND 2013
GROUP BY YEAR(hire_date)

--Q40. Find departments with more than 5 employees rated 'Outstanding' in any year.

SELECT 
	e.department,
	YEAR(e.hire_date) each_year,
	COUNT(p.employee_id) as no_of_emps
FROM hr_employees e
JOIN hr_performance p 
ON e.employee_id = p.employee_id
WHERE rating='outstanding'
GROUP BY e.department,YEAR(e.hire_date)
HAVING COUNT(p.employee_id) > 5

--## Questions 41–50: Logistics Domain

--Q41. Find total freight_cost per carrier per year. Show carrier, year, total cost.

SELECT  
	carrier,
	YEAR(dispatch_date) year_of_dispatch,
	SUM(freight_cost) total_cost
FROM logistics_shipments
GROUP BY carrier,
	YEAR(dispatch_date)
ORDER BY year_of_dispatch;

--Q42. Find average delay (in days) per carrier. (actual_delivery - estimated_delivery)

SELECT 
    carrier,
    AVG(DATEDIFF(DAY, estimated_delivery, actual_delivery)) AS average_delay_days
FROM logistics_shipments
WHERE actual_delivery IS NOT NULL 
    AND estimated_delivery IS NOT NULL
GROUP BY carrier
ORDER BY average_delay_days DESC;


--Q43. Find total inventory value (quantity  unit_cost) per warehouse.

SELECT 
	warehouse_id,
	SUM(quantity*unit_cost) total_inventory_value
FROM logistics_inventory
GROUP BY warehouse_id
ORDER BY total_inventory_value DESC;

--Q44. Count shipments delivered on time (actual_delivery <= estimated_delivery) per carrier.

SELECT 
	carrier,
	COUNT(shipment_id) no_shipments
FROM logistics_shipments
WHERE actual_delivery <= estimated_delivery 
GROUP BY carrier;

--Q45. Find the warehouse with the most inventory items (by COUNT of inventory records).



SELECT TOP 1
	warehouse_id,
	COUNT(product_id) as total_invertory_items
FROM logistics_inventory
GROUP BY warehouse_id
ORDER BY total_invertory_items DESC;
	
--Q46. Find average freight_cost per destination_city. Top 5 most expensive cities to ship to.

SELECT TOP 5
	destination_city,
	AVG(freight_cost) average_cost
FROM logistics_shipments
GROUP BY destination_city
ORDER BY average_cost DESC;

--Q47. Count shipments per month for 2023.

SELECT 
	MONTH(dispatch_date) as month_of_dispatch,
	COUNT(shipment_id) count_of_shipments
FROM logistics_shipments
WHERE YEAR(dispatch_date)=2023
GROUP BY MONTH(dispatch_date) 
ORDER BY month_of_dispatch,count_of_shipments DESC;

--Q48. Find total weight shipped (SUM of weight_kg) per carrier.

SELECT 
	carrier,
	SUM(weight_kg) total_weight_kg
FROM logistics_shipments
GROUP BY carrier
ORDER BY total_weight_kg DESC;
	

--Q49. Find suppliers (count) per city. Order by count descending.

SELECT 
	city,
	COUNT(supplier_id) count_of_suppliers
FROM logistics_suppliers
GROUP BY city
ORDER BY count_of_suppliers DESC;
	

--Q50. Find the minimum reorder_level and maximum quantity per warehouse (from inventory).

SELECT 
	warehouse_id,
	MIN(reorder_level) as minmum_reorder_level,
	MAX(quantity) as maximum_quantity
FROM logistics_inventory
GROUP BY warehouse_id;