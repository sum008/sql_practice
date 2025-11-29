-- create
CREATE TABLE date_data (
  month INTEGER,
  year INTEGER
);

-- insert
INSERT INTO date_data VALUES (6, 2024);
-- INSERT INTO date_data VALUES (7, 2024);
INSERT INTO date_data VALUES (9, 2024);
-- INSERT INTO date_data VALUES (10, 2024);
-- INSERT INTO date_data VALUES (11, 2024);
-- INSERT INTO date_data VALUES (12, 2024);
-- INSERT INTO date_data VALUES (1, 2025);
-- INSERT INTO date_data VALUES (2, 2025);
INSERT INTO date_data VALUES (4, 2025);

-- fetch 
-- with cte as (
-- SELECT *, lag(month) over (order by year, month) as lag_month,
-- abs(month - lag(month) over (order by year, month) % 12) as part,
-- month+year*12 as test
-- FROM date_data
-- )
-- select *,
-- sum(case when part>1 then 1 else 0 end) 
-- over (order by year, month rows between unbounded preceding and current row) as consecutive_sequence
-- from cte

with cte as (
SELECT *, lag(month) over (order by year, month) as lag_month,
abs(month+year*12 - lag(month+year*12) over (order by year, month)) as part,
month+year*12 as test
FROM date_data
)
select *,
sum(case when part=1 then 0 else 1 end) 
over (order by year, month rows between unbounded preceding and current row) as consecutive_sequence
from cte

