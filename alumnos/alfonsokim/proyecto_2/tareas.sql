\d sightings;
select count(distinct state_str) from sightings;
\d
select * from state;
select * from sightings a where a.state_str not in (select distinct abbreviation from state);
select count(*) from sightings a where a.state_str not in (select distinct abbreviation from state);
select count(*) from sightings;
select * from sightings into sightings_not_usa a where a.state_str not in (select distinct abbreviation from state);
select * into sightings_not_usa from sightings a where a.state_str not in (select distinct abbreviation from state);
select distinct a.state_str from sightings_not_usa a;
select a.state_str, count(*) from sightings_not_usa a group by 1 order by 2;
select * into sightings_full from sightings;
delete rom sightings a where a.state_str not in (select distinct abbreviation from state);
delete from sightings a where a.state_str not in (select distinct abbreviation from state);
\d sightings;
select min(date_time), max(date_time) from sightings;
select * from sightings where date_time >= now();
select date_time from sightings where date_time >= now();
alter table sightings add date_time_fix datetime with time zone;
\d sightings;
alter table sightings add date_time_fix add timestamp with time zone;
alter table sightings add date_time_fix timestamp with time zone;
update sightings set date_time_fix case when date_time <= now() then date_time else date_time - interval '100 year' end;
update sightings set date_time_fix = case when date_time <= now() then date_time else date_time - interval '100 year' end;
select min(date_time_fix), max(date_time_fix) from sightings;
select count(*) from sightings where date_time_fix is null;
alter sightings rename date_time to date_time_old;
alter table sightings rename date_time to date_time_old;
alter table sightings rename date_fix to date_time;
alter table sightings rename date_time_fix to date_time;
select min(date_time), max(date_time) from sightings;
create index idx_sightings_datetime on sightings (date_time);
\d sightings;
create index idx_sightings_sate on sightings (state_str);
select min(date_time), max(date_time) from sightings;
analyze select min(date_time), max(date_time) from sightings;
explain select min(date_time), max(date_time) from sightings;


===== Analisis =====

== Primer avistamiento

WITH sigths AS (
    SELECT state_str, date_time, ROW_NUMBER() 
      OVER(PARTITION BY state_str ORDER BY date_time) AS rk
      FROM sightings p
      WHERE date_time > '1900-01-01 00:00:00')
SELECT s.*
  FROM sigths s
 WHERE s.rk = 1;

== Ultimo avistamiento

WITH sigths AS (
    SELECT state_str, date_time, ROW_NUMBER() 
      OVER(PARTITION BY state_str ORDER BY date_time DESC) AS rk
      FROM sightings p
      WHERE date_time > '1900-01-01 00:00:00')
SELECT s.*
  FROM sigths s
 WHERE s.rk = 1;

=== Conteo de avistamientos

== Por mes
select extract(month from date_time), count(*) from sightings group by 1 order by 1;

== Por año
select extract(year from date_time), count(*) from sightings group by 1 order by 1;

== Por estado
select state_str, count(*) from sightings group by 1 order by 2;

=== Promedios al mes por estado 
with conteos as (select state_str, extract(month from date_time) as mes, 
                 count(*) as total from sightings group by 1, 2) 
select state_str, mes, avg(total) from conteos group by 1, 2 order by 1, 2;


=== Promedios al año por estado 
with conteos as (select state_str, extract(year from date_time) as anio, 
                    count(*) as total from sightings group by 1, 2) 
select state_str, anio, avg(total) from conteos group by 1, 2 order by 1, 2;

=== Encontrar olas
select date_time::date as dia, count(*) 
from sightings group by 1 order by 1;

=== Similaridad
select similarity(s1.report, s2.report) as sim, 
       s1.report as r1, s2.report as r2 
into similar_reports
from sightings s1 
     join sightings s2 on s1.report <> s2.report 
                      and s1.report % s2.report 
where similarity(s1.report, s2.report) >= 0.5
order by sim desc;
