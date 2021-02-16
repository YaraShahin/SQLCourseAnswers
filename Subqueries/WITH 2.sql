/*Provide the name of the sales_rep in each region with the largest amount of
total_amt_usd sales.*/

SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total
FROM orders o
JOIN accounts a
ON a.id=o.account_id
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN region r
ON r.id = s.region_id
GROUP BY 1,2
ORDER BY 3 DESC

SELECT region, MAX(total) maxi
FROM( SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total
      FROM orders o
      JOIN accounts a
      ON a.id=o.account_id
      JOIN sales_reps s
      ON a.sales_rep_id=s.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2 DESC

SELECT t1.rep, t2.region, t2.maxi
FROM( SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total
      FROM orders o
      JOIN accounts a
      ON a.id=o.account_id
      JOIN sales_reps s
      ON a.sales_rep_id=s.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY 1,2
      ORDER BY 3 DESC) t1
JOIN( SELECT region, MAX(total) maxi
      FROM( SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total
            FROM orders o
            JOIN accounts a
            ON a.id=o.account_id
            JOIN sales_reps s
            ON a.sales_rep_id=s.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1,2) t1
      GROUP BY 1) t2
ON t1.total = t2.maxi
ORDER BY 3 DESC;

/*WITH*/

WITH t1 AS (SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total
            FROM orders o
            JOIN accounts a
            ON a.id=o.account_id
            JOIN sales_reps s
            ON a.sales_rep_id=s.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1,2),
      t2 AS(SELECT region, MAX(total) maxi
            FROM t1
            GROUP BY 1)
SELECT t1.rep, t2.region, t2.maxi
FROM t1
JOIN t2
ON t1.total = t2.maxi
ORDER BY 3 DESC;

/*For the region with the largest sales total_amt_usd, how many total orders
were placed?*/

SELECT r.name region, SUM(o.total_amt_usd) total
FROM orders o
JOIN accounts a
ON a.id=o.account_id
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN region r
ON r.id = s.region_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

SELECT r.name, COUNT(o.*)
FROM orders o
JOIN accounts a
ON a.id=o.account_id
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN region r
ON r.id = s.region_id
WHERE r.name=(SELECT region
              FROM( SELECT r.name region, SUM(o.total_amt_usd) total
                    FROM orders o
                    JOIN accounts a
                    ON a.id=o.account_id
                    JOIN sales_reps s
                    ON a.sales_rep_id=s.id
                    JOIN region r
                    ON r.id = s.region_id
                    GROUP BY 1
                    ORDER BY 2 DESC
                    LIMIT 1) t1) t2
GROUP BY 1;

/*WITH*/

WITH t1 AS (SELECT r.name region, SUM(o.total_amt_usd) total
            FROM orders o
            JOIN accounts a
            ON a.id=o.account_id
            JOIN sales_reps s
            ON a.sales_rep_id=s.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1)
SELECT r.name, COUNT(o.*)
FROM orders o
JOIN accounts a
ON a.id=o.account_id
JOIN sales_reps s
ON a.sales_rep_id=s.id
JOIN region r
ON r.id = s.region_id
WHERE r.name=(SELECT region FROM t1)
GROUP BY 1;

/*How many accounts had more total purchases than the account name which has
bought the most standard_qty paper throughout their lifetime as a customer?*/

WITH t1 AS (SELECT a.name, SUM(o.standard_qty) total, SUM(o.total) purchases
            FROM accounts a
            JOIN orders o
            ON a.id=o.account_id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1),
     t2 AS (SELECT a.name
            FROM accounts a
            JOIN orders o
            ON a.id=o.account_id
            GROUP BY 1
            HAVING SUM(o.total) > (SELECT purchases FROM t1))
SELECT COUNT(t2.*)
FROM t2;

/*For the customer that spent the most (in total over their lifetime as a
customer) total_amt_usd, how many web_events did they have for each channel?*/

WITH t1 AS (SELECT a.id id, SUM(o.total_amt_usd)
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1)

SELECT w.channel, COUNT(w.*)
FROM web_events w
JOIN t1
ON t1.id = w.account_id
GROUP BY 1
ORDER BY 2 DESC;

/*What is the lifetime average amount spent in terms of total_amt_usd for the
top 10 total spending accounts?*/

SELECT a.id, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

SELECT AVG(total)
FROM(SELECT a.id, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10) t1;

/*WITH*/
WITH t1 AS (SELECT a.id, SUM(o.total_amt_usd) total
            FROM accounts a
            JOIN orders o
            ON o.account_id = a.id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 10)
SELECT AVG(total)
FROM t1;

/*What is the lifetime average amount spent in terms of total_amt_usd,
including only the companies that spent more per order, on average, than the
average of all orders.*/

WITH t1 AS (SELECT AVG(o.total_amt_usd) one_avg
            FROM orders o),

     t2 AS (SELECT a.id, AVG(o.total_amt_usd) many_avgs
            FROM orders o
            JOIN accounts a
            ON o.account_id = a.id
            GROUP BY 1
            HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(t2.many_avgs)
FROM t2;
