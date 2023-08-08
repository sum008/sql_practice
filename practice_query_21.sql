-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1126-active-businesses--medium---leetcode


SELECT  business_id
       ,COUNT(e.occurences) AS occurance_count
FROM events e
INNER JOIN
(
	SELECT  event_type
	       ,AVG(cast(occurences AS decimal)) AS avg_occur
	FROM events
	GROUP BY  event_type
) a
ON e.event_type = a.event_type
WHERE e.occurences > avg_occur
GROUP BY  business_id
HAVING COUNT(e.occurences) > 1;