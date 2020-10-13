--Create a database named "Manufacturer"

create database Manufacturer
--on
--(
--Name=ManufacturerData1,
--FileName='C:\DATABASES\DATA\ManufacturerData1.mdf',
--size=10MB, --KB, MB,GB,TB
--maxsize=unlimited,
--filegrowth= 1GB
--)
--log on
--(
--Name=ManufacturerLog,
--FileName='C:\DATABASES\DATA\ManufacturerLog1.ldf',
--size=10MB, --KB, MB, GB,TB
--maxsize=unlimited,
--filegrowth= 1024MB
--)

--Create the tables inthe database.
--Create keys (PKs, FKs etc).
use Manufacturer
create table Components
([compID] int primary key identity(1,1) not null,
--or
--[compID] int identity(1,1) not null,
--PRIMARY KEY (compID)
[comp_name] varchar(20) not null,
[description] varchar(50)  not null 
);


insert into dbo.[Components](
[comp_name],
[description])

values
('car tire','125/45 R 16 86H'),
('car tire','195/55 R 16 87V'),
('car tire','195/45 R 16 84V'),
('car tire','215/55 R 16 93H'),
('car tire','185/45 R 18 85H'),
('car tire','195/45 R 16 84V'),
('car tire','205/60 R 17 92H'),
('rim','7.5X17 CAR 737 5X114.3 ET45 72.6 MBZ'),
('rim','8.5X16 CAR 737 5X114.3 ET45 72.6 MBZ'),
('rim','9.5X16 CAR 737 5X114.3 ET45 72.6 MBZ'),
('rim','6.5X16 CAR 737 5X114.3 ET45 72.6 MBZ'),
('rim','7.5X17 CAR 737 5X114.3 ET45 72.6 MBZ');

--use Manufacturer
--select * from dbo.[Components]

create table [Suppliers](
[supplierID] int primary key identity(1,1) not null,
[supplier_name] varchar(20) not null
);


insert into dbo.[Suppliers]
([supplier_name])

values
('Koçtaş'),
('Tekzen'),
('Goodyear'),
('Garajmarketim'),
('bauhouse');

--select * from dbo.[Suppliers]

create table Products
([productID] int primary key identity(1,1) not null,
[product_name] varchar(20) not null,
[quantity] int not null 
);


insert into dbo.[Products]
([product_name],[quantity])

values
('Toyota Corolla',3),
('Ford Focus',1),
('Ford K',7),
('Fiat Albea',2),
('Mazda 3',4),
('Renault Laguna',1),
('Murat 131',1),
('Renault Toros',4),
('Kia Picanto',7),
('Voswagen Jetta',5),
('Voswagen Golf',2),
('Voswagen Passat',4);

--use Manufacturer
--select * from dbo.[Products]

create table Comp_Products (
[productID] int foreign key REFERENCES dbo.[Products]([productID]),
[compID] int foreign key REFERENCES dbo.[Components]([compID])
--CONSTRAINT fk1_productId FOREIGN KEY ([productID]) REFERENCES Products ([productID]),
--CONSTRAINT fk2_componentId FOREIGN KEY ([compID]) REFERENCES Components ([compID]),
--PRIMARY KEY ([productID], [compID]) 
--([productID], [compID]) birlikte composite primary key olusturur.
);
--select * from Products
--select * from [Components]

insert into dbo.[Comp_Products]
([productID],[compID])

values
(1,3),
(1,5),
(6,7),
(3,2),
(4,12),
(10,1),
(11,1),
(7,4),
(2,7),
(6,5),
(9,2),
(4,10);

--use Manufacturer
--select * from dbo.[Comp_Products]

create table Comp_Supplier
([compID] int foreign key REFERENCES dbo.[Components]([compID]),
[supplierID] int foreign key REFERENCES dbo.[Suppliers]([supplierID]),
--CONSTRAINT fk1_supplierID FOREIGN KEY ([supplierID]) REFERENCES  Suppliers ([supplierID]),
--CONSTRAINT fk3_componentID FOREIGN KEY ([compID]) REFERENCES Components ([compID]),
--PRIMARY KEY (supplierID, compID)
--([supplierID], [compID]) birlikte composite primary key olusturur.
);

--select * from Suppliers
--select * from [Components]

insert into dbo.[Comp_Supplier]
([compID],[supplierID])

values
(10,3),
(11,5),
(6,1),
(3,2),
(2,4),
(1,1),
(11,1),
(7,4),
(2,5),
(8,5),
(9,2),
(8,3);

--use Manufacturer
--select * from dbo.[Comp_Supplier]