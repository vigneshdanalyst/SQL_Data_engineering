--Q1. [E-Commerce] Concatenate first_name and last_name from ecom_customers into a single 'full_name' column with a space between them.

SELECT 
	first_name,
	last_name,
	CONCAT(first_name,' ',last_name) full_name
FROM ecom_customers;


--Q2. [E-Commerce] Convert all product_names to UPPERCASE. Show product_id and the uppercase name.

SELECT 
	product_id,
	UPPER(product_name) as uppercase_name
FROM ecom_products;


--Q3. [HR] Find all employees whose last_name starts with the letter 'E'. Use LIKE or LEFT().

SELECT 
	last_name
FROM hr_employees
WHERE last_name LIKE 'E%';

--Q4. [Banking] Extract only the first 10 characters of the 'description' column from bank_transactions.

SELECT 
	LEFT(description, 10) first_ten_char
FROM bank_transactions;

--Q5. [HR] Show the length (LEN) of each employee's first_name. Find employees with the longest first name.

SELECT first_name 
FROM hr_employees
WHERE LEN(first_name) = (
SELECT MAX(LEN(first_name)) max_length
FROM hr_employees)

--Q6. [E-Commerce] From the email column in ecom_customers, extract the domain (e.g., 'email.com' from 'user1@email.com'). Use SUBSTRING + CHARINDEX.
SELECT 
	SUBSTRING(email,
	CHARINDEX('@',email)+1,
	LEN(email)
	) AS domain
FROM ecom_customers;


--Q7. [Healthcare] Show doctor_name in format: "Dr. [LASTNAME]" — assume last word is last name. Use string functions to split.

SELECT
    CONCAT(
        'Dr. ',
        PARSENAME(REPLACE(doctor_name,' ','.'),1)
    ) AS formatted_name
FROM health_doctors;

--Q8. [Logistics] Replace 'WH_' prefix in warehouse_name with 'WAREHOUSE_' using REPLACE().

SELECT 
	REPLACE(warehouse_name,'WH_','WAREHOUSE_') as New_value
FROM logistics_warehouses;
	
--Q9. [Banking] Show customer names in LOWER case. Also show the REVERSE of their name (use REVERSE function).

SELECT 
	LOWER(REVERSE(name)) as new_customer
FROM bank_customers;


--Q10. [HR] Trim any leading/trailing spaces from first_name and last_name. Combine them as full_name.
SELECT 
	TRIM(first_name) first_name,
	TRIM(last_name) last_name,
	CONCAT(first_name,' ',last_name) as full_name
FROM hr_employees;

--## Questions 11–20: Numeric Functions

--Q11. [E-Commerce] Round all product prices to the nearest ₹100. Show product_name, original price, rounded price.

SELECT 
	product_name,
	price as original_price,
	ROUND(price,-2) as rounded_price
FROM ecom_products

--Q12. [E-Commerce] Calculate profit margin % as ((price - cost)/price)100. Round to 2 decimal places.

SELECT  
	product_name,
	ROUND(((price-cost)*100.0/price),2) as profit_margin
FROM ecom_products;
--Q13. [Banking] Show the CEILING and FLOOR of each account balance. (Use CEILING() and FLOOR())

SELECT 
	balance,
	CEILING(balance) as ceiling_balance,
	FLOOR(balance) as floor_balance
FROM bank_accounts;

--Q14. [Logistics] Calculate the absolute difference between estimated and actual freight costs. Use ABS().


--Q15. [HR] Calculate 15% salary hike for each employee. Round to nearest integer using ROUND().

SELECT 
	first_name,
	salary,
	ROUND((salary * 0.15),0) as salary_hike
FROM hr_employees;

--Q16. [Banking] Show loan interest per year: loan_amount  (interest_rate/100). Round to 2 decimal places.

SELECT 
	loan_amount,
	ROUND((loan_amount*(interest_rate/100)),2) loan_intrest_per_year
FROM bank_loans;

--Q17. [E-Commerce] In order_items, calculate total line value: quantity  unit_price  (1 - discount_pct/100). Round to 2 decimal places.

SELECT 
	order_id,
	ROUND(quantity*unit_price *(1-discount_pct/100.0),2) total_line_value
FROM ecom_order_items;

--Q18. [Logistics] Calculate value of inventory: quantity  unit_cost. Use ROUND to 2 decimal places.

SELECT
	ROUND(quantity*unit_cost,2) as total_value_inventory
FROM logistics_inventory;

--Q19. [Healthcare] Find the out-of-pocket expense: total_bill - insurance_covered. Show ABS value if insurance > bill.
SELECT 
	patient_id,
	ABS(total_bill-insurance_covered) as out_of_pocket
FROM health_admissions
where total_bill > insurance_covered ;
--Q20. [HR] Show performance score rounded DOWN to nearest integer (FLOOR). Show original and floored score.
SELECT 
	score,
	FLOOR(score) as rounded_score
FROM hr_performance;

--## Questions 21–30: Date & Time Functions

--Q21. [E-Commerce] From ecom_orders, extract the year, month, and day from order_date using YEAR(), MONTH(), DAY().

SELECT	
	YEAR(order_date) Year,
	MONTH(order_date) Month,
	DAY(order_date) day
FROM ecom_orders;


--Q22. [E-Commerce] Calculate how many days it took to deliver each order: DATEDIFF(day, order_date, delivery_date). Show NULL if not yet delivered.

SELECT 
	order_id,
	DATEDIFF(day,order_date,delivery_date) as date_difference
FROM ecom_orders;

--Q23. [HR] Calculate each employee's tenure in years as of today: DATEDIFF(year, hire_date, GETDATE()).

SELECT 
	employee_id,
	DATEDIFF(year,hire_date,GETDATE()) employee_tenure
FROM hr_employees;

--Q24. [Banking] Find all transactions made in the last 90 days from today.

SELECT * FROM bank_transactions;

SELECT 
	*
FROM bank_transactions
WHERE txn_date >= DATEADD(DAY,-90,GETDATE()) ;
	
	

--Q25. [Healthcare] Calculate patient age at time of admission: DATEDIFF(year, registered_on, admission_date). (approximation)

SELECT 
	p.patient_id,
	 FLOOR(DATEDIFF(day, p.registered_on, a.admission_date) / 365.25) AS age_at_admission
FROM health_patients p
JOIN health_admissions a
ON p.patient_id = a.patient_id;

--Q26. [E-Commerce] Show the name of the month (DATENAME(month, order_date)) for each order.

SELECT 
	order_id,
	DATENAME(month,order_date) as order_month
FROM ecom_orders;

--Q27. [HR] Find employees hired on a MONDAY. Use DATEPART(weekday, hire_date) — note: weekday 2 = Monday in SQL Server default.

SELECT 
	employee_id,
	DATEPART(weekday,hire_date) hire_date
FROM hr_employees
WHERE DATEPART(weekday,hire_date)=2;

--Q28. [Logistics] Calculate delay in shipments: DATEDIFF(day, estimated_delivery, actual_delivery). Show positive = delayed.

SELECT 
	order_id,
	shipment_id,
	DATEDIFF(day,estimated_delivery,actual_delivery) as days_delayed
FROM logistics_shipments
WHERE DATEDIFF(day,estimated_delivery,actual_delivery) < 0;
	
--Q29. [Banking] Use EOMONTH() to find the last day of the month for each transaction date.

SELECT 
	EOMONTH(txn_date) last_day_transaction
FROM bank_transactions;

--Q30. [HR] Use DATEADD to add 1 year to each employee's hire_date as their "1-year anniversary" date.

SELECT	
	hire_date,
	DATEADD(year,1,hire_date) as first_year_anniversary
FROM hr_employees;

--## Questions 31–40: NULL Functions and CASE

--Q31. [E-Commerce] In ecom_orders, the delivery_date can be NULL. Replace NULLs with 'Pending Delivery' using ISNULL().

SELECT 
	ISNULL(CONVERT(VARCHAR,delivery_date,23),'Pending Delivery') as  delivery_delayed
FROM ecom_orders;

--Q32. [HR] Replace NULL manager_id with 0 using ISNULL(). Show employee_id and manager_id (with 0 for top-level).

SELECT 
	employee_id,
	ISNULL(manager_id,0)  as manager_id
FROM hr_employees;


--Q33. [Banking] Use COALESCE to show account balance; if NULL, show outstanding_balance from loans; if that's NULL, show 0.

SELECT 
	COALESCE(a.balance, l.outstanding_balance,0) as balance
FROM bank_accounts a
JOIN bank_loans l
ON a.customer_id = l.customer_id;

--Q34. [Healthcare] Use NULLIF to set insurance_covered to NULL if it equals 0 (avoid showing ₹0 covered).

SELECT 
	NULLIF(insurance_covered,0) as insurance_covered
FROM health_admissions;

--Q35. [E-Commerce] Using CASE, categorize product prices: < ₹500 = 'Budget', ₹500–₹5000 = 'Mid-Range', > ₹5000 = 'Premium'.

SELECT 
	product_id,
    CASE
        WHEN price < 500 THEN 'Budget'
        WHEN price BETWEEN 500 AND 5000 THEN 'Mid-Range'
        WHEN price > 5000 THEN 'Premium'
        ELSE 'Unknown'
    END AS categorize
FROM ecom_products;


--Q36. [HR] Using CASE, label employee age groups: < 30 = 'Young', 30–45 = 'Mid-Career', > 45 = 'Senior'.

SELECT
	employee_id,
	age,
	CASE
		WHEN age < 30 THEN 'Young'
		WHEN age BETWEEN 30 AND 45 THEN 'Mid-career'
		WHEN age>45 THEN 'Senior'
	ELSE 'Too low'
END AS age
FROM hr_employees;


--Q37. [Banking] Using CASE on credit_score: < 500 = 'Poor', 500–650 = 'Fair', 650–750 = 'Good', > 750 = 'Excellent'.

SELECT 
	name,
	CASE 
		WHEN credit_score < 500 THEN 'Poor'
		WHEN credit_score BETWEEN 500 AND 650 THEN 'Fair'
		WHEN credit_score BETWEEN 650 AND 750 THEN 'Good'
		WHEN credit_score > 750 THEN 'Excellent'
		ELSE 'credit_score'
	END AS credit_score
FROM bank_customers;

--Q38. [Healthcare] Using CASE on treatment_outcome: 'Recovered' → 'Positive', 'Deceased' → 'Critical Loss', everything else → 'In Progress'.

SELECT 
	patient_id,
	CASE 
		WHEN treatment_outcome='Recovered' THEN 'Positive'
		WHEN treatment_outcome='Deceased' THEN 'Critical Loss' 
		ELSE 'In-progress'
	END as treatment
FROM health_admissions;

--Q39. [Logistics] Using CASE, label shipment delay: < 0 days = 'Early', 0 days = 'On Time', 1–3 days = 'Slight Delay', > 3 days = 'Major Delay'. (Use DATEDIFF inside CASE)

SELECT * FROM logistics_shipments;

SELECT 
	shipment_id,
	order_id,
	CASE 
		WHEN DATEDIFF(day,estimated_delivery,actual_delivery) < 0 THEN 'Early'
		WHEN DATEDIFF(day,estimated_delivery,actual_delivery) = 0 THEN 'On Time'
		WHEN DATEDIFF(day,estimated_delivery,actual_delivery) BETWEEN 1 AND 3 THEN 'Slight Delay'
		WHEN DATEDIFF(day,estimated_delivery,actual_delivery) > 3 THEN 'Major Delay'
	ELSE 'Unknown'
END AS estimated
FROM logistics_shipments;

--Q40. [E-Commerce] Using CASE in GROUP BY context: Count how many 'Budget', 'Mid-Range', and 'Premium' products exist.

SELECT 
	CASE
        WHEN price < 500 THEN 'Budget'
        WHEN price BETWEEN 500 AND 5000 THEN 'Mid-Range'
        WHEN price > 5000 THEN 'Premium'
        ELSE 'Unknown'
    END AS categorize,
	COUNT(*) count_of_category
FROM ecom_products
GROUP BY CASE
        WHEN price < 500 THEN 'Budget'
        WHEN price BETWEEN 500 AND 5000 THEN 'Mid-Range'
        WHEN price > 5000 THEN 'Premium'
        ELSE 'Unknown'
    END;
	
--## Questions 41–50: Combined Functions (Mixed)

--Q41. [E-Commerce] Show a formatted order summary: 'Order #[order_id] by [customer_id] on [formatted date]'. Use CONCAT + CONVERT/FORMAT.

SELECT 
	CONCAT('order #[',o.order_id,'] by [',c.customer_id,'] on [',FORMAT(o.order_date,'yyyy-MM-dd'),']') as order_summary
FROM ecom_customers c 
JOIN ecom_orders o 
ON c.customer_id = o.customer_id 
JOIN ecom_order_items ot 
ON o.order_id = ot.order_id ;
--Q42. [HR] Show full employee info string: 'EmpF1 EmpL1 | Engineering | Manager | ₹500000'. Use CONCAT and CAST.

SELECT 
	CONCAT(first_name,' ',last_name,' |',department,' |',role,' | $',CAST(salary AS CHAR)) AS employee_info
FROM hr_employees;

SELECT * FROM hr_employees;
--Q43. [Banking] Find loan EMI estimate: loan_amount / tenure_months. Show as integer using FLOOR(). Also format tenure as '[X] months'.

SELECT 
	FLOOR(loan_amount/tenure_months) as EMI_estimate,
	CONCAT(tenure_months,' Months') AS months
FROM bank_loans;

--Q44. [Healthcare] Show admission summary: 'Patient [patient_id] admitted on [date] for [diagnosis]. Bill: ₹[amount]'. Use CONCAT.

SELECT 
	CONCAT('Patient ',[patient_id],'admitted on ',[admission_date],'for ',[diagnosis],' Bill: ₹',[total_bill]) AS admission_summary
FROM health_admissions;

SELECT * FROM health_admissions;
--Q45. [Logistics] Calculate days in transit: DATEDIFF between dispatch_date and actual_delivery. Use ISNULL to show 'Still in Transit' if actual_delivery is NULL.

SELECT 
	ISNULL
		(CONVERT(VARCHAR, 
			DATEDIFF(day,dispatch_date,actual_delivery)),
		'Still in Transit') Days_intransit
FROM logistics_shipments;

--Q46. [E-Commerce] Combine product name with its price tier (from CASE) as a single label column. E.g., 'Product_Electronics_5 | Premium'.

SELECT 
	CONCAT(
		Product_name,'|',
	CASE
        WHEN price < 500 THEN 'Budget'
        WHEN price BETWEEN 500 AND 5000 THEN 'Mid-Range'
        WHEN price > 5000 THEN 'Premium'
        ELSE 'Unknown'
    END ) as product_label
FROM ecom_products;

--Q47. [Banking] Convert loan disbursement_date to format 'DD-Mon-YYYY' using FORMAT or CONVERT style 106.

SELECT 
	FORMAT(disbursement_date,'dd-MMM-yyy') AS formatted_date
FROM bank_loans;

--Q48. [HR] Find employees whose name (first_name) contains exactly 5 characters. Use LEN().

SELECT 
	employee_id,
	LEN(first_name) as length_of_name
FROM hr_employees
WHERE LEN(first_name) =5;


--Q49. [Healthcare] Show each doctor's name in format 'LASTNAME, Firstname' (UPPER last word, normal first word).

SELECT 
	CONCAT(UPPER(last_name),',',first_name) AS doctor_name
FROM hr_employees;


--Q50. [Logistics] Classify inventory health: quantity = 0 → 'Out of Stock', quantity < reorder_level → 'Low Stock', else → 'Adequate'. Use CASE.

SELECT  
	inventory_id,
	CASE
		WHEN quantity=0 THEN 'Out of Stock'
		WHEN quantity<reorder_level THEN 'Low Stock'
		ELSE 'Adequate'
	END AS inventory_health
FROM logistics_inventory;