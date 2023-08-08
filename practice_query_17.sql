-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#614-second-degree-follower--medium---leetcode


-- below query will fail if followee is equal to follower
SELECT  followee
       ,COUNT(followee) AS num
FROM fb
WHERE followee IN ( SELECT CASE WHEN COUNT(f) > 1 THEN f end AS f FROM  ( SELECT distinct followee AS f FROM fb  UNION ALL( SELECT distinct follower FROM fb)  ) q_1 GROUP BY f)
GROUP BY  followee;

-- below will not fail in above scenario
SELECT  f1.followee
       ,COUNT(f1.followee) AS num
FROM fb f1
INNER JOIN fb f2
ON f1.followee = f2.follower AND f1.followee <> f1.follower
GROUP BY  f1.followee;

insert into fb values ('F', 'F');
