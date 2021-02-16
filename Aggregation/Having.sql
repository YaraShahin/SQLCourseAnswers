/*How many of the sales reps have more than 5 accounts that they manage?*/

SELECT COUNT(a.*), s.name
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name
HAVING COUNT(a.*) > 5
ORDER BY COUNT(a.*) DESC;

/*OR*/

SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;

/*How many accounts have more than 20 orders?*/

SELECT a.name, COUNT(o.*)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
HAVING COUNT(o.*) > 20
ORDER BY COUNT(o.*) DESC;

/*Which account has the most orders?*/

SELECT a.name, COUNT(o.*)
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY COUNT(o.*) DESC
LIMIT 1;

/*Which accounts spent more than 30,000 usd total across all orders?*/

SELECT a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY SUM(o.total_amt_usd) DESC;

/*Which accounts spent less than 1,000 usd total across all orders?*/

SELECT a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY SUM(o.total_amt_usd) DESC;

/*Which account has spent the most with us?*/

SELECT a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC
LIMIT 1;

/*Which account has spent the least with us?*/

SELECT a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd)
LIMIT 1;

/*Which accounts used facebook as a channel to contact customers more than 6 times?*/

SELECT a.name, COUNT(w.*)
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING COUNT(w.*) > 6 AND w.channel = 'facebook'
ORDER BY COUNT(w.*) DESC;

/*Which account used facebook most as a channel?*/

SELECT a.name, COUNT(w.*)
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY a.name, w.channel
HAVING w.channel = 'facebook'
ORDER BY COUNT(w.*) DESC
LIMIT 1;

/*Which channel was most frequently used by most accounts?*/

SELECT w.channel, COUNT(w.*)
FROM web_events w
GROUP BY w.channel
ORDER BY COUNT(w.*) DESC
LIMIT 1;

/*OR*/

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;
