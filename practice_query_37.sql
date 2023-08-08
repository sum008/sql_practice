-- https://www.dsfaisal.com/articles/sql/leetcode-sql-problem-solving#1596-the-most-frequently-ordered-products-for-each-customer--medium---leetcode

WITH cte AS
(
	SELECT  customer_id
	       ,product_id
	       ,COUNT(product_id) AS pdt_cnt
	FROM odr
	GROUP BY  customer_id
	         ,product_id
)
SELECT  *
FROM cte c
WHERE pdt_cnt IN ( SELECT MAX(pdt_cnt) FROM cte WHERE customer_id = c.customer_id GROUP BY customer_id);