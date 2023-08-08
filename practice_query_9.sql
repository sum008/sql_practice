-- Query 9:

-- Find the top 2 accounts with the maximum number of unique patients on a monthly basis.

-- Note: Prefer the account if with the least value in case of same number of unique patients

--Table Structure:

-- drop table patient_logs;
-- create table patient_logs
-- (
--   account_id int,
--   date date,
--   patient_id int
-- );

-- insert into patient_logs values (1, cast('20200102' as date), 100);
-- insert into patient_logs values (1, cast('20200127' as date), 200);
-- insert into patient_logs values (2, cast('20200101' as date), 300);
-- insert into patient_logs values (2, cast('20200121' as date), 400);
-- insert into patient_logs values (2, cast('20200121' as date), 300);
-- insert into patient_logs values (2, cast('20200101' as date), 500);
-- insert into patient_logs values (3, cast('20200120' as date), 400);
-- insert into patient_logs values (1, cast('20200304' as date), 500);
-- insert into patient_logs values (3, cast('20200120' as date), 450);

select * from patient_logs;

SELECT  *
FROM
(
	SELECT  *
	       ,first_value(account_id) over(partition by part ORDER BY account_id) AS selected_id
	FROM
	(
		SELECT  *
		       ,SUM(CASE WHEN lag_mx <> max_unique_pat THEN 1 ELSE 0 END) over (order by sub_query_5.max_unique_pat desc rows BETWEEN unbounded PRECEDING AND current row) AS part
		FROM
		(
			SELECT  *
			       ,lag(sub_query_4.max_unique_pat) over (order by sub_query_4.max_unique_pat desc) AS lag_mx
			FROM
			(
				SELECT  *
				FROM
				(
					SELECT  *
					       ,MAX(part_count) over (partition by account_id) AS max_unique_pat
					FROM
					(
						SELECT  *
						       ,COUNT(*) over (partition by account_id,year(date),month(date) ORDER BY account_id) AS part_count
						FROM
						(
							SELECT  *
							FROM
							(
								SELECT  *
								       ,CASE WHEN lag(patient_id) over (partition by account_id,year(date),month(date) ORDER BY patient_id) = patient_id THEN 'x'  ELSE 'y' END AS lg
								FROM patient_logs
							) sub_query_a
							WHERE lg = 'y' 
						) sub_query_1
					) sub_query_2
				) sub_query_3
				WHERE part_count = max_unique_pat 
			) sub_query_4
		) sub_query_5
	) sub_query_6
) sub_query_7
WHERE selected_id = account_id;


select month_, account_id, no_unique_pat from (
SELECT DateName( month , DateAdd( month , month(date) , 0 ) - 1 ) as month_, account_id, part_count as no_unique_pat
FROM
(
	SELECT  *
	       ,first_value(account_id) over(partition by part ORDER BY account_id) AS selected_id
	FROM
	(
		SELECT  *
		       ,SUM(CASE WHEN lag_mx <> max_unique_pat THEN 1 ELSE 0 END) over (order by sub_query_5.max_unique_pat desc rows BETWEEN unbounded PRECEDING AND current row) AS part
		FROM
		(
			SELECT  *
			       ,lag(sub_query_4.max_unique_pat) over (order by sub_query_4.max_unique_pat desc) AS lag_mx
			FROM
			(
				SELECT  *
				FROM
				(
					SELECT  *
					       ,MAX(part_count) over (partition by account_id) AS max_unique_pat
					FROM
					(
						SELECT  *
						       ,COUNT(*) over (partition by account_id,year(date),month(date) ORDER BY account_id) AS part_count
						FROM
						(
							SELECT  *
							FROM
							(
								SELECT  *
								       ,CASE WHEN lag(patient_id) over (partition by account_id,year(date),month(date) ORDER BY patient_id) = patient_id THEN 'x'  ELSE 'y' END AS lg
								FROM patient_logs
							) sub_query_a
							WHERE lg = 'y' 
						) sub_query_1
					) sub_query_2
				) sub_query_3
				-- WHERE part_count = max_unique_pat 
			) sub_query_4
		) sub_query_5
	) sub_query_6
) sub_query_7
WHERE selected_id = account_id) sub_query_8 group by month_, account_id, no_unique_pat order by no_unique_pat desc;


select account_id
       ,month_, unique_pat, ROW_NUMBER() over (partition by month_ order by unique_pat) as rn from (
SELECT  account_id
       ,month_
       ,COUNT(1) AS unique_pat
FROM
(
	SELECT DISTINCT DateName(month ,DateAdd(month ,month(date) ,0 ) - 1 ) AS month_
	       ,patient_id, account_id
	FROM patient_logs
) q_1
GROUP BY  account_id
         ,month_) q_2;