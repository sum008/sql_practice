-- CREATE table source (id smallint, name varchar(255));
-- CREATE table target (id smallint, name varchar(255));

-- TRUNCATE table source;
-- bulk insert source from 'C:\Users\sumit.a.kumar\Desktop\source.csv'
-- with (format = 'CSV', firstrow=2) ;

-- TRUNCATE table target;
-- bulk insert target from 'C:\Users\sumit.a.kumar\Desktop\target.csv'
-- with (format = 'CSV', firstrow=2) ;

select * from source;
SELECT * from [target];

select * from source join target on source.id = [target].id and source.name != [target].name;

select * from source except select * from source union select * from [target];

