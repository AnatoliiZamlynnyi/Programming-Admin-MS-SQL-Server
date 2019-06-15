--USE BookShopZam

--declare @id int;
--declare @category nvarchar(MAX);
--declare @nameBook nvarchar(MAX);
--set @id=13
--select @nameBook=Book.BookName, @category=Category.CategoryName from Book, Category where Book.CategoryId=Category.Id AND Book.Id=@id
--print ('ID: '+convert(nvarchar(MAX), @id))
--print ('Book Name: '+@nameBook)
--print ('Category: '+@category)


--declare @category nvarchar(MAX)='Historical';
--select Book.BookName  from Book JOIN Category on Category.CategoryName=@category
--where Book.CategoryId=Category.Id;

--declare @number int=10;
--select Book.BookName  from Book JOIN Sales on Book.Id=Sales.BookId
--group by Book.BookName
--having SUM(Sales.Amount)>@number

--select Book.BookName, 'Price'=
--case
--when Sales.Amount>10 then 'Good sales'
--when Sales.Amount>5 then 'Middle sales'
--when Sales.Amount>0 then 'Sale'
--else 'No Sales'
--end
--FROM Book JOIN Sales on Sales.BookId=Book.id

--select Top(5)* from Book order by Price
--declare @i int=0, @Id int
--while(@i<>5)
--begin
--select @Id=id from Book order by Price
--offset @i rows
--fetch next 1 rows only
--select *From Book where Id=@Id
--update Book Set Price=Price*1.03 where Id=@Id
--select *From Book where Id=@Id
--set @i+=1;
--end

create procedure GetBooksCategory(@category nvarchar(MAX)) as
if exists (select * From Book join Category on Book.CategoryId=Category.Id Where Category.CategoryName=@category)
select * From Book join Category on Book.CategoryId=Category.Id Where Category.CategoryName=@category
else
print ('not category');

exec GetBooksCategory 'Historical'
