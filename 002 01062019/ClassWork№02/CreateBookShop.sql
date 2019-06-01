use master
DROP BookShopPublisherZam

create database BookShopPublisherZam
Go
use BookShopPublisherZam
Go

CREATE TABLE Country(
Id INT PRIMARY KEY NOT NULL IDENTITY,
CountryName nvarchar(20));

CREATE TABLE Publish(
Id INT NOT NULL PRIMARY KEY IDENTITY,
PublishName nvarchar(30) NOT NULL,
CountryId INT CONSTRAINT FK_Publish_Country Foreign KEY  References Country(Id));

CREATE TABLE Address
(Id INT NOT NULL PRIMARY KEY IDENTITY,
Street nvarchar(20) NOT NULL default 'no street',
City nvarchar(20) NOT NULL,
CountryId INT CONSTRAINT FK_Address_Country Foreign KEY  References Country(Id));

CREATE TABLE Author
(Id INT PRIMARY KEY NOT NULL IDENTITY,
AuthorName nvarchar(30) NOT NULL,
AddressId INT CONSTRAINT Fk_Author_Address FOREIGN KEY REFERENCES Address(Id),
PublishId INT CONSTRAINT Fk_Author_Publish FOREIGN KEY REFERENCES Publish(Id));

CREATE TABLE Category
(Id INT PRIMARY KEY NOT NULL IDENTITY,
CategotyName nvarchar(50) NOT NULL);

CREATE TABLE Book
(Id INT PRIMARY KEY NOT NULL IDENTITY,
BookName nvarchar(250) NOT NULL,
Description nvarchar(MAX) NULL,
NumberPages INT,
Price Money NOT NULL,
PublishDate Date DEFAULT GETDATE(),
AuthorId INT CONSTRAINT Fk_Book_Author FOREIGN KEY REFERENCES Author(Id),
CategoryId INT CONSTRAINT Fk_Book_Category FOREIGN KEY REFERENCES Category(Id));

CREATE TABLE UserProfile
(Id INT PRIMARY KEY IDENTITY,
Email nvarchar(30) UNIQUE NOT NULL CHECK (Email LIKE '%@%'),
Password nvarchar(20) NOT NULL CHECK (LEN(Password)>=6),
CONSTRAINT FK_UserProfile_Author FOREIGN KEY(Id) REFERENCES Author(Id));

CREATE TABLE Shop
(Id INT PRIMARY KEY IDENTITY,
ShopName nvarchar(30) NOT NULL,
CountryId INT CONSTRAINT Fk_Shop_Country FOREIGN KEY REFERENCES Country(Id));

CREATE TABLE Incomes
(Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateIncomes Date NOT NULL,
Amount INT NOT NULL,
CONSTRAINT Fk_Incomes_Shop Foreign Key (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_Incomes_Book Foreign Key (BookId) REFERENCES Book(Id));

CREATE TABLE Sales
(Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateSale Date NOT NULL,
Amount INT NOT NULL,
SalePrice money NOT NULL,
CONSTRAINT Fk_Sales_Shop Foreign Key (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_Sales_Book Foreign Key (BookId) REFERENCES Book(Id));

-----------INSERT VALUES--------------------------
Go
INSERT INTO Country Values
('China'),
('Poland'),
('Ukraine');

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
('Semen Sklyarenko',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Zagrebelnyj Pavel',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Bern Eric',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Kleinman Paul',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Andersen Hans Christian',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Denisova Mila',(SELECT Id FROM Address WHERE Street='Bednarska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher')),
('Romanova Maria',(SELECT Id FROM Address WHERE Street='Bednarska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher')),
('Scott Rob',(SELECT Id FROM Address WHERE Street='Gdanska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher'));

INSERT INTO UserProfile VALUES
('ivanov@mail.ru','qwertyy');

INSERT INTO Category VALUES
('Historical'),
('Scientific'),
('Childrens'),
('Adult'),
('Artistic'),
('Fantasy'),
('Poetry');

INSERT INTO Book VALUES
(N'Роксолана', NULL, 800, 120, '02/10/2013',(select Id from Author where AuthorName='Zagrebelnyj Pavel'), (select Id from Category where CategotyName='Historical')),
(N'Володимир',NULL,528,28.50,'01/05/2010',(select Id from Author where AuthorName='Semen Sklyarenko'),(select Id from Category where CategotyName='Historical')),
(N'Ярослав',NULL,576,222,'02/06/2015',(select Id from Author where AuthorName='Zagrebelnyj Pavel'),(select Id from Category where CategotyName='Historical')),
(N'Ігри у які грають люди',NULL,256,84.90,'09/05/2016',(select Id from Author where AuthorName='Bern Eric'),(select Id from Category where CategotyName='Adult')),
(N'Психологічний помічник',N'Психологія101',240,120.5,'01/01/2016',(select Id from Author where AuthorName='Kleinman Paul'),(select Id from Category where CategotyName='Scientific')),
(N'Снежная королева',N'Сказка',64,125,'01/02/2018',(select Id from Author where AuthorName='Andersen Hans Christian'),(select Id from Category where CategotyName='Childrens')),
(N'Белий мишка',N'Сказка',6,84,'05/10/2015',(select Id from Author where AuthorName='Denisova Mila'),(select Id from Category where CategotyName='Childrens')),
(N'Милашки-очаровашки',N'Миниатюрная книжка «Белый мишка» серии «Милашки-очаровашки» создана специально для самых маленьких читателей.',10,114,'08/11/2015',(select Id from Author where AuthorName='Romanova Maria'),(select Id from Category where CategotyName='Childrens')),
(N'Шмяк и пингвины',N'Котенок Шмяк и его друзья живут весело. ',40,196,'05/11/2015',(select Id from Author where AuthorName='Scott Rob'),(select Id from Category where CategotyName='Childrens')),
(N'Рассел ищет клад',N'Что вас ждет под обложкой: Однажды ворона принесла Расселу изрядно потрепанную карту сокровищ Лягушачьей низины. ',32,209,'02/09/2015',(select Id from Author where AuthorName='Scott Rob'),(select Id from Category where CategotyName='Childrens')),
(N'Котенок Шмяк. Давай играть!',N'Наконец-то к котёнку Шмяку в гости пришли друзья, и можно вместе поиграть.',32,137.5,'09/05/2015',(select Id from Author where AuthorName='Scott Rob'),(select Id from Category where CategotyName='Childrens'));

INSERT INTO Shop VALUES
('PolandShop',2),
('Slovo',3);

INSERT INTO Incomes VALUES
(1,(SELECT Id FROM Book where BookName=N'Котенок Шмяк. Давай играть!'),'01/09/2015',20),
(2,(SELECT Id FROM Book where BookName=N'Ігри у які грають люди'),'12/07/2016',20),
(1,(SELECT Id FROM Book where BookName=N'Володимир'),'01/08/2010',10),
(2,(SELECT Id FROM Book where BookName=N'Ярослав'),'03/09/2015',5),
(2,(SELECT Id FROM Book where BookName=N'Снежная королева'),'05/04/2018',7),
(2,(SELECT Id FROM Book where BookName=N'Психологічний помічник'),'05/08/2016',15),
(2,(SELECT Id FROM Book where BookName=N'Белий мишка'),'04/12/2015',30),
(2,(SELECT Id FROM Book where BookName=N'Рассел ищет клад'),'01/12/2015',5),
(2,(SELECT Id FROM Book where BookName=N'Шмяк и пингвины'),'01/02/2016',7),
(2,(SELECT Id FROM Book where BookName=N'Милашки-очаровашки'),'12/01/2016',15),
(2,(SELECT Id FROM Book where BookName=N'Роксолана'),'10/12/2013',30);

INSERT INTO Sales VALUES
(1,(SELECT Id FROM Book where BookName=N'Шмяк и пингвины'),'02/10/2017',99,99),
(2,(SELECT Id FROM Book where BookName=N'Ігри у які грають люди'),'05/05/2019',5,49.5),
(2,(SELECT Id FROM Book where BookName=N'Белий мишка'),'02/04/2018',3,25.3),
(2,(SELECT Id FROM Book where BookName=N'Рассел ищет клад'),'03/05/2019',2,149.99),
(2,(SELECT Id FROM Book where BookName=N'Роксолана'),'05/05/2019',7,89.99),
(2,(SELECT Id FROM Book where BookName=N'Снежная королева'),'07/01/2019',10,77.55);
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

select sum(Amount) as [Count Sales], max(Sales.SalePrice) as [max Price],  avg(Sales.SalePrice) as [avg Sales] from Sales
select sum (Amount) from Sales where Sales.DateSale >DateAdd("D", -7, GETDATE())

select distinct Book.Id from Book left outer join Author on Book.AuthorId= Author.Id
where NOT  EXISTS (select BookId from Sales where Sales.BookId= Book.Id)

select *from Sales



