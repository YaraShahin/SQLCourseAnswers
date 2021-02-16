/*Each company in the accounts table wants to create an email address for each
primary_poc. The email address should be the first name of the primary_poc .
last name primary_poc @ company name .com.*/

SELECT name, LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) first_name,
       RIGHT(primary_poc, LENGTH("primary_poc") - STRPOS(primary_poc, ' ')) last_name
FROM accounts

SELECT first_name, last_name,
       CONCAT(t1.first_name, '.', t1.last_name, '@', name, '.com')
FROM(SELECT name, LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) first_name,
            RIGHT(primary_poc, LENGTH("primary_poc") - STRPOS(primary_poc, ' ')) last_name
     FROM accounts) t1;

/*You may have noticed that in the previous solution some of the company names
include spaces, which will certainly not work in an email address. See if you
can create an email address that will work by removing all of the spaces in the
account name, but otherwise your solution should be just as in question 1. Some
helpful documentation is here.*/

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) first_name,
            RIGHT(primary_poc, LENGTH("primary_poc") - STRPOS(primary_poc, ' ')) last_name,
            REPLACE(a.name, ' ', '') company
FROM accounts

SELECT first_name, last_name,
       CONCAT(t1.first_name, '.', t1.last_name, '@', t1.company, '.com') email
FROM(SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) first_name,
            RIGHT(primary_poc, LENGTH("primary_poc") - STRPOS(primary_poc, ' ')) last_name,
            REPLACE(name, ' ', '') company
     FROM accounts) t1;

/*We would also like to create an initial password, which they will change after
their first log in. The first password will be the first letter of the
primary_poc's first name (lowercase), then the last letter of their first name
(lowercase), the first letter of their last name (lowercase), the last letter
of their last name (lowercase), the number of letters in their first name, the
number of letters in their last name, and then the name of the company they are
working with, all capitalized with no spaces.*/

WITH t1 AS (
  SELECT LOWER(LEFT(primary_poc, 1)) one,
         LOWER(RIGHT(LEFT(primary_poc, STRPOS(primary_poc,' ')-1),1)) two,
         LOWER(RIGHT(LEFT(primary_poc, STRPOS(primary_poc,' ')+1),1)) three,
         LOWER(RIGHT(primary_poc, 1)) four,
         LENGTH(LEFT(primary_poc, STRPOS(primary_poc,' ')-1)) five,
         LENGTH(RIGHT(primary_poc, LENGTH(primary_poc)- LENGTH(LEFT(primary_poc,
         STRPOS(primary_poc,' ')-1))-1)) six,
         UPPER(REPLACE(name, ' ', '')) seven
  FROM accounts)

SELECT CONCAT(one, two, three, four, five, six, seven)
FROM t1;
