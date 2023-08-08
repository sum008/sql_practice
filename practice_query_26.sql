-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1212-team-scores-in-football-tournament--medium---leetcode

-- solution 1

WITH t1 AS
(
	SELECT  *
	       ,CASE WHEN host_goals > guest_goals THEN host_team
	             WHEN host_goals < guest_goals THEN guest_team  ELSE 0 END AS winner
	FROM mtches
), t2 AS
(
	SELECT  match_id
	       ,host_team  AS team_id
	       ,host_goals AS goals
	       ,winner
	FROM t1
	UNION (
	SELECT  match_id
	       ,guest_team  AS team_id
	       ,guest_goals AS goals
	       ,winner
	FROM t1)
)
SELECT  t.team_id
       ,team_name
       ,coalesce(num_points,0) AS num_points
FROM teams t
LEFT JOIN
(
	SELECT  team_id
	       ,SUM(points) AS num_points
	FROM
	(
		SELECT  *
		       ,CASE WHEN winner = team_id THEN 3
		             WHEN winner = 0 THEN 1  ELSE 0 END AS points
		FROM t2
	) q1
	GROUP BY  team_id
) tt
ON t.team_id = tt.team_id
ORDER BY num_points DESC, t.team_id ASC;



WITH t1 AS
(
	SELECT  *
	       ,CASE WHEN host_goals > guest_goals THEN host_team
	             WHEN host_goals < guest_goals THEN guest_team  ELSE 0 END AS winner
	FROM mtches
), t2 AS
(
	SELECT  match_id
	       ,host_team  AS team_id
	       ,host_goals AS goals
	       ,winner
	FROM t1
	UNION (
	SELECT  match_id
	       ,guest_team  AS team_id
	       ,guest_goals AS goals
	       ,winner
	FROM t1)
)
SELECT  t.team_id
       ,team_name
       ,coalesce(num_points,0) AS num_points
FROM teams t
LEFT JOIN
(
	SELECT  team_id
	       ,SUM(case WHEN winner = team_id THEN 3 WHEN winner = 0 THEN 1 else 0 end) AS num_points
	FROM t2
	GROUP BY  team_id
) tt
ON t.team_id = tt.team_id
ORDER BY num_points DESC, t.team_id ASC;