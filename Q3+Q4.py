create view Actions
as
select B.ID, count(*) as Actions
from Buying B
group by B.ID

create view TotalSum
as
select B.ID, round(sum(B.BQuantity*S.price),3) as TotalSum
from Buying B inner join Stock S on S.Symbol = B.Symbol and S.tDate = B.tDate
group by B.ID

create view Aux_Sector
as
select B.ID, count(B.BQuantity) as Quantity, C.Sector
from Buying B inner join Company C on B.Symbol = C.Symbol
group by B.ID, C.Sector

create view Sector
as
select A.ID ,max(A.Quantity), A.Sector
from Aux_Sector A
group by ID


select distinct ID
from Buying
where ID not in ((select B.ID
                from Buying B
                group by B.ID, B.tDate
                having (count(*) < 2))
                      union
                (select B1.ID
                from Buying B1
                group by B1.ID
                having count(distinct B1.tDate) != (select count(distinct B2.tDate)
                                                    from Buying B2)));


