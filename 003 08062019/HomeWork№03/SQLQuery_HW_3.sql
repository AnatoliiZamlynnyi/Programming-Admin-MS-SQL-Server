USE BookShopZam
GO
--1. �������� ���������� ������� � ���� ������. ��������� ��������� � ������ �������.
SELECT COUNT(*) FROM Author  
	SELECT Author.AuthorName, Country.CountryName+', City '+ Address.City+', str. '+Address.Street AS [Adress] 
	INTO AuthorCopy FROM (Author INNER JOIN Address ON Author.AddressId=Address.Id)
	INNER JOIN Country ON Address.CountryId=Country.Id;
Select *From AuthorCopy;
--2. �������� �������������������� ���� ������� ���� ����. ��������� ��������� � ��������� ��������� �������.
SELECT *INTO #AverageSale FROM (
	SELECT Tbl1.SumPrice/ Tbl2.SumAmount as [Average] From 
	(SELECT SUM(Sales.SalePrice*Sales.Amount) as [SumPrice] From Sales) as Tbl1,
	(SELECT SUM(Sales.Amount)as[SumAmount] FROM Sales) as Tbl2) as Tbl
Select *From #AverageSale;
--3. ������� ���� �������, ������� ���������� � ���� ������ � ��������� (��� �������) �� ����, ������� �������� �������������.
SELECT Author.AuthorName, Book.BookName, Publish.PublishName 
	FROM ((Author INNER JOIN Publish ON Author.PublishId=Publish.Id)
	INNER JOIN Book ON Book.AuthorId=Author.Id)
	GROUP BY Author.AuthorName, Book.BookName, Publish.PublishName;
--4. ��������� ����� � ���, ����� �������� ����������� ���������� � ���������� ���������� ���� ������������ (��������������� ���������� UNION).
SELECT Temp1.ShopName FROM (
SELECT TOP(1)Shop.ShopName, SUM(Sales.Amount) AS [CountSales] FROM Shop LEFT JOIN Sales ON Sales.ShopId=Shop.Id
	GROUP BY Shop.ShopName
	HAVING SUM(Sales.Amount)>0
	ORDER BY SUM(Sales.Amount) DESC) AS Temp1
UNION
SELECT Temp2.ShopName FROM (
SELECT TOP(1)Shop.ShopName, SUM(Sales.Amount) AS [CountSales] FROM Shop LEFT JOIN Sales ON Sales.ShopId=Shop.Id
	GROUP BY Shop.ShopName
	HAVING SUM(Sales.Amount)>0
	ORDER BY SUM(Sales.Amount)) AS Temp2
--5. �������� ������������� �������������, ������������ ����� ���������� �����.
CREATE VIEW TopBook (BookName, Amount) WITH ENCRYPTION AS
SELECT TOP(1)Book.BookName, MAX(Sales.Amount) AS [Count Sales Book] FROM Book INNER JOIN  Sales ON Sales.BookId=Book.Id
GROUP BY Book.BookName
ORDER BY MAX(Sales.Amount)DESC;
--6. �������� ���������������� �������������, � ������� ��������������� ���������� �� �������, ����� ������� ���������� � � ��� �.
CREATE VIEW AuthorSelect (AuthorName, AddressId, PublishId) AS SELECT AuthorName, AddressId, PublishId FROM Author 
WHERE Author.AuthorName LIKE 'A%' OR Author.AuthorName LIKE 'B%'
WITH CHECK OPTION;
--7. �������� �������������, � ������� � ������� ��� �������� ������� �������� ���������, ������� ��� �� ������� ����� ������ ������������.
CREATE VIEW Shops (ShopName)AS
SELECT ShopName FROM Shop WHERE NOT EXISTS(SELECT *FROM Sales WHERE Shop.Id=Sales.ShopId);
--8. �������� �������������, ���������� ����� ������� ����� ��������, ��������, "Web Technologies".
CREATE VIEW BookPrice (BookName) AS
SELECT TOP(1)Book.BookName FROM Book WHERE Book.CategoryId=(SELECT Category.Id FROM Category WHERE Category.CategoryName='Scientific')
GROUP BY Book.BookName, Book.Price
ORDER BY Book.Price DESC;
--9. �������� �������������, ������� ��������� ������� ��� ���������� � ������ ���������. 
--   ������������� ������� �� ������� � ������������ � �� ��������� ��������� � ��������� �������.
CREATE VIEW ShopInfo (BookName, DateSale, Amount, ShopName, CountryName) AS
SELECT TOP(100)PERCENT Book.BookName, Sales.DateSale, Sales.Amount, Shop.ShopName, Country.CountryName  
	FROM ((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Country ON Shop.CountryId=Country.Id
	GROUP BY Book.BookName, Sales.DateSale, Sales.Amount, Shop.ShopName, Country.CountryName
	ORDER BY Country.CountryName,  Shop.ShopName DESC
