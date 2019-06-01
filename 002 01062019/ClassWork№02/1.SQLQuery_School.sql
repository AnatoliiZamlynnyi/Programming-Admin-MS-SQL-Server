--1. ��������� ����� (��������� ) ���� ����� ����� (������� 5 �������). ���� ����� 
--������ ���������� ��� �������, �������� �� ���� ������, �������, ���� �� ������

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
('���������'),
('������'),
('����������'),
('˳��������'),
('�����������');

GO
INSERT INTO Teachers VALUES
('³�����', '�������', (SELECT ID_Lesson FROM Lessons where Lesson='����������')),
('������', '�����', (SELECT ID_Lesson FROM Lessons where Lesson='�����������')),
('���', '�������', (SELECT ID_Lesson FROM Lessons where Lesson='������')),
('�������', '��������', (SELECT ID_Lesson FROM Lessons where Lesson='���������')),
('���������', 'ʳ��', (SELECT ID_Lesson FROM Lessons where Lesson='˳��������'));

GO
INSERT INTO Audiences VALUES
((SELECT ID_Teacher FROM Teachers where FastName='������' and LastName='�����')),
((SELECT ID_Teacher FROM Teachers where FastName='���' and LastName='�������')),
((SELECT ID_Teacher FROM Teachers where FastName='�������' and LastName='��������')),
((SELECT ID_Teacher FROM Teachers where FastName='���������' and LastName='ʳ��')),
((SELECT ID_Teacher FROM Teachers where FastName='³�����' and LastName='�������'));
 
 GO
INSERT INTO Pupils VALUES
('���������', '�����'),
('�������', '���������'),
('�������', '�����'),
('������', '��������'),
('�����', '��������'),
('�������', '����'),
('�����', '�������'),
('��������', '�����'),
('�����', '��������'),
('�����', '����������');

GO
INSERT INTO Ratings VALUES
((SELECT ID_Lesson FROM Lessons  where Lesson='����������'),(SELECT ID_Pupil FROM Pupils  where LastName='����'),5),
((SELECT ID_Lesson FROM Lessons  where Lesson='������'),(SELECT ID_Pupil FROM Pupils  where LastName='���������'),12),
((SELECT ID_Lesson FROM Lessons  where Lesson='�����������'),(SELECT ID_Pupil FROM Pupils  where LastName='��������'),10),
((SELECT ID_Lesson FROM Lessons  where Lesson='����������'),(SELECT ID_Pupil FROM Pupils  where LastName='��������'),2),
((SELECT ID_Lesson FROM Lessons  where Lesson='������'),(SELECT ID_Pupil FROM Pupils  where LastName='��������'),8),
((SELECT ID_Lesson FROM Lessons  where Lesson='���������'),(SELECT ID_Pupil FROM Pupils  where LastName='�����'),6),
((SELECT ID_Lesson FROM Lessons  where Lesson='���������'),(SELECT ID_Pupil FROM Pupils  where LastName='�����'),4),
((SELECT ID_Lesson FROM Lessons  where Lesson='������'),(SELECT ID_Pupil FROM Pupils  where LastName='����'),12),
((SELECT ID_Lesson FROM Lessons  where Lesson='����������'),(SELECT ID_Pupil FROM Pupils  where LastName='����'),9),
((SELECT ID_Lesson FROM Lessons  where Lesson='���������'),(SELECT ID_Pupil FROM Pupils  where LastName='��������'),11),
((SELECT ID_Lesson FROM Lessons  where Lesson='���������'),(SELECT ID_Pupil FROM Pupils  where LastName='���������'),10 ),
((SELECT ID_Lesson FROM Lessons  where Lesson='������'),(SELECT ID_Pupil FROM Pupils  where LastName='�����'),6),
((SELECT ID_Lesson FROM Lessons  where Lesson='�����������'),(SELECT ID_Pupil FROM Pupils  where LastName='��������'),7),
((SELECT ID_Lesson FROM Lessons  where Lesson='���������'),(SELECT ID_Pupil FROM Pupils  where LastName='����'),3),
((SELECT ID_Lesson FROM Lessons  where Lesson='�����������'),(SELECT ID_Pupil FROM Pupils  where LastName='�������'),10),
((SELECT ID_Lesson FROM Lessons  where Lesson='����������'),(SELECT ID_Pupil FROM Pupils  where LastName='��������'),2),
((SELECT ID_Lesson FROM Lessons  where Lesson='���������'),(SELECT ID_Pupil FROM Pupils  where LastName='����������'),1),
((SELECT ID_Lesson FROM Lessons  where Lesson='������'),(SELECT ID_Pupil FROM Pupils  where LastName='����������'),10 ),
((SELECT ID_Lesson FROM Lessons  where Lesson='�����������'),(SELECT ID_Pupil FROM Pupils  where LastName='��������'),11);

SELECT p.FastName+' '+p.LastName, l.Lesson, a.ID_Audience, t.FastName+' '+t.LastName, r.Rating 
FROM Pupils as p, Lessons as l, Audiences as a, Teachers as t, Ratings as r
WHERE r.ID_Lesson=l.ID_Lesson;