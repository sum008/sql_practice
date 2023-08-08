SELECT  SUM(final) AS median
FROM
(
	SELECT  *
	       ,id_a+id_b+id_c AS final
	FROM
	(
		SELECT  id
		       ,CASE WHEN id_a is not null THEN cast(val AS decimal)/2  ELSE 0 END AS id_a
		       ,CASE WHEN id_b is not null THEN cast(val AS decimal)/2  ELSE 0 END AS id_b
		       ,CASE WHEN id_c is not null THEN val  ELSE 0 END                    AS id_c
		FROM
		(
			SELECT  *
			FROM
			(
				SELECT  *
				FROM test_tbl t1
				LEFT JOIN
				(
					SELECT  CASE WHEN AVG(cast(id AS DECIMAL)) % 1 <> 0 THEN AVG(id) END AS id_a
					FROM test_tbl
				) t2
				ON t1.id = t2.id_a
				LEFT JOIN
				(
					SELECT  CASE WHEN AVG(cast(id AS DECIMAL)) % 1 <> 0 THEN AVG(id)+1 END AS id_b
					FROM test_tbl
				) t3
				ON t1.id = t3.id_b
				LEFT JOIN
				(
					SELECT  CASE WHEN AVG(cast(id AS DECIMAL)) % 1 = 0 THEN AVG(id) END AS id_c
					FROM test_tbl
				) t4
				ON t1.id = t4.id_c
			) tt
			WHERE id_a is not null or id_b is not null or id_c is not null
		) ty
	) tz
) tk;

select * from test_tbl;

delete from test_tbl where id = 5;
insert into test_tbl values (5, 8);