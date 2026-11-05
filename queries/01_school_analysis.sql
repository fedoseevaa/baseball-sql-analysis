-- PART I: SCHOOL ANALYSIS
-- 1. View the schools and school details tables

select * from schools;
select * from school_details;

-- 2. In each decade, how many schools were there that produced players?
select yearID from schools
group by yearID
order by yearID;

select   floor(yearID/10)*10 as decades, count(distinct schoolID) num_schools
from schools
group by decades
order by decades;


-- 3. What are the names of the top 5 schools that produced the most players?

select sd.name_full, count(distinct playerID) as num_players
from schools sch join school_details sd 
on sch.schoolID = sd.schoolID
group by sd.schoolID
order by count(distinct playerID) desc
limit 5;


-- 4. For each decade, what were the names of the top 3 schools that produced the most players?
with ds as (
select 	floor(yearID/10)*10 as decades, 
		sd.name_full as school_name, 
		count(distinct playerID) as num_players
from schools sch join school_details sd 
on sch.schoolID = sd.schoolID
group by decades, sd.schoolID),
rn as(
select 	*, 
		row_number() over (partition by decades order by num_players desc) as rn
from ds)
select decades, school_name from rn
where rn <= 3;