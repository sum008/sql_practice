-- https://stackoverflow.com/questions/79690317/select-groups-of-values-that-cover-a-date-interval-together

CREATE TABLE group_intervals (
    group_id INTEGER,
    valid_from date,
    valid_to date
);

-- INSERT INTO group_intervals (group_id, valid_from, valid_to) VALUES
-- (1, '2025-02-01', '2025-02-28'),
-- (2, '2025-02-01', '2025-02-28'),
-- (2, '2025-02-01', '2025-02-28'),
-- (3, '2025-02-01', '2025-02-15'),
-- (3, '2025-02-13', '2025-02-20'),
-- (3, '2025-02-21', '2025-02-28'),
-- (4, '2025-01-01', '2025-02-20'),
-- (4, '2025-02-10', '2025-02-15'),
-- (4, '2025-02-19', '2025-02-28'),
-- (5, '2025-01-01', '2025-01-15'),
-- (5, '2025-05-13', '2025-06-19');


INSERT INTO group_intervals (group_id, valid_from, valid_to) VALUES
(1, '2025-02-01', '2025-02-28'),
(2, '2025-02-01', '2025-02-20'),
(2, '2025-02-22', '2025-02-25'),
(2, '2025-02-23', '2025-02-28'),
(3, '2025-02-01', '2025-02-15'),
(3, '2025-02-13', '2025-02-20'),
(3, '2025-02-21', '2025-02-28'),
(4, '2025-01-01', '2025-02-20'),
(4, '2025-02-25', '2025-02-26'),
(4, '2025-02-19', '2025-02-28'),
(5, '2025-01-01', '2025-01-15'),
(5, '2025-05-13', '2025-06-19');

select * from group_intervals
-- where group_id in (4,5)
;

-- Step 1: Compute preceding_date and difference for intervals
WITH cte AS (
    SELECT *, 
           MAX(valid_to) OVER (
               PARTITION BY group_id 
               ORDER BY valid_from ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
           ) AS preceding_date,
           valid_from - MAX(valid_to) OVER (
               PARTITION BY group_id 
               ORDER BY valid_from ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
           ) AS dif
    FROM group_intervals
),

-- Step 2: Create custom partitions for continuous intervals using sum over difference logic
custom_partition AS (
    SELECT *, 
           SUM(CASE 
                   WHEN COALESCE(dif, 0) <= 1 THEN 0 
                   ELSE 1 
               END
           ) OVER (
               PARTITION BY group_id 
               ORDER BY valid_from ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS part
    FROM cte
),

-- Step 3: Calculate new min and max dates for each partition
new_min_max_date AS (
    SELECT *, 
           MIN(valid_from) OVER (PARTITION BY group_id, part) AS min_valid_from,
           MAX(valid_to) OVER (PARTITION BY group_id, part) AS max_valid_to
    FROM custom_partition
),

-- Step 4: Remove duplicates and clean results
cleaned AS (
    SELECT DISTINCT 
           group_id, 
           min_valid_from, 
           max_valid_to, 
           part 
    FROM new_min_max_date
    ORDER BY group_id, min_valid_from
)

-- Step 5: Perform final aggregation and join with `group_intervals`
SELECT 
    gi.group_id AS g_group_id,
    gi.valid_from, 
    gi.valid_to, 
    MAX(part) AS partition_from_cleaned,
    ARRAY_AGG(nm.group_id) AS n_group_id,
    STRING_AGG(CONCAT(CAST(nm.group_id AS VARCHAR), '-', nm.part), ',') AS n_group_id_details
FROM group_intervals gi
LEFT JOIN cleaned nm
    ON min_valid_from <= gi.valid_from 
       AND gi.valid_from <= max_valid_to 
       AND min_valid_from <= gi.valid_to 
       AND gi.valid_to <= max_valid_to
       AND gi.group_id <> nm.group_id
GROUP BY 
    gi.group_id, 
    gi.valid_from, 
    gi.valid_to
ORDER BY 
    g_group_id;
