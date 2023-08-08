-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1412-find-the-quiet-students-in-all-exams--hard---leetcode


WITH all_quite AS
(
	SELECT  *
	FROM exam e
	WHERE score not IN ( SELECT MIN (score) AS scr FROM exam GROUP BY exam_id HAVING exam_id = e.exam_id UNION  SELECT MAX(score) AS scr FROM exam GROUP BY exam_id HAVING exam_id = e.exam_id)
), non_quite AS
(
	SELECT  *
	FROM exam e
	WHERE score IN ( SELECT MIN (score) AS scr FROM exam GROUP BY exam_id HAVING exam_id = e.exam_id UNION  SELECT MAX(score) AS scr FROM exam GROUP BY exam_id HAVING exam_id = e.exam_id)
)
SELECT  s1.student_id
       ,s.student_name
FROM students s
JOIN
(
	SELECT  distinct student_id
	FROM all_quite
	WHERE student_id not IN ( SELECT student_id FROM non_quite)
) s1
ON s.id = s1.student_id;