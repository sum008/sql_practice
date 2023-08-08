-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1164-product-price-at-a-given-date--medium---leetcode


SELECT  pdt_id
       ,CASE WHEN chg_date <= '2019-08-16' THEN price  ELSE 10 END AS price
FROM
(
	SELECT  *
	FROM
	(
		SELECT  product_id       AS pdt_id
		       ,MAX(new_price)   AS price
		       ,MAX(change_date) AS chg_date
		FROM products
		WHERE change_date <= '2019-08-16'
		GROUP BY  product_id
	) p1
	UNION (
	SELECT  product_id
	       ,MAX(new_price)
	       ,MAX(change_date)
	FROM products
	WHERE product_id not IN ( SELECT product_id FROM products WHERE change_date <= '2019-08-16' GROUP BY product_id)
	GROUP BY  product_id)
) q2;