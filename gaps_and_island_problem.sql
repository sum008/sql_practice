create table tower_test
(Tower_Number        VARCHAR(12),
 Tower_Side          VARCHAR(1),
 Tower_Height        integer,
 Tower_Height_Um     VARCHAR(1) default 'm',
 Client              VARCHAR(25),
 Client_Start_Height integer,
 Range_From          integer,
 Range_To            integer);
 
-- No Client

-- Side A
-- Client 1
-- INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'B', 50, 'Client_1', 12, 17, 18);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'A', 50, 'Client_1', 12, 17, 18);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'A', 50, 'Client_1', 12, 22, 23);
-- Client 2
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'A', 50, 'Client_2', 24, 35, 36);
-- Client 3
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'A', 50, 'Client_3', 40, 40, 41);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'A', 50, 'Client_3', 40, 47, 48);

-- Side B
-- Client 1
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'B', 50, 'Client_1', 12, 13, 14);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'B', 50, 'Client_1', 12, 19, 20);
-- Client 2
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'B', 50, 'Client_2', 24, 31, 32);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'B', 50, 'Client_2', 24, 37, 38);
-- Client 3
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'B', 50, 'Client_3', 40, 43, 44);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'B', 50, 'Client_3', 40, 46, 47);

-- Side C
-- Client 1 
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'C', 50, 'Client_1', 12, 17, 18);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'C', 50, 'Client_1', 12, 22, 23);
-- Client 2
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'C', 50, 'Client_2', 24, 28, 29);
-- Client 3
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'C', 50, 'Client_3', 40, 40, 41);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'C', 50, 'Client_3', 40, 47, 48);

-- Side D
-- Client 1
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'D', 50, 'Client_1', 12, 19, 20);
-- Client 2
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'D', 50, 'Client_2', 24, 31, 32);
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'D', 50, 'Client_2', 24, 37, 38);
-- Client 3
INSERT INTO tower_test (Tower_Number, Tower_Side, Tower_Height, Client, Client_Start_Height, Range_From, Range_To) VALUES ('123456_TWR1', 'D', 50, 'Client_3', 40, 46, 47);


SELECT * FROM tower_test order by client, Range_From;
-- ,tower_side, Range_From;


with no_client as (
select tower_number, tower_height,Tower_Height_Um, 
'no_client' as client,
'Not_avail_no_cli' as available_type, --fully available
0 as range_from,
min(Client_Start_Height)-1 as range_to
from tower_test
group by tower_number, tower_height,Tower_Height_Um
having min(Client_Start_Height) > 0
),

na_or_pa as (
select tower_number, tower_height,Tower_Height_Um, 
-- min(client) as client,
client,
'Gap-fully_avail-x' available_type, --fully available
case when min(Client_Start_Height) < min(Range_From) then min(Client_Start_Height) 
    when max(range_to) < tower_height then max(Range_to) +1
  end as Range_From,
case when min(Client_Start_Height) < min(Range_From) then min(Range_from)-1 
    when max(range_to) < tower_height then tower_height
  end as Range_To
from tower_test
group by tower_number, tower_height,Tower_Height_Um
, client
having min(Client_Start_Height) < min(Range_From) 
  or max(range_to) < tower_height

union all

select tower_number, tower_height,Tower_Height_Um, client,
-- case when sum(case when Tower_Side in ('A','C') then 1 else 0 end) = 2
--           or sum(case when tower_side in ('B','D') then 1 else 0 end) = 2 
--     then 'NA' else 'PA' end as available_type,
case when count(distinct case when Tower_Side in ('A','C') then Tower_Side end) 
  + count(distinct case when tower_side in ('B','D') then Tower_Side end) = 2
    then 'Not_avail' else 
    case when count(distinct tower_side) =1 then 'Partial_avail' else 'Fault' end 
  end as available_type,
-- case when count(distinct tower_side) =1 then 'PA' end as available_type,
range_from,
range_to
from tower_test
group by tower_number, tower_height,Tower_Height_Um, client, range_from, range_to
),

data_for_gaps as (
select tower_number, tower_height,Tower_Height_Um, client, 'Gap-fully_avail',
lead(range_from) over (partition by tower_number, tower_height,Tower_Height_Um order by range_from) as lead_range_from,
range_from, range_to
from na_or_pa
)
,
gaps as (
select tower_number, tower_height,Tower_Height_Um, client,
'Gap-fully_avail' as available_type,
case when lead_range_from > range_to+1 then range_to+1 end as range_from,
case when lead_range_from > range_to+1 then lead_range_from-1 end as range_to
from data_for_gaps
)

select * from no_client
union
select tower_number, tower_height,Tower_Height_Um, client, available_type, range_from, range_to from na_or_pa
union
select * from gaps where range_from is not null
order by range_from
