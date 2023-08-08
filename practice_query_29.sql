-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1355-activity-participants--medium---leetcode

with t1 as (select activity, count(id) as activity_count from frnds group by activity)

select activity from t1 where activity_count not in 
(select max(activity_count) from t1 union select min(activity_count) from t1)