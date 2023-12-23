select * from practice.cod_wlc_data limit 100;

select `match id`  ,team, sum(score) from practice.cod_wlc_data group by team, `match id`;

select team, sum(score) from practice.cod_wlc_data group by team;

select team, coalesce (max(case when `win?` = 'L' then win_count end),0) as loss,
				coalesce (max(case when `win?` = 'W' then win_count end),0) as wins, 
				coalesce (max(case when `win?` = 'W' then win_count end),0)/coalesce (max(case when `win?` = 'L' then win_count end),1) as win_to_loss_ratio
from (
select team, `win?`, count(`win?`) as win_count from (
select distinct `match id`, team, `win?` from practice.cod_wlc_data cwd ) a group by team, `win?`) b group by team;


select * from practice.cod_wlc_data cwd where player ='Seany' and team <> 'Reciprocity'

-- if a perticular player has played in multiple teams, and in which team did the player played the best(basically, k/d and score, and win/loss)

select a.*, b.team from (
select player, count(player) from (
select a.team, a.player  from 
(select distinct team, player from practice.cod_wlc_data) a inner join 
(select distinct player from practice.cod_wlc_data) b 
on a.player = b.player) c group by player having count(player)>1) a inner join (select distinct player, team from practice.cod_wlc_data) b
on a.player=b.player



