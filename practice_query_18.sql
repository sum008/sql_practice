-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#615-average-salary-departments-vs-company--hard---leetcode


SELECT  *
       ,CASE WHEN company_avg_sal < avg_dept_amt THEN 'higher'
             WHEN company_avg_sal > avg_dept_amt THEN 'lower'  ELSE 'same' END AS comparison
FROM
(
	SELECT  department_id
	       ,concat (month(pay_date),'-',year(pay_date)) AS dd
	       ,AVG(amount)                                 AS avg_dept_amt
	FROM company c
	LEFT JOIN empl e
	ON c.employee_id = e.employee_id
	GROUP BY  department_id
	         ,year(pay_date)
	         ,month(pay_date)
) s1
LEFT JOIN
(
	SELECT  AVG(amount)                                 AS company_avg_sal
	       ,concat (month(pay_date),'-',year(pay_date)) AS dd
	FROM company c
	GROUP BY  year(pay_date)
	         ,month(pay_date)
) s2
ON s1.dd = s2.dd
ORDER BY s1.dd;