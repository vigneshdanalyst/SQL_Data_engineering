--1) Show each transaction with the account holder's name, city, transaction type, amount, and date.

SELECT a.holder_name,
	   a.city,
	   t.txn_type,
	   t.amount,
	   t.txn_date
FROM account_holders AS a 
INNER JOIN transactions AS t 
ON a.holder_id = t.holder_id;

--2)Find total Credits and total Debits per account holder. Display holder name, total credited, total debited.

SELECT a.holder_name,
		t.txn_type,
		COUNT(t.txn_type) As counts
FROM account_holders AS a
INNER JOIN transactions AS t
ON a.holder_id = t.holder_id 
GROUP BY a.holder_name,t.txn_type;


--3) Show only Debit transactions above ₹10,000. Display holder name, city, amount, and date.

SELECT a.holder_name,
	   a.city,
	   t.amount,
	   t.txn_date
FROM account_holders AS a 
INNER JOIN transactions as t
ON a.holder_id = t.holder_id 
WHERE t.txn_type = 'Debit' 
	  AND t.amount > 10000;



--4) Find the city with the highest total transaction volume (Credits + Debits combined).

SELECT a.city, 
	   SUM(t.amount) AS total_amount 
FROM account_holders AS a 
INNER JOIN transactions as t
ON a.holder_id = t.holder_id 
GROUP BY a.city 
ORDER BY total_amount DESC 
LIMIT 1;

--5) Rank account holders by total Credit amount, highest first.

SELECT a.holder_name,
	   SUM(t.amount) AS total_amount
FROM account_holders AS a 
INNER JOIN transactions AS t 
ON a.holder_id = t.holder_id 
WHERE t.txn_type = 'Credit'
GROUP BY a.holder_name
ORDER BY total_amount DESC;
