--2. �� � ������. ���������� ���� ����� �� ��������� ������
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
(N'���'),
(N'�����'),
(N'������'),
(N'ͳ�������'),
(N'�������'),
(N'�����'),
(N'������'),
(N'�����'),
(N'��������');

GO
INSERT INTO Themes VALUES
(N'����������'),
(N'�����'),
(N'̳�����'),
(N'�����'),
(N'�������'),
(N'���������'),
(N'�����'),
(N'��������'),
(N'������');

GO
INSERT INTO Shops VALUES
(N'�����', (SELECT ID_COUNTRY FROM Country where NameCountry=N'������')),
(N'�����', (SELECT ID_COUNTRY FROM Country where NameCountry=N'������')),
(N'���������', (SELECT ID_COUNTRY FROM Country where NameCountry=N'������')),
(N'�������', (SELECT ID_COUNTRY FROM Country where NameCountry=N'���')),
(N'������ � ��', (SELECT ID_COUNTRY FROM Country where NameCountry=N'�������')),
(N'Mir-Skazki', (SELECT ID_COUNTRY FROM Country where NameCountry=N'ͳ�������')),
(N'Murawei.de', (SELECT ID_COUNTRY FROM Country where NameCountry=N'ͳ�������'));
GO
INSERT INTO Authors VALUES
(N'�����', N'��������', (SELECT ID_COUNTRY FROM Country where NameCountry=N'������')),
(N'˳��', N'��������', (SELECT ID_COUNTRY FROM Country where NameCountry=N'������')),
(N'�����', N'����� ����', (SELECT ID_COUNTRY FROM Country where NameCountry=N'�����')),
(N'�����', N'ʳ��', (SELECT ID_COUNTRY FROM Country where NameCountry=N'���')),
(N'�����', N'����', (SELECT ID_COUNTRY FROM Country where NameCountry=N'�������')),
(N'�����', N'���', (SELECT ID_COUNTRY FROM Country where NameCountry=N'ͳ�������')),
(N'�����', N'����', (SELECT ID_COUNTRY FROM Country where NameCountry=N'�����')),
(N'����', N'������', (SELECT ID_COUNTRY FROM Country where NameCountry=N'��������')),
(N'����', N'������', (SELECT ID_COUNTRY FROM Country where NameCountry=N'������')),
(N'�����', N'����', (SELECT ID_COUNTRY FROM Country where NameCountry=N'�����')),
(N'������', N'��������', (SELECT ID_COUNTRY FROM Country where NameCountry=N'�����'));


GO
INSERT INTO Sales VALUES
((SELECT ID_BOOK FROM Books where NameBook=N'������'), '20190131', 699, 3, (SELECT ID_SHOP FROM Shops where NameShop=N'�����')),
((SELECT ID_BOOK FROM Books where NameBook=N'³���������'), '20180413', 69, 5, (SELECT ID_SHOP FROM Shops where NameShop=N'�������')),
((SELECT ID_BOOK FROM Books where NameBook=N'ʳ� � �������'), '20141109', 199, 8, (SELECT ID_SHOP FROM Shops where NameShop=N'Mir-Skazki')),
((SELECT ID_BOOK FROM Books where NameBook=N'�������'), '19991105', 77, 6, (SELECT ID_SHOP FROM Shops where NameShop=N'�����')),
((SELECT ID_BOOK FROM Books where NameBook=N'����������� ������'), '20190601', 159, 4, (SELECT ID_SHOP FROM Shops where NameShop=N'������ � ��')),
((SELECT ID_BOOK FROM Books where NameBook=N'������ �����'), '20190511', 199, 12, (SELECT ID_SHOP FROM Shops where NameShop=N'���������'));



SELECT *FROM Country;
SELECT *FROM Themes;
SELECT *FROM Shops;
SELECT *FROM Authors;
SELECT *FROM Books;
SELECT *FROM Sales;
