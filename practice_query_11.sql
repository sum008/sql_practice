select * from company_tbl t1
join company_tbl t2 on t1.Company = t2.Company
order by t1.company, t1.id, t1.salary desc;


select * from company_tbl t1, company_tbl t2;
select * from company_tbl t1;



CREATE TABLE temperature (
    id int,
    record_date date,
    temperature int
);

insert into temperature values (2, '2015-01-02', 25), 
(3, '2015-01-03', 20),
(4, '2015-01-04', 30);

select * from temperature as t2, temperature as t1 
where DATEDIFF(day, t1.record_date, t2.record_date) = 1 
and 
t2.temperature > t1.temperature;



SELECT *,
CASE WHEN t2.Salary<t1.Salary THEN 1
WHEN t2.Salary>t1.Salary THEN -1
WHEN t2.Salary=t1.Salary AND t2.Id<t1.Id THEN 1
WHEN t2.Salary=t1.Salary AND t2.Id>t1.Id THEN -1
ELSE 0 END as tt
FROM company_tbl AS t1 JOIN company_tbl AS t2
ON t1.Company = t2.Company;

