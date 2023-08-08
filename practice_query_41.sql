-- https://www.dsfaisal.com/articles/sql/leetcode-sql-problem-solving#1285-find-the-start-and-end-number-of-continuous-ranges--medium---leetcode

SELECT  distinct first_value(log_id) over (partition by part ORDER BY log_id) AS start_id
       ,first_value(log_id) over (partition by part ORDER BY log_id desc)     AS end_id
FROM
(
	SELECT  *
	       ,sum (case WHEN lag_log IN (0,1) THEN 0 else 1 end) over (order by log_id) AS part
	FROM
	(
		SELECT  *
		       ,log_id - lag(log_id,1,log_id) over (order by log_id) AS lag_log
		FROM logs
	) t
) u