-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1132-reported-posts-ii--medium---leetcode


SELECT  cast(SUM(div) AS decimal)/COUNT(div) AS average_daily_percent
FROM
(
	SELECT  *
	       ,cast(numerator AS decimal)/denominator * 100 AS div
	FROM
	(
		SELECT  action_date
		       ,cast(SUM(case WHEN a.action = 'report' AND a.extra = 'spam' AND r.remove_date is not null THEN 1 else 0 end) AS decimal) AS numerator
		       ,cast(SUM(case WHEN a.action = 'report' AND a.extra = 'spam' THEN 1 else 0 end) AS decimal)                               AS denominator
		FROM actions a
		LEFT JOIN removals r
		ON a.post_id = r.post_id
		GROUP BY  action_date
	) q1
	WHERE denominator <> 0
) q2;