/*notice the row with the missing data*/

SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/*Use Coalesce to fill in the accounts.id column with the account.id for the NULL
value in the previous table.*/

SELECT *, COALESCE(a.id, '0')
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/*this would do the same thing btw*/

SELECT *, a.id modified_id
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/*Model answer*/

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat,
       a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/*Use Coalesce to fill in the orders.accounts_id column with the account.id for
the NULL value in the first table*/

SELECT COALESCE(a.id, a.id) filled_a_id, a.name, a.website, a.lat,
       a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) filled_o_id,
       o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total,
       o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/*Use COALESCE to fill the null values of the columns qty & usd from table 1
with 0*/

SELECT COALESCE(a.id, a.id) filled_a_id, a.name, a.website, a.lat,
       a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) filled_o_id,
       o.occurred_at, COALESCE(o.standard_qty, '0') modified_standard_qty,
       COALESCE(o.gloss_qty, '0') modified_gloss_qty,
       COALESCE(o.poster_qty, '0') modified_poster_qty,
       COALESCE(o.total, '0') modified_total,
       COALESCE(o.standard_amt_usd, '0') modified_standard_usd,
       COALESCE(o.gloss_amt_usd, '0') modified_gloss_usd,
       COALESCE(o.poster_amt_usd, '0') modified_poster_usd,
       COALESCE(o.total_amt_usd, '0') modified_total_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/*run the first query without the where and count the ids*/

SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

/*Run the previous query but with the COALESCE used in the previous questions*/

SELECT COALESCE(a.id, a.id) filled_a_id, a.name, a.website, a.lat,
       a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) filled_o_id,
       o.occurred_at, COALESCE(o.standard_qty, '0') modified_standard_qty,
       COALESCE(o.gloss_qty, '0') modified_gloss_qty,
       COALESCE(o.poster_qty, '0') modified_poster_qty,
       COALESCE(o.total, '0') modified_total,
       COALESCE(o.standard_amt_usd, '0') modified_standard_usd,
       COALESCE(o.gloss_amt_usd, '0') modified_gloss_usd,
       COALESCE(o.poster_amt_usd, '0') modified_poster_usd,
       COALESCE(o.total_amt_usd, '0') modified_total_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
