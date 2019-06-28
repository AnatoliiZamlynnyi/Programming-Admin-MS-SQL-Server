use BookShopZam

declare @shema XML
select @shema=c from openrowset (bulk 'D:\Documents\GoogleDrive\Training\Programming-Admin-MS-SQL-Server\006 29062019\ClassWork¹01\BookShema.xsd', single_blob) as tmp(c)
create xml schema collection BooksCatalog as @shema
drop xml schema collection BooksCatalog

select XML_SCHEMA_NAMESPACE (N'dbo', N'BooksCatalog')
create table BooksCatalog (Id_Catalog int identity not null, 
BCatalog xml (BooksCatalog));
drop table BooksCatalog
