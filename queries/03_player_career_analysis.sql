-- PART III: PLAYER CAREER ANALYSIS
-- 1. View the players table and find the number of players in the table

select * from players;

select count(distinct playerID)
from players;

-- 2. For each player, calculate their age at their first game, their last game, and their career length (all in years). Sort from longest career to shortest career.
select 	playerID, nameGiven,
        timestampdiff(year, cast(concat(birthYear, '-', birthMonth, '-', birthDay) as date), debut) as age_first_game,
        timestampdiff(year, cast(concat(birthYear, '-', birthMonth, '-', birthDay) as date), finalGame) as age_last_game,
        timestampdiff(year, debut, finalGame) as career_length
from players
where debut is not null
and finalGame is not null
and birthYear is not null
and birthMonth is not null
and birthDay is not null
order by career_length desc;

-- 3. What team did each player play on for their starting and ending years?
with years as
(select playerID, nameGiven, year(debut) as year_first, year(finalGame) as year_last
from players)
select 	y.playerID, nameGiven, year_first, year_last,
		s1.teamID as team_first,
        s2.teamID as team_last
from years y 
inner join salaries s1 on y.playerID = s1.playerID and y.year_first = s1.yearID
inner join salaries s2 on y.playerID = s2.playerID and y.year_last = s2.yearID;

-- 4. How many players started and ended on the same team and also played for over a decade?
with years as
(select playerID, nameGiven, year(debut) as year_first, year(finalGame) as year_last
from players)
select 	count(distinct y.playerID) as start_end_same
from years y 
inner join salaries s1 on y.playerID = s1.playerID and y.year_first = s1.yearID
inner join salaries s2 on y.playerID = s2.playerID and y.year_last = s2.yearID
where s1.teamID = s2.teamID and (year_last - year_first) > 10;