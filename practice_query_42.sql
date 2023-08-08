-- Write an SQL query to find the top 3 customers who have made the highest number of orders within a 7-day sliding window.



-- INSERT INTO customer1 (order_id, customer_id, order_date)
-- VALUES
--   (12, 104, '2022-05-9');

--   select * from customer1;

with
    cte
    as
    (
        select *, dense_rank() over (order by order_date) as rnk
        from customer1
    )
select customer_id, max_count
from (
select *, row_number() over (order by max_count desc) as rnk
    from (
select customer_id, max(cnt) as max_count
        from (
select customer_id, order_date, rnk, (select count(customer_id)
                from cte c
                where 
c.customer_id = c1.customer_id and c1.rnk - c.rnk <= 7 and c1.rnk - c.rnk >= 0) as cnt
            from cte c1) x
        group by customer_id) y) z
where rnk <= 3 

