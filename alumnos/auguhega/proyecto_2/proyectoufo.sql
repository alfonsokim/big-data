DROP TABLE IF EXISTS ufosql CASCADE;

CREATE TABLE ufosql (
id int,
datetime timestamp,
date date,
time varchar,
dia varchar,
state varchar,
shape varchar, 
duration varchar);

\copy ufosql (id, datetime, date, time, dia, state, shape, duration) FROM 'dataufo_ar2.csv' with delimiter ',' header csv;


CREATE INDEX datetime_id on ufosql (datetime);
CREATE INDEX dia_id on ufosql (dia);
CREATE INDEX state_id on ufosql (state);
CREATE INDEX shape_id on ufosql (shape);
CREATE INDEX duration_id on ufosql (duration);--No conviene hacerlo por la cantidad de posibles valores


SELECT MIN(date), state FROM ufosql
GROUP BY state
ORDER BY state;

SELECT MIN(date), shape FROM ufosql
GROUP BY shape
ORDER BY shape;

SELECT COUNT(date) AS conteo, extract(month from date) FROM ufosql
GROUP BY extract(month from date)
ORDER BY extract(month from date);

SELECT AVG(count), month
FROM(
	SELECT COUNT(*) AS count, extract(month from date) as month, extract (year from date) as year
	FROM ufosql
	GROUP BY year, month) AS count
GROUP BY month
ORDER BY month;

SELECT AVG(count), year
FROM(
	SELECT COUNT(*) AS count, extract (year from date) as year, extract (month from date) as month 
	FROM ufosql
	GROUP BY year, month) AS count
GROUP BY year
ORDER BY year;


SELECT AVG(count), state
FROM(
      	 SELECT COUNT(*) AS count, state, extract(month from date) as month, extract (year from date) as year 
	 FROM ufosql
	 GROUP BY state, month, year) AS count
GROUP BY state
ORDER BY state;


SELECT stddev(count) as desviacion, state
FROM(
      	 SELECT COUNT(*) AS count, state, extract(month from date) as month, extract (year from date) as year 
	 FROM ufosql
	 GROUP BY state, month, year) AS count
GROUP BY state
ORDER BY desviacion desc;


