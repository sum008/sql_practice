-- https://stackoverflow.com/questions/55246899/how-to-find-the-average-distance-between-the-locations


SELECT  *
FROM dis;


WITH cte AS
(
	SELECT  source
	       ,destination
	       ,SUM(distance)   AS distance_new
	       ,COUNT(distance) AS cnt
	FROM dis
	GROUP BY  source
	         ,destination
)
SELECT  *
       ,cast((dis_1 + dis_2) AS decimal) / (cnt_1 + cnt_2) AS dd
FROM
(
	SELECT  d1.source       AS source_1
	       ,d1.destination  AS destination_1
	       ,d1.distance_new AS dis_1
	       ,d1.cnt          AS cnt_1
	       ,d2.source       AS source_2
	       ,d2.destination  AS destination_2
	       ,d2.distance_new AS dis_2
	       ,d2.cnt          AS cnt_2
	FROM cte d1
	JOIN cte d2
	ON d1.source = d2.destination AND d1.destination = d2.source AND d1.source < d2.source AND d1.destination > d2.destination
) t