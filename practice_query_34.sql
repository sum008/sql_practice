-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1454-active-users--medium---leetcode


WITH cte AS
(
	SELECT  *
	       ,SUM(case WHEN (datediff(day,lag_date,login_date) IN (0,1)) AND lag_id = id THEN 0 else 1 end) over (order by id,login_date rows BETWEEN unbounded preceding AND current row) AS sub_partition
	FROM
	(
		SELECT  *
		       ,lag(login_date,1,login_date) over(partition by id ORDER BY login_date) AS lag_date
		       ,lag(id,1,id) over(order by id)                                         AS lag_id
		FROM
		(
			SELECT  distinct id
			       ,login_date
			FROM logins
		) t
	) t1
), cte1 AS
(
	SELECT  id
	       ,sub_partition
	       ,COUNT(id) AS cnt
	FROM
	(
		SELECT  *
		FROM cte
	) t2
	GROUP BY  id
	         ,sub_partition
	HAVING COUNT(id) >= 5
)
SELECT  c.id
       ,c.login_date
       ,c.sub_partition
       ,sub_1.mx_cnt
       ,sub_1.cnt
FROM cte c
JOIN
(
	SELECT  cc.id
	       ,cc.mx_cnt
	       ,c1.cnt
	       ,c1.sub_partition
	FROM
	(
		SELECT  id
		       ,MAX(cnt) AS mx_cnt
		FROM cte1
		GROUP BY  id
	) cc
	JOIN
	(
		SELECT  *
		FROM cte1
	) c1
	ON cc.id = c1.id
	WHERE mx_cnt <= cnt
) sub_1
ON c.id = sub_1.id AND c.sub_partition = sub_1.sub_partition;