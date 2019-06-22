use BookShopZam

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