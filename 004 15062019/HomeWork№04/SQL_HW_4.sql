USE BookShopZam

--2. Написать запрос, который изменяет данные в таблице Books следующим образом: если книги были изданы после 2008 года, 
--тогда их тираж увеличить на 1000 екзмпляров, иначе тираж увеличить на 100 ед. Примечание! Воспользоваться инструкцией CASE.
UPDATE Incomes
SET Incomes.Amount=
(CASE
	WHEN YEAR(Book.PublishDate)>2008 THEN Incomes.Amount+1000
	ELSE (Incomes.Amount+100)
	END)
FROM Book JOIN Incomes ON Incomes.BookId=Book.Id;	

--4. Создать хранимую процедуру, которая выводит на экран список магазинов, которые продали хотя бы одну книгу Вашего издательства. 
--Указать также месторасположение (страну) магазина.
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

--5. Написать процедуру, позволяющую просмотреть все книги определенного автора, при этом его имя передается при вызове
GO
CREATE PROCEDURE BookAuthor (@nameAuthor NVARCHAR(MAX))AS
IF EXISTS (SELECT * FROM Author	WHERE Author.AuthorName=@nameAuthor)
		SELECT * 
		FROM Book INNER JOIN Author ON Book.AuthorId=Author.Id
		WHERE Author.AuthorName=@nameAuthor
	ELSE
		PRINT ('Such an author does not exist!');

EXEC BookAuthor 'Scott Rob'

--6. Создать хранимую процедуру, которая возвращает максимальное из двух чисел.
GO 
CREATE PROCEDURE MaxNumber(@num1 INT, @num2 INT, @max INT OUTPUT) AS
IF (@num1>@num2)
SET @max=@num1
ELSE
SET @max=@num2;

DECLARE @num INT;
EXEC MaxNumber 152, 18, @num OUTPUT
PRINT ('MAX number= '+convert(NVARCHAR(MAX),@num))

--7. Написать процедуру, которая выводит на экран книги и цены по указанной тематике. При этом необходимо указывать 
--направление сортировки: 0 – по цене, по росту, 1 – по убыванию, любое другое – без сортировки.
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

EXEC OrderBook 'Навчальний посібник', 5

--8. Написать процедуру, которая возвращает полное имя автора, книг которого больше всех было издано.
GO
CREATE PROCEDURE TopAuthor AS
SELECT TOP(1)Author.AuthorName, SUM(Incomes.Amount) 
FROM (Book JOIN Author ON Book.AuthorId=Author.Id)
JOIN Incomes ON Incomes.BookId=Book.Id
GROUP BY Author.AuthorName
ORDER BY SUM(Incomes.Amount) DESC;

EXEC TopAuthor

--9. Написать процедуру для расчета факториала числа.
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
EXEC FactorNumber 8, @rez OUTPUT
PRINT ('Factorial number = '+convert(NVARCHAR(MAX),@rez))


--10. Написать хранимую процедуру, которая позволяет увеличить дату издательства каждой книги, которая соответствует шаблону на 2 года. 
--Шаблон передается в качестве параметра в процедуру.
GO
CREATE PROCEDURE NewDate(@author NVARCHAR(MAX), @date DATE) AS
UPDATE Book
SET Book.PublishDate=
(CASE
WHEN Author.AuthorName=@author AND Book.PublishDate<@date THEN DATEADD(YEAR,2,Book.PublishDate)
ELSE Book.PublishDate
END)
FROM Book JOIN Author ON Book.AuthorId=Author.Id;

EXEC NewDate 'Zagrebelnyj Pavel', '20180101'

--11. Написать хранимую процедуру с параметрами, определяющими диапазон дат выпуска книг. Процедура позволяет обновить данные 
--о тираже выпуска книг по следующим условиям:
--	- Если дата выпуска книги находится в определенном диапазоне, тогда тираж нужно увеличить в два раза, а цену за единицу увеличить на 20%;
--	- Если дата выпуска книги не входит в диапазон, тогда тираж оставить без изменений.
--	!!!Предусмотреть вывод на экран соответствующих сообщений об ошибке, если передаваемые даты одинаковые, или конечная дата 
--промежутка меньше начала, или же начальная больше текущей даты.
GO
CREATE PROCEDURE RangeDate(@date1 DATE, @date2 DATE) AS
IF(@date1=@date2)
PRINT ('Date 1 = Date2!')
IF(@date2<@date1)
PRINT ('Date 2 < Date1!')
IF(@date1>=GETDATE())
PRINT ('Date 1 >= The current date!')
ELSE
BEGIN
	IF EXISTS (SELECT *FROM Book WHERE Book.PublishDate BETWEEN @date1 AND @date2)
	BEGIN
		UPDATE Incomes SET Incomes.Amount=Incomes.Amount*2 WHERE Incomes.BookId IN (SELECT Id FROM Book WHERE Book.PublishDate BETWEEN @date1 AND @date2)
		UPDATE Book SET Book.Price=Book.Price*1.2 WHERE Book.Id IN (SELECT Id FROM Book)
	END
END

SELECT *FROM Book JOIN Incomes ON Incomes.BookId=Book.Id
EXEC RangeDate '20030101', '20110101'
SELECT *FROM Book JOIN Incomes ON Incomes.BookId=Book.Id