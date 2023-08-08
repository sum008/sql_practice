-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1159-market-analysis-ii--hard---leetcode


-- solution 1
SELECT  user_id
       ,CASE WHEN MAX(fav) = 1 THEN 'yes'  ELSE 'no' END AS fav
FROM
(
	SELECT  user_id
	       ,favorite_brand
	       ,item_brand
	       ,CASE WHEN row_num = 2 AND favorite_brand = item_brand THEN 1  ELSE null END AS fav
	FROM
	(
		SELECT  *
		       ,ROW_NUMBER() over (partition by seller_id ORDER BY seller_id) AS row_num
		FROM ord
	) o
	RIGHT JOIN usr u
	ON o.seller_id = u.user_id
	LEFT JOIN itm i
	ON o.item_id = i.item_id
) q1
GROUP BY  user_id;

-- solution 2

SELECT  user_id
       ,CASE WHEN MIN(seller_id) is not null AND MIN(favorite_brand) = MIN(item_brand) THEN 'yes'  ELSE 'no' END AS '2nd_item_fav_brand'
FROM
(
	SELECT  *
	FROM
	(
		SELECT  seller_id       AS slr_id
		       ,MIN(order_date) AS ord_date
		FROM
		(
			SELECT  o.seller_id
			       ,o.order_date
			       ,o.item_id
			FROM
			(
				SELECT  seller_id
				       ,MIN(order_date) AS min_order_date
				FROM ord
				GROUP BY  seller_id
			) q1
			LEFT JOIN ord o
			ON q1.seller_id = o.seller_id AND q1.min_order_date <> o.order_date
		) q2
		GROUP BY  seller_id
	) q2
	JOIN ord o
	ON q2.slr_id = o.seller_id AND q2.ord_date = o.order_date
) p
RIGHT JOIN usr u
ON p.seller_id = u.user_id
LEFT JOIN itm i
ON p.item_id = i.item_id
GROUP BY  u.user_id;