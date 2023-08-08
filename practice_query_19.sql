-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1077-project-employees-iii--medium---leetcode

SELECT  a.project_id, employee_id
FROM
(
	SELECT  project_id
	       ,experience_years
           ,p.employee_id
	FROM project p
	JOIN employee_prj e
	ON p.employee_id = e.employee_id
) a
JOIN
(
	SELECT  project_id
	       ,MAX(experience_years) AS experience_years
	FROM project p
	JOIN employee_prj e
	ON p.employee_id = e.employee_id
	GROUP BY  p.project_id
) b
ON a.project_id = b.project_id AND a.experience_years = b.experience_years;