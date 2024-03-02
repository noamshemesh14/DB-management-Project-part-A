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

create view Aux_Sector_Not_Max
as
select DISTINCT A1.ID, A1.Quantity ,A1.Sector
from Aux_Sector A1 inner join Aux_Sector A2 on A1.ID = A2.ID
where A1.Quantity < A2.Quantity or (A1.Quantity = A2.Quantity AND A1.Sector > A2.Sector)

create view Sector
as
select A.ID, A.Sector
from Aux_Sector A left outer join Aux_Sector_Not_Max A1 on A.ID = A1.ID AND A.Sector = A1.Sector
where A1.ID is null;


select distinct A.ID ,A.Actions, TS.TotalSum, Sector.Sector
from Actions A inner join TotalSum TS on A.ID = TS.ID inner join Sector on A.ID = Sector.ID
where A.ID not in ((select B.ID
                from Buying B
                group by B.ID, B.tDate
                having (count(*) < 2))
                      union
                (select B1.ID
                from Buying B1
                group by B1.ID
                having count(distinct B1.tDate) != (select count(distinct B2.tDate)
                                                    from Buying B2)))
ORDER BY Actions DESC, Sector;


