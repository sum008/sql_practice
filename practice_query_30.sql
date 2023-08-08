-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1364-number-of-trusted-contacts-of-a-customer--medium---leetcode

SELECT  *
FROM invoices iv
RIGHT JOIN
(
	SELECT  customer_id
	       ,customer_name
	       ,SUM(case WHEN contact_email is not null THEN 1 else 0 end) AS contacts_cnt
	       ,SUM(tt)                                                    AS trusted_contacts_cnt
	FROM
	(
		SELECT  *
		       ,CASE WHEN contact_email IN ( SELECT email FROM customers) THEN 1  ELSE 0 END AS tt
		FROM customers c1
		LEFT JOIN contacts c2
		ON c1.customer_id = c2.user_id
	) t1
	GROUP BY  customer_id
	         ,customer_name
) t2
ON iv.user_id = t2.customer_id
ORDER BY invoice_id;