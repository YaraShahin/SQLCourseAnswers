/*You need to find the average number of events for each channel per day.*/
/*Using a subquery*/

SELECT channel, DATE_TRUNC('day', occurred_at), COUNT(*) events
FROM web_events
GROUP BY 1,2

SELECT channel, AVG(events)
FROM( SELECT channel, DATE_TRUNC('day', occurred_at), COUNT(*) events
      FROM web_events
      GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2;

/*Using WITH*/

WITH day_table AS (
  SELECT channel, DATE_TRUNC('day', occurred_at), COUNT(*) events
  FROM web_events
  GROUP BY 1,2)


SELECT channel, AVG(events)
FROM day_table
GROUP BY 1
ORDER BY 2 DESC;

/*If we need two or more tables to pull from*/

WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)


SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;
