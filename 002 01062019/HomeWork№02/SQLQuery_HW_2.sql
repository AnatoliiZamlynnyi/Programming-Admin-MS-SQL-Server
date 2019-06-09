USE BookShopZam;

--на 8
--1. Создать запрос на выборку всей информации о продажах книг в магазинах. 
SELECT Book.BookName, Book.Description, Category.CategoryName, Author.AuthorName, Sales.DateSale, Sales.Amount, Sales.SalePrice, Shop.ShopName 
	FROM ((((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Category ON Book.CategoryId= Category.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	GROUP BY Book.BookName, Book.Description, Category.CategoryName, Author.AuthorName, Sales.DateSale, Sales.Amount, Sales.SalePrice, Shop.ShopName;
--2. Вывести названия книг количество страниц для которых не указанао. 
SELECT Book.BookName FROM Book WHERE Book.NumberPages IS NULL;
--3. Создать запрос на выборку информации о авторах, а именно их названия и полный адрес. 
--Адрес вывести в одном поле (отформатировать вывод). 
SELECT Author.AuthorName, Country.CountryName+', City '+ Address.City+', str. '+Address.Street AS [Adress]  
	FROM (Author INNER JOIN Address ON Author.AddressId=Address.Id)
	INNER JOIN Country ON Address.CountryId=Country.Id;
--4. Вывести информацию о том, каких именно книг было продано более 10 в промежутке от 01/12/2008 до 01/03/2009. 
SELECT *FROM Book, Sales WHERE Sales.BookId=Book.Id AND Sales.Amount>10 AND Sales.DateSale BETWEEN '20081201' AND '20090301';
--5. Вывести названия книг которые продавались в течение последнего месяца (без повторений). 
--Примечание! Для получения информации о текущем месяце следует воспользоваться необходимыми функциями. 
SELECT DISTINCT Book.BookName, Sales.DateSale FROM Book, Sales  WHERE Sales.BookId=Book.Id AND Sales.DateSale>DateAdd("D", -30, GETDATE());
--6. Вывести на экран количество старых книг в магазине, то есть книг, которые были поставлены до 2019 года
SELECT SUM(Incomes.Amount) AS [Number of old books] FROM Incomes  WHERE YEAR([DateIncomes])<2019;
--7. Подсчитать общее количество книг двух авторов например Иванов и Воробей. (любые ваши)
SELECT COUNT(*) AS [Books: Romanova Maria & Scott Rob] 
	FROM Book WHERE Book.AuthorId IN (SELECT Id FROM Author WHERE  Author.AuthorName IN ('Romanova Maria','Scott Rob'));
--8. Показать все книги, в которых количество страниц больше 500, но меньше 650.
SELECT Book.BookName, Book.NumberPages FROM Book WHERE Book.NumberPages BETWEEN 501 AND 649;
--9. Показать количество авторов в базе данных. 
SELECT COUNT(*) AS [Count Authors] FROM Author;
--10. Вывести всю информацию о работе магазинов: что, когда, сколько и кем было продано, а также указать страну, 
--где находится магазин.
SELECT Book.BookName, Sales.DateSale, Sales.Amount, Shop.ShopName, Country.CountryName  
	FROM ((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Country ON Shop.CountryId=Country.Id;

--на 10 (все предыдущие плюс)
--11. Подсчитать и вывести информацию об общем количестве продаж на каждый день и вывести их в убывающем порядке количества продаж. 
SELECT Sales.DateSale, SUM(Sales.Amount) AS [Count Sales] FROM Sales
	GROUP BY Sales.DateSale
	ORDER BY SUM(Sales.Amount) DESC;
--12. Вывести названия товаров автора Иванов(выбррать любого), которые продавались более чем в двух магазинах. 
SELECT Book.BookName FROM (((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	WHERE Author.AuthorName='Ratbon Andy'
	GROUP BY Book.BookName
	HAVING COUNT(*)>1
--13. Вывести информацию о издательствах, страны их расположения, количество книг которые издавались. 
SELECT Publish.PublishName, Country.CountryName, COUNT(*) AS [Count Book publish] FROM ((Publish INNER JOIN Country ON Publish.CountryId=Country.Id)
	INNER JOIN Author ON Author.PublishId=Publish.Id)
	INNER JOIN Book ON Book.AuthorId=Author.Id
	GROUP BY Publish.PublishName, Country.CountryName;
--14. Вычислить и вывести количество книг каждой категории, которые необходимо списать. К списанию подлежат книги,
--которые есть в наличии в магазине и не продавались с даты их поставки в течение 3 месяцев. (есть в наличии - смотрим по таблице Incomes - если поставлялись, значит есть в наличии)
SELECT Category.CategoryName, SUM(Incomes.Amount) AS [Books for writing off]
	FROM ((Incomes INNER JOIN Book ON Incomes.BookId=Book.Id) 
	INNER JOIN Category ON Book.CategoryId=Category.Id)
	WHERE Incomes.DateIncomes<DateAdd("M", -3, GETDATE())
	GROUP BY Category.CategoryName;
--15. Вывести на экран количество поставленых книг по каждой категории, при этом учитывать только книги,
--стоимость которых превышает 300 грн. Выведеная информация должна касаться только трех авторов - Иванов, Петров, Сидоров
SELECT Category.CategoryName, SUM(Incomes.Amount) AS [Books Incomes]
	FROM (((Incomes INNER JOIN Book ON Incomes.BookId=Book.Id) 
	INNER JOIN Category ON Book.CategoryId=Category.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	WHERE Book.Price>300 AND Author.AuthorName IN('Scott Rob','Zagrebelnyj Pavel','Ratbon Andy')
	GROUP BY Category.CategoryName;
--16. Показать категорию, товаров которой в магазине находится меньше всего.
SELECT TOP(1) Category.CategoryName, SUM(Incomes.Amount) AS [Books Incomes]
	FROM (((Incomes INNER JOIN Book ON Incomes.BookId=Book.Id) 
	INNER JOIN Category ON Book.CategoryId=Category.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	GROUP BY Category.CategoryName
	ORDER BY SUM(Incomes.Amount);
--17. Необходимо вывести все названия книг, в которых первая буква или А, или С.
SELECT Book.BookName FROM Book WHERE Book.BookName LIKE 'Р%' OR Book.BookName LIKE 'С%'
--18. Показать названия книг, тематика которых не "Science Fiction" и тираж которых >=20 экземпляров. 
SELECT Book.BookName, Category.CategoryName, Incomes.Amount  
	FROM Book, Category, Incomes WHERE Category.CategoryName<>'Historical' AND Incomes.Amount>=20 AND Book.CategoryId=Category.ID AND Incomes.BookId=Book.Id
	GROUP BY Book.BookName, Category.CategoryName, Incomes.Amount;
--19. Показать все книги-новинки, цена которых ниже $30. 
--(Новинкой будет считаться книга, которая была издана на протяжении последней недели). 
SELECT Book.BookName, Book.PublishDate, Book.Price/26.63 AS [Price $] FROM Book WHERE Book.PublishDate>DateAdd("D", -7, GETDATE()) AND (Book.Price/26.63)<30;
--20. Показать книги, в названиях которых есть слово "Microsoft", но нет слова "Windows". 
SELECT *FROM Book WHERE Book.BookName LIKE '%Microsoft%' AND Book.BookName NOT LIKE'%Windows%';
--21. Вывести названия книг, тематику, автора (полное имя), цена одной страницы которых менее 10 центов. 
SELECT Book.BookName, Category.CategoryName, Author.AuthorName, (Book.Price/Book.NumberPages)/26.63 as [The cost of page $]
	FROM (((Incomes INNER JOIN Book ON Incomes.BookId=Book.Id) 
	INNER JOIN Category ON Book.CategoryId=Category.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	WHERE ((Book.Price/Book.NumberPages)/26.63)<0.10
	GROUP BY Book.BookName, Category.CategoryName, Author.AuthorName, (Book.Price/Book.NumberPages)/26.63;
--22. Вывести информацию обо всех книгах, в имени которых больше 4-х слов. 
SELECT Book.BookName FROM Book WHERE LEN(Book.BookName)-LEN(REPLACE(Book.BookName, ' ', ''))+1>4;
--23. Вывести на экран все книги, их авторов и цены их продажи в у.е., 
--дата продажи которых находится в диапазоне 01/01/2007 по сегодняшнюю дату. 
SELECT Book.BookName, Author.AuthorName, Sales.SalePrice/29.60 AS [Price Є]
	FROM ((Book INNER JOIN  Author ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	WHERE Sales.DateSale>'20070101'
	GROUP BY Book.BookName, Author.AuthorName, Sales.SalePrice;
--24. Показать всю информацию по продажам книг в следующем виде: 
--¦ название книги;
--¦ тематик, которые касаются "Computer Science"; 
--¦ автор книги (полное имя); 
--¦ цена продажи книги; 
--¦ имеющееся количество продаж данной книги; 
--¦ название магазина, который находится не в Украине и не в Канаде и продает эту книгу. 
SELECT Book.BookName, Book.Description, Author.AuthorName, Sales.SalePrice, Sales.Amount AS [Count sales], Shop.ShopName
	FROM (((Book INNER JOIN  Author ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	WHERE Book.Description='Навчальний посібник' AND (Shop.CountryId<>5 AND Shop.CountryId<>6)
	GROUP BY Book.BookName, Book.Description, Author.AuthorName, Sales.SalePrice, Sales.Amount, Shop.ShopName;

--на 12 (все предыдущие плюс)
--25. Показать среднеарифметическую цену продажи всех книг.
SELECT AVG(Sales.SalePrice) AS [Average selling price of all books] FROM Sales;
--26. Показать тематики книг и сумму страниц по каждой из них. 
SELECT Category.CategoryName, SUM(Book.NumberPages) AS [Sum of pages]
	FROM Book INNER JOIN Category ON Book.CategoryId=Category.Id
	GROUP BY Category.CategoryName;
--27. Вывести количество книг и сумму страниц этих книг по каждому из первых трех (!) авторов в базе данных. 
SELECT TOP(3) COUNT(Book.ID) AS [Count books], SUM(Book.NumberPages) AS [Count all pages] 
	FROM Book INNER JOIN Author on Book.AuthorId=Author.Id
	GROUP BY Author.Id 
	ORDER BY Author.Id;
--28. Вывести информацию о книгах по "Computer Science" с наибольшим количеством страниц.
SELECT TOP(1) *FROM Book WHERE Book.Description='Навчальний посібник' ORDER BY Book.NumberPages DESC;
--НЕВИХОДИТЬ--29. Показать авторов и самую старую книгу по каждому из них. 
SELECT Author.AuthorName, MIN(Book.PublishDate) as [Old book] FROM Author INNER JOIN Book ON Book.AuthorId=Author.Id 
	GROUP BY Author.AuthorName
--30. Показать на экран среднее количество страниц по каждой из тематик, при этом показать только тематики, 
--в которых среднее количество более 400. 
SELECT Category.CategoryName, AVG(Book.NumberPages) AS [average number of pages]
	FROM Book INNER JOIN Category ON Book.CategoryId=Category.Id
	GROUP BY Category.CategoryName
	HAVING AVG(Book.NumberPages)>400;
--31. Показать на экран сумму страниц по каждой из тематик, 
--при этом учитывать только книги с количеством страниц более 300, но учитывать при этом только 3 тематики, 
--например "Computer Science", "Science Fiction" и "Web Technologies". 
SELECT Category.CategoryName, SUM(Book.NumberPages) AS [Sum of pages]
	FROM Book INNER JOIN Category ON Book.CategoryId=Category.Id
	WHERE Book.NumberPages>300 AND Category.CategoryName in ('Childrens','Historical','Poetry')
	GROUP BY Category.CategoryName;
--32. Показать количество проданных книг по каждому магазину, в промежутке от 01/01/2007 до сегодняшней даты. 
SELECT Shop.ShopName, SUM(Sales.Amount) AS [Count sales books] FROM Sales LEFT OUTER JOIN Shop ON Sales.ShopId=Shop.Id
	WHERE Sales.DateSale>'20070101'
	GROUP BY Shop.ShopName;

--дополнительно (за кристалы)
--33. Вывести все книги, которые продаются более чем одним магазином. 
SELECT Book.BookName FROM (((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	GROUP BY Book.BookName
	HAVING COUNT(*)>1;
--34. Вывести только тех авторов, чьи книги продаются больше, чем книги авторов США. 
SELECT Author.AuthorName, SUM(Sales.Amount) AS [Number of copies]
	FROM ((((Author INNER JOIN Address ON Author.AddressId=Address.Id) 
	INNER JOIN Country ON Address.CountryId=Country.Id)
	INNER JOIN	Book ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	WHERE Country.CountryName<>'USA' AND Sales.Amount>(SELECT SUM(Sales.Amount) FROM ((((Author INNER JOIN Address ON Author.AddressId=Address.Id) 
	INNER JOIN Country ON Address.CountryId=Country.Id)
	INNER JOIN	Book ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	WHERE Country.CountryName='USA')
	GROUP BY Author.AuthorName;
--35. Вывести всех авторов, которые существуют в базе данных с указанием (при наличии) их книг, которые издаются издательством. 
SELECT Author.AuthorName, Book.BookName, Publish.PublishName 
	FROM ((Author INNER JOIN Publish ON Author.PublishId=Publish.Id)
	INNER JOIN Book ON Book.AuthorId=Author.Id)
	GROUP BY Author.AuthorName, Book.BookName, Publish.PublishName;
--36. С помощью подзапросов найдите всех авторов, которые живут в странах, где есть магазин, который продает их книги. 
--Отсортировать выборку по фамилии автора.
SELECT Author.AuthorName, Country.CountryName, Shop.ShopName
	FROM (((((Author INNER JOIN Address ON Author.AddressId=Address.Id) 
	INNER JOIN Country ON Address.CountryId=Country.Id)
	INNER JOIN	Book ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	WHERE Address.CountryId=Shop.CountryId
	ORDER BY Author.AuthorName;