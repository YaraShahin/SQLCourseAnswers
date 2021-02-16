/*Use DISTINCT to test if there are any accounts associated with more than one
region.*/
/*the following two query return 351 results, meaning that there r no accounts
with two or more regions. If there were, the second query would have less rows
than the first.*/

SELECT r.name reg_name, a.name acc_name
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON s.region_id = r.id;

SELECT DISTINCT accounts.name
FROM accounts;

/*Have any sales reps worked on more than one account*/
/*the first query returns 351, the second only 50. So, there are more than one
sale_rep working on more than an account.*/
SELECT a.name acc_name, s.name sales_reps_name
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id;

SELECT DISTINCT sales_reps.name
FROM salea_reps

/*Another way to solve the second question*/

SELECT s.name, COUNT(a.*) num_accounts
FROM sales_reps s
JOIN accounts a
On s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY num_accounts;
