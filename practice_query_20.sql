-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1107-new-users-daily-count--medium---leetcode

SELECT  activity_date
       ,COUNT(activity) AS user_count
FROM traffic
WHERE user_id IN ( SELECT user_id FROM traffic GROUP BY user_id, activity HAVING activity = 'login' AND DATEDIFF(day, MIN (activity_date), '2019-06-30') <= 90)
GROUP BY  activity_date
         ,activity
HAVING DATEDIFF(day, activity_date, '2019-06-30') < 90 AND activity = 'login';


select activity_date, COUNT(activity_date) AS user_count from (
SELECT  min(activity_date) as activity_date
       ,COUNT(activity) AS user_count
FROM traffic
where activity = 'login'
GROUP BY  user_id
having DATEDIFF(day, MIN (activity_date), '2019-06-30') <= 90) q1 group by activity_date;


select * from traffic;

