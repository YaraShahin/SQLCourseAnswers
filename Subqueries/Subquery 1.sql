/*find the number of events that occur for each day for each channel.*/

SELECT DATE_TRUNC('day', occurred_at) AS day, w.channel,
       COUNT(w.*) AS num_events
FROM web_events w
GROUP BY 1, 2
ORDER BY 3 DESC;

/*Write a subquery that provides all the data from your first query.*/

SELECT *
FROM(SELECT DATE_TRUNC('day', occurred_at) AS day, w.channel,
     COUNT(w.*) AS num_events
  FROM web_events w
  GROUP BY 1, 2
  ORDER BY 3 DESC) subquery

/*Find the average number of events for each channel.*/

SELECT channel, AVG(num_events) AS avg_events
FROM(SELECT DATE_TRUNC('day', occurred_at) AS day, channel,
     COUNT(*) AS num_events
  FROM web_events
  GROUP BY 1, 2) subquery
GROUP BY 1
ORDER BY 2 DESC;
