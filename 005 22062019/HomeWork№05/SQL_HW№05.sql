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
PRINT (dbo.ShopNoSales())
--2. Функцию, которая возвращает минимальный из трех параметров.

--. Функцию, которая возвращает список книг, которые соответствуют набору критериев (имя и фамилия автора, тематика), 
--и отсортированы по фамилии автора в указанном в 4-м параметре направлении. 


------------------------
--Создайте локальный ключевой курсор, который содержит список тематик и информацию о том, сколько авторов пишут в каждом отдельном жанре. 
--Сохраните значения полей в переменных. С помощью курсора и связанных переменных выполните следующие действия: 
--¦ выведите в цикле все множество данных курсора; 
--¦ выведите отдельно последнюю запись; 
--¦ выведите отдельно 5-ю запись с конца; 
--¦ выведите отдельно 3-ю запись с начала. 



--Написать следующие триггеры: 
--1. Триггер, который при продаже книги автоматически изменяет количество книг в таблице Books. 
--(Примечание Добавить в таблице Books необходимое поле количества имеющихся книг QuantityBooks). 
--2. Триггер на проверку, чтобы количество продаж книг не превысила имеющуюся. 
--3. Триггер, который при удалении книги, копирует данные о ней в отдельную таблицу "DeletedBooks". 
--4. Триггер, который следит, чтобы цена продажи книги не была меньше основной цены книги из таблицы Books. 
--5. Триггер, запрещающий добавления новой книги, для которой не указана дата выпуска и выбрасывает 
--соответствующее сообщение об ошибке. 
--6. Добавьте к базе данных триггер, который выполняет аудит изменений данных в таблице Books.




go
create function CountSales(@category nvarchar(max)) returns INT
as
begin
declare @count int
select @count=Count(*) From Book Join Category ON Book.CategoryId=Category.Id
WHERE Category.CategoryName=@category
return @count
end

go
print (dbo.CountSales('Childrens'))

go
create function SalesPrice(@bookId int) returns money
as
begin
declare @price int
select @price=Book.Price*1.1 From Book
WHERE Book.Id=@bookId
return @price
end

--drop function dbo.SalesPrice
go
CREATE TABLE SalesPr
(
Id INT PRIMARY KEY NOT NULL IDENTITY,
ShopId INT NOT NULL,
BookId INT NOT NULL,
DateSale Date NOT NULL,
Amount INT NOT NULL,
SalePrice as dbo.SalesPrice(BookId),
CONSTRAINT Fk_SalesPr_Shop Foreign Key (ShopId) REFERENCES Shop(Id),
CONSTRAINT Fk_SalesPr_Book Foreign Key (BookId) REFERENCES Book(Id),
);
select *from Book
select *from SalesPr
Insert Into SalesPr Values
(1,1,'12.10.2017',5),
(2,2,GetDate(),5),
(1,3,GetDate(),3),
(2,4,GetDate(),2),
(2,5,GetDate(),7),
(2,6,GetDate(),10),
(2,7,GetDate(),5),
(1,8,GetDate(),3),
(2,9,GetDate(),2),
(2,10,GetDate(),7),
(2,11,GetDate(),10);

------TRIGERS-------------
go
create trigger SaleInsert on Sales
instead of INSERT
as
---inserted
---@@rowcount
begin
declare @bookId INT;
select @bookId = BookId FROM inserted

declare @price money
select @price = Price FROM Book Where Id = @bookId;

declare @tmp money
select @tmp=SalePrice from inserted
if(@price > @tmp)
    raiserror('SalePrice < Price', 0,1, @@rowcount)
else
    begin
    declare @shopId int, @dateSale DateTime, @salePrice money, @amountToSale INT;
    Select @shopId = ShopId FROM inserted;
    Select @dateSale = DateSale FROM inserted;
    Select @salePrice = SalePrice FROM inserted;
	Select @amountToSale = Amount FROM inserted;
    insert into Sales values (@shopId, @bookId, @dateSale, @amountToSale, @salePrice);
    raiserror('OK!!! Inserted', 0,1, @@rowcount)
    end
end

 insert into Sales values (3, 1, GetDate(), 1, 250.5);
 select *from Sales
 ----------INDEXES----------------
 ----------FULLTEXT---------------
 go
 create fulltext catalog Text_Box as default 
 create unique index in_BookId on dbo.Book(Id)
 create fulltext index on dbo.Book(BookName, Description)
 key index in_BookId
 on Text_Box

 ------------CURSORS---------------------
 GO
 declare CategoryBook cursor 
 for select BookName, Category.CategoryName from Book, Category Where Book.CategoryId=Category.Id
 declare @name nvarchar(max), @cat nvarchar(max);
 open CategoryBook;
 fetch next from CategoryBook into @name, @cat;
 print 'Name Book: '+@name+'  Category '+@cat
 while @@FETCH_STATUS = 0
 begin
 fetch next from CategoryBook into @name, @cat;
 print 'Name Book: '+@name+'  Category '+@cat
 end
 close CategoryBook;
 deallocate CategoryBook;
 go