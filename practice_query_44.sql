-- CREATE TABLE categories (
--     category_id INT PRIMARY KEY,
--     category_name VARCHAR(100) NOT NULL,
--     parent_category_id INT NULL
-- );

-- INSERT INTO categories (category_id, category_name, parent_category_id)
-- VALUES
--     (1, 'Electronics', NULL),
--     (2, 'Mobile Phones', 1),
--     (3, 'Laptops', 1),
--     (4, 'Smartphones', 2),
--     (5, 'Accessories', NULL),
--     (6, 'Cases & Covers', 5),
--     (7, 'Chargers', 5),
--     (8, 'Batteries', 5);


select * from categories;

with cte as (
    select category_id, category_name, category_id as parent_category, category_name as parent_cat_name
    from categories
    union all
    select cat.category_id, cat.category_name, c.parent_category, c.parent_cat_name 
    from categories cat 
    inner join cte c 
    on cat.parent_category_id = c.category_id

)

select * from cte