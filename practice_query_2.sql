
-- Write a SQL query to fetch the second last record 
-- from a employee table.

-- create table employee
-- ( emp_ID int primary key
-- , emp_NAME varchar(50) not null
-- , DEPT_NAME varchar(50)
-- , SALARY int);

-- insert into employee values(101, 'Mohan', 'Admin', 4000);
-- insert into employee values(102, 'Rajkumar', 'HR', 3000);
-- insert into employee values(103, 'Akbar', 'IT', 4000);
-- insert into employee values(104, 'Dorvin', 'Finance', 6500);
-- insert into employee values(105, 'Rohit', 'HR', 3000);
-- insert into employee values(106, 'Rajesh',  'Finance', 5000);
-- insert into employee values(107, 'Preet', 'HR', 7000);
-- insert into employee values(108, 'Maryam', 'Admin', 4000);
-- insert into employee values(109, 'Sanjay', 'IT', 6500);
-- insert into employee values(110, 'Vasudha', 'IT', 7000);
-- insert into employee values(111, 'Melinda', 'IT', 8000);
-- insert into employee values(112, 'Komal', 'IT', 10000);
-- insert into employee values(113, 'Gautham', 'Admin', 2000);
-- insert into employee values(114, 'Manisha', 'HR', 3000);
-- insert into employee values(115, 'Chandni', 'IT', 4500);
-- insert into employee values(116, 'Satya', 'Finance', 6500);
-- insert into employee values(117, 'Adarsh', 'HR', 3500);
-- insert into employee values(118, 'Tejaswi', 'Finance', 5500);
-- insert into employee values(119, 'Cory', 'HR', 8000);
-- insert into employee values(120, 'Monica', 'Admin', 5000);
-- insert into employee values(121, 'Rosalin', 'IT', 6000);
-- insert into employee values(122, 'Ibrahim', 'IT', 8000);
-- insert into employee values(123, 'Vikram', 'IT', 8000);
-- insert into employee values(124, 'Vikram', 'IT', 8000);
-- insert into employee values(125, 'Dheeraj', 'IT', 11000);
-- insert into employee values(126, 'Dheeraj', 'IT', 12000);
-- insert into employee values(127, 'Dheeraj', 'IT', 12000);

-- drop table employee;


select * from employee;


SELECT  *
FROM employee
WHERE emp_id = (
SELECT  MAX(sub_query_2.emp_id_ld) AS mx
FROM
(
	SELECT  *
	       ,lag(emp_ID) over(order by emp_ID) AS emp_id_ld
	FROM
	(
		SELECT  *
		FROM employee
	)sub_query_1
)sub_query_2
GROUP BY  ());


SELECT  *
FROM employee
WHERE emp_id = (
SELECT  MAX(sub_query_3.mx) AS new_max
FROM
(
	SELECT  min(sub_query_2.emp_id_ld) AS mx
	FROM
	(
		SELECT  *
		       ,lag(sub_query_1.emp_ID) over(order by sub_query_1.emp_ID) AS emp_id_ld
		FROM
		(
			SELECT  *
			FROM employee
		)sub_query_1
	)sub_query_2
	GROUP BY  emp_NAME
	         ,DEPT_NAME
) sub_query_3
GROUP BY  ());


-- last(id) over(partition by val order by id) 
-- id,val,l_id
-- 1,a,2
-- 2,a,2
-- 3,b,4
-- 4,b,4
-- 5,c,7
-- 6,c,7
-- 7,c,7
-- filter on id==l_id, lag on l_id
-- 2,a,2,0
-- 4,b,4,2
-- 7,c,7,4


SELECT  *
FROM employee
WHERE emp_id = (
SELECT  MAX(lag_val)
FROM
(
	SELECT  *
	       ,lag(l_emp_id,1,0) over(order by emp_id) AS lag_val
	FROM
	(
		SELECT  *
		FROM
		(
			SELECT  *
			       ,last_value(emp_id) over (partition by dept_name,emp_name ORDER BY emp_id range BETWEEN unbounded preceding AND unbounded following) AS l_emp_id
			FROM
			(
				SELECT  *
				FROM employee
			) sub_query_1
		) sub_query_2
		WHERE sub_query_2.emp_id = sub_query_2.l_emp_id
	) sub_query_3
) AS sub_query_4
GROUP BY  ());