/*Q1 Use the Invoice table to determine the countries that have the most invoices.
Provide a table of BillingCountry and Invoices ordered by the number of invoices
for each country. The country with the most invoices should appear first.*/

SELECT BillingCountry, COUNT(i.Total)
FROM Invoice i
GROUP BY 1
ORDER BY 2 DESC;

/*Q2 We would like to throw a promotional Music Festival in the city we made the
most money. Write a query that returns the 1 city that has the highest sum of
invoice totals. Return both the city name and the sum of all invoice totals.*/
/*The top city for Invoice dollars was Prague with an amount of 90.24*/

SELECT BillingCity, SUM(i.Total)
FROM Invoice i
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

/*Q3 The customer who has spent the most money will be declared the best customer.
Build a query that returns the person who has spent the most money. I found the
solution by linking the following three: Invoice, InvoiceLine, and Customer
tables to retrieve this information, but you can probably do it with fewer!*/
/*The customer who spent the most according to invoices was Customer 6 with
49.62 in purchases.*/

SELECT c.CustomerId, c.FirstName, c.LastName, SUM(i.Total) AS Invoices
FROM Customer c
JOIN Invoice i
ON i.CustomerId = c.CustomerId
GROUP BY 1
ORDER BY 4 DESC
LIMIT 1;

/*Q4 The team at Chinook would like to identify all the customers who listen to
Rock music. Write a query to return the email, first name, last name, and Genre
of all Rock Music listeners. Return your list ordered alphabetically by email
address starting with 'A'.*/
/*Your final table should have 59 rows and 4 columns.*/

SELECT c.Email, c.FirstName, c.LastName, g.Name
FROM Customer c
JOIN Invoice i
ON i.CustomerId = c.CustomerId
JOIN InvoiceLine l
ON l.InvoiceId = i.InvoiceId
JOIN Track t
ON t.TrackId = l.TrackId
JOIN Genre g
ON g.GenreId = t.GenreId
WHERE g.Name = "Rock"
GROUP BY 1
ORDER BY 1;

/*Q5 Write a query that determines the customer that has spent the most on music
for each country. Write a query that returns the country along with the top
customer and how much they spent. For countries where the top amount spent is
shared, provide all customers who spent this amount.
You should only need to use the Customer and Invoice tables.*/
/*Though there are only 24 countries, your query should return 25 rows because 
the United Kingdom has 2 customers that share the maximum.*/

WITH t1 AS (SELECT c.CustomerId, c.FirstName, c.LastName, i.BillingCountry, SUM(i.Total) total
            FROM Customer c
            JOIN Invoice i
            ON i.CustomerId = c.CustomerId
            GROUP BY 1,2,3,4),
     t2 AS (SELECT BillingCountry, MAX(total) total
            FROM t1
            GROUP BY 1)

SELECT t1.CustomerId, t1.FirstName, t1.LastName, t1.BillingCountry AS Country, t2.total AS TotalSpent
FROM t1
JOIN t2
ON t1.total = t2.total AND t1.BillingCountry = t2.BillingCountry
ORDER BY 4;
