/*U can't use aggregate functions in group by, and u can't use non-aggregate in
select without mentioning it in a group by statement*/

/*For each account, determine the average amount of each type of paper they
purchased across their orders. Your result should have four columns - one for
the account name and one for the average quantity purchased for each of the
paper types for each account.*/

SELECT a.name account_name
       , AVG(o.standard_qty) standard_avg
       , AVG(o.poster_qty) poster_avg
       , AVG(o.gloss_qty) gloss_avg
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/*For each account, determine the average amount spent per order on each paper
type. Your result should have four columns - one for the account name and one
for the average amount spent on each paper type.*/

SELECT a.name account_name
       , AVG(O.standard_amt_usd) standard_usd_avg
       , AVG(o.poster_amt_usd) poster_usd_avg
       , AVG(o.gloss_amt_usd) gloss_usd_avg
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;


/*Determine the number of times a particular channel was used in the web_events
table for each sales rep. Your final table should have three columns - the name
of the sales rep, the channel, and the number of occurrences. Order your table
with the highest number of occurrences first.*/

SELECT s.name, w.channel, COUNT(*) no_events
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
ON w.account_id = a.id
GROUP BY s.name, w.channel
ORDER BY no_events DESC;

/*Determine the number of times a particular channel was used in the web_events
table for each region. Your final table should have three columns - the region
name, the channel, and the number of occurrences. Order your table with the
highest number of occurrences first.*/

SELECT r.name, w.channel, COUNT(*) no_events
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
On w.account_id = a.id
GROUP BY r.name, w.channel
ORDER BY no_events DESC;
