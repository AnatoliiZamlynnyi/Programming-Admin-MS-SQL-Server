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

		--3. Функцию, которая возвращает список книг, которые соответствуют набору критериев (имя и фамилия автора, тематика), 
		--и отсортированы по фамилии автора в указанном в 4-м параметре направлении. 
GO
CREATE FUNCTION AuthorBook (@author NVARCHAR(MAX), @category NVARCHAR(MAX), @sort INT) RETURNS TABLE
AS
BEGIN
IF(@sort=1)
RETURN(SELECT Book.BookName, Author.AuthorName, Category.CategoryName FROM (Book JOIN Author ON Book.AuthorId=Author.Id)
JOIN Category ON Book.CategoryId=Category.Id
GROUP BY Book.BookName, Author.AuthorName, Category.CategoryName
ORDER BY Author.AuthorName)
IF (@sort=0)
RETURN(SELECT TOP(1)Book.BookName, Author.AuthorName, Category.CategoryName FROM (Book JOIN Author ON Book.AuthorId=Author.Id)
JOIN Category ON Book.CategoryId=Category.Id
GROUP BY Book.BookName, Author.AuthorName, Category.CategoryName
ORDER BY Author.AuthorName DESC)
IF (@sort<>0 AND @sort<>1)
RETURN(SELECT TOP(1)Book.BookName, Author.AuthorName, Category.CategoryName FROM (Book JOIN Author ON Book.AuthorId=Author.Id)
JOIN Category ON Book.CategoryId=Category.Id
GROUP BY Book.BookName, Author.AuthorName, Category.CategoryName)
END
GO
PRINT (dbo.AuthorBook('Scott Rob','Childrens',1))



------------------------
--Создайте локальный ключевой курсор, который содержит список тематик и информацию о том, сколько авторов пишут в каждом отдельном жанре. 
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

--Написать следующие триггеры: 
--1. Триггер, который при продаже книги автоматически изменяет количество книг в таблице Books. 
--(Примечание Добавить в таблице Books необходимое поле количества имеющихся книг QuantityBooks). 
ALTER TABLE Book ADD QuantityBooks INT 
Update Book Set QuantityBooks=200 From Book

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

		--3. Триггер, который при удалении книги, копирует данные о ней в отдельную таблицу "DeletedBooks". 
GO
CREATE TRIGGER DeleteBook ON Sales
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
		--5. Триггер, запрещающий добавления новой книги, для которой не указана дата выпуска и выбрасывает 
		--соответствующее сообщение об ошибке. 
GO
CREATE TRIGGER AddBookNotDAta ON Sales
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

		--6. Добавьте к базе данных триггер, который выполняет аудит изменений данных в таблице Books.
GO
CREATE TRIGGER BookTable ON Sales
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