CREATE database ucl;
USE ucl;

SELECT * FROM stg_player_goal_details;

CREATE TABLE dim_player (
	player_id int auto_increment primary key,
    player_name varchar(255) unique
);

INSERT INTO dim_player (player_name)
SELECT DISTINCT Player FROM stg_player_appear_details
UNION
SELECT DISTINCT Player FROM stg_player_goal_details
UNION
SELECT DISTINCT Player FROM stg_player_goal_totals
UNION
SELECT DISTINCT Player FROM stg_top_goal_scorer;

SELECT * FROM dim_player;

CREATE TABLE dim_club (
  club_id INT AUTO_INCREMENT PRIMARY KEY,
  club_name VARCHAR(255) UNIQUE,
  country VARCHAR(255)
);

INSERT INTO dim_club (club_name, country)
SELECT DISTINCT club, country
FROM stg_all_time_ranking_by_club;

SELECT * FROM dim_club;

CREATE TABLE dim_coach (
  coach_id INT AUTO_INCREMENT PRIMARY KEY,
  coach_name VARCHAR(255) UNIQUE
);

INSERT INTO dim_coach (coach_name)
SELECT DISTINCT Coach
FROM stg_coaches_appear_details;

SELECT * FROM dim_coach;

CREATE TABLE dim_country (
  country_id INT AUTO_INCREMENT PRIMARY KEY,
  country_name VARCHAR(255) UNIQUE
);

INSERT INTO dim_country (country_name)
SELECT DISTINCT Country
FROM stg_all_time_ranking_by_country;

SELECT * FROM dim_country;

CREATE TABLE dim_season (
  season_id INT AUTO_INCREMENT PRIMARY KEY,
  season VARCHAR(20) UNIQUE
);

INSERT INTO dim_season (season)
SELECT DISTINCT season
FROM stg_goal_stats_per_group_round;

SELECT * FROM dim_season;

SELECT COUNT(*) FROM dim_player;
SELECT COUNT(*) FROM dim_club;
SELECT COUNT(*) FROM dim_coach;
SELECT COUNT(*) FROM dim_country;
SELECT COUNT(*) FROM dim_season;

CREATE TABLE fact_player_appearances_total (
  player_id INT,
  club_id INT,
  appearances INT,
  PRIMARY KEY (player_id, club_id),
  FOREIGN KEY (player_id) REFERENCES dim_player(player_id),
  FOREIGN KEY (club_id) REFERENCES dim_club(club_id)
);

INSERT INTO fact_player_appearances_total (player_id, club_id, appearances)
SELECT
  p.player_id,
  c.club_id,
  s.appearances
FROM stg_player_appear_details s
JOIN dim_player p
  ON s.Player = p.player_name
JOIN dim_club c
  ON s.Club = c.club_name;

SELECT COUNT(*) FROM fact_player_appearances_total;
 
SELECT * FROM fact_player_appearances_total
ORDER BY player_id ASC;

CREATE TABLE fact_player_goals_total (
	player_id INT,
    club_id INT,
    goals INT,
    PRIMARY KEY (player_id, club_id),
    FOREIGN KEY (player_id) REFERENCES dim_player(player_id),
    FOREIGN KEY (club_id) REFERENCES dim_club(club_id)
);

INSERT INTO fact_player_goals_total (player_id, club_id, goals)
SELECT
  p.player_id,
  c.club_id,
  SUM(s.Goals) AS goals
FROM stg_player_goal_details s
JOIN dim_player p
  ON s.Player = p.player_name
JOIN dim_club c
  ON s.Club = c.club_name
GROUP BY
	p.player_id,
    c.club_id;
    
select * from fact_player_goals_total;

SELECT * FROM stg_all_time_ranking_by_club;

CREATE TABLE fact_club_all_time_performance (
  club_id INT,
  position INT,
  participated INT,
  titles INT,
  played INT,
  wins INT,
  draws INT,
  losses INT,
  goals_for INT,
  goals_against INT,
  points INT,
  goal_diff INT,
  FOREIGN KEY (club_id) REFERENCES dim_club(club_id)
);

INSERT INTO fact_club_all_time_performance (
  club_id,
  position,
  participated,
  titles,
  played,
  wins,
  draws,
  losses,
  goals_for,
  goals_against,
  points,
  goal_diff
)
SELECT
  c.club_id,
  s.Position,
  s.Participated,
  s.Titles,
  s.Played,
  s.Win,
  s.Draw,
  s.Loss,
  s.`Goals For`,
  s.`Goals Against`,
  s.Pts,
  s.`Goal Diff`
FROM stg_all_time_ranking_by_club s
JOIN dim_club c
  ON s.Club = c.club_name;
  
SELECT * FROM fact_club_all_time_performance;

DESCRIBE stg_goal_stats_per_group_round;

CREATE TABLE fact_season_goal_statistics (
  season_id INT PRIMARY KEY,
  matches INT,
  total_goals INT,
  avg_goals_per_match DECIMAL(5,2),
  group_a_goals INT,
  group_b_goals INT,
  group_c_goals INT,
  group_d_goals INT,
  group_e_goals INT,
  group_f_goals INT,
  group_g_goals INT,
  group_h_goals INT,
  round_of_16_goals INT,
  quarter_final_goals INT,
  semi_final_goals INT,
  final_goals INT,
  FOREIGN KEY (season_id) REFERENCES dim_season(season_id)
);

INSERT INTO fact_season_goal_statistics (
  season_id, matches,
  total_goals,
  avg_goals_per_match,
  group_a_goals,
  group_b_goals,
  group_c_goals,
  group_d_goals,
  group_e_goals,
  group_f_goals,
  group_g_goals,
  group_h_goals,
  round_of_16_goals,
  quarter_final_goals,
  semi_final_goals,
  final_goals
)
SELECT
  ds.season_id,
  s.matches,
  s.total_goals,
  s.avg_goals_per_match,
  s.group_a_goals,
  s.group_b_goals,
  s.group_c_goals,
  s.group_d_goals,
  s.group_e_goals,
  s.group_f_goals,
  s.group_g_goals,
  s.group_h_goals,
  s.round_of_16_goals,
  s.quarter_final_goals,
  s.semi_final_goals,
  s.final_goals
FROM stg_goal_stats_per_group_round s
JOIN dim_season ds
  ON s.season = ds.season;
  
SELECT * FROM fact_season_goal_statistics;

DESCRIBE stg_coaches_appear_details;

CREATE TABLE fact_coach_appearances_total (
  coach_id INT,
  club_id INT,
  appearances INT,
  PRIMARY KEY (coach_id, club_id),
  FOREIGN KEY (coach_id) REFERENCES dim_coach(coach_id),
  FOREIGN KEY (club_id) REFERENCES dim_club(club_id)
);

INSERT INTO fact_coach_appearances_total (coach_id, club_id, appearances)
SELECT
  dc.coach_id,
  dcl.club_id,
  s.Appearance
FROM stg_coaches_appear_details s
JOIN dim_coach dc
  ON s.Coach = dc.coach_name
JOIN dim_club dcl
  ON s.Club = dcl.club_name;

SELECT * FROM fact_coach_appearances_total; 