SELECT  SUM(sal_2) AS sum_sal
       ,id_1
       ,MAX(mon_2) AS mon_2
FROM
(
	SELECT  e1.id     AS id_1
	       ,e1.month  AS mon_1
	       ,e1.salary AS sal_1
	       ,e2.id     AS id_2
	       ,e2.month  AS mon_2
	       ,e2.salary AS sal_2
	FROM emp e1
	CROSS JOIN emp e2
	WHERE e1.id = e2.id
	AND e2.month < e1.month 
) aa
GROUP BY  id_1
         ,mon_1
ORDER BY id_1 asc
         ,mon_1 desc;