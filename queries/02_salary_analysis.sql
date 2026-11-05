-- PART II: SALARY ANALYSIS
-- 1. View the salaries table

select * from salaries;

-- 2. Return the top 20% of teams in terms of average annual spending

-- using row num
with total_sal as (
select 	teamID, yearID,
		sum(salary) as total_salary
from salaries
group by teamID, yearID),
rn as (select 	teamID,
		round(avg(total_salary),2) as avg_annual_sal,
        row_number() over(order by avg(total_salary) desc) as row_num
from total_sal
group by teamID)
select teamID, avg_annual_sal
from rn
where row_num <= (select ceil(max(row_num) * 0.2) from rn);

-- using ntile
with total_sal as (
select 	teamID, yearID,
		sum(salary) as total_salary
from salaries
group by teamID, yearID),
sp as (select 	teamID,
		round(avg(total_salary),2) as avg_annual_sal,
        ntile(5) over(order by avg(total_salary) desc) as sal_perc
from total_sal
group by teamID)
select teamID, avg_annual_sal
from sp
where sal_perc = 1;

-- 3. For each team, show the cumulative sum of spending over the years

with total_sal as
(select teamID, yearID, sum(salary) as total_salary
from salaries
group by teamID, yearID)
select 	teamID, yearID, total_salary, 
		sum(total_salary) over(partition by teamID order by yearID) as cum_sum
from total_sal;

-- 4. Return the first year that each team's cumulative spending surpassed 1 billion

with total_sal as
(select teamID, yearID, sum(salary) as total_salary
from salaries
group by teamID, yearID),
cs as
(select 	teamID, yearID, total_salary, 
		sum(total_salary) over(partition by teamID order by yearID) as cum_sum
from total_sal),
rn as 
(select 	teamID, yearID, cum_sum,
		row_number() over(partition by teamID order by yearID) as row_num
from cs
where cum_sum >= 1000000000)
select teamID, yearID, cum_sum
from rn
where row_num = 1
order by yearID, teamID;