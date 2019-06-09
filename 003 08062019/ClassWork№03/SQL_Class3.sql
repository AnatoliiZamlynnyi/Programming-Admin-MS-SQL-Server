METANIT.COM

USE BookShopZam

Insert Into Shop VAlues
('Bukvarik',(SELECT Id From Country WHERE Country.CountryName='Ukraine'))
Select *From Shop

SELECT *FROM BOOK WHERE CategoryId in (SELECT Id FROM Category Where CategoryName='Historical' OR CategoryName='Childrens')

SELECT *FROM BOOK WHERE CategoryId not in (SELECT Id FROM Category Where CategoryName='Historical' OR CategoryName='Childrens')

Select Distinct BookName From ((Book Inner join Sales on Sales.BookId=Book.Id)
Inner join Shop on Sales.ShopId=Shop.Id)
Inner join Country on Shop.CountryId=Country.Id
Where Country.CountryName='Ukraine';

select *from Book where Book.Id in
(select BookId from Sales Where ShopId in
(select Shop.Id from Shop inner join Country on Shop.CountryId=Country.Id
Where Country.CountryName='Ukraine'))

select *from Book where Book.AuthorId =
(select Author.Id from Author 
Where Author.AuthorName='Scott Rob')

select *into #ExpensiveBook from Book where Book.Price>100
select *from #ExpensiveBook

select Book.BookName from Book Where Book.NumberPages>100
union
select Author.AuthorName from Author  
  


select Author.AuthorName from Author inner join Book on Author.Id=Book.AuthorId 
group by Author.AuthorName
having count(Book.BookName)>1
union
select  Author.AuthorName from Author inner join Book on Author.Id=Book.AuthorId 
group by Author.AuthorName
having avg(Book.NumberPages)>100



select Author.AuthorName From (Book inner join Author on Book.AuthorId=Author.Id)
inner join Category on Book.CategoryId=Category.Id
Where Category.CategoryName='Historical'
union
select Author.AuthorName From Book inner join Author on Book.AuthorId=Author.Id
Where Year(Book.PublishDate)=2015
union
select Tbl.AuthorName from
(select TOP(3) sum(Book.Price) as 'suma', Author.AuthorName From Book inner join Author on Book.AuthorId=Author.Id
Group by Author.AuthorName
Order by sum(Book.Price) desc) as Tbl



