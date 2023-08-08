-- Query 4:

-- From the doctors table, fetch the details of doctors who work in the same hospital but in different speciality.

-- Fetch the details of doctor who has max or min fees if two or more doctor work in same hospital as well as under same 
-- speciality (applicable to first sceario as well)

--Table Structure:

-- create table doctors
-- (
-- id int primary key,
-- name varchar(50) not null,
-- speciality varchar(100),
-- hospital varchar(50),
-- city varchar(50),
-- consultation_fee int
-- );

-- insert into doctors values
-- (1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
-- (2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
-- (3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
-- (4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
-- (5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
-- (6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

-- update doctors set speciality = 'Dermatology' where id = 7;

-- insert into doctors values (8, 'Dr. Mehak', 'Dermi', 'Apollo Hospital', 'Bangalore', 2100);
-- insert into doctors values (9, 'Dr. KKK', 'Dermi', 'Apollo Hospital', 'Bangalore', 2000);
-- insert into doctors values (10, 'Dr. PPP', 'Dermi', 'Apollo Hospital', 'Bangalore', 2800);

select * from doctors order by hospital desc;

select * from doctors d1 join doctors d2 on d1.hospital = d2.hospital and d1.speciality <> d2.speciality and d1.id <> d2.id;

SELECT  *
FROM
(
	SELECT  *
	       ,MAX(consultation_fee) over (partition by speciality, hospital) AS mx_fee
	FROM
	(
		SELECT  *
		FROM
		(
			SELECT  *
			       ,COUNT(*) over(partition by speciality,hospital) AS sub_part_cnt
			FROM
			(
				SELECT  *
				       ,COUNT(*) over (partition by hospital) AS part_count
				FROM
				(
					SELECT  *
					FROM doctors
				) sub_query_1
			) sub_query_2
		) sub_query_3
		WHERE part_count <> sub_part_cnt
		AND part_count > 1
		-- AND sub_part_cnt >= 1
	) sub_query_4
) sub_query_5
WHERE consultation_fee = mx_fee;