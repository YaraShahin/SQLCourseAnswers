/*Top 10 rows*/

SELECT *
FROM sf_crime_data
LIMIT 10;

/*put the date in the correct format*/

/*MY FIRST ANSWER*/
SELECT t2.correct_date :: date AS final_date
FROM(
SELECT CONCAT(t1.filter_year, '-', t1.filter_month, '-', t1.filter_day) correct_date
FROM(
SELECT SUBSTR(s.date, 1, 2) filter_month, SUBSTR(s.date, 4, 2) filter_day,
       SUBSTR(s.date, 7, 4) filter_year
FROM sf_crime_data s) t1) t2;

/*MODEL ANSWER*/

SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;

/*MY FINAL ANSWER*/

SELECT CONCAT(SUBSTR(s.date, 7, 4), '-', SUBSTR(s.date, 1, 2), '-', SUBSTR(s.date, 4, 2)) str_date
FROM sf_crime_data s;

/*convert the correct date formate from string to date*/

SELECT t1.str_date :: date AS date_date
FROM(
  SELECT CONCAT(SUBSTR(s.date, 7, 4), '-', SUBSTR(s.date, 1, 2), '-', SUBSTR(s.date, 4, 2)) str_date
  FROM sf_crime_data s)t1;
