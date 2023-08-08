-- https://www.dsfaisal.com/articles/sql/leetcode-sql-problem-solving#1709-biggest-window-between-visits--medium---leetcode


select * from uservisits


WITH cte AS
(
	SELECT  *
	       ,row_number() over (partition by user_id ORDER BY visit_date) AS rw_num
	FROM
	(
		SELECT  *
		FROM uservisits v
		UNION ALL
		SELECT  distinct user_id
		       ,final_date
		FROM uservisits
		CROSS JOIN
		(
			SELECT  '2021-01-01' AS final_date
		) t
	) k
)
SELECT  user_id
       ,MAX(biggest_window) AS biggest_window
FROM
(
	SELECT  *
	       ,DATEDIFF(day,v_dt,visit_date) AS biggest_window
	FROM
	(
		SELECT  c1.*
		       ,c2.visit_date AS v_dt
		       ,c2.rw_num     AS rw_num_2
		FROM cte c1
		JOIN cte c2
		ON c1.user_id = c2.user_id AND c1.visit_date > c2.visit_date AND c1.rw_num - c2.rw_num = 1
	) l
) m
GROUP BY  user_id