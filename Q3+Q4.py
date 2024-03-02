create view Actions
as
select
from Stock

create view TotalSum
as
select
from Stock

create view Sector
as
select
from Stock






select *
from Buying
where ID not in (select B.ID
                from Buying B
                group by B.ID, B.tDate
                having (count(*) < 2));
