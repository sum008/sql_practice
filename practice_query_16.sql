 
--  https://www.hackerrank.com/challenges/binary-search-tree-1/problem
 
 select b1.n, case when b1.p is null then 'root' else 'inner' end as type from bst b1 inner join (select p from bst group by p) b2 
 on b1.n = b2.p where b2.p is not null union 
 (select n, case when n is not null then 'leaf' end as type from bst where n in 
 (select n from bst except select p from bst group by p));


 select n, case when p is null then 'Root'
				when (select count(*) from bst where p=b1.n)>0 then 'Inner'
				else 'Leaf' end as type
from bst b1 order by n;