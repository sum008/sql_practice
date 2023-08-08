-- Query 7:

-- From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

-- Note: Weather is considered to be extremely cold then its temperature is less than zero.

--Table Structure:

-- drop table weather;
-- create table weather
-- (
-- id int,
-- city varchar(50),
-- temperature int,
-- day date
-- );
delete from weather;
insert into weather values
(1, 'London', 1, GETDATE()+1),
(2, 'London', -2, GETDATE()+1),
(3, 'London', 4, GETDATE()+1),
(4, 'London', 1, GETDATE()+1),
(5, 'London', -2, GETDATE()+1),
(6, 'London', -5, GETDATE()+1),
(7, 'London', -7,GETDATE()+1),
(8, 'London', 5, GETDATE()+1);

-- select * from weather;

select * from (select *, count(*) over (partition by part order by id range between unbounded preceding and unbounded following) as count from (select *, sum(case when (temperature < 0 and prev_temp >= 0) or temperature >= 0 then 1 else 0 end) over (order by id) as part 
from (select *, lag(temperature) over (order by id)
as prev_temp from weather sub_query_1) sub_query_2) sub_query_3) sub_query_4 where count >= 3;