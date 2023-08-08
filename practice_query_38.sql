-- https://www.dsfaisal.com/articles/sql/leetcode-sql-problem-solving#1635-hopper-company-queries-i--hard---leetcode


SELECT  *
FROM drivers;

SELECT  *
FROM riders;

SELECT  *
FROM accepted_rides;
WITH cte AS
(
	SELECT  d.driver_id
	       ,d1.cur_month
	FROM drivers d
	RIGHT JOIN
	(
		SELECT  1 AS cur_month
		UNION
		SELECT  2 AS cur_month
		UNION
		SELECT  3 AS cur_month
		UNION
		SELECT  4 AS cur_month
		UNION
		SELECT  5 AS cur_month
		UNION
		SELECT  6 AS cur_month
		UNION
		SELECT  7 AS cur_month
		UNION
		SELECT  8 AS cur_month
		UNION
		SELECT  9 AS cur_month
		UNION
		SELECT  10 AS cur_month
		UNION
		SELECT  11 AS cur_month
		UNION
		SELECT  12 AS cur_month
	) d1
	ON (month(d.join_date) <= d1.cur_month AND year(d.join_date) = 2020) or year(d.join_date) < 2020
), cte1 AS
(
	SELECT  cur_month
	       ,COUNT(r_id_1) AS accepted_rides
	FROM
	(
		SELECT  distinct r_id_1
		       ,cur_month
		FROM accepted_rides a
		JOIN
		(
			SELECT  ride_id   AS r_id_1
			       ,driver_id AS d_id_1
			       ,cur_month
			FROM riders r
			JOIN cte c
			ON c.cur_month = month(r.requested_at) AND year(requested_at) = 2020
		) b
		ON a.ride_id = b.r_id_1
	) t1
	GROUP BY  cur_month
)
SELECT  c2.cur_month
       ,active_driver
       ,coalesce(accepted_rides,0) AS accepted_rides
FROM cte1 c1
RIGHT JOIN
(
	SELECT  cur_month
	       ,COUNT(driver_id) AS active_driver
	FROM cte
	GROUP BY  cur_month
) c2
ON c1.cur_month = c2.cur_month;