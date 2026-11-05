-- PART IV: PLAYER COMPARISON ANALYSIS
-- 1. View the players table

select * from players; 

-- 2. Which players have the same birthday?

-- same full birth dates (including year)
with birth_dates as
(select  playerID, nameGiven,
		cast(concat(birthYear, '-', birthMonth, '-', birthDay) as date) as full_bdate
from players)
select full_bdate, group_concat(nameGiven)
from birth_dates
where full_bdate is not null
and year(full_bdate) between 1980 and 1990
group by full_bdate
having count(nameGiven) > 1
order by full_bdate;

-- same birth dates (only month and day)
select concat(birthMonth, '/', birthDay), group_concat(nameGiven order by nameGiven) as players
from players
where birthMonth is not null
  and birthDay is not null
group by birthMonth, birthDay
having count(distinct playerID) > 1
order by birthMonth, birthDay;

-- 3. Create a summary table that shows for each team, what percent of players bat right, left and both
with team_players as (
    select distinct teamID, playerID
    from salaries)
select
    tp.teamID,
    round(count(case when p.bats = 'R' then p.playerID end) / count(p.playerID) * 100, 2) as bat_right,
    round(count(case when p.bats = 'L' then p.playerID end) / count(p.playerID) * 100, 2) as bat_left,
    round(count(case when p.bats = 'B' then p.playerID end) / count(p.playerID) * 100, 2) as bat_both
from team_players tp
join players p on tp.playerID = p.playerID
group by tp.teamID;

-- 4. How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?

with debut_wh as
(select floor(year(debut)/10)*10 as decades,
        avg(weight) as avg_weight, 
        avg(height) as avg_height
from players
where debut is not null
group by decades)
select 	decades, 
		round(avg_weight,1) as avg_weight,
		round(avg_weight - lag(avg_weight) over(order by decades),1) as dod_weight,
		round(avg_height,1) as avg_height,
        round(avg_height - lag(avg_height) over(order by decades),1) as dod_height
from debut_wh;