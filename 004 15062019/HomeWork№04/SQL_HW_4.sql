USE BookShopZam

--2. �������� ������, ������� �������� ������ � ������� Books ��������� �������: ���� ����� ���� ������ ����� 2008 ����, 
--����� �� ����� ��������� �� 1000 ����������, ����� ����� ��������� �� 100 ��. ����������! ��������������� ����������� CASE.
UPDATE Incomes
SET Incomes.Amount=
(CASE
	WHEN YEAR(Book.PublishDate)>2008 THEN Incomes.Amount+1000
	ELSE (Incomes.Amount+100)
	END)
FROM Book JOIN Incomes ON Incomes.BookId=Book.Id;	

--4. ������� �������� ���������, ������� ������� �� ����� ������ ���������, ������� ������� ���� �� ���� ����� ������ ������������. 
--������� ����� ����������������� (������) ��������.
GO
CREATE PROCEDURE ListShopSales AS
	SELECT Shop.ShopName, Publish.PublishName, Country.CountryName  
	FROM ((((Publish INNER JOIN Author ON Author.PublishId=Publish.Id)
	INNER JOIN Book ON Book.AuthorId=Author.Id)
	INNER JOIN Sales ON Sales.BookId=Book.Id)
	INNER JOIN Shop ON Sales.ShopId=Shop.Id)
	INNER JOIN Country ON Shop.CountryId=Country.Id
	WHERE Sales.Amount>0 --AND Publish.PublishName=@namePublish
	GROUP BY Shop.ShopName, Publish.PublishName, Country.CountryName;

EXEC ListShopSales

--5. �������� ���������, ����������� ����������� ��� ����� ������������� ������, ��� ���� ��� ��� ���������� ��� ������
GO
CREATE PROCEDURE BookAuthor (@nameAuthor NVARCHAR(MAX))AS
IF EXISTS (SELECT * FROM Author	WHERE Author.AuthorName=@nameAuthor)
		SELECT * 
		FROM Book INNER JOIN Author ON Book.AuthorId=Author.Id
		WHERE Author.AuthorName=@nameAuthor
	ELSE
		PRINT ('Such an author does not exist!');

EXEC BookAuthor 'Scott Rob'

--6. ������� �������� ���������, ������� ���������� ������������ �� ���� �����.
GO 
CREATE PROCEDURE MaxNumber(@num1 INT, @num2 INT, @max INT OUTPUT) AS
IF (@num1>@num2)
SET @max=@num1
ELSE
SET @max=@num2;

DECLARE @num INT;
EXEC MaxNumber 152, 18, @num OUTPUT
PRINT ('MAX number= '+convert(NVARCHAR(MAX),@num))

--7. �������� ���������, ������� ������� �� ����� ����� � ���� �� ��������� ��������. ��� ���� ���������� ��������� 
--����������� ����������: 0 � �� ����, �� �����, 1 � �� ��������, ����� ������ � ��� ����������.
GO
CREATE PROCEDURE OrderBook (@descrip NVARCHAR(MAX), @sort INT) AS
IF(@sort<1)
SELECT Book.BookName, Book.Description, Book.Price FROM Book WHERE Book.Description=@descrip
GROUP BY Book.BookName, Book.Description, Book.Price
ORDER BY Book.Price
IF(@sort=1)
SELECT Book.BookName, Book.Description, Book.Price FROM Book WHERE Book.Description=@descrip
GROUP BY Book.BookName, Book.Description, Book.Price
ORDER BY Book.Price DESC
IF (@sort>1)
SELECT Book.BookName, Book.Description, Book.Price FROM Book WHERE Book.Description=@descrip
GROUP BY Book.BookName, Book.Description, Book.Price;

EXEC OrderBook '���������� �������', 5

--8. �������� ���������, ������� ���������� ������ ��� ������, ���� �������� ������ ���� ���� ������.
GO
CREATE PROCEDURE TopAuthor AS
SELECT TOP(1)Author.AuthorName, SUM(Incomes.Amount) 
FROM (Book JOIN Author ON Book.AuthorId=Author.Id)
JOIN Incomes ON Incomes.BookId=Book.Id
GROUP BY Author.AuthorName
ORDER BY SUM(Incomes.Amount) DESC;

EXEC TopAuthor

--9. �������� ��������� ��� ������� ���������� �����.
GO
CREATE PROCEDURE FactorNumber(@num INT, @factor INT OUTPUT) AS
DECLARE @i INT=1
SET @factor=@i
WHILE(@i<=@num)
BEGIN
SET @factor*=@i
SET @i+=1
END

DECLARE @rez INT;
EXEC FactorNumber 10, @rez OUTPUT
PRINT ('Factorial number = '+convert(NVARCHAR(MAX),@rez))


--10. �������� �������� ���������, ������� ��������� ��������� ���� ������������ ������ �����, ������� ������������� ������� �� 2 ����. 
--������ ���������� � �������� ��������� � ���������.

--11. �������� �������� ��������� � �����������, ������������� �������� ��� ������� ����. ��������� ��������� �������� ������ 
--� ������ ������� ���� �� ��������� ��������:
--	- ���� ���� ������� ����� ��������� � ������������ ���������, ����� ����� ����� ��������� � ��� ����, 
--	  � ���� �� ������� ��������� �� 20%;
--	- ���� ���� ������� ����� �� ������ � ��������, ����� ����� �������� ��� ���������.

--	!!!������������� ����� �� ����� ��������������� �� ������� �� ������, ���� ������������ ���� ����������, ��� �������� ���� 
--���������� ������ ������, ��� �� ��������� ������ ������� ����.