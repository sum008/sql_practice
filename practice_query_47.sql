-- invert columns without using pivot

-- 101,english,88
-- 101,science,90
-- 101,maths,85
-- 102,english,70
-- 102,science,80
-- 102,maths,83


-- create table f_pivot (id int, subject VARCHAR(255), marks INT);

-- LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/f_pivot.csv"
-- INTO TABLE practice.f_pivot
-- COLUMNS TERMINATED BY ','
-- LINES TERMINATED BY '\n'
-- IGNORE 1 LINES;

select * from f_pivot;

select distinct id, max(english) over(partition by id) as english,
					max(science) over(partition by id) as science,
					max(maths) over(partition by id)  as maths from (
select id, case when subject = 'english' then (select marks from practice.f_pivot where subject='english' and id=f.id) end as english,
		  case when subject = 'science' then (select marks from practice.f_pivot where subject='science' and id=f.id) end as science,
          case when subject = 'maths' then (select marks from practice.f_pivot where subject='maths' and id=f.id) end as maths
from practice.f_pivot f) b;

--------- optimized --------------------

select distinct id, 
		case when subject != '' then (select marks from practice.f_pivot where subject='english' and id=f.id) end as english,
		case when subject != ''  then (select marks from practice.f_pivot where subject='science' and id=f.id) end as science,
		case when subject != '' then (select marks from practice.f_pivot where subject='maths' and id=f.id) end as maths
from practice.f_pivot f;