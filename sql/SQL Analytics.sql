-- SQL query to show player name, club name, and total goals for all players who have scored goals, sorted by goals in descending order.
SELECT dp.player_name, dc.club_name, f.goals
FROM fact_player_goals_total f
JOIN dim_player dp
	ON f.player_id = dp.player_id
JOIN dim_club dc
	ON f.club_id = dc.club_id
ORDER BY f.goals DESC;

-- SQL query to show total goals scored by each club, sorted by total goals in descending order.
SELECT dc.club_name, SUM(f.goals) as total_goals
FROM fact_player_goals_total f
JOIN dim_club dc
	ON f.club_id = dc.club_id
GROUP BY dc.club_name
ORDER BY total_goals DESC;

-- SQL query to show clubs that have scored more than 500 total goals, sorted by total goals descending.
SELECT
  dc.club_name,
  SUM(f.goals) AS total_goals
FROM fact_player_goals_total f
JOIN dim_club dc
  ON f.club_id = dc.club_id
GROUP BY dc.club_name
HAVING SUM(f.goals) > 500
ORDER BY total_goals DESC;

-- SQL query to find top 3 goal-scoring players for each club based on total goals.
SELECT club_name, player_name, goals, position
FROM (
  SELECT dc.club_name, dp.player_name, f.goals,
    DENSE_RANK() OVER (
      PARTITION BY dc.club_name
      ORDER BY f.goals DESC
    ) AS position
  FROM fact_player_goals_total f
  JOIN dim_player dp
    ON f.player_id = dp.player_id
  JOIN dim_club dc
    ON f.club_id = dc.club_id
) ranked_players
WHERE position <= 3
ORDER BY club_name, position;

/* Write an SQL query to show for each club:
	total goals
	number of players who scored goals
	average goals per scoring player */
SELECT
  dc.club_name,
  SUM(f.goals) AS total_goals,
  COUNT(f.player_id) AS player_count,
  ROUND(AVG(f.goals), 2) AS avg_goals_per_player
FROM fact_player_goals_total f
JOIN dim_club dc
  ON f.club_id = dc.club_id
GROUP BY dc.club_name
ORDER BY total_goals DESC;
    
-- SQL query to show club name and total points, ordered by points descending.
SELECT dc.club_name, f.points
FROM dim_club dc
JOIN fact_club_all_time_performance f
	ON dc.club_id = f.club_id
ORDER BY f.points DESC;

-- SQL query to show clubs that have won more than 10 titles, along with their club name and titles, ordered by titles descending.
SELECT dc.club_name, f.titles
FROM dim_club dc
JOIN fact_club_all_time_performance f
	ON dc.club_id = f.club_id
WHERE f.titles > 10
ORDER BY f.titles DESC;

-- SQL query to show club name, goal difference, and average goals per match, ordered by average goals per match descending.
SELECT dc.club_name, f.goal_diff, (f.goals_for * 1.0 / f.played) as avg_goals_per_match
FROM dim_club dc
JOIN fact_club_all_time_performance f
	ON dc.club_id = f.club_id
ORDER BY avg_goals_per_match DESC;

-- SQL query to rank clubs by points (highest points = position 1).
SELECT dc.club_name, f.points, 
	DENSE_RANK() OVER (ORDER BY f.points DESC) AS position
FROM dim_club dc
JOIN fact_club_all_time_performance f
	ON dc.club_id = f.club_id
ORDER BY position;

-- SQL query to show coach name, club name, and total appearances, ordered by appearances descending.
SELECT dco.coach_name, dcl.club_name, f.appearances
FROM fact_coach_appearances_total f
JOIN dim_coach dco
	ON f.coach_id = dco.coach_id
JOIN dim_club dcl
	ON f.club_id = dcl.club_id
ORDER BY f.appearances DESC;

-- SQL query to show total appearances per coach across all clubs, ordered by total appearances descending.
SELECT dc.coach_name, SUM(f.appearances) AS total_appearances
FROM dim_coach dc
JOIN fact_coach_appearances_total f
	ON dc.coach_id = f.coach_id
GROUP BY dc.coach_name
ORDER BY total_appearances DESC;

-- SQL query to find the top 2 clubs for each coach based on appearances.
SELECT
  coach_name,
  club_name,
  appearances,
  position
FROM (
  SELECT
    dco.coach_name,
    dcl.club_name,
    f.appearances,
    DENSE_RANK() OVER (
      PARTITION BY dco.coach_name
      ORDER BY f.appearances DESC
    ) AS position
  FROM fact_coach_appearances_total f
  JOIN dim_coach dco
    ON f.coach_id = dco.coach_id
  JOIN dim_club dcl
    ON f.club_id = dcl.club_id
) ranked_clubs
WHERE position <= 2
ORDER BY coach_name, position;

-- SQL query to show season and total goals, ordered by total goals descending.
SELECT ds.season, f.total_goals
FROM fact_season_goal_statistics f
JOIN dim_season ds
	ON f.season_id = ds.season_id
ORDER BY f.total_goals DESC;

/* SQL query to show seasons where average goals per match is greater than 2.5, along with:
	season
	average goals per match
	total goals */
SELECT ds.season, f.total_goals, f.avg_goals_per_match
FROM fact_season_goal_statistics f
JOIN dim_season ds
	ON ds.season_id = f.season_id
WHERE f.avg_goals_per_match > 2.5
ORDER BY f.avg_goals_per_match DESC;

-- For each season, calculate the percentage of goals scored in knockout rounds relative to total goals.
SELECT
  ds.season,
  ROUND(
    (
      f.round_of_16_goals
      + f.quarter_final_goals
      + f.semi_final_goals
      + f.final_goals
    ) * 100.0 / f.total_goals,
    2
  ) AS knockout_goal_percentage
FROM fact_season_goal_statistics f
JOIN dim_season ds
  ON f.season_id = ds.season_id
ORDER BY ds.season;
