select * from trips;

select * from trip_user;

--1 > true
-- 0 > false

select request_at, 
round(cast(sum(case when t.status <> 'completed' then 1 else 0 end) as decimal(2,2)) / count(t.status), 1) as ss
from trips t 
where 
t.client_id not in (select users_id from trip_user where banned = 1) AND
t.driver_id not in (select users_id from trip_user where banned = 1)
group by Request_at;

select DISTINCT *  from trips t inner join trip_user tu on (t.Client_Id = tu.Users_Id or
t.Driver_Id = tu.Users_Id) and tu.Banned = 0;

select request_at, 
round(cast(sum(case when status <> 'completed' then 1 else 0 end) as decimal(3,2)) / count(*), 2) 
as cancellation_rate
from (
select *  from trips t inner join trip_user tu on t.Client_Id = tu.Users_Id 
where (t.Driver_Id = tu.Users_Id and t.client_Id = tu.Users_Id and tu.Banned = 0) and
Request_at in ('2013-10-01', '2013-10-02', '2013-10-03')) sub_1 group by Request_at;





select *  from trips t 
inner join trip_user tu on t.Client_Id = tu.Users_Id 
inner join trip_user tuu on t.Driver_Id = tuu.Users_Id 
where Not (tu.Banned = 1 or tuu.Banned = 1) and 
Request_at in ('2013-10-01', '2013-10-02', '2013-10-03');



