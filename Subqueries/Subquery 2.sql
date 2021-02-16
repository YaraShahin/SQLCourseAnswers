/*Get the month info about the first order ever places in the orders table.*/

SELECT MIN(DATE_TRUNC('month', occurred_at))
FROM orders;

/*Find only the orders of the same month and year as the first order, and pull
the average of each type of paper quantity of this month.*/

SELECT AVG(standard_qty) standard_avg, AVG(poster_qty) poster_avg,
       AVG(gloss_qty) gloss_avg, SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
      (SELECT MIN(DATE_TRUNC('month', occurred_at))
      FROM orders);
