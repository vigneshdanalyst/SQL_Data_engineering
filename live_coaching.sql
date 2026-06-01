--## Questions 1–10: Ranking Functions

--Q1. [E-Commerce] Rank products within each category by price (highest = rank 1). Use RANK().

SELECT 
	category,
	price,
	product_name,
	RANK() OVER(PARTITION BY category ORDER BY PRICE DESC) rank_of_product
FROM ecom_products;


--Q2. [E-Commerce] Assign ROW_NUMBER() to orders per customer ordered by order_date ascending. Then find each customer's FIRST order.

SELECT 
	customer_id,
	order_date,
	total_amount
FROM (
SELECT 
	customer_id,
	order_id
	order_date,
	total_amount,
	ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) row_number_customer
FROM ecom_orders) as ranked_customers
WHERE row_number_customer =1;

--Q3. [HR] Rank employees within each department by salary (descending). Use DENSE_RANK(). Show top salary in each dept.

SELECT 
	employee_id,
	first_name,
	last_name,
	department,
	salary,
	DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rank
FROM hr_employees;
	

--Q4. [Banking] Rank accounts by balance descending. Use NTILE(4) to divide into quartiles. Label: 1='Top 25%', 4='Bottom 25%'.

SELECT 
	account_id,
	customer_id,
	balance,
	NTILE(4) OVER(ORDER BY balance DESC) as quartile,
	CASE 
		WHEN NTILE(4) OVER (ORDER BY balance DESC)=1 THEN 'Top 25%'
		WHEN NTILE(4) OVER (ORDER BY balance DESC)=2 THEN 'Upper Middle 25%'
		WHEN NTILE(4) OVER (ORDER BY balance DESC)=3 THEN 'Lower Middle 25%'
		WHEN NTILE(4) OVER (ORDER BY balance DESC)=4 THEN 'Bottom 25%'
	END AS quartile_total
FROM bank_accounts;


--Q5. [Healthcare] Rank doctors by total admissions handled (using subquery or CTE + RANK).

SELECT 
    doctor_id,
    RANK() OVER (ORDER BY count_of_admission DESC) AS rank_of_doctor
FROM (
    SELECT 
        d.doctor_id,
        COUNT(a.admission_id) AS count_of_admission
    FROM health_doctors d
    JOIN health_admissions a 
        ON d.doctor_id = a.doctor_id
    GROUP BY d.doctor_id
) AS doctor_admissions
ORDER BY rank_of_doctor;

--Q6. [Logistics] Rank shipments per carrier by freight_cost descending using DENSE_RANK(). Find the top-cost shipment per carrier.

USE practice;

SELECT 
	shipment_id,
	carrier,
	DENSE_RANK() OVER(PARTITION BY carrier ORDER BY freight_cost DESC) as shipments
FROM logistics_shipments;


--Q7. [E-Commerce] Use ROW_NUMBER() partitioned by customer_id ORDER BY total_amount DESC to find each customer's highest-value order.


SELECT 
	customer_id,
	total_amount
FROM 
(SELECT
	c.customer_id,
	o.total_amount,
	ROW_NUMBER() OVER(PARTITION BY c.customer_id ORDER BY o.total_amount DESC) customer_rank
FROM ecom_customers c
JOIN ecom_orders o 
ON c.customer_id = o.customer_id) as customer_ranks
WHERE customer_rank=1;


--Q8. [HR] Use NTILE(3) to divide employees into salary bands (Low/Mid/High) within each department.

SELECT 
	employee_id,
	salary,
	NTILE(3) OVER(PARTITION BY department ORDER BY salary) AS thirdile,
	CASE 
		WHEN NTILE(3) OVER(PARTITION BY department ORDER BY salary)=1 THEN 'Low'
		WHEN NTILE(3) OVER(PARTITION BY department ORDER BY salary)=2 THEN 'Mid'
		WHEN NTILE(3) OVER(PARTITION BY department ORDER BY salary)=3 THEN 'High'
	ELSE 'Unknown'
END salary_band
FROM hr_employees;


--Q9. [Banking] Rank loan customers by outstanding_balance descending. Use ROW_NUMBER() — show top 20.

SELECT TOP 20
	customer_id,
	ROW_NUMBER() OVER(ORDER BY outstanding_balance DESC) as out_rank
FROM bank_loans;
	



--Q10. [Healthcare] Use DENSE_RANK() on total_bill to find the top 3 most expensive admissions overall.
SELECT 
	admission_id,
	patient_id,
	total_bill
FROM 
(SELECT 
	admission_id,
	patient_id,
	total_bill,
	DENSE_RANK() OVER(ORDER BY total_bill DESC) as rank_of_customer
FROM health_admissions) as rank_of_customers 
WHERE rank_of_customer<=3;
	


--## Questions 11–20: Running Totals and Moving Averages

--Q11. [E-Commerce] Calculate running total of total_amount ordered by order_date. Use SUM() OVER (ORDER BY order_date).

SELECT 
	customer_id,
	order_date,
	total_amount,
	SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date DESC) running_total
FROM ecom_orders;

--Q12. [E-Commerce] Calculate 7-day moving average of order amounts. Use ROWS BETWEEN 6 PRECEDING AND CURRENT ROW.

SELECT 
	order_date,
	total_amount,
	AVG(total_amount) OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as moving_average
FROM ecom_orders
ORDER BY order_date;

--Q13. [Banking] Calculate running total of transaction amounts per account_id ordered by txn_date.

SELECT 
	account_id,
	SUM(amount) OVER(PARTITION BY account_id ORDER BY txn_date) running_total_transaction
FROM bank_transactions;

--Q14. [Banking] Calculate 30-day rolling SUM of Credit transactions per account.

SELECT 
    account_id,
    txn_date,
    amount,
    SUM(amount) OVER (PARTITION BY account_id ORDER BY txn_date ROWS BETWEEN 30 PRECEDING AND CURRENT ROW) AS rolling_30day
FROM bank_transactions
WHERE txn_type = 'credit';


--Q15. [HR] Calculate running total of salary expense per department ordered by hire_date.

SELECT
	department,
	hire_date,
	salary,
	SUM(salary) OVER(PARTITION BY department ORDER BY hire_date) running_total_salary
FROM hr_employees;


--Q16. [Healthcare] Calculate running total of total_bill per ward ordered by admission_date.


SELECT 
    ward,
    admission_date,
    total_bill,
    SUM(total_bill) OVER(PARTITION BY ward ORDER BY admission_date) AS running_total_per_ward
FROM health_admissions
ORDER BY ward, admission_date;


--Q17. [Logistics] Calculate running total of freight_cost per carrier ordered by dispatch_date.

SELECT 
	carrier,
	dispatch_date,
	freight_cost,
	SUM(freight_cost) OVER(PARTITION BY carrier ORDER BY dispatch_date) as running_total
FROM logistics_shipments;


--Q18. [E-Commerce] Use COUNT() OVER (PARTITION BY customer_id ORDER BY order_date) to show cumulative order count per customer.

SELECT 
	customer_id,
	COUNT(order_id) OVER(PARTITION BY customer_id ORDER BY order_date) as count_cumm
FROM ecom_orders;

--Q19. [Banking] Use AVG() OVER (PARTITION BY account_type ORDER BY open_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) for rolling average balance.

SELECT 
	customer_id,
	AVG(balance) OVER (PARTITION BY account_type ORDER BY open_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) rolling_average_balance
FROM bank_accounts;

--Q20. [HR] Show cumulative salary paid per department as of each hire date (running total partitioned by department).

SELECT 
	department,
	hire_date,
	SUM(salary) OVER(PARTITION BY department ORDER BY hire_date) running_total
FROM hr_employees;


--## Questions 21–30: LAG, LEAD, FIRST_VALUE, LAST_VALUE

--Q21. [E-Commerce] Use LAG(total_amount, 1, 0) OVER (PARTITION BY customer_id ORDER BY order_date) to find each customer's previous order amount.

SELECT 
	customer_id,
	LAG(total_amount,1,0) OVER(PARTITION BY customer_id ORDER BY order_date) previous_order_amount
FROM ecom_orders;


--Q22. [E-Commerce] Calculate the difference between current and previous order amount per customer. Use LAG.

SELECT 
	customer_id,
	LAG(total_amount,1,0) OVER(PARTITION BY customer_id ORDER BY order_date) previous_order_amount,
	total_amount - LAG(total_amount,1,0) OVER(PARTITION BY customer_id ORDER BY order_date) AS difference
FROM ecom_orders;


--Q23. [Banking] Use LAG(amount, 1) OVER (PARTITION BY account_id ORDER BY txn_date) to compare each transaction with the previous one on the same account.

SELECT 
	amount,
	LAG(amount,1) OVER (PARTITION BY account_id ORDER BY txn_date) as previous_amount,
	amount-LAG(amount,1) OVER (PARTITION BY account_id ORDER BY txn_date) as difference_between
FROM bank_transactions;

--Q24. [Banking] Use LEAD(txn_date) OVER (PARTITION BY account_id ORDER BY txn_date) to find how many days until the NEXT transaction.

SELECT 
	account_id,
	txn_id,
	txn_date,
	LEAD(txn_date) OVER (PARTITION BY account_id ORDER BY txn_date) as days_next_transaction
FROM bank_transactions;
	
--Q25. [HR] Use LAG(salary) OVER (PARTITION BY employee_id ORDER BY review_year) in the performance table to see salary before last hike (conceptual — adapt using salary_hike_pct).

-- Need to learn 

--Q26. [Healthcare] Use FIRST_VALUE(total_bill) OVER (PARTITION BY patient_id ORDER BY admission_date) to show each patient's first-ever bill.

SELECT 
	patient_id,
	FIRST_VALUE(total_bill) OVER(PARTITION BY patient_id ORDER BY admission_date) as first_ever_bill
FROM health_admissions;


--Q27. [Healthcare] Use LAST_VALUE(total_bill) OVER (PARTITION BY patient_id ORDER BY admission_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) to show the latest bill.

SELECT 
	patient_id,
	admission_date,
	LAST_VALUE(total_bill) OVER(PARTITION BY patient_id ORDER BY admission_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as latest_bill
FROM health_admissions

--Q28. [Logistics] Use LAG(freight_cost, 1, 0) OVER (PARTITION BY carrier ORDER BY dispatch_date) to find cost change per carrier over shipments.

SELECT 
	carrier,
	dispatch_date,
	LAG(freight_cost,1,0) OVER(PARTITION BY carrier ORDER BY dispatch_date) rate_difference,
	freight_cost - LAG(freight_cost,1,0) OVER(PARTITION BY carrier ORDER BY dispatch_date) rate_difference1
FROM logistics_shipments;

--Q29. [E-Commerce] Use LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) to calculate days between consecutive orders per customer.
SELECT 
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_date,
    DATEDIFF(DAY, 
        order_date, 
        LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)
    ) AS days_between_orders
FROM ecom_orders
ORDER BY customer_id, order_date;

--Q30. [Banking] Use FIRST_VALUE(amount) OVER (PARTITION BY account_id ORDER BY txn_date) to find the FIRST transaction amount for each account.

SELECT 
	account_id,
	FIRST_VALUE(amount) OVER (PARTITION BY account_id ORDER BY txn_date) as first_values
FROM bank_transactions;


--## Questions 31–40: Combined Window Function Challenges

--Q31. [E-Commerce] Show each order with its rank within the customer's order history AND the running total for that customer.

--Q32. [HR] Show each employee's salary, their department's average salary (window), and their rank within the department.

--Q33. [Banking] Show each transaction with the running balance (Credit adds, Debit subtracts). Use SUM with CASE inside OVER.

--Q34. [Healthcare] For each doctor, show the running count of admissions and the latest admission date using LAST_VALUE().

--Q35. [Logistics] Show each shipment with its carrier's average freight_cost (window) and the difference from that average.

--Q36. [E-Commerce] Find customers whose latest order value is HIGHER than their first order value. Use FIRST_VALUE and LAST_VALUE (or LAG with ROW_NUMBER).

--Q37. [HR] Show each employee's performance score, previous year's score (LAG), and the change (current - previous).

--Q38. [Banking] Identify accounts where a transaction amount is MORE than 3x the account's average transaction (use AVG() OVER PARTITION BY account_id).

--Q39. [E-Commerce] Use NTILE(5) to divide all orders into 5 revenue quintiles. Count how many orders fall in each quintile.

--Q40. [Logistics] Show each shipment's freight cost, the MINIMUM cost for that carrier (window), and how much more expensive it is than the min.

--## Questions 41–50: Advanced Window Challenges

--Q41. [E-Commerce] Find the product that was most recently ordered in each category. Use LAST_VALUE() or ROW_NUMBER() with partition.

--Q42. [HR] Find employees who have consistently scored above 7.0 for 3 consecutive years. (Requires LAG twice or CTE approach)

--Q43. [Banking] Find accounts where the balance has been growing (each month's closing balance is greater than the previous — use LAG on balance by date).

--Q44. [Healthcare] Find the doctor whose patient bills have been increasing over time — check if LEAD(total_bill) > LAG(total_bill) trend.

--Q45. [E-Commerce] For each category, show the top 2 products by total sales quantity (use DENSE_RANK on SUM quantity from order_items).

--Q46. [Logistics] Identify the longest streak of on-time deliveries per carrier. (Complex — use ROW_NUMBER trick with is_on_time flag)

--Q47. [Banking] Using window functions, calculate the percentage contribution of each transaction to the account's total transaction volume. (amount / SUM(amount) OVER PARTITION BY account_id)

--Q48. [HR] Show the running headcount (COUNT of employees hired) per department by year using window functions.

--Q49. [E-Commerce] Find the month-over-month revenue growth rate per year. Use LAG on monthly SUM.

--Q50. [All Domains] Multi-domain challenge: Write a query that ranks the top 3 customers by lifetime order value (e-commerce), top 3 patients by total hospital spend (healthcare), and top 3 account holders by balance (banking). UNION ALL the results with a domain label column.
