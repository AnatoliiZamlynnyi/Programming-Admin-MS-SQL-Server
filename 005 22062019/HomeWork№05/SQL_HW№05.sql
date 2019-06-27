USE BookShopZam

--1. Функцию, которая возвращает количество магазинов, которые не продали ни одной книги издательства. 
GO
CREATE FUNCTION ShopNoSales() RETURNS INT
AS
BEGIN
DECLARE @count INT
SELECT @count=COUNT(*)FROM Shop WHERE NOT EXISTS (SELECT *FROM Sales WHERE Shop.Id=Sales.ShopId)
RETURN @count
END
GO
PRINT ('Кількість магазинів нереалізувавших жодної книги: '+CONVERT(NVARCHAR(MAX),dbo.ShopNoSales()))
---------------------------------------------------------------------------------------------------------
--2. Функцию, которая возвращает минимальный из трех параметров.
GO
CREATE FUNCTION MinNum(@num1 INT, @num2 INT, @num3 INT) RETURNS INT
AS
BEGIN
RETURN (
		SELECT MIN(mt.num )
		FROM (SELECT @num1 'num' UNION
		SELECT @num2 UNION
		SELECT @num3)mt)		
END
PRINT 'Min number = '+CONVERT(NVARCHAR(MAX),dbo.MinNum(15,11,99))
-------------------------------------------------------------------------------------------------------
--3. Функцию, которая возвращает список книг, которые соответствуют набору критериев (имя и фамилия автора, тематика), 
--и отсортированы по фамилии автора в указанном в 4-м параметре направлении. 
-- !!!!!!!!!!!!!!!!!! Я отсортировал по названию книг, смысла сортировать по автору каторого задаеш в параметрах я не вижу либо я что-то не так понял!!!!!!!!!!!!!!!!!!---------------
GO
CREATE FUNCTION AuthorBook(@author NVARCHAR(MAX), @category NVARCHAR(MAX), @sort INT= 2) 
	RETURNS @tableAuthorBook TABLE (BookName NVARCHAR(MAX), AuthorName NVARCHAR(MAX), CategoryName NVARCHAR(MAX)) AS
BEGIN
IF (@sort=0)
	INSERT @tableAuthorBook SELECT b.BookName, a.AuthorName, c.CategoryName 
	FROM (Book b JOIN Author a ON b.AuthorId=a.Id)
		JOIN Category c ON b.CategoryId=c.Id
	WHERE a.AuthorName=@author AND c.CategoryName=@category
	GROUP BY b.BookName, a.AuthorName, c.CategoryName
	ORDER BY b.BookName
IF (@sort=1)
	INSERT @tableAuthorBook SELECT TOP(99)b.BookName, a.AuthorName, c.CategoryName 
	FROM (Book b JOIN Author a ON b.AuthorId=a.Id)
		JOIN Category c ON b.CategoryId=c.Id
	WHERE a.AuthorName=@author AND c.CategoryName=@category
	GROUP BY b.BookName, a.AuthorName, c.CategoryName
	ORDER BY b.BookName DESC
ELSE IF (@sort<>0 AND @sort<>1)
	INSERT @tableAuthorBook SELECT b.BookName, a.AuthorName, c.CategoryName 
	FROM (Book b JOIN Author a ON b.AuthorId=a.Id)
		JOIN Category c ON b.CategoryId=c.Id
	WHERE a.AuthorName=@author AND c.CategoryName=@category
RETURN
END;

SELECT *FROM AuthorBook('Scott Rob','Childrens',0)
SELECT *FROM AuthorBook('Scott Rob','Childrens',1)
SELECT *FROM AuthorBook('Scott Rob','Childrens',default)

---------------------------------------------------------------------------------------------------------------------------------------
--4. Создайте локальный ключевой курсор, который содержит список тематик и информацию о том, сколько авторов пишут в каждом отдельном жанре. 
--Сохраните значения полей в переменных. С помощью курсора и связанных переменных выполните следующие действия: 
--¦ выведите в цикле все множество данных курсора; 
--¦ выведите отдельно последнюю запись; 
--¦ выведите отдельно 5-ю запись с конца; 
--¦ выведите отдельно 3-ю запись с начала. 
GO
DECLARE CategoryAuthor CURSOR LOCAL SCROLL DYNAMIC
FOR SELECT Category.CategoryName, COUNT(DISTINCT Author.AuthorName) from Book, Author, Category 
WHERE Book.AuthorId=Author.Id AND Book.CategoryId=Category.Id
GROUP BY Category.CategoryName
DECLARE @category nvarchar(max), @count int;
OPEN CategoryAuthor;
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'Category: '+@category+'  COUNT '+CONVERT(NVARCHAR(MAX),@count)
FETCH NEXT FROM CategoryAuthor INTO @category, @count
END
PRINT '-----------------------------------------------'
PRINT 'Остання позиція'
FETCH LAST FROM CategoryAuthor INTO @category, @count;
PRINT 'Category: '+@category+'  COUNT '+CONVERT(NVARCHAR(MAX),@count)
PRINT 'Третя позиція з кінця'
FETCH RELATIVE -2 FROM CategoryAuthor INTO @category, @count;
PRINT 'Category: '+@category+'  COUNT '+CONVERT(NVARCHAR(MAX),@count)
PRINT 'Третя позиція з початку'
FETCH ABSOLUTE 3 FROM CategoryAuthor INTO @category, @count;
PRINT 'Category: '+@category+'  COUNT '+CONVERT(NVARCHAR(MAX),@count)
CLOSE CategoryAuthor

DEALLOCATE CategoryAuthor;
-----------------------------------------------------------------------------------------------------------------------
--Написать следующие триггеры: 
--1. Триггер, который при продаже книги автоматически изменяет количество книг в таблице Books. 
--(Примечание Добавить в таблице Books необходимое поле количества имеющихся книг QuantityBooks). 
--ALTER TABLE Book ADD QuantityBooks INT 
--Update Book Set QuantityBooks=200 From Book

GO
CREATE TRIGGER QuantityBooks ON Sales INSTEAD OF INSERT AS
BEGIN
DECLARE @shopId INT, @bookId INT, @dateSale DATE, @amountToSale INT, @salePrice MONEY, @quantityBooks INT;
SELECT @shopId = ShopId FROM inserted;
SELECT @bookId = BookId FROM inserted
SELECT @dateSale = DateSale FROM inserted;
SELECT @amountToSale = Amount FROM inserted;
SELECT @salePrice = SalePrice FROM inserted;
SELECT @quantityBooks = Book.QuantityBooks FROM Book WHERE Book.Id=@bookid;
INSERT INTO Sales VALUES (@shopId, @bookId, @dateSale, @amountToSale, @salePrice)
UPDATE Book SET Book.QuantityBooks-=@amountToSale FROM inserted WHERE Book.id=@bookId
END
--------------------------------------------------------------------------------------------------------------------
--2. Триггер на проверку, чтобы количество продаж книг не превысила имеющуюся. 
GO
CREATE TRIGGER SalesAmount ON Sales FOR INSERT, UPDATE AS
BEGIN
DECLARE @shopId INT, @bookId INT, @dateSale DATE, @amountToSale INT, @salePrice MONEY, @quantityBooks INT;
SELECT @shopId = ShopId FROM inserted;
SELECT @bookId = BookId FROM inserted
SELECT @dateSale = DateSale FROM inserted;
SELECT @amountToSale = Amount FROM inserted;
SELECT @salePrice = SalePrice FROM inserted;
SELECT @quantityBooks = Book.QuantityBooks FROM Book WHERE Book.Id=@bookid;
UPDATE Book SET Book.QuantityBooks-=@amountToSale FROM inserted WHERE Book.id=@bookId
IF(@quantityBooks<@amountToSale)
	ROLLBACK TRAN
END

--------------------------------------------------------------------------------------------------------------------
--3. Триггер, который при удалении книги, копирует данные о ней в отдельную таблицу "DeletedBooks". 
--CREATE TABLE DeleteBooks
--(Id INT ,
--BookName NVARCHAR(250),
--Description NVARCHAR(MAX),
--NumberPages INT,
--Price MONEY,
--PublishDate DATE,
--AuthorId INT CONSTRAINT Fk_DeleteBooks_Author FOREIGN KEY REFERENCES Author(Id),
--CategoryId INT CONSTRAINT Fk_DeleteBooks_Category FOREIGN KEY REFERENCES Category(Id),
--QuantityBooks INT);

GO
CREATE TRIGGER DeleteBook ON Book
INSTEAD OF DELETE AS
BEGIN
DECLARE @id INT, @bookName NVARCHAR(MAX), @description NVARCHAR(MAX), @numberPages INT, @price MONEY, @publishDate DATE, @authorId INT, @categoryId INT, @quantityBooks INT;
SELECT @id=Id FROM deleted;
SELECT @bookName = BookName FROM deleted;
SELECT @description=Description FROM deleted;
SELECT @numberPages=NumberPages FROM deleted;
SELECT @price=Price FROM deleted;
SELECT @publishDate=PublishDate FROM deleted;
SELECT @authorId=AuthorId FROM deleted;
SELECT @categoryId=CategoryId FROM deleted;
SELECT @quantityBooks=QuantityBooks FROM deleted;
INSERT INTO DeleteBooks VALUES (@id, @bookName, @description, @numberPages, @price, @publishDate, @authorId, @categoryId, @quantityBooks);
DELETE FROM Incomes WHERE BookId=@id;
DELETE FROM Sales WHERE BookId=@id;
DELETE FROM Book WHERE Id=@id;
END

--------------------------------------------------------------------------------------------------------------------
--4. Триггер, который следит, чтобы цена продажи книги не была меньше основной цены книги из таблицы Books. 
GO
CREATE TRIGGER SaleInsert ON Sales
INSTEAD OF INSERT AS
BEGIN
DECLARE @shopId INT, @bookId INT, @price MONEY, @dateSale DateTime, @salePrice money, @amountToSale INT;
SELECT @shopId = ShopId FROM inserted;
SELECT @bookId = BookId FROM inserted
SELECT @dateSale = DateSale FROM inserted;
SELECT @price = Price FROM Book WHERE Id = @bookId;
SELECT @amountToSale = Amount FROM inserted;
SELECT @salePrice=SalePrice from inserted
IF(@price > @salePrice)
    RAISERROR('SalePrice < Price', 0,1, @@ROWCOUNT)
ELSE
    BEGIN
    INSERT INTO Sales VALUES (@shopId, @bookId, @dateSale, @amountToSale, @salePrice);
    RAISERROR('OK!!! Inserted', 0,1, @@ROWCOUNT)
    END
END

--------------------------------------------------------------------------------------------------------------------
--5. Триггер, запрещающий добавления новой книги, для которой не указана дата выпуска и выбрасывает соответствующее сообщение об ошибке. 
GO
CREATE TRIGGER AddBookNotDAta ON Book
FOR INSERT AS
BEGIN
DECLARE @publishDate DATE;
SELECT @publishDate=PublishDate FROM inserted;
IF (@publishDate>='00010101' AND @publishDate<=GETDATE())
PRINT ('OK!')
ELSE
BEGIN
RAISERROR('Not date publisher', 0,1, @@ROWCOUNT)
ROLLBACK TRAN
END
END

--------------------------------------------------------------------------------------------------------------------
--6. Добавьте к базе данных триггер, который выполняет аудит изменений данных в таблице Books.
GO
CREATE TRIGGER BookTables ON Book
FOR UPDATE AS
RAISERROR('%d string add or modifi', 0,1, @@ROWCOUNT)
return