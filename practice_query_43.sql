-- -- Create the "employees" table
-- CREATE TABLE employees (
--     emp_id INT PRIMARY KEY,
--     emp_name VARCHAR(50) NOT NULL,
--     manager_id INT
-- );

-- -- Insert data into the "employees" table
-- INSERT INTO employees (emp_id, emp_name, manager_id) VALUES
-- (1, 'John', 4),
-- (2, 'Jane', 4),
-- (3, 'Mike', 5),
-- (4, 'Sarah', 6),
-- (5, 'Chris', 6),
-- (6, 'Alex', NULL),
-- (7, 'Emily', 5),
-- (8, 'Mark', 4),
-- (9, 'Lisa', 6),
-- (10, 'Tom', 5);


select * from employees;


with cte as (

    select emp_id as e1_id, emp_name as e1_name, manager_id as m1_id, emp_name as mngr_name 
    from employees where manager_id is null
    union all
    select emp_id, emp_name, manager_id, c.mngr_name from employees e1 inner join cte c
    on c.e1_id = e1.manager_id
    

)
select * from cte;

WITH EmployeeHierarchy AS (
    SELECT
        emp_id,
        emp_name,
        manager_id,
        emp_name AS manager_name,
        0 AS depth,
        CAST('/' + CAST(emp_id AS VARCHAR(MAX)) + '/' AS VARCHAR(MAX)) AS emp_path
    FROM employees
    
    UNION ALL
    
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        eh.manager_name,
        eh.depth + 1,
        CAST(eh.emp_path + CAST(e.emp_id AS VARCHAR(MAX)) + '/' AS VARCHAR(MAX))
    FROM employees AS e
    INNER JOIN EmployeeHierarchy AS eh ON e.manager_id = eh.emp_id
)
SELECT *
FROM EmployeeHierarchy;
