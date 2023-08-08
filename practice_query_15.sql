-- https://dsfaisal.com/articles/2020-11-06-leetcode-sql-problem-solving/#585-investments-in-2016--medium---leetcode

select sum(tiv_2016) as total_inv from insurace where concat(lat,lon) in (
select concat(lat,lon) from insurace group by concat(lat,lon) having count(concat(lat, lon)) = 1)  group by tiv_2015
having count(tiv_2015) > 1;


select sum(tiv_2016) as total_inv from insurace where concat(lat,lon) in (
select concat(lat,lon) from insurace group by concat(lat,lon) having count(concat(lat, lon)) = 1) and tiv_2015 in (select tiv_2015 from
insurace group by tiv_2015 having count(tiv_2015) > 1);