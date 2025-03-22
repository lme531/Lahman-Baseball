--EXECUTIVE SUMMARY

--This report provides insights into the best pitchers and the top-performing teams in Major League Baseball 
--(MLB) over the last three years using the Lahman Baseball Dataset.
--The analysis relies on key performance metrics, including wins, earned run average (ERA),
--and strikeouts for pitchers, as well as win-loss records for teams.

---------------------------------------------------------------------------------------------------------------------
--BEST PITCHERS ANALYSIS

--To determine the best pitchers, we considered three key metrics:
--Total Wins (W) – Indicates the number of games a pitcher has won.
--Earned Run Average (ERA) – Measures runs allowed per nine innings (lower is better).
--Total Strikeouts (SO) – Higher strikeouts indicate dominance over batters.
-------------------------------------------------------------------------------------------------------------------
SELECT p.nameFirst, 
       p.nameLast, 
       SUM(CAST(pit.W AS INT)) AS total_wins, 
       ROUND(SUM(CAST(pit.ERA AS FLOAT) * CAST(pit.IPouts AS INT)) / NULLIF(SUM(CAST(pit.IPouts AS INT)), 0), 2) AS avg_era, 
       SUM(CAST(pit.SO AS INT)) AS total_strikeouts
FROM people p
JOIN Pitching2 pit ON pit.playerID = p.playerID
GROUP BY pit.playerID, p.nameFirst, p.nameLast
ORDER BY total_wins DESC, avg_era ASC, total_strikeouts DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-----------------------------------------------------------------------------------------------------------------
--Top 3 Teams in the Last 3 Years
--To determine the best teams, we evaluated win percentage over the three most recent seasons.
-----------------------------------------------------------------------------------------------------------------
WITH LatestYears AS (
    SELECT DISTINCT yearID 
    FROM teams
    ORDER BY yearID DESC
    OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY
)
SELECT t.teamID, t.name, t.yearID, 
       t.W AS Wins, t.L AS Losses, 
       ROUND(CAST(t.W AS FLOAT) / NULLIF(t.W + t.L, 0), 3) AS Win_Percentage
FROM teams t
JOIN LatestYears ly ON t.yearID = ly.yearID
ORDER BY Win_Percentage DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-----------------------------------------------------------------------------------------------------------------
--WHY THESE METRICS ARE EFFECTIVE?

--1.Wins and ERA for Pitchers Provide a Balanced View – Wins show a pitcher’s contribution to team success,
--while ERA accounts for effectiveness in preventing runs.
--2.Win Percentage for Teams Measures Performance Accurately 
--The ratio of wins to total games played is a standard benchmark in baseball rankings.
--3.Strikeouts Indicate Pitching Skill – A high strikeout count demonstrates
--a pitcher's ability to overpower batters.

----------------------------------------------------------------------------------------------------------------
--LIMITATION OF THE METRICS
--1.Wins for Pitchers Depend on Team Performance – A great pitcher on a weak 
--team may have fewer wins.
--2.ERA Can Be Influenced by Ballpark and Defense – External factors such 
--as stadium size and fielding quality affect ERA.
--3.Win Percentage May Not Reflect Playoff Performance – A team with a strong 
--record may not necessarily succeed in postseason games.

----------------------------------------------------------------------------------------------------------------
--ADDITIONAL DATA THAT COULD IMPROVE THE ANALYSIS

--1.Advanced Pitching Metrics – Such as WAR (Wins Above Replacement) and 
--FIP (Fielding Independent Pitching) to adjust for external influences.
--2.Team Strength and Playoff Performance – To better gauge true 
--competitiveness beyond the regular season.
--3.Player Consistency Over Multiple Seasons – Averages over more 
--years could provide better long-term insights.

-----------------------------------------------------------------------------------------------------------------
--CONCLUSION

--This report identifies the best MLB pitchers and top-performing teams based on 
--fundamental statistics. While the chosen metrics provide a solid 
--foundation for evaluation, incorporating additional advanced data 
--would enhance accuracy and depth of analysis.