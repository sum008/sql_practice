-- -- select * from products;
-- -- select * from orders;

with cte as (
select 
	p.product_id, 
	o.order_id, 
	p.price_date,
	o.order_date,
	p.price
	from 'data_sources/dynamic_pricing_orders.csv' o 
	left join 'data_sources/dynamic_pricing_products.csv' p 
	on p.product_id = o.product_id and
	p.price_date <= o.order_date
),
cte1 as (
select 
	c.product_id, 
	c.order_id,
	price_date,
	price,
	row_number() over (partition by c.product_id, c.order_id order by c.price_date desc) as rn
from cte c
-- qualify rn = 1
)
select product_id, sum(price) as total_sales from cte1 where rn=1 group by product_id
order by product_id;

-- select * from 'data_sources/dynamic_pricing_orders.csv'