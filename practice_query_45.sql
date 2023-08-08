-- CREATE TABLE empl1 (
--     emp_id INT PRIMARY KEY,
--     emp_name VARCHAR(100) NOT NULL,
--     manager_id INT NULL
-- );

-- INSERT INTO empl1 (emp_id, emp_name, manager_id)
-- VALUES
--     (1, 'Sarah', NULL),
--     (2, 'John', 1),
--     (3, 'Jane', 1),
--     (4, 'Michael', 2),
--     (5, 'Emily', 2),
--     (6, 'David', 4),
--     (7, 'Mary', 4),
--     (8, 'Mark', 3);


select * from empl1;

-- with cte as (
--     select emp_id, emp_name, emp_id as mngr_id, emp_name as mngr_name,
--     CAST(emp_name AS VARCHAR(MAX)) AS emp_hierarchy from empl1
--     union all
--     select e.emp_id, e.emp_name, c.mngr_id, c.mngr_name, 
--     CAST(c.emp_hierarchy + '->' + c.mngr_name + '->' + e.emp_name + '->' AS VARCHAR(MAX)) 
--     from empl1 e inner join cte c 
--     on e.manager_id = c.emp_id
-- )

-- select * from cte


with cte as (
    select emp_id, emp_name, manager_id, emp_id as mngr_id, emp_name as mngr_name,
    CAST(emp_name AS VARCHAR(MAX)) AS emp_hierarchy from empl1
    where manager_id is null
    union all 

    select e.emp_id, e.emp_name, e.manager_id, c.mngr_id, c.mngr_name, 
    CAST(c.emp_hierarchy  + '->' + e.emp_name  AS VARCHAR(MAX)) 
    from empl1 e inner join cte c 
    on e.manager_id = c.emp_id
)

select c.emp_name, e.emp_name as manager_name ,c.emp_hierarchy 
from cte c left join empl1 e on e.emp_id = c.manager_id