-- CREATE TABLE empl2 (
--     emp_id INT PRIMARY KEY,
--     emp_name VARCHAR(100) NOT NULL,
--     manager_id INT NULL
-- );

-- INSERT INTO empl2 (emp_id, emp_name, manager_id)
-- VALUES
--     (1, 'Chris', NULL),
--     (2, 'John', 1),
--     (3, 'Jane', 1),
--     (4, 'Michael', 2),
--     (5, 'Emily', 2),
--     (6, 'David', 4),
--     (7, 'Mary', 4),
--     (8, 'Mark', 3);


select * from empl2;

with cte as (
    select emp_id, emp_name, manager_id, 0 as depth 
    from empl2 where manager_id is null
    union all
    select e.emp_id, e.emp_name, e.manager_id, c.depth+1 from empl2 e
    inner join cte c
    on e.manager_id=c.emp_id
)
select c.emp_name, e.emp_name as manager_name ,c.depth 
from cte c left join empl2 e on e.emp_id = c.manager_id
