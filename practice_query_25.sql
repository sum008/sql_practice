-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1194-tournament-winners--hard---leetcode

-- solution #1

WITH t1 AS
(
	SELECT  match_id
	       ,first_player AS player_id
	       ,first_Score  AS score
	       ,group_id
	FROM matches m
	LEFT JOIN players p
	ON m.first_player = p.player_id
), t2 AS
(
	SELECT  match_id
	       ,second_player AS player_id
	       ,second_Score  AS score
	       ,group_id
	FROM matches m
	LEFT JOIN players p
	ON m.second_player = p.player_id
), t3 AS
(
	SELECT  *
	FROM t1
	UNION (
	SELECT  *
	FROM t2)
)
SELECT  group_id
       ,CASE WHEN COUNT(max_dup_flag) > 1 THEN MIN(player_id)  ELSE MAX(player_id) END AS player_id
FROM
(
	SELECT  *
	       ,CASE WHEN score IN ( SELECT MAX(score) FROM t3 WHERE group_id = kk.group_id) THEN 1  ELSE 0 END AS max_dup_flag
	FROM t3 AS kk
) q1
WHERE max_dup_flag = 1
GROUP BY  group_id;



-- solution #2

WITH t1 AS
(
	SELECT  match_id
	       ,first_player AS player_id
	       ,first_Score  AS score
	       ,group_id
	FROM matches m
	LEFT JOIN players p
	ON m.first_player = p.player_id
), t2 AS
(
	SELECT  match_id
	       ,second_player AS player_id
	       ,second_Score  AS score
	       ,group_id
	FROM matches m
	LEFT JOIN players p
	ON m.second_player = p.player_id
), t3 AS
(
	SELECT  *
	FROM t1
	UNION (
	SELECT  *
	FROM t2)
)
SELECT  group_id
       ,CASE WHEN SUM(rw_num) > 1 THEN MIN(player_id)  ELSE MAX(player_id) END AS player_id
FROM
(
	SELECT  *
	       ,dense_rank() over (partition by group_id ORDER BY score desc) AS rw_num
	FROM t3
) qq
WHERE rw_num = 1
GROUP BY  group_id;