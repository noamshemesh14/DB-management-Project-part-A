create table Investor(
    Id char(9) primary key check (Id != '0%'),
    IName varchar(40),
    BirthDate date check (BirthDate >= '2016-01-01'),
    Email varchar(40) unique ,
    Rdate date
    -- UNIQUE (Id, Rdate), to be considered
);

create table Premium(
    Id char(9) primary key ,
    Rdate date check (Rdate <= DATEADD(month, -3, GETDATE())),
    FinancialGoals varchar(40),
    foreign key (Id) references Investor(Id) on delete cascade
    -- foreign key (Id, Rdate) references Investor(Id) on delete cascade, to be considered

);

create table Employee(
    Id char(9)primary key ,
    foreign key (Id) references Premium (Id) on delete no action
    -- each employee guides at least one beginner investor
);

create table Beginner(
    Id char(9) primary key ,
    Rdate date check (Rdate > DATEADD(month, -3, GETDATE())),
    Guided_by char(9) not null,
    foreign key (Id) references Investor(Id) on delete cascade,
    foreign key (Guided_by) references Employee (Id) on delete cascade
);

create table Company(
    Symbol   varchar(40) primary key,
    Sector   varchar(40),
    Founded  date,
    Location varchar(40),
);

create table Rival_of(
    Company1 varchar(40),
    Company2 varchar(40),
    Cause varchar(40),
    Employee char(9),
    Document varchar(40),
    primary key (Company1,Company2),
    foreign key (Company1) references Company(symbol) on delete no action ,
    foreign key (Company2) references Company(symbol) on delete no action ,
    foreign key (Employee) references Employee(Id) on delete set null ,
    check (Company1 > Company2)
);

create table TradeAccount(
    TAid char(10) PRIMARY KEY ,
    Money varchar(40) ,
    --money attribute can't be some of value from different rows.
    Investor char(9),
    foreign key (Investor) references Investor(Id) on delete cascade
);

create table Transfer(
    Tdate date,
    TAid char (10),
    Tamount varchar(40) check (Tamount >= 1000),
    Employee char(9),
    TLegality varchar(40) check (TLegality = 1 OR TLegality = 0),
    primary key (Tdate,TAid),
    foreign key (TAid) references TradeAccount(TAid) on delete cascade ,
    foreign key (Employee) references Employee(Id) on delete set null
);

create table Stock(
    Sdate date,
    Company varchar(40),
    Svalue varchar(40),
    primary key (Sdate,Company),
    foreign key (Company) references Company(symbol) on delete cascade ,
    --Each company have to at least one stock at day.
);

create table Buying (
    SAmount varchar(40),
    TAid char(10),
    Svalue varchar(40),
    Company varchar(40),
    primary key (SAmount,TAid,Svalue,Company)
);


--drop table Buying ;
--drop table Stock;
--drop table Transfer;
--drop table TradeAccount;
--drop table Rival_of;
--drop table Company;
--drop table Beginner;
--drop table Employee;
--drop table Premium;
--drop table Investor;





