USE BookShopZam
GO
--1. ѕоказать количество авторов в базе данных. –езультат сохранить в другую таблицу.
SELECT COUNT(*) FROM Author  
	SELECT Author.AuthorName, Country.CountryName+', City '+ Address.City+', str. '+Address.Street AS [Adress] 
	INTO AuthorCopy FROM (Author INNER JOIN Address ON Author.AddressId=Address.Id)
	INNER JOIN Country ON Address.CountryId=Country.Id;
Select *From AuthorCopy;
--2. ѕоказать среднеарифметическую цену продажи всех книг. –езультат сохранить в локальную временную таблицу.
SELECT *INTO #AverageSale FROM (
	SELECT Tbl1.SumPrice/ Tbl2.SumAmount as [Average] From 
	(SELECT SUM(Sales.SalePrice*Sales.Amount) as [SumPrice] From Sales) as Tbl1,
	(SELECT SUM(Sales.Amount)as[SumAmount] FROM Sales) as Tbl2) as Tbl
Select *From #AverageSale;
--3. ¬ывести всех авторов, которые существуют в базе данных с указанием (при наличии) их книг, которые издаютс€ издательством.
SELECT Author.AuthorName, Book.BookName, Publish.PublishName 
	FROM ((Author INNER JOIN Publish ON Author.PublishId=Publish.Id)
	INNER JOIN Book ON Book.AuthorId=Author.Id)
	GROUP BY Author.AuthorName, Book.BookName, Publish.PublishName;
--4. —оставить отчет о том, какие магазины реализовали наибольшее и наименьшее количество книг издательства (воспользоватьс€ оператором UNION).
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
--5. Ќаписать зашифрованное представление, показывающее самую попул€рную книгу.
CREATE VIEW TopBook (BookName, Amount) WITH ENCRYPTION AS
SELECT TOP(1)Book.BookName, MAX(Sales.Amount) AS [Count Sales Book] FROM Book INNER JOIN  Sales ON Sales.BookId=Book.Id
GROUP BY Book.BookName
ORDER BY MAX(Sales.Amount)DESC;
--6. Ќаписать модифицированное представление, в котором предоставл€етс€ информаци€ об авторах, имена которых начинаютс€ с ј или ¬.
CREATE VIEW AuthorSelect (AuthorName, AddressId, PublishId) AS SELECT AuthorName, AddressId, PublishId FROM Author 
WHERE Author.AuthorName LIKE 'A%' OR Author.AuthorName LIKE 'B%'
WITH CHECK OPTION;
--7. Ќаписать представление, в котором с помощью под запросов вывести названи€ магазинов, которые еще не продают книги вашего издательства.
CREATE VIEW Shops (ShopName)AS
SELECT ShopName FROM Shop WHERE NOT EXISTS(SELECT *FROM Sales WHERE Shop.Id=Sales.ShopId);
--8. Ќаписать представлени€, содержащие самую дорогую книгу тематики, например, "Web Technologies".
CREATE VIEW BookPrice (BookName) AS
SELECT TOP(1)Book.BookName FROM Book WHERE Book.CategoryId=(SELECT Category.Id FROM Category WHERE Category.CategoryName='Scientific')
GROUP BY Book.BookName, Book.Price
ORDER BY Book.Price DESC;
--9. Ќаписать представление, которое позвол€ет вывести всю информацию о работе магазинов. 
--   ќтсортировать выборку по странам в возрастающем и по названи€м магазинов в убывающем пор€дке.
CREATE VIEW ShopInfo (BookName, DateSale, Amount, ShopName, CountryName) AS
SELECT TOP(100)PERCENT Book.BookName, Sales.DateSale, Sales.Amount, Shop.ShopName, Country.CountryName  
	FROM ((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Country ON Shop.CountryId=Country.Id
	GROUP BY Book.BookName, Sales.DateSale, Sales.Amount, Shop.ShopName, Country.CountryName
	ORDER BY Country.CountryName,  Shop.ShopName DESC
