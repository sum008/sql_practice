select * from employee order by salary desc;

-- 2nd highest salary
select max(salary) from employee where salary not in 
(select max(salary) from employee);

-- highest salary in each department
select dept_name, max(salary) as mx_sal from employee group by dept_name;

-- 2nd highest salary in each department
select distinct * from (
    select emp_name, dept_name, salary, 
    dense_rank() over (partition by dept_name order by salary desc) as rnk 
    from employee
) sub_1 where rnk = 2;

-- 2nd highest salary in each department without window function
select dept_name, max(salary) as mx_sale 
from employee e where salary not in (
select max(salary)
from employee e1 where e1.dept_name = e.dept_name)
group by dept_name;

-- 2nd highest salary in dept using join, here except right join all join type will WORK
-- because lets say in case of inner join, it will only take those column which 
-- is matching the condition, if we use right join then it will take all the columns with matching condition
-- and remaining columns from right table, so basically the max salary data will also get selected
select dpt_name, max(salary) from (
select dept_name, max(salary) as mx_sal from employee group by dept_name) e1
inner join
(select dept_name as dpt_name, salary from employee) e2 ON
e1.dept_name  = e2.dpt_name and e1.mx_sal <> e2.salary group by dpt_name
