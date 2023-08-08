-- https://www.dsfaisal.com/articles/sql/leetcode-sql-problem-solving#1767-find-the-subtasks-that-did-not-execute--hard---leetcode

-- below cte is a recursive cte

select * from tasks;
select * from executed;

WITH cte AS
(
	SELECT  1 AS subtask_id
	       ,task_id
	       ,subtasks_count
	FROM tasks t1
	UNION ALL
	SELECT  subtask_id+1
	       ,task_id
	       ,subtasks_count
	FROM cte
	WHERE subtask_id < subtasks_count 
)
select * from cte
SELECT  task_id
       ,subtask_id
FROM cte c1
WHERE not exists (
SELECT  *
FROM executed
WHERE task_id = c1.task_id
AND subtask_id = c1.subtask_id);