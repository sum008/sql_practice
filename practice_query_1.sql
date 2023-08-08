-- create table users
-- (
-- user_id int primary key,
-- user_name varchar(30) not null,
-- email varchar(50));

-- insert into users values
-- (6, 'Sumit', 'sumit@gmail.com'),
-- (7, 'Sumit', 'sumit@gmail.com'),
-- (8, 'Farhana', 'farhana@gmail.com'),
-- (9, 'Farhana', 'farhana@gmail.com'),
-- (10, 'Robin', 'robin@gmail.com');

use temp_db;
select * from users;

-- without window
-- select * from users where user_id not in 
-- (select min(user_id) from users group by user_name);

-- with window

-- select * from 
-- (select *, ROW_NUMBER() over(partition by user_name order by user_id) 
-- as row_num from users) as inner_query where row_num <> 1;


-- select * from 
-- (select *, max(row_num) from (select *, ROW_NUMBER() 
-- over(partition by user_name order by user_id) 
-- as row_num from users) as tt group by user_name order by user_id) as b;

-- with a as (select *, ROW_NUMBER() 
-- over(partition by user_name order by user_id) 
-- as row_num from users)

-- select *, Lag(row_num,1,0) 
-- over (partition by user_name order by user_id) 
--     as lg from a;

with x as (select * from users LEFT JOIN (select  user_id as user_id_1, ROW_NUMBER() 
over(partition by user_name order by user_id) 
as row_num from users) as user_1 on  users.user_id = user_1.user_id_1)

SELECT  *
FROM x
LEFT JOIN
(
	SELECT  user_id_1                                                           AS user_id_2
	       ,Lag(x.row_num,1,0) over (partition by x.user_name ORDER BY row_num) AS lg
	FROM x
) AS user_2
ON x.user_id = user_2.user_id_2
ORDER BY email;



SELECT  user_id, [user_name], email
FROM
(
	SELECT  *
	       ,LAST_VALUE(sub_query_4.user_id) over(partition by sub_query_4.part ORDER BY sub_query_4.user_name) AS selected_id
	FROM
	(
		SELECT  *
		       ,SUM(case WHEN sub_query_3.row_lag >= sub_query_3.row_num THEN 1 else 0 end) over(order by sub_query_3.user_name rows BETWEEN unbounded PRECEDING AND current row) AS part
		FROM
		(
			SELECT  *
			       ,LAG(sub_query_2.row_num,1,0) OVER(ORDER BY sub_query_2.user_name) AS row_lag
			FROM
			(
				SELECT  *
				       ,ROW_NUMBER() OVER(partition by sub_query_1.user_name ORDER BY sub_query_1.user_id) AS row_num
				FROM
				(
					SELECT  *
					FROM users
				) sub_query_1
			) sub_query_2
		)sub_query_3
	)sub_query_4
) sub_query_5
WHERE sub_query_5.selected_id = sub_query_5.user_id order by user_id;






-- with x as (select * from users LEFT JOIN (select  user_id as user_id_1, ROW_NUMBER() 
-- over(partition by user_name order by user_id) 
-- as row_num from users) as user_1 on  users.user_id = user_1.user_id_1)

-- select *, sum(
--     case when ((x.row_num) in (select Lag(row_num,1,0) over (partition by user_name 
--     order by row_num) as lg from x)) then 1 else 0 end) 
--     over (order by row_num ROWS BETWEEN UNBOUNDED PRECEDING AND 
--     current row) as ww from x;



-- select * from users LEFT JOIN (select  user_id as user_id_1, ROW_NUMBER() 
-- over(partition by user_name order by user_id) 
-- as row_num from users) as user_1 on  users.user_id = user_1.user_id_1

-- LEFT JOIN (select user_id_1 as user_id_2, Lag(user_1.row_num,1,0) 
-- over (partition by x.user_name 
--     order by row_num) as lg from user_1) as user_2 on 
--     user_1.user_id = user_2.user_id_2;







select *, Lag(
    (select *, ROW_NUMBER() 
over(partition by user_name order by user_id) from users)
,1,0) 
over (partition by user_name order by user_id) 
    as lg from users;

-- select *, sum(
--     case when ((select Lag(row_num,1,0) over (partition by user_name 
--     order by row_num) as lg from a) > 
--     (select row_num from a)) then 0 else 1 end) 
--     over (order by row_num ROWS BETWEEN UNBOUNDED PRECEDING AND 
--     current row) as ww from a;


-- rows between unbounded preceding and current row