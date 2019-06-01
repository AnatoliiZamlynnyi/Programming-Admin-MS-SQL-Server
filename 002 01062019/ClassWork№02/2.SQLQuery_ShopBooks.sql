--2. ДЗ з лекції. Розгорнути базу даних та наповнити даними
USE master;
DROP DATABASE PublisherZ;
DROP TABLE Country;
DROP TABLE Themes;
DROP TABLE Shops;
DROP TABLE Authors;
DROP TABLE Books;
DROP TABLE Sales;

GO
CREATE DATABASE PublisherZ;
USE PublisherZ;

GO
CREATE TABLE Country(
ID_COUNTRY INT PRIMARY KEY IDENTITY NOT NULL,
NameCountry NVARCHAR(MAX) NOT NULL);

GO
CREATE TABLE Themes(
ID_THEME INT PRIMARY KEY IDENTITY NOT NULL,
NameTheme NVARCHAR(MAX) NOT NULL);

GO
CREATE TABLE Shops(
ID_SHOP INT PRIMARY KEY IDENTITY NOT NULL,
NameShop NVARCHAR(MAX) NOT NULL,
ID_COUNTRY INT FOREIGN KEY REFERENCES Country(ID_Country) NOT NULL);

GO

CREATE TABLE Authors(
ID_AUTHOR INT PRIMARY KEY IDENTITY NOT NULL,
FastName NVARCHAR(MAX) NOT NULL,
LastName NVARCHAR(MAX) NOT NULL,
ID_COUNTRY INT FOREIGN KEY REFERENCES Country(ID_Country) NOT NULL);

GO
CREATE TABLE Books(
ID_BOOK INT PRIMARY KEY IDENTITY NOT NULL,
NameBook NVARCHAR(MAX) NOT NULL,
ID_THEME INT FOREIGN KEY REFERENCES Themes(ID_THEME) NOT NULL,
ID_AUTHOR INT FOREIGN KEY REFERENCES Authors(ID_AUTHOR) NOT NULL,
Price MONEY NOT NULL,
DrawingOfBook NVARCHAR(MAX),
DateOfPublish INT NOT NULL,
Pages INT NOT NULL);

GO
CREATE TABLE Sales(
ID_SALE INT PRIMARY KEY IDENTITY NOT NULL,
ID_BOOK INT FOREIGN KEY REFERENCES Books(ID_Book) NOT NULL,
DateOfSale DATE NOT NULL,
Price MONEY NOT NULL,
Quantity INT NOT NULL,
ID_SHOP INT FOREIGN KEY REFERENCES Shops(ID_Shop) NOT NULL);

GO
INSERT INTO Country VALUES
(N'США'),
(N'Англія'),
(N'Україна'),
(N'Німеччина'),
(N'Франція'),
(N'Італія'),
(N'Турція'),
(N'Японія'),
(N'Білорусь');

GO
INSERT INTO Themes VALUES
(N'Фантастика'),
(N'Поеми'),
(N'Містика'),
(N'Наука'),
(N'Пригоди'),
(N'Біографія'),
(N'Казки'),
(N'Детектив'),
(N'Історія');

GO
INSERT INTO Shops VALUES
(N'Слово', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Україна')),
(N'Буква', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Україна')),
(N'Книголенд', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Україна')),
(N'Персида', (SELECT ID_COUNTRY FROM Country where NameCountry=N'США')),
(N'Шекспір и Ко', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Франція')),
(N'Mir-Skazki', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Німеччина')),
(N'Murawei.de', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Німеччина'));
GO
INSERT INTO Authors VALUES
(N'Тарас', N'Шевченко', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Україна')),
(N'Ліна', N'Костенко', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Україна')),
(N'Артур', N'Конан Дойл', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Англія')),
(N'Стівен', N'Кінг', (SELECT ID_COUNTRY FROM Country where NameCountry=N'США')),
(N'Шарль', N'Перо', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Франція')),
(N'Брати', N'Грім', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Німеччина')),
(N'Агата', N'Крісті', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Англія')),
(N'Янка', N'Купала', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Білорусь')),
(N'Яшар', N'Кемаль', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Турція')),
(N'Данте', N'Алігєрі', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Італія')),
(N'Харуки', N'Мураками', (SELECT ID_COUNTRY FROM Country where NameCountry=N'Японія'));


GO
INSERT INTO Sales VALUES
((SELECT ID_BOOK FROM Books where NameBook=N'Кобзар'), '20190131', 699, 3, (SELECT ID_SHOP FROM Shops where NameShop=N'Слово')),
((SELECT ID_BOOK FROM Books where NameBook=N'Відродження'), '20180413', 69, 5, (SELECT ID_SHOP FROM Shops where NameShop=N'Персида')),
((SELECT ID_BOOK FROM Books where NameBook=N'Кіт у чоботях'), '20141109', 199, 8, (SELECT ID_SHOP FROM Shops where NameShop=N'Mir-Skazki')),
((SELECT ID_BOOK FROM Books where NameBook=N'Вибране'), '19991105', 77, 6, (SELECT ID_SHOP FROM Shops where NameShop=N'Буква')),
((SELECT ID_BOOK FROM Books where NameBook=N'Божественна комедія'), '20190601', 159, 4, (SELECT ID_SHOP FROM Shops where NameShop=N'Шекспір и Ко')),
((SELECT ID_BOOK FROM Books where NameBook=N'Шерлок Голмс'), '20190511', 199, 12, (SELECT ID_SHOP FROM Shops where NameShop=N'Книголенд'));



SELECT *FROM Country;
SELECT *FROM Themes;
SELECT *FROM Shops;
SELECT *FROM Authors;
SELECT *FROM Books;
SELECT *FROM Sales;
