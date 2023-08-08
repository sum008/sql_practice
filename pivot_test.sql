SELECT  *
FROM
(
	SELECT  'Total'                     AS customer
	       ,format(sales_date,'MMM-yy') AS sales_date
	       ,cast(amount AS int)         AS amount
	FROM pivot_test
) AS sales_data pivot ( SUM(amount) for sales_date IN ([Jan-21], [Feb-21], [Mar-21], [Apr-21], 
[May-21], [Jun-21], [Jul-21], [Aug-21], [Sep-21], [Oct-21], [Nov-21], [Dec-21]) ) AS sales_data;

SELECT  *
FROM pivot_test;

SELECT  *
       ,ROW_NUMBER() OVER(partition by cust_id ORDER BY amount desc) AS row_num
FROM pivot_test;