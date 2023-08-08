-- Query 6:

-- From the students table, write a SQL query to interchange the adjacent student names.

-- Note: If there are no adjacent student then the student name should stay the same.

--Table Structure:

-- drop table students;
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

select * from students;

SELECT  *
       ,CASE WHEN row_num % 2 <> 0 THEN lead(student_name,1,student_name) over(order by id)
             else lag(student_name,1,student_name) over(order by id) END AS new_student_name
FROM
(
	SELECT  *
	       ,row_number() over(order by id) AS row_num
	FROM students sub_query_1
) sub_query_2;

-- SELECT *, CASE WHEN id % 2 <> 0 THEN lead(student_name, 1, student_name) over(order by id) WHEN id % 2 = 0 THEN lag(student_name, 1, student_name) over(order by id) end
-- FROM students;