--1. Розробити схему (структуру ) бази даних Школа (мынымум 5 таблиць). База даних 
--зберігає інформацію про вчителів, предмети які вони ведуть, айдиторії, учнів та оцінки

USE MASTER;
DROP DATABASE SchoolZ;
DROP TABLE Lessons;
DROP TABLE Teachers;
DROP TABLE Audiences;
DROP TABLE Pupils;
DROP TABLE Ratings;

GO
CREATE DATABASE SchoolZ;
USE SchoolZ;

GO
CREATE TABLE Lessons(
ID_Lesson INT PRIMARY KEY IDENTITY NOT NULL,
Lesson NVARCHAR(MAX) NOT NULL)

GO
CREATE TABLE Teachers(
ID_Teacher INT PRIMARY KEY IDENTITY NOT NULL,
FastName NVARCHAR(MAX) NOT NULL,
LastName NVARCHAR(MAX) NOT NULL,
ID_Lesson INT FOREIGN KEY REFERENCES Lessons(ID_Lesson) NOT NULL)

GO
CREATE TABLE Audiences(
ID_Audience INT PRIMARY KEY IDENTITY NOT NULL,
ID_Teacher INT FOREIGN KEY REFERENCES Teachers(ID_Teacher) NOT NULL)

GO
CREATE TABLE Pupils(
ID_Pupil INT PRIMARY KEY IDENTITY NOT NULL,
FastName NVARCHAR(MAX) NOT NULL,
LastName NVARCHAR(MAX) NOT NULL)

GO
CREATE TABLE Ratings(
ID_Rating INT PRIMARY KEY IDENTITY NOT NULL,
ID_Lesson INT FOREIGN KEY REFERENCES Lessons(ID_Lesson) NOT NULL,
ID_Pupil INT FOREIGN KEY REFERENCES Pupils(ID_Pupil) NOT NULL,
Rating INT)

GO
INSERT INTO Lessons (Lesson) VALUES
('Географія'),
('Історія'),
('Математика'),
('Література'),
('Інформатика');

GO
INSERT INTO Teachers VALUES
('Віолета', 'Архімед', (SELECT ID_Lesson FROM Lessons where Lesson='Математика')),
('Степан', 'Джобс', (SELECT ID_Lesson FROM Lessons where Lesson='Інформатика')),
('Біл', 'Геродот', (SELECT ID_Lesson FROM Lessons where Lesson='Історія')),
('Арнольд', 'Врунгель', (SELECT ID_Lesson FROM Lessons where Lesson='Географія')),
('Олександр', 'Кінг', (SELECT ID_Lesson FROM Lessons where Lesson='Література'));

GO
INSERT INTO Audiences VALUES
((SELECT ID_Teacher FROM Teachers where FastName='Степан' and LastName='Джобс')),
((SELECT ID_Teacher FROM Teachers where FastName='Біл' and LastName='Геродот')),
((SELECT ID_Teacher FROM Teachers where FastName='Арнольд' and LastName='Врунгель')),
((SELECT ID_Teacher FROM Teachers where FastName='Олександр' and LastName='Кінг')),
((SELECT ID_Teacher FROM Teachers where FastName='Віолета' and LastName='Архімед'));
 
 GO
INSERT INTO Pupils VALUES
('Олександр', 'Марад'),
('Анабель', 'Приходько'),
('Михайло', 'Бернд'),
('Валерій', 'Засядько'),
('Ольга', 'Впертова'),
('Григорій', 'Цвях'),
('Ірина', 'Знайвсе'),
('Сирофима', 'Сироїд'),
('Пилип', 'Нечуйвсіх'),
('Антон', 'Неходитуди');

GO
INSERT INTO Ratings VALUES
((SELECT ID_Lesson FROM Lessons  where Lesson='Математика'),(SELECT ID_Pupil FROM Pupils  where LastName='Цвях'),5),
((SELECT ID_Lesson FROM Lessons  where Lesson='Історія'),(SELECT ID_Pupil FROM Pupils  where LastName='Приходько'),12),
((SELECT ID_Lesson FROM Lessons  where Lesson='Інформатика'),(SELECT ID_Pupil FROM Pupils  where LastName='Нечуйвсіх'),10),
((SELECT ID_Lesson FROM Lessons  where Lesson='Математика'),(SELECT ID_Pupil FROM Pupils  where LastName='Впертова'),2),
((SELECT ID_Lesson FROM Lessons  where Lesson='Історія'),(SELECT ID_Pupil FROM Pupils  where LastName='Впертова'),8),
((SELECT ID_Lesson FROM Lessons  where Lesson='Географія'),(SELECT ID_Pupil FROM Pupils  where LastName='Бернд'),6),
((SELECT ID_Lesson FROM Lessons  where Lesson='Географія'),(SELECT ID_Pupil FROM Pupils  where LastName='Бернд'),4),
((SELECT ID_Lesson FROM Lessons  where Lesson='Історія'),(SELECT ID_Pupil FROM Pupils  where LastName='Цвях'),12),
((SELECT ID_Lesson FROM Lessons  where Lesson='Математика'),(SELECT ID_Pupil FROM Pupils  where LastName='Цвях'),9),
((SELECT ID_Lesson FROM Lessons  where Lesson='Географія'),(SELECT ID_Pupil FROM Pupils  where LastName='Нечуйвсіх'),11),
((SELECT ID_Lesson FROM Lessons  where Lesson='Географія'),(SELECT ID_Pupil FROM Pupils  where LastName='Приходько'),10 ),
((SELECT ID_Lesson FROM Lessons  where Lesson='Історія'),(SELECT ID_Pupil FROM Pupils  where LastName='Сироїд'),6),
((SELECT ID_Lesson FROM Lessons  where Lesson='Інформатика'),(SELECT ID_Pupil FROM Pupils  where LastName='Засядько'),7),
((SELECT ID_Lesson FROM Lessons  where Lesson='Географія'),(SELECT ID_Pupil FROM Pupils  where LastName='Цвях'),3),
((SELECT ID_Lesson FROM Lessons  where Lesson='Інформатика'),(SELECT ID_Pupil FROM Pupils  where LastName='Знайвсе'),10),
((SELECT ID_Lesson FROM Lessons  where Lesson='Математика'),(SELECT ID_Pupil FROM Pupils  where LastName='Нечуйвсіх'),2),
((SELECT ID_Lesson FROM Lessons  where Lesson='Географія'),(SELECT ID_Pupil FROM Pupils  where LastName='Неходитуди'),1),
((SELECT ID_Lesson FROM Lessons  where Lesson='Історія'),(SELECT ID_Pupil FROM Pupils  where LastName='Неходитуди'),10 ),
((SELECT ID_Lesson FROM Lessons  where Lesson='Інформатика'),(SELECT ID_Pupil FROM Pupils  where LastName='Засядько'),11);

SELECT p.FastName+' '+p.LastName, l.Lesson, a.ID_Audience, t.FastName+' '+t.LastName, r.Rating 
FROM Pupils as p, Lessons as l, Audiences as a, Teachers as t, Ratings as r
WHERE r.ID_Lesson=l.ID_Lesson;