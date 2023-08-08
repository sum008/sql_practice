-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#1341-movie-rating--medium---leetcode


with a as (select u.user_id, u.name, t.ss from users u join (select user_id, sum(rating) as ss from movie_rating group by user_id) t on u.user_id = t.user_id),

b as (select m.movie_id, m.title, u.avg_rating from movies m join 
(select movie_id, avg(rating) as avg_rating from movie_rating where month(created_at) = 2 group by movie_id) u on m.movie_id = u.movie_id)

select min(a.name) as results from a where ss in (select max(ss) from a) union all
select min(b.title) as results from b where avg_rating in (select max(avg_rating) from b);