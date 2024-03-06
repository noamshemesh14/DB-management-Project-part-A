create table Investor(
    Id int primary key check (Id <= 999999999 and Id >= 100000000),
    IName varchar(40),
    BirthDate date check (BirthDate < '2006-01-01'),
    Email varchar(40) unique ,
    Rdate date
    -- Unable to implement in DDL: each Investor has at least one tradeAccount.
    -- one-to-many relation that isn't stored and enforced in Investor table.
    -- Can be verified using SQL query.
);

create table Premium(
    Id int primary key ,
    FinancialGoals varchar(40),
    foreign key (Id) references Investor(Id) on delete cascade
);

create table Employee(
    Id int primary key ,
    foreign key (Id) references Premium (Id) on delete cascade
    -- Unable to implement in DDL: each employee guides at least one beginner.
    -- one-to-many relation that isn't stored and enforced in Employee table.
    -- Can be verified using SQL query.
);

create table Beginner(
    Id int primary key ,
    Guided_by int not null, -- each beginner has exactly 1 guide (therefor not null).
    check (Id != Guided_by),
    foreign key (Id) references Investor(Id) on delete cascade,
    foreign key (Guided_by) references Employee (Id)
    --Unable to on delete cascade, may cause cycles or multiple cascade paths.
);

create table Company(
    Symbol   varchar(40) primary key,
    Sector   varchar(40),
    Founded  date,
    Location varchar(40),
    -- Unable to implement in DDL: each Company has at least one Stock a day.
    -- Can be verified using SQL query.
);

create table Rival_of(
    Company1 varchar(40),
    Company2 varchar(40),
    Cause varchar(40) ,
    Employee int UNIQUE default null,
    Document varchar(40),
    primary key (Company1,Company2),
    check (Company1 > Company2), -- defining relation as ordered pair to ignore internal order.
    -- prevents reflexivity (company is a rival of itself).
    check ((Employee is null and Document is null) or (Employee is not null and Document is not null )),
    foreign key (Company1) references Company(symbol) on delete cascade ,
    foreign key (Company2) references Company(symbol),
    --Unable to on delete cascade, may cause cycles or multiple cascade paths.
    foreign key (Employee) references Employee(Id) on delete set null
);

create table TradeAccount(
    TAid char(10) primary key ,
    Money double precision ,
    -- Unable to implement in DDL: Money = sum of transactions made to TA - invested money
    -- field value can't be calculated by values in different rows / tables.
    -- Can be verified using SQL query.
    Investor int,
    foreign key (Investor) references Investor(Id) on delete cascade
);

create table Transfer(
    Tdate date,
    TAid char (10),
    Tamount double precision check (Tamount >= 1000),
    Employee int default null,
    TLegality char(1) check (TLegality = '1' or TLegality = '0'),
    primary key (Tdate,TAid),
    check ((Employee is null and TLegality is null) or (Employee is not null and TLegality is not null )),
    foreign key (TAid) references TradeAccount(TAid) on delete cascade ,
    foreign key (Employee) references Employee(Id)
    --Unable to on delete set null, may cause cycles or multiple cascade paths.
);

create table Stock(
    Sdate date,
    Company varchar(40),
    Svalue double precision,
    primary key (Sdate,Company),
    foreign key (Company) references Company(symbol) on delete cascade
);

create table Buying (
    SAmount double precision,
    TAid char(10),
    Sdate date,
    Company varchar(40),
    primary key (TAid,Sdate,Company),
    foreign key (TAid) references TradeAccount(TAid) on delete cascade,
    foreign key (Sdate,Company) references Stock(Sdate,Company) on delete cascade
);
