USE BookShopZam;

--�� 8
--1. ������� ������ �� ������� ���� ���������� � �������� ���� � ���������. 
SELECT Book.BookName, Book.Description, Category.CategoryName, Author.AuthorName, Sales.DateSale, Sales.Amount, Sales.SalePrice, Shop.ShopName 
	FROM ((((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Category ON Book.CategoryId= Category.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	GROUP BY Book.BookName, Book.Description, Category.CategoryName, Author.AuthorName, Sales.DateSale, Sales.Amount, Sales.SalePrice, Shop.ShopName;
--2. ������� �������� ���� ���������� ������� ��� ������� �� ��������. 
SELECT Book.BookName FROM Book WHERE Book.NumberPages IS NULL;
--3. ������� ������ �� ������� ���������� � �������, � ������ �� �������� � ������ �����. 
--����� ������� � ����� ���� (��������������� �����). 
SELECT Author.AuthorName, Country.CountryName+', City '+ Address.City+', str. '+Address.Street AS [Adress]  
	FROM (Author INNER JOIN Address ON Author.AddressId=Address.Id)
	INNER JOIN Country ON Address.CountryId=Country.Id;
--4. ������� ���������� � ���, ����� ������ ���� ���� ������� ����� 10 � ���������� �� 01/12/2008 �� 01/03/2009. 
SELECT *FROM Book, Sales WHERE Sales.BookId=Book.Id AND Sales.Amount>10 AND Sales.DateSale BETWEEN '20081201' AND '20090301';
--5. ������� �������� ���� ������� ����������� � ������� ���������� ������ (��� ����������). 
--����������! ��� ��������� ���������� � ������� ������ ������� ��������������� ������������ ���������. 
SELECT DISTINCT Book.BookName, Sales.DateSale FROM Book, Sales  WHERE Sales.BookId=Book.Id AND Sales.DateSale>DateAdd("D", -30, GETDATE());
--6. ������� �� ����� ���������� ������ ���� � ��������, �� ���� ����, ������� ���� ���������� �� 2019 ����
SELECT SUM(Incomes.Amount) AS [Number of old books] FROM Incomes  WHERE YEAR([DateIncomes])<2019;
--7. ���������� ����� ���������� ���� ���� ������� �������� ������ � �������. (����� ����)
SELECT COUNT(*) AS [Books: Romanova Maria & Scott Rob] 
	FROM Book WHERE Book.AuthorId IN (SELECT Id FROM Author WHERE  Author.AuthorName IN ('Romanova Maria','Scott Rob'));
--8. �������� ��� �����, � ������� ���������� ������� ������ 500, �� ������ 650.
SELECT Book.BookName, Book.NumberPages FROM Book WHERE Book.NumberPages BETWEEN 501 AND 649;
--9. �������� ���������� ������� � ���� ������. 
SELECT COUNT(*) AS [Count Authors] FROM Author;
--10. ������� ��� ���������� � ������ ���������: ���, �����, ������� � ��� ���� �������, � ����� ������� ������, 
--��� ��������� �������.
SELECT Book.BookName, Sales.DateSale, Sales.Amount, Shop.ShopName, Country.CountryName  
	FROM ((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Country ON Shop.CountryId=Country.Id;

--�� 10 (��� ���������� ����)
--11. ���������� � ������� ���������� �� ����� ���������� ������ �� ������ ���� � ������� �� � ��������� ������� ���������� ������. 
SELECT Sales.DateSale, SUM(Sales.Amount) AS [Count Sales] FROM Sales
	GROUP BY Sales.DateSale
	ORDER BY SUM(Sales.Amount) DESC;
--12. ������� �������� ������� ������ ������(�������� ������), ������� ����������� ����� ��� � ���� ���������. 
SELECT Book.BookName FROM (((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	WHERE Author.AuthorName='Ratbon Andy'
	GROUP BY Book.BookName
	HAVING COUNT(*)>1
--13. ������� ���������� � �������������, ������ �� ������������, ���������� ���� ������� ����������. 
SELECT Publish.PublishName, Country.CountryName, COUNT(*) AS [Count Book publish] FROM ((Publish INNER JOIN Country ON Publish.CountryId=Country.Id)
	INNER JOIN Author ON Author.PublishId=Publish.Id)
	INNER JOIN Book ON Book.AuthorId=Author.Id
	GROUP BY Publish.PublishName, Country.CountryName;
--14. ��������� � ������� ���������� ���� ������ ���������, ������� ���������� �������. � �������� �������� �����,
--������� ���� � ������� � �������� � �� ����������� � ���� �� �������� � ������� 3 �������. (���� � ������� - ������� �� ������� Incomes - ���� ������������, ������ ���� � �������)
SELECT Category.CategoryName, SUM(Incomes.Amount) AS [Books for writing off]
	FROM ((Incomes INNER JOIN Book ON Incomes.BookId=Book.Id) 
	INNER JOIN Category ON Book.CategoryId=Category.Id)
	WHERE Incomes.DateIncomes<DateAdd("M", -3, GETDATE())
	GROUP BY Category.CategoryName;
--15. ������� �� ����� ���������� ����������� ���� �� ������ ���������, ��� ���� ��������� ������ �����,
--��������� ������� ��������� 300 ���. ��������� ���������� ������ �������� ������ ���� ������� - ������, ������, �������
SELECT Category.CategoryName, SUM(Incomes.Amount) AS [Books Incomes]
	FROM (((Incomes INNER JOIN Book ON Incomes.BookId=Book.Id) 
	INNER JOIN Category ON Book.CategoryId=Category.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	WHERE Book.Price>300 AND Author.AuthorName IN('Scott Rob','Zagrebelnyj Pavel','Ratbon Andy')
	GROUP BY Category.CategoryName;
--16. �������� ���������, ������� ������� � �������� ��������� ������ �����.
SELECT TOP(1) Category.CategoryName, SUM(Incomes.Amount) AS [Books Incomes]
	FROM (((Incomes INNER JOIN Book ON Incomes.BookId=Book.Id) 
	INNER JOIN Category ON Book.CategoryId=Category.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	GROUP BY Category.CategoryName
	ORDER BY SUM(Incomes.Amount);
--17. ���������� ������� ��� �������� ����, � ������� ������ ����� ��� �, ��� �.
SELECT Book.BookName FROM Book WHERE Book.BookName LIKE '�%' OR Book.BookName LIKE '�%'
--18. �������� �������� ����, �������� ������� �� "Science Fiction" � ����� ������� >=20 �����������. 
SELECT Book.BookName, Category.CategoryName, Incomes.Amount  
	FROM Book, Category, Incomes WHERE Category.CategoryName<>'Historical' AND Incomes.Amount>=20 AND Book.CategoryId=Category.ID AND Incomes.BookId=Book.Id
	GROUP BY Book.BookName, Category.CategoryName, Incomes.Amount;
--19. �������� ��� �����-�������, ���� ������� ���� $30. 
--(�������� ����� ��������� �����, ������� ���� ������ �� ���������� ��������� ������). 
SELECT Book.BookName, Book.PublishDate, Book.Price/26.63 AS [Price $] FROM Book WHERE Book.PublishDate>DateAdd("D", -7, GETDATE()) AND (Book.Price/26.63)<30;
--20. �������� �����, � ��������� ������� ���� ����� "Microsoft", �� ��� ����� "Windows". 
SELECT *FROM Book WHERE Book.BookName LIKE '%Microsoft%' AND Book.BookName NOT LIKE'%Windows%';
--21. ������� �������� ����, ��������, ������ (������ ���), ���� ����� �������� ������� ����� 10 ������. 
SELECT Book.BookName, Category.CategoryName, Author.AuthorName, (Book.Price/Book.NumberPages)/26.63 as [The cost of page $]
	FROM (((Incomes INNER JOIN Book ON Incomes.BookId=Book.Id) 
	INNER JOIN Category ON Book.CategoryId=Category.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	WHERE ((Book.Price/Book.NumberPages)/26.63)<0.10
	GROUP BY Book.BookName, Category.CategoryName, Author.AuthorName, (Book.Price/Book.NumberPages)/26.63;
--22. ������� ���������� ��� ���� ������, � ����� ������� ������ 4-� ����. 
SELECT Book.BookName FROM Book WHERE LEN(Book.BookName)-LEN(REPLACE(Book.BookName, ' ', ''))+1>4;
--23. ������� �� ����� ��� �����, �� ������� � ���� �� ������� � �.�., 
--���� ������� ������� ��������� � ��������� 01/01/2007 �� ����������� ����. 
SELECT Book.BookName, Author.AuthorName, Sales.SalePrice/29.60 AS [Price �]
	FROM ((Book INNER JOIN  Author ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	WHERE Sales.DateSale>'20070101'
	GROUP BY Book.BookName, Author.AuthorName, Sales.SalePrice;
--24. �������� ��� ���������� �� �������� ���� � ��������� ����: 
--� �������� �����;
--� �������, ������� �������� "Computer Science"; 
--� ����� ����� (������ ���); 
--� ���� ������� �����; 
--� ��������� ���������� ������ ������ �����; 
--� �������� ��������, ������� ��������� �� � ������� � �� � ������ � ������� ��� �����. 
SELECT Book.BookName, Book.Description, Author.AuthorName, Sales.SalePrice, Sales.Amount AS [Count sales], Shop.ShopName
	FROM (((Book INNER JOIN  Author ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	WHERE Book.Description='���������� �������' AND (Shop.CountryId<>5 AND Shop.CountryId<>6)
	GROUP BY Book.BookName, Book.Description, Author.AuthorName, Sales.SalePrice, Sales.Amount, Shop.ShopName;

--�� 12 (��� ���������� ����)
--25. �������� �������������������� ���� ������� ���� ����.
SELECT AVG(Sales.SalePrice) AS [Average selling price of all books] FROM Sales;
--26. �������� �������� ���� � ����� ������� �� ������ �� ���. 
SELECT Category.CategoryName, SUM(Book.NumberPages) AS [Sum of pages]
	FROM Book INNER JOIN Category ON Book.CategoryId=Category.Id
	GROUP BY Category.CategoryName;
--27. ������� ���������� ���� � ����� ������� ���� ���� �� ������� �� ������ ���� (!) ������� � ���� ������. 
SELECT TOP(3) COUNT(Book.ID) AS [Count books], SUM(Book.NumberPages) AS [Count all pages] 
	FROM Book INNER JOIN Author on Book.AuthorId=Author.Id
	GROUP BY Author.Id 
	ORDER BY Author.Id;
--28. ������� ���������� � ������ �� "Computer Science" � ���������� ����������� �������.
SELECT TOP(1) *FROM Book WHERE Book.Description='���������� �������' ORDER BY Book.NumberPages DESC;
--����������--29. �������� ������� � ����� ������ ����� �� ������� �� ���. 
SELECT Author.AuthorName, MIN(Book.PublishDate) as [Old book] FROM Author INNER JOIN Book ON Book.AuthorId=Author.Id 
	GROUP BY Author.AuthorName
--30. �������� �� ����� ������� ���������� ������� �� ������ �� �������, ��� ���� �������� ������ ��������, 
--� ������� ������� ���������� ����� 400. 
SELECT Category.CategoryName, AVG(Book.NumberPages) AS [average number of pages]
	FROM Book INNER JOIN Category ON Book.CategoryId=Category.Id
	GROUP BY Category.CategoryName
	HAVING AVG(Book.NumberPages)>400;
--31. �������� �� ����� ����� ������� �� ������ �� �������, 
--��� ���� ��������� ������ ����� � ����������� ������� ����� 300, �� ��������� ��� ���� ������ 3 ��������, 
--�������� "Computer Science", "Science Fiction" � "Web Technologies". 
SELECT Category.CategoryName, SUM(Book.NumberPages) AS [Sum of pages]
	FROM Book INNER JOIN Category ON Book.CategoryId=Category.Id
	WHERE Book.NumberPages>300 AND Category.CategoryName in ('Childrens','Historical','Poetry')
	GROUP BY Category.CategoryName;
--32. �������� ���������� ��������� ���� �� ������� ��������, � ���������� �� 01/01/2007 �� ����������� ����. 
SELECT Shop.ShopName, SUM(Sales.Amount) AS [Count sales books] FROM Sales LEFT OUTER JOIN Shop ON Sales.ShopId=Shop.Id
	WHERE Sales.DateSale>'20070101'
	GROUP BY Shop.ShopName;

--������������� (�� ��������)
--33. ������� ��� �����, ������� ��������� ����� ��� ����� ���������. 
SELECT Book.BookName FROM (((Book INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Author ON Book.AuthorId=Author.Id)
	GROUP BY Book.BookName
	HAVING COUNT(*)>1;
--34. ������� ������ ��� �������, ��� ����� ��������� ������, ��� ����� ������� ���. 
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
--35. ������� ���� �������, ������� ���������� � ���� ������ � ��������� (��� �������) �� ����, ������� �������� �������������. 
SELECT Author.AuthorName, Book.BookName, Publish.PublishName 
	FROM ((Author INNER JOIN Publish ON Author.PublishId=Publish.Id)
	INNER JOIN Book ON Book.AuthorId=Author.Id)
	GROUP BY Author.AuthorName, Book.BookName, Publish.PublishName;
--36. � ������� ����������� ������� ���� �������, ������� ����� � �������, ��� ���� �������, ������� ������� �� �����. 
--������������� ������� �� ������� ������.
SELECT Author.AuthorName, Country.CountryName, Shop.ShopName
	FROM (((((Author INNER JOIN Address ON Author.AddressId=Address.Id) 
	INNER JOIN Country ON Address.CountryId=Country.Id)
	INNER JOIN	Book ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	WHERE Address.CountryId=Shop.CountryId
	ORDER BY Author.AuthorName;