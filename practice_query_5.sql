-- Query 5:

-- From the login_details table, fetch the users who logged in consecutively 3 or more times.

--Table Structure:
-- drop table login_details;
-- create table login_details(
-- login_id int primary key,
-- user_name varchar(50) not null,
-- login_date date);

-- insert into login_details values
-- (101, 'Michael', GETDATE()),
-- (102, 'James', GETDATE()),
-- (103, 'Stewart', GETDATE()+1),
-- (104, 'Stewart', GETDATE()+1),
-- (105, 'Stewart', GETDATE()+1),
-- (106, 'Michael', GETDATE()+2),
-- (107, 'Michael', GETDATE()+2),
-- (108, 'Stewart', GETDATE()+3),
-- (109, 'Stewart', GETDATE()+3),
-- (110, 'James', GETDATE()+4),
-- (111, 'James', GETDATE()+4),
-- (112, 'James', GETDATE()+5),
-- (113, 'James', GETDATE()+6);

select * from login_details;

SELECT  user_name
FROM
(
	SELECT  *
	       ,row_number() over (partition by part ORDER BY login_id) AS row_num
	FROM
	(
		SELECT  *
		       ,SUM(case WHEN user_name <> prev_user THEN 1 else 0 end) over(order by login_id rows BETWEEN unbounded preceding AND current row) AS part
		FROM
		(
			SELECT  *
			       ,lag(user_name,1) over (order by login_id) AS prev_user
			FROM login_details sub_query_1
		) sub_query_2
	) sub_query_3
) sub_query_4
GROUP BY  user_name
         ,part
HAVING MAX(row_num) >= 3;


-- select *, sum(case when user_name = prev_user then 1 else 0 end) over(order by login_id rows between unbounded preceding and current row) 
-- from (select *, lag(user_name, 1) over (order by login_id) as prev_user from login_details sub_query_1) sub_query_2;