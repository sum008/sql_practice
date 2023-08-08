-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1369-get-the-second-most-recent-activity--hard---leetcode


SELECT  t2.username
       ,u.activity
       ,t2.startdate
       ,t2.enddate
FROM
(
	SELECT  username
	       ,MAX(startdate) AS startdate
	       ,MAX(enddate)   AS enddate
	FROM
	(
		SELECT  *
		FROM user_activity u1
		JOIN
		(
			SELECT  username        AS uname
			       ,MAX(startdate)  AS sdate
			       ,MAX(enddate)    AS edate
			       ,COUNT(username) AS user_count
			FROM user_activity
			GROUP BY  username
		) u2
		ON u1.startdate <= u2.sdate AND u1.username = u2.uname
	) t1
	WHERE startdate != sdate or user_count = 1
	GROUP BY  username
) t2
JOIN user_activity u
ON t2.username = u.username AND t2.startdate = u.startdate AND t2.enddate = u.enddate