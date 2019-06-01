use master
DROP BookShopPublisherZam
create database BookShopPublisherZam
Go
use BookShopPublisherZam
Go

CREATE TABLE Country(
Id INT PRIMARY KEY NOT NULL IDENTITY,
CountryName nvarchar(20),
);


CREATE TABLE Publish
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
PublishName nvarchar(30) NOT NULL,
CountryId INT CONSTRAINT FK_Publish_Country Foreign KEY  References Country(Id)
);

CREATE TABLE Address
(
Id INT NOT NULL PRIMARY KEY IDENTITY,
Street nvarchar(20) NOT NULL default 'no street',
City nvarchar(20) NOT NULL,
CountryId INT CONSTRAINT FK_Address_Country Foreign KEY  References Country(Id)
);


CREATE TABLE Author
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
AuthorName nvarchar(30) NOT NULL,
AddressId INT CONSTRAINT Fk_Author_Address FOREIGN KEY REFERENCES Address(Id),
PublishId INT CONSTRAINT Fk_Author_Publish FOREIGN KEY REFERENCES Publish(Id)
);

CREATE TABLE Category
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
CategotyName nvarchar(50) NOT NULL
);

CREATE TABLE Book
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
BookName nvarchar(250) NOT NULL,
Description nvarchar(MAX) NULL,
NumberPages INT,
Price Money NOT NULL,
PublishDate Date DEFAULT GETDATE(),
AuthorId INT CONSTRAINT Fk_Book_Author FOREIGN KEY REFERENCES Author(Id),
CategoryId INT CONSTRAINT Fk_Book_Category FOREIGN KEY REFERENCES Category(Id)
);

CREATE TABLE UserProfile
(
Id INT PRIMARY KEY IDENTITY,
Email nvarchar(30) UNIQUE NOT NULL CHECK (Email LIKE '%@%'),
Password nvarchar(20) NOT NULL CHECK (LEN(Password)>=6),
CONSTRAINT FK_UserProfile_Author FOREIGN KEY(Id) REFERENCES Author(Id)
);

CREATE TABLE Shop
(
Id INT PRIMARY KEY IDENTITY,
ShopName nvarchar(30) NOT NULL,
CountryId INT CONSTRAINT Fk_Shop_Country FOREIGN KEY REFERENCES Country(Id)
);

CREATE TABLE Incomes
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateIncomes Date NOT NULL,
Amount INT NOT NULL,
CONSTRAINT Fk_Incomes_Shop Foreign Key (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_Incomes_Book Foreign Key (BookId) REFERENCES Book(Id),
);

CREATE TABLE Sales
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateSale Date NOT NULL,
Amount INT NOT NULL,
SalePrice money NOT NULL,
CONSTRAINT Fk_Sales_Shop Foreign Key (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_Sales_Book Foreign Key (BookId) REFERENCES Book(Id),
);
-----------INSERT VALUES--------------------------
Go
INSERT INTO Country Values
('China'),
('Poland'),
('Ukraine')
;
Go
INSERT INTO Address VALUES
('BigStreet','Vroclav',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Bednarska','Varshava',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Gdanska','Branevo',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Mury','Rivne',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Soborna','Rivne',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Hrescharuk','Kyiv',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Cisy','Ninbo',(SELECT Id FROM Country WHERE CountryName='China'));

INSERT INTO Publish VALUES
('CoolPublisher',(SELECT Id FROM Country WHERE CountryName='Poland')),
('ZirkaBook',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Ababagalamaga',(SELECT Id FROM Country WHERE CountryName='Ukraine'));

INSERT INTO Author VALUES
('Ivanov',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Petrov',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Verne Jules',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Vorontsov Nikolay',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Andersen Hans Christian',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Romanova M.',(SELECT Id FROM Address WHERE Street='Bednarska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher')),
('Scotton P.',(SELECT Id FROM Address WHERE Street='Bednarska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher')),
('Fanny Marceau',(SELECT Id FROM Address WHERE Street='Gdanska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher'));

INSERT INTO UserProfile VALUES
('ivanov@mail.ru','qwertyy');

INSERT INTO Category VALUES
('Historical'),
('Scientific'),
('Childrens'),
('Adults'),
('Artistic'),
('Fantasy'),
('Poetry');



INSERT INTO Book  VALUES
('Roksolana',NULL,100,250.5,'12.10.2005',(select Id from Author where AuthorName='Ivanov'),(select Id from Category where CategotyName='Historical')),
('Volodimyr',NULL,NULL,400.5,'10.05.2016',(select Id from Author where AuthorName='Ivanov'),(select Id from Category where CategotyName='Historical')),
('Yaroslav',NULL,200,250.5,'2.06.2017',(select Id from Author where AuthorName='Ivanov'),(select Id from Category where CategotyName='Historical')),
(N'Ігри у які грають люди','Something',150,25.2,'12.12.2016',(select Id from Author where AuthorName='Scotton P.'),(select Id from Category where CategotyName='Adults')),
(N'Психологічний помічник',N'Психологія101',110,25.5,'10.10.2015',(select Id from Author where AuthorName='Romanova M.'),(select Id from Category where CategotyName='Scientific')),
(N'Снежная королева',N'Сказка',110,25.5,'10.10.2016',(select Id from Author where AuthorName='Andersen Hans Christian'),(select Id from Category where CategotyName='Scientific')),
(N'Белий мишка',N'Сказка',110,25.5,'10.10.2017',(select Id from Author where AuthorName='Fanny Marceau'),(select Id from Category where CategotyName='Scientific')),
(N'Милашки-очаровашки',N'Миниатюрная книжка «Белый мишка» серии «Милашки-очаровашки» создана специально для самых маленьких читателей.',110,25.5,'10.10.2015',(select Id from Author where AuthorName='Fanny Marceau'),(select Id from Category where CategotyName='Scientific')),
(N'Шмяк и пингвины',N'Котенок Шмяк и его друзья живут весело. ',110,25.5,'10.10.2014',(select Id from Author where AuthorName='Fanny Marceau'),(select Id from Category where CategotyName='Scientific')),
(N'Рассел ищет клад',N'Что вас ждет под обложкой: Однажды ворона принесла Расселу изрядно потрепанную карту сокровищ Лягушачьей низины. ',110,25.5,'10.10.2015',(select Id from Author where AuthorName='Fanny Marceau'),(select Id from Category where CategotyName='Scientific')),
(N'Котенок Шмяк. Давай играть!',N'Наконец-то к котёнку Шмяку в гости пришли друзья, и можно вместе поиграть.',120,30.5,'10.10.2017',(select Id from Author where AuthorName='Fanny Marceau'),(select Id from Category where CategotyName='Scientific'));


INSERT INTO Shop VALUES
('PolandShop',2),
('Slovo',3);

INSERT INTO Incomes VALUES
(1,11,'12.10.2017',20),
(2,4,GetDate(),20),
(1,2,GetDate(),10),
(2,3,GetDate(),5),
(2,6,GetDate(),7),
(2,5,GetDate(),15),
(2,7,GetDate(),30),
(2,10,GetDate(),5),
(2,9,GetDate(),7),
(2,8,GetDate(),15),
(2,1,GetDate(),30);

INSERT INTO Sales VALUES
(1,1,'12.10.2017',5,60),
(2,2,GetDate(),5,70.5),
(1,3,GetDate(),3,80.3),
(2,4,GetDate(),2,100),
(2,5,GetDate(),7,70.8),
(2,6,GetDate(),10,250),
(2,7,GetDate(),5,70.5),
(1,8,GetDate(),3,80.3),
(2,9,GetDate(),2,100),
(2,10,GetDate(),7,70.8),
(2,11,GetDate(),10,250);

-------------------------------------
select *from Address
select *from Author
select *from Book
select *from Category
select *from Country
select *from Incomes
select *from Publish
select *from Sales
select *from Shop
select *from UserProfile

select Book.BookName + ISNULL(Description, '-')+ISNULL(Convert(nvarchar(max), '-'), NumberPages) as Book  From Book
SELECT ISNULL('-', Description) from Book

Select b.BookName from book as b

select *from Book
where BookName Like N'М%'

select *from Book
where BookName Like 'V%l%'

select *from Book
where BookName Between  N'A%' and 'S%'

select *from Book
where Price >10 and Price<200

select *from Book
where Price Between 10 and 200

select *from Book where PublishDate >'10.10.2016'

select *from Book where PublishDate >DateAdd("D", -30, GETDATE())

select *from Author
select *from Book where book.AuthorId='1'
select *from Book where book.AuthorId=(select TOP(1)Id from Author where AuthorName='Ivanov')
-----------------------------------Order by----------------- Сортування
select Top(3)* from Book Order by Price desc
-----------------Fetch -----take only ------row----
select *from Book Order by Price 
offset 2 rows
fetch next 3 rows only

select *from Author where PublishId=(select Id from Publish where  PublishName='CoolPublisher') order by AuthorName
-------------------------sum()--------------
select sum(Price) from Book
select sum(s.Amount*s.SalePrice) from Sales as s
---------------count()--------------
select count(*) from Book
select count (*) from Author where PublishId=(select Id from Publish where PublishName='CoolPublisher')
--------------------AVG()--------------------------
select avg(Price) from Book
-------------------max-----min------------
select min(Price) from Book
select max(Price)as [MAX], min(Price) as [MIN] from Book
-----------------------Group by--------------
select AuthorId, CategoryId, avg(Price), max(Price) from Book
Group by AuthorId, CategoryId

----------------------having-----------------
select Author.AuthorName, Category.CategotyName, Author.AddressId, avg(Price) as [avg price], max(Price) as [max Price] 
from (Book join Author on Book.AuthorId= Author.Id) join Category on Book.CategoryId=Category.Id
where Author.AddressId=4
Group by Author.AuthorName,Category.CategotyName, Author.AddressId
having Max(Price)>10
Order by Author.AuthorName

--------------------------JOIN--------------
select *from Book, Author
where Book.AuthorId=Author.Id
select BookName, AuthorName from Book, Author
where Book.AuthorId=Author.Id

select *from Book INNER JOIN Author on Book.AuthorId=Author.Id
select BookName, AuthorName from Book JOIN Author on Book.AuthorId=Author.Id
select BookName, AuthorName from Book JOIN Author on Book.AuthorId=Author.Id
--------------------------Left OUTER JOIN--------------
select BookName, AuthorName from Book LEFT OUTER JOIN Author on Book.AuthorId=Author.Id
--------------------------Right OUTER JOIN--------------
select BookName, AuthorName from Book Right OUTER JOIN Author on Book.AuthorId=Author.Id
select BookName, AuthorName from Book FULL OUTER JOIN Author on Book.AuthorId=Author.Id

-------------------Book--Author----Publish--
select BookName, AuthorName, PublishName
 from (Book JOIN Author on Book.AuthorId=Author.Id) JOIN Publish on Author.PublishId=Publish.Id

select BookName, AuthorName, PublishName, CountryName
  from((Book LEFT OUter JOIN Author on Book.AuthorId=Author.Id)
  LEFT OUter JOIN Publish on Author.PublishId=Publish.Id)
  LEFT OUter JOIN Country on Country.Id=Publish.CountryId

select BookName, ShopName, AuthorName,  CountryName
  from((((Book LEFT OUter JOIN Author on Book.AuthorId=Author.Id)
  LEFT OUter JOIN Sales on Sales.BookId=Book.Id )
  Left outer JOIN Shop on Shop.Id=Sales.ShopId)
  Left outer JOIN Address on Address.Id=Author.AddressId)
  LEFT OUter JOIN Country on Country.Id=Address.CountryId

----------------exists----notexists--------------
select *from Author where PublishId=(Select Id from Publish where PublishName like 'A%')
select *from Author where EXISTS (Select *from Publish where PublishId=2)
select *from Author where NOT EXISTS (Select *from Publish where PublishId=2)
select count(*)from Book where EXISTS (Select *from Sales where Book.Id=Sales.BookId)
------------------IN----------------------
select *from Author where PublishId=(Select Id from Publish where PublishName like 'A%')
select *from Author where PublishId IN (Select Id from Publish where PublishName like 'A%')
select *from Author where Author.Id IN (Select Book.AuthorId from Book where Price Between 20 and 100)
-----------------------ANY------------------
select *from Book where Price > any (Select Price from Book where Price Between 20 and 100)
--------------------------ALL----------------------------
select *from Book where Price > ALL (Select Price from Book where Price Between 20 and 100)
select *from Book where Price < ALL (Select Price from Book where Price Between 20 and 100)

select *from Book where Price < ALL (Select avg(Price) from Book)

select sum(Amount) as [Count Sales], max(Sales.SalePrice) as [max Price],  avg(Sales.SalePrice) from Sales
select sum (Amount) from Sales where Sales.DateSale >DateAdd("D", -7, GETDATE())

select distinct Book.Id from Book left outer join Author on Book.AuthorId= Author.Id
where NOT  EXISTS (select BookId from Sales where Sales.BookId= Book.Id)

select *from Sales



