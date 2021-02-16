/*Create a column that divides the standard_amt_usd by the standard_qty to find
the unit price for standard paper for each order. Limit the results to the first
10 orders, and include the id and account_id fields.*/

SELECT id, account_id, standard_amt_usd/standard_qty
FROM orders
LIMIT 10;

/*NOTEE - you will be thrown an error with the correct solution to this question.
This is for a division by zero. USE CASE to get around the error*/

SELECT id, account_id,
       CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
            ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;
