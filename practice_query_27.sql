-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1225-report-contiguous-dates--hard---leetcode


SELECT  MAX(period_state) AS period_state
       ,MIN(fail_date)    AS start_date
       ,MAX(fail_date)    AS end_date
FROM
(
	SELECT  *
	       ,SUM(case WHEN DATEDIFF(day,fail_date,failed_lag) IN (0,1,-1) THEN 0 else 1 end) over (order by fail_date rows BETWEEN unbounded preceding AND current row) AS part
	FROM
	(
		SELECT  fail_date
		       ,lag(fail_date,1,fail_date) over (order by fail_date)             AS failed_lag
		       ,CASE WHEN fail_date is not null THEN 'failed'  ELSE 'failed' END AS period_state
		FROM failed
		WHERE fail_date >= '2019-01-01'
		AND fail_date <= '2019-12-31'
	) q1
) q2
GROUP BY  part union(
SELECT  MAX(period_state) AS period_state
       ,MIN(success_Date) AS start_date
       ,MAX(success_date) AS end_date
FROM
(
	SELECT  *
	       ,SUM(case WHEN DATEDIFF(day,success_date,success_lag) IN (0,1,-1) THEN 0 else 1 end) over (order by success_date rows BETWEEN unbounded preceding AND current row) AS part
	FROM
	(
		SELECT  success_date
		       ,lag(success_date,1,success_date) over (order by success_date)             AS success_lag
		       ,CASE WHEN success_date is not null THEN 'succeeded'  ELSE 'succeeded' END AS period_state
		FROM success
		WHERE success_date >= '2019-01-01'
		AND success_date <= '2019-12-31'
	) q1
) q2
GROUP BY  part)
ORDER BY start_date;