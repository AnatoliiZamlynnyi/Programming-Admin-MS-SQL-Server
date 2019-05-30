--1. Розробити схему (структуру ) бази даних Школа (мынымум 5 таблиць). База даних 
--зберігає інформацію про вчителів, предмети які вони ведуть, айдиторії, учнів та оцінки

CREATE DATABASE SchoolZ;
USE SchoolZ;

GO
CREATE TABLE Lessons(
ID_Lesson INT PRIMARY KEY IDENTITY NOT NULL,
Lesson NVARCHAR(MAX) NOT NULL);

GO
CREATE TABLE Teachers(
ID_Teacher INT PRIMARY KEY IDENTITY NOT NULL,
FastName NVARCHAR(MAX) NOT NULL,
LastName NVARCHAR(MAX) NOT NULL,
ID_Lesson INT FOREIGN KEY REFERENCES Lessons(ID_Lesson) NOT NULL);

GO
CREATE TABLE Audiences(
ID_Audience INT PRIMARY KEY IDENTITY NOT NULL,
ID_Teacher INT FOREIGN KEY REFERENCES Teachers(ID_Teacher) NOT NULL);

GO
CREATE TABLE Pupils(
ID_Pupil INT PRIMARY KEY IDENTITY NOT NULL,
FastName NVARCHAR(MAX) NOT NULL,
LastName NVARCHAR(MAX) NOT NULL);

GO
CREATE TABLE Ratings(
ID_Rating INT PRIMARY KEY IDENTITY NOT NULL,
ID_Lesson INT FOREIGN KEY REFERENCES Lessons(ID_Lesson) NOT NULL,
ID_Pupil INT FOREIGN KEY REFERENCES Pupils(ID_Pupil) NOT NULL,
Rating INT);