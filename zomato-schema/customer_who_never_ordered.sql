with users as (
    select * from read_csv('https://docs.google.com/spreadsheets/d/1JgNHxTixDA50W1l6pNFmHKRaX1a9QnXrpGLsJtzo6Gg/export?format=csv&gid=0')
),
orders as (
    select * from read_csv('https://docs.google.com/spreadsheets/d/1JgNHxTixDA50W1l6pNFmHKRaX1a9QnXrpGLsJtzo6Gg/export?format=csv&gid=1555918958')
)
select u.user_id, u.name from users u
left join orders o
on u.user_id = o.user_id
where o.user_id is null