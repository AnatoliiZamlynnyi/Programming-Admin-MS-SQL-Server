-----------DDL-------------
create database TestZaml --створити базу
use TestZaml --перейти в базу
use master
drop database TestZaml --видалити базу
CREATE TABLE Products( --cтворити таблицю
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(MAX) NOT NULL,
Category NVARCHAR(MAX),
Price MONEY --CHECK (Price>1)
);
DROP TABLE Products -- видалити таблицю
ALTER TABLE Products ALTER COLUMN Category nvarchar(20) NOT NULL --редагування полів
ALTER TABLE Products ADD Discount INT NULL CHECK (Discount<15)
ALTER TABLE Products ADD CONSTRAINT PK_Prodacts Primary key (Id)
ALTER TABLE Products drop CONSTRAINT PK_Products
ALTER TABLE Products DROP COLUMN Category
Create Table Customer(
CustomerID uniqueidentifier NOT NULL
DEFAULT newid(),
Company varchar(30) NOT NULL,
ConstName varchar(max) NOT NULL
)
ALTER TABLE Products ADD CategoryID INT Constraint FK_Prod_Category Foreign key REFERENCES Category(Id)

Create Table Category(
Id int NOT NULL IDENTITY PRIMARY KEY,
CategoryName nvarchar(max) NOT NULL
)


CREATE TABLE Muvies(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(MAX) NOT NULL,
Category NVARCHAR(MAX),
Price float CHECK (Price>1),
CategoryID INT NOT NULL CONSTRAINT FK_Muvies_Category FOREIGN KEY REFERENCES Category(Id)
);


------------------DML----------------------

Insert into Muvies Values
('Shark',1,25.3,1),
('Shark',1,25.3,1),
('Shark',1,25.3,1),
('Shark',1,25.3,1);
select *from Muvies
UPDATE Muvies set Price=30;
delete from Muvies;

Insert into Muvies (CategoryId, ShopId, Name )
Values(1, 1, 'Yuogurt')
-------WHERE----------
Select *From Muvies where Price>26
Select *From Muvies where Price<>26
Select *From Muvies where Price is not null
Update Muvies set Price=110 where Price IS NOT NULL
Update Muvies set Price=110 where Price IS NULL
Update Muvies set Price=null where Price <>110
delete from Muvies where name='Milk'
------------select-----------
select Name as 'Muvies Name' from Muvies
select [Name]+'-'+convert(nvarchar(20), Price) as 'Muvies Name' from Muvies
go
Insert into Shops values('CoolShop', null), ('VeryCoolShop', 'Kyiv'),('Shop to bag', 'Rivne')
select Id from Shops where Name='CoolShop' ;
select Id from Category where CategoryName='Electronic';
go
Insert into Muvies (CategoryId, Name )
Values((select Id from Category where CategoryName='Electronic'),(select id from Shops where Name='CoolShop'),'Yuogurt')
------------------
go
select Muvies.Id, Muvies.Name, CategoryName, ShopName from Muvies, Category, Shops
where Muvies.CategoryID=Category.Id and Muvies.ShopsId=Shops.Id
