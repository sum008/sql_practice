-- Write a Query to fetch the Brands whose Price is Increasing Every Year


-- solution 1
SELECT  year
       ,brand
       ,amount
FROM
(
	SELECT  *
	       ,SUM(correctness) over (partition by brand) AS partition_sum
	FROM
	(
		SELECT  *
		       ,CASE WHEN lag(amount,1,amount-1) over (partition by brand ORDER BY amount) < amount AND lag(year,1,year-1) over (partition by brand ORDER BY amount) < year THEN 1  ELSE 0 END AS correctness
		       ,COUNT(brand) over (partition by brand) AS partition_count
		FROM brands
	) t
) t1
WHERE partition_sum = partition_count;


-- solution 2
SELECT  year
       ,brand
       ,amount
FROM
(
	SELECT  *
	       ,SUM(correctness) over (partition by brand) AS partition_sum
	FROM
	(
		SELECT  *
		       ,CASE WHEN lag(amount,1,amount-1) over (partition by brand ORDER BY year) < amount THEN 1  ELSE 0 END AS correctness
		       ,COUNT(brand) over (partition by brand)                                                               AS partition_count
		FROM brands
	) t
) t1
WHERE partition_sum = partition_count;


-- solution 3 
WITH cte AS
(
	SELECT  *
	       ,CASE WHEN lag(amount,1,amount-1) over (partition by brand ORDER BY year) < amount THEN 1  ELSE 0 END AS correctness
	FROM brands
)
SELECT  year
       ,brand
       ,amount
FROM cte
WHERE brand IN ( SELECT brand FROM cte GROUP BY brand HAVING MIN (correctness) = MAX(correctness));