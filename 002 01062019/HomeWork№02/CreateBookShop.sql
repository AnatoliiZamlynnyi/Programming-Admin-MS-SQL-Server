USE master
DROP BookShopZam

CREATE DATABASE BookShopZam
GO
USE BookShopZam

GO
CREATE TABLE Country(
Id INT PRIMARY KEY NOT NULL IDENTITY,
CountryName NVARCHAR(20));

CREATE TABLE Address
(Id INT NOT NULL PRIMARY KEY IDENTITY,
Street NVARCHAR(20) NOT NULL DEFAULT 'no street',
City NVARCHAR(20) NOT NULL,
CountryId INT CONSTRAINT FK_Address_Country FOREIGN KEY REFERENCES Country(Id));

CREATE TABLE Publish(
Id INT NOT NULL PRIMARY KEY IDENTITY,
PublishName NVARCHAR(30) NOT NULL,
CountryId INT CONSTRAINT FK_Publish_Country FOREIGN KEY REFERENCES Country(Id));

CREATE TABLE Author
(Id INT PRIMARY KEY NOT NULL IDENTITY,
AuthorName NVARCHAR(30) NOT NULL,
AddressId INT CONSTRAINT Fk_Author_Address FOREIGN KEY REFERENCES Address(Id),
PublishId INT CONSTRAINT Fk_Author_Publish FOREIGN KEY REFERENCES Publish(Id));

CREATE TABLE UserProfile
(Id INT PRIMARY KEY IDENTITY,
Email NVARCHAR(30) UNIQUE NOT NULL CHECK (Email LIKE '%@%'),
Password NVARCHAR(20) NOT NULL CHECK (LEN(Password)>=6),
CONSTRAINT FK_UserProfile_Author FOREIGN KEY(Id) REFERENCES Author(Id));

CREATE TABLE Category
(Id INT PRIMARY KEY NOT NULL IDENTITY,
CategoryName NVARCHAR(50) NOT NULL);

CREATE TABLE Book
(Id INT PRIMARY KEY NOT NULL IDENTITY,
BookName NVARCHAR(250) NOT NULL,
Description NVARCHAR(MAX) NULL,
NumberPages INT,
Price MONEY NOT NULL,
PublishDate DATE DEFAULT GETDATE(),
AuthorId INT CONSTRAINT Fk_Book_Author FOREIGN KEY REFERENCES Author(Id),
CategoryId INT CONSTRAINT Fk_Book_Category FOREIGN KEY REFERENCES Category(Id));

CREATE TABLE Shop
(Id INT PRIMARY KEY IDENTITY,
ShopName NVARCHAR(30) NOT NULL,
CountryId INT CONSTRAINT Fk_Shop_Country FOREIGN KEY REFERENCES Country(Id));

CREATE TABLE Incomes
(Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateIncomes DATE NOT NULL,
Amount INT NOT NULL,
CONSTRAINT Fk_Incomes_Shop FOREIGN KEY (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_Incomes_Book FOREIGN KEY (BookId) REFERENCES Book(Id));

CREATE TABLE Sales
(Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateSale DATE NOT NULL,
Amount INT NOT NULL,
SalePrice MONEY NOT NULL,
CONSTRAINT Fk_Sales_Shop FOREIGN KEY (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_Sales_Book FOREIGN KEY (BookId) REFERENCES Book(Id));

-----------INSERT VALUES--------------------------
GO
INSERT INTO Country VALUES
('China'),
('Poland'),
('USA'),
('Russia'),
('Ukraine'),
('Denmark'),
('Canada');

INSERT INTO Address VALUES
('BigStreet','Vroclav',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Bednarska','Varshava',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Gdanska','Branevo',(SELECT Id FROM Country WHERE CountryName='Poland')),
('Mury','Rivne',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Soborna','Rivne',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Hrescharuk','Kyiv',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('13 street','New-York',(SELECT Id FROM Country WHERE CountryName='USA')),
('Polevaya','St. Petersburg',(SELECT Id FROM Country WHERE CountryName='Russia')),
('Cisy','Ninbo',(SELECT Id FROM Country WHERE CountryName='China')),
('Andersona','Odense',(SELECT Id FROM Country WHERE CountryName='Denmark')),
('Central','Montreal',(SELECT Id FROM Country WHERE CountryName='Canada'));

INSERT INTO Publish VALUES
('CoolPublisher',(SELECT Id FROM Country WHERE CountryName='Poland')),
('ZirkaBook',(SELECT Id FROM Country WHERE CountryName='Ukraine')),
('Williams',(SELECT Id FROM Country WHERE CountryName='USA')),
('Ababagalamaga',(SELECT Id FROM Country WHERE CountryName='Ukraine'));

INSERT INTO Author VALUES
('Semen Sklyarenko',(SELECT Id FROM Address WHERE Street='Mury'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Zagrebelnyj Pavel',(SELECT Id FROM Address WHERE Street='Hrescharuk'),(SELECT Id FROM Publish WHERE PublishName='Ababagalamaga')),
('Bern Eric',(SELECT Id FROM Address WHERE Street='Central'),(SELECT Id FROM Publish WHERE PublishName='Williams')),
('Kleinman Paul',(SELECT Id FROM Address WHERE Street='13 street'),(SELECT Id FROM Publish WHERE PublishName='Williams')),
('Andersen Hans Christian',(SELECT Id FROM Address WHERE Street='Andersona'),(SELECT Id FROM Publish WHERE PublishName='ZirkaBook')),
('Denisova Mila',(SELECT Id FROM Address WHERE Street='Bednarska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher')),
('Bortnik Olga',(SELECT Id FROM Address WHERE Street='Polevaya'),(SELECT Id FROM Publish WHERE PublishName='Ababagalamaga')),
('Romanova Maria',(SELECT Id FROM Address WHERE Street='Bednarska'),(SELECT Id FROM Publish WHERE PublishName='CoolPublisher')),
('Ratbon Andy',(SELECT Id FROM Address WHERE Street='13 street'),(SELECT Id FROM Publish WHERE PublishName='Williams')),
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
(N'Роксолана', NULL, 800, 120, '02/10/2013',(SELECT Id FROM Author WHERE AuthorName='Zagrebelnyj Pavel'), (SELECT Id FROM Category WHERE CategoryName='Historical')),
(N'Володимир',NULL,528,28.50,'01/05/2010',(SELECT Id FROM Author WHERE AuthorName='Semen Sklyarenko'),(SELECT Id FROM Category WHERE CategoryName='Historical')),
(N'Ярослав',NULL,576,422,'02/06/2015',(SELECT Id FROM Author WHERE AuthorName='Zagrebelnyj Pavel'),(SELECT Id FROM Category WHERE CategoryName='Historical')),
(N'Ігри у які грають люди',NULL,256,84.90,'09/05/2016',(SELECT Id FROM Author WHERE AuthorName='Bern Eric'),(SELECT Id FROM Category WHERE CategoryName='Adult')),
(N'Психологічний помічник',N'Психологія101',340,120.5,'01/01/2016',(SELECT Id FROM Author WHERE AuthorName='Kleinman Paul'),(SELECT Id FROM Category WHERE CategoryName='Scientific')),
(N'Снежная королева',N'Сказка',64,125,'01/02/2018',(SELECT Id FROM Author WHERE AuthorName='Andersen Hans Christian'),(SELECT Id FROM Category WHERE CategoryName='Childrens')),
(N'Белий мишка',N'Сказка',NULL,84,'05/10/2015',(SELECT Id FROM Author WHERE AuthorName='Denisova Mila'),(SELECT Id FROM Category WHERE CategoryName='Childrens')),
(N'Милашки-очаровашки',N'Миниатюрная книжка «Белый мишка» серии «Милашки-очаровашки» создана специально для самых маленьких читателей.',NULL,114,'08/11/2015',(SELECT Id FROM Author WHERE AuthorName='Romanova Maria'),(SELECT Id FROM Category WHERE CategoryName='Childrens')),
(N'Шмяк и пингвины',N'Котенок Шмяк и его друзья живут весело. ',40,396,'05/11/2015',(SELECT Id FROM Author WHERE AuthorName='Scott Rob'),(SELECT Id FROM Category WHERE CategoryName='Childrens')),
(N'Изучаем Microsoft Office','Навчальний посібник',32,85,'05/06/2009',(SELECT Id FROM Author WHERE AuthorName='Bortnik Olga'),(SELECT Id FROM Category WHERE CategoryName='Scientific')),
(N'Рассел ищет клад',N'Что вас ждет под обложкой: Однажды ворона принесла Расселу изрядно потрепанную карту сокровищ Лягушачьей низины. ',32,209,'02/09/2015',(SELECT Id FROM Author WHERE AuthorName='Scott Rob'),(SELECT Id FROM Category WHERE CategoryName='Childrens')),
(N'Котенок Шмяк. Давай играть!',N'Наконец-то к котёнку Шмяку в гости пришли друзья, и можно вместе поиграть.',32,137.5,'09/05/2015',(SELECT Id FROM Author WHERE AuthorName='Scott Rob'),(SELECT Id FROM Category WHERE CategoryName='Childrens')),
(N'Microsoft Windows для чайников','Навчальний посібник',416,99.99,'01/01/2003',(SELECT Id FROM Author WHERE AuthorName='Ratbon Andy'),(SELECT Id FROM Category WHERE CategoryName='Scientific')),
(N'Windows 10 для чайников','Навчальний посібник',588,325.00,'05/06/2019',(SELECT Id FROM Author WHERE AuthorName='Ratbon Andy'),(SELECT Id FROM Category WHERE CategoryName='Scientific'));

INSERT INTO Shop VALUES
('PolandShop',(SELECT Id FROM Country WHERE CountryName=N'Poland')),
('Slovo',(SELECT Id FROM Country WHERE CountryName=N'Ukraine')),
('ShopUSA',(SELECT Id FROM Country WHERE CountryName=N'USA')),
('Russkie Skazki',(SELECT Id FROM Country WHERE CountryName=N'Russia'));

INSERT INTO Incomes VALUES
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='PolandShop'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Котенок Шмяк. Давай играть!'),'20150901',20),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Ігри у які грають люди'),'20190512',20),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='PolandShop'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Ігри у які грають люди'),'20190122',10),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='PolandShop'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Володимир'),'20090101',10),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Ярослав'),'20081203',5),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='PolandShop'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Изучаем Microsoft Office'),'20100325',86),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Снежная королева'),'20190405',7),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Психологічний помічник'),'20160805',15),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Белий мишка'),'20151204',30),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='PolandShop'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Microsoft Windows для чайников'),'20060325',86),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Microsoft Windows для чайников'),'20060325',5),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Рассел ищет клад'),'20151201',5),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Шмяк и пингвины'),'20190201',7),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Милашки-очаровашки'),'20160112',15),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='Slovo'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Роксолана'),'20090223',30),
((SELECT Shop.Id FROM Shop WHERE Shop.ShopName='ShopUSA'),(SELECT Book.Id FROM Book WHERE Book.BookName=N'Windows 10 для чайников'),'20190515',30);

INSERT INTO Sales VALUES
((SELECT Id FROM Shop WHERE ShopName=N'PolandShop'),(SELECT Id FROM Book WHERE BookName=N'Шмяк и пингвины'),'20171002',99,99),
((SELECT Id FROM Shop WHERE ShopName=N'Slovo'),(SELECT Id FROM Book WHERE BookName=N'Ігри у які грають люди'),'20190505',5,49.5),
((SELECT Id FROM Shop WHERE ShopName=N'PolandShop'),(SELECT Id FROM Book WHERE BookName=N'Ігри у які грають люди'),'20190605',2,49.5),
((SELECT Id FROM Shop WHERE ShopName=N'Slovo'),(SELECT Id FROM Book WHERE BookName=N'Белий мишка'),'20180402',3,25.3),
((SELECT Id FROM Shop WHERE ShopName=N'Slovo'),(SELECT Id FROM Book WHERE BookName=N'Microsoft Windows для чайников'),'20061225',10,99.99),
((SELECT Id FROM Shop WHERE ShopName=N'Slovo'),(SELECT Id FROM Book WHERE BookName=N'Рассел ищет клад'),'20190603',2,149.99),
((SELECT Id FROM Shop WHERE ShopName=N'PolandShop'),(SELECT Id FROM Book WHERE BookName=N'Microsoft Windows для чайников'),'20081225',23,99.99),
((SELECT Id FROM Shop WHERE ShopName=N'PolandShop'),(SELECT Id FROM Book WHERE BookName=N'Изучаем Microsoft Office'),'20110503',2,149.99),
((SELECT Id FROM Shop WHERE ShopName=N'Slovo'),(SELECT Id FROM Book WHERE BookName=N'Роксолана'),'20190605',7,89.99),
((SELECT Id FROM Shop WHERE ShopName=N'Slovo'),(SELECT Id FROM Book WHERE BookName=N'Снежная королева'),'20190107',10,77.55),
((SELECT Id FROM Shop WHERE ShopName=N'ShopUSA'),(SELECT Id FROM Book WHERE BookName=N'Windows 10 для чайников'),'20091105',5,99.99);

---------------SELECT----------------------
SELECT *FROM Country
SELECT *FROM Address
SELECT *FROM Publish
SELECT *FROM Author
SELECT *FROM UserProfile
SELECT *FROM Category
SELECT *FROM Book
SELECT *FROM Shop
SELECT *FROM Incomes
SELECT *FROM Sales