/*Provide the name of the sales_rep in each region with the largest amount of
total_amt_usd sales.*/

SELECT s.name sales_rep, r.name region, SUM(o.total_amt_usd) total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY 1, 2
ORDER BY 3 DESC

SELECT region, MAX(total_usd)
FROM (SELECT s.name sales_rep, r.name region, SUM(o.total_amt_usd) total_usd
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  JOIN sales_reps s
  ON a.sales_rep_id = s.id
  JOIN region r
  ON s.region_id = r.id
  GROUP BY 1, 2
  ORDER BY 3 DESC) t1
GROUP BY 1

SELECT t3.sales_rep, t3.region, t3.total_usd
FROM(SELECT region, MAX(total_usd) total_usd
  FROM (SELECT s.name sales_rep, r.name region, SUM(o.total_amt_usd) total_usd
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
    JOIN sales_reps s
    ON a.sales_rep_id = s.id
    JOIN region r
    ON s.region_id = r.id
    GROUP BY 1, 2) t1
  GROUP BY 1) t2
JOIN(SELECT s.name sales_rep, r.name region, SUM(o.total_amt_usd) total_usd
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  JOIN sales_reps s
  ON a.sales_rep_id = s.id
  JOIN region r
  ON s.region_id = r.id
  GROUP BY 1, 2
  ORDER BY 3 DESC) t3
ON t2.total_usd = t3.total_usd AND t2.region = t3.region;

/*For the region with the largest (sum) of sales total_amt_usd, how many total
(count) orders were placed?*/

SELECT r.name region, COUNT(o.*), SUM(o.total_amt_usd) total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1;
/*OR*/
SELECT r.name region, SUM(o.total_amt_usd) total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY 1

SELECT MAX(total_usd)
FROM(SELECT r.name region, SUM(o.total_amt_usd) total_usd
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  JOIN sales_reps s
  ON a.sales_rep_id = s.id
  JOIN region r
  ON s.region_id = r.id
  GROUP BY 1) t1

SELECT r.name region, COUNT(o.*)
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (
  SELECT MAX(total_usd)
  FROM( SELECT r.name region, SUM(o.total_amt_usd) total_usd
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
    JOIN sales_reps s
    ON a.sales_rep_id = s.id
    JOIN region r
    ON s.region_id = r.id
    GROUP BY 1) t1
  );

/*How many accounts had more total purchases than the account name which has
bought the most standard_qty paper throughout their lifetime as a customer?*/

SELECT a.name acc, SUM(o.standard_qty) qty, SUM(o.total) num_orders
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

SELECT a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (SELECT num_orders
      FROM(SELECT a.name acc, SUM(o.standard_qty) qty, SUM(o.total) num_orders
          FROM orders o
          JOIN accounts a
          ON a.id = o.account_id
          GROUP BY 1
          ORDER BY 2 DESC
          LIMIT 1
          ) sub1)

SELECT COUNT(sub2.*)
FROM (
  SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT num_orders
        FROM(SELECT a.name acc, SUM(o.standard_qty) qty, SUM(o.total) num_orders
            FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1
            ) sub1)
) sub2;

/*For the customer that spent the most (in total over their lifetime as a
customer) total_amt_usd, how many web_events did they have for each channel?*/

SELECT a.id, a.name, SUM(o.total_amt_usd) thetot
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN web_events w
ON w.account_id = a.id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 1

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
AND a.id = (SELECT id
            FROM( SELECT a.id, a.name, SUM(o.total_amt_usd) thetot
                  FROM orders o
                  JOIN accounts a
                  ON a.id = o.account_id
                  GROUP BY a.id, a.name
                  ORDER BY 3 DESC
                  LIMIT 1)sub)
GROUP BY 1,2
ORDER BY 3 DESC;

/*What is the lifetime average amount spent in terms of total_amt_usd for the
top 10 total spending accounts?*/

SELECT a.id, a.name, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1,2
ORDER BY total DESC
LIMIT 10

SELECT AVG(total)
FROM( SELECT a.id, a.name, SUM(o.total_amt_usd) total
      FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY 1,2
      ORDER BY total DESC
      LIMIT 10) sub;

/*If they want the average total for each of the most spending accounts
individually*/

SELECT a.name, AVG(o.total_amt_usd)
FROM(SELECT a.id, a.name, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1,2
ORDER BY total DESC
LIMIT 10) sub
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/*What is the lifetime average amount spent in terms of total_amt_usd,
including only the companies that spent more per order, on average, than the
average of all orders.*/

SELECT AVG(total_amt_usd)
FROM orders

SELECT a.id, a.name, AVG(o.total_amt_usd) average
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1,2
HAVING AVG(o.total_amt_usd) >  (SELECT AVG(total_amt_usd)
                                FROM orders)

SELECT AVG(average)
FROM( SELECT a.id, a.name, AVG(o.total_amt_usd) average
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1,2
      HAVING AVG(o.total_amt_usd) >  (SELECT AVG(total_amt_usd)
                                      FROM orders)
    )sub;

/*I'm a coding MANIAC rn. I'm on fire*/
