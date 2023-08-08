-- https://www.dsfaisal.com/articles/sql/leetcode-sql-problem-solving#1479

select*
FROM
(
	SELECT  item_category
	       ,cur_day
	       ,quantity
	FROM
	(
		SELECT  t.item_id
		       ,coalesce(t.quantity,0) AS quantity
		       ,t.item_name
		       ,d.item_category
		       ,d.cur_day
		FROM
		(
			SELECT  distinct item_category
			       ,cur_day
			FROM items
			CROSS JOIN
			(
				SELECT  'Monday' AS cur_day
				UNION
				SELECT  'Tuesday'
				UNION
				SELECT  'Wednesday'
				UNION
				SELECT  'Thursday'
				UNION
				SELECT  'Friday'
				UNION
				SELECT  'Saturday'
				UNION
				SELECT  'Sunday'
			) k
		) d
		LEFT JOIN
		(
			SELECT  o.*
			       ,i.item_name
			       ,i.item_category
			       ,datename(dw,order_date) AS cur_day
			FROM ordrs o
			RIGHT JOIN items i
			ON o.item_id = i.item_id
		) t
		ON d.cur_day = t.cur_day AND d.item_category = t.item_category
	) u
) q pivot ( SUM(quantity) for cur_day IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday]) ) AS PVT_TBL;