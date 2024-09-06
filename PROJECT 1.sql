USE master;

IF exists (SELECT * FROM sysdatabases WHERE NAME= 'Project 1 - Amir Halili')
		DROP DATABASE [Project 1 - Amir Halili];

CREATE DATABASE "Project 1 - Amir Halili";

USE "Project 1 - Amir Halili";

CREATE TABLE "Category"
(CategoryID INT NOT NULL,
CategoryName VARCHAR(30),
Description VARCHAR (100),
CONSTRAINT "CatId_Cat_PK" PRIMARY KEY (CategoryID));


CREATE TABLE "Suppliers"
(SupplierID INT IDENTITY NOT NULL,
SupplierName VARCHAR (30),
CategoryID INT NOT NULL,
Description VARCHAR(40),
SupplierPhone VARCHAR (20),
SupplierManager VARCHAR (30),
CONSTRAINT "SupID_Sup_PK" PRIMARY KEY (SupplierID),
CONSTRAINT "Cat_Sup_FK" FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID));

CREATE TABLE "Employee"
(EmployeeID INT IDENTITY NOT NULL,
EmployeeName VARCHAR (30),
HireDate Date,
VETEK INT,
Role VARCHAR (30),
BirthDate DATE,
Salary MONEY,
CONSTRAINT "EmpId_emp_PK" PRIMARY KEY (EmployeeID),
CONSTRAINT Salary_Emp_CK CHECK (Salary > 6000));


CREATE TABLE "Customer"
(CustomerID INT IDENTITY NOT NULL,
CustomerName VARCHAR (30),
IDNumber VARCHAR (30),
Phone VARCHAR (20),
SecondPhone VARCHAR(20),
Adress VARCHAR(40),
NumOfPolocies INT,
BirthDate DATE,
Tviot INT,
CONSTRAINT "CusID_Cus_PK" PRIMARY KEY (CustomerID));


CREATE TABLE "Policy"
(PolID INT IDENTITY(55555,1)  NOT NULL,
CategoryID INT  NOT NULL,
CustomerID INT  NOT NULL,
[Start date] DATE,
VETEK INT,
Cost MONEY,
Tviot INT,
SellerOfPolicy INT,
AccountManagerPol INT,
SupplierID INT,
CONSTRAINT "Pol_PolId_PK" PRIMARY KEY (PolID),
CONSTRAINT "Pol_Seller_FK" FOREIGN KEY (SellerOfPolicy) REFERENCES Employee(EmployeeID),
CONSTRAINT "Pol_Manger_FK" FOREIGN KEY (AccountManagerPol) REFERENCES Employee(EmployeeID),
CONSTRAINT "Cat_Pol_FK" FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
CONSTRAINT "Cus_Pol_FK" FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
CONSTRAINT "Sup_Pol_FK" FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID));





INSERT INTO "Category"
VALUES 
(1, 'Car', 'HOVA, MEKIF'),
(2, 'Home', 'MIVNE, TCHULA'),
(3, 'Health', 'Life Insurance, Health Insurance, Malignant Diseases, Medical Treatments, Accident Insurance'),
(4, 'Flights', 'Travel Insurance');

INSERT INTO "Suppliers"
VALUES
('SHAGRIR',1,'Towing Services','03-1234567','Haim'),
('NATI',1, 'Towing Services','052-7431454','Netanel'),
('OTO-GLASS',1,'Lights and mirrors services','052-11111111','Moshe'),
('BLUE', 2, 'Plumbing repairs','054-4872282','David'),
('MILGAM',2, 'Plumbing repairs','052-3974549','Bar'),
('FEMI',3,'Medical Teatments','03-5688142','Shira'),
('HATZALA',4,'Service center abroad','+972-3-9206900','Rami'),
('GRIRA',1,'Towing Services',NULL,NULL),
('Ilan Car Glass',1,'Mirrors services',NULL,NULL),
('HALUFI',1,'Replacement cars',NULL,NULL),
('ZHUHIT+',2,'Glass and showcase services',NULL,NULL),
('SHAMAY',2,'Damage assessment',NULL,NULL),
('SHARAP+',3,'Alternative Medicine','073-3300399',NULL),
('BEYAHAD ITAHA',3,'LTC',NULL,NULL);


INSERT INTO Customer 
VALUES 
('Amir Halili','209374545','052-7369370',NULL,'Aba Hilel 116',2,'1998-05-28',0),
('Shira Rosenblum','207612890','052-7960420',NULL,'Aba Hilel 116',1,'1998-09-02',1),
('Oded Miha','2067432679','053-1412412',NULL,'Hamaapil 4', 3,'1990-02-02',0),
('Dana Shemesh','28094258','051-23124151',NULL,'Rosh Pina 26',1,'1995-10-10',0),
('Rami Rubin','023097660','052-2241214','03-9242224','Asirey Zion 3',4,'1973-12-02',2),
('Revial Noy','121235123','052-8276070',NULL,'Asirey Zion 100',1, '1980-03-03',1),
('Moshe Levi','111111111','03-547356347',NULL,'Moshe Sharet 15',1,'1960-01-01',1),
('Yael Cohen','305697814','054-7896231',NULL,'HaYarkon 50',2,'1987-07-15',0),
('Avi Avrahami','208754320','050-1234567',NULL,'Herzl 12',1,'1993-04-20',1),
('Maya Levi','305487123','053-9876543',NULL,'Dizengoff 78',3,'1985-11-30',0),
('Nadav Biton','208765432','052-3334445',NULL,'Bialik 3',1,'1992-09-10',0),
('Tamar Mizrahi','305689743','054-5556667','03-76786787','Ben Gurion 25',4,'1989-05-25',2),
('Yossi Cohen','208675431','050-7778889','09-8723412','Rothschild 15',1,'1996-02-18',1),
('Orly Levi','305678901','053-1112223',NULL,'King George 7',1,'1991-03-22',1),
('Eliyahu Amar','207654321','052-1234567',NULL,'Derech HaTzofim 3',2,'1994-08-12',0),
('Shira Golan','305689012','054-7778889',NULL,'Allenby 10',3,'1988-12-05',0),
('Eran Cohen','205678901','051-3334445',NULL,'HaHashmonaim 20',1,'1997-06-30',0),
('Avigail Levi','305698734','054-9998887',NULL,'Ben Yehuda 42',2,'1986-04-18',1),
('Yakov Biton','207654890','052-5556667',NULL,'Shenkin 5',4,'1990-10-15',2),
('Shlomit Avrahami','305678904','054-7779998',NULL,'Bnei Brak 8',1,'1998-01-09',1);


INSERT INTO Employee
VALUES
('Shirly Levi','2021-10-21',DATEDIFF (YY,'2021-10-21',GETDATE()), 'Account Manager','1995-02-15',9000),
('Linoy Krener','2020-01-01', DATEDIFF (YY,'2020-01-01',GETDATE()), 'Account Manager','1992-08-20',11000),
('Hen Hadad','2014-12-12',DATEDIFF (YY,'2014-12-12',GETDATE()), 'CustomerServiceTeam Manager','1987-10-10',18000),
('Nir Avraham','2023-05-29',DATEDIFF (YY,'2023-05-29',GETDATE()), 'Salesman','2001-04-15',13000),
('Yossi Cohen','2019-04-25',DATEDIFF (YY,'2019-04-25',GETDATE()), 'Salesman','1995-03-21',7000),
('Avi Levi','2020-03-14',DATEDIFF (YY,'2020-03-14',GETDATE()), 'Salesman','1997-11-18',8000),
('Rachel Ben-David','2021-01-02',DATEDIFF (YY,'2021-01-02',GETDATE()), 'Salesman','1996-08-01',9500),
('Tamar Shoham','2018-11-11',DATEDIFF (YY,'2018-11-11',GETDATE()), 'Salesman','1990-12-05',17500),
('Daniel Goldstein','2022-09-15',DATEDIFF (YY,'2022-09-15',GETDATE()), 'Salesman','1993-07-31',18200),
('Efrat Cohen','2019-08-20',DATEDIFF (YY,'2019-08-20',GETDATE()), 'Salesman','1994-05-14',16800),
('Roni Levy','2020-07-18',DATEDIFF (YY,'2020-07-18',GETDATE()), 'Salesman','1988-09-29',17200),
('Avraham Cohen','2023-01-01',DATEDIFF (YY,'2023-01-01',GETDATE()), 'Salesman','1998-11-12',18900),
('Yael Moshe','2021-11-30',DATEDIFF (YY,'2021-11-30',GETDATE()), 'Salesman','1992-03-04',18100),
('Oren Cohen','2020-10-05',DATEDIFF (YY,'2020-10-05',GETDATE()), 'Salesman','1996-06-30',17700),
('Noa Levi','2018-06-15',DATEDIFF (YY,'2018-06-15',GETDATE()), 'Salesman','1991-09-22',17800),
('Tali Cohen','2019-05-01',DATEDIFF (YY,'2019-05-01',GETDATE()), 'Salesman','1997-12-28',18400),
('Itay Cohen','2022-03-11',DATEDIFF (YY,'2022-03-11',GETDATE()), 'Salesman','1994-10-15',18800),
('Dana Levi','2017-02-28',DATEDIFF (YY,'2017-02-28',GETDATE()), 'Salesman','1990-05-07',17300),
('Liron Cohen','2023-09-01',DATEDIFF (YY,'2023-09-01',GETDATE()), 'Salesman','1995-11-23',17900),
('Ido Cohen','2022-05-06',DATEDIFF (YY,'2022-05-06',GETDATE()), 'Salesman','1989-07-17',18600),
('Eyal Catz','2003-05-05',DATEDIFF (YY,'2003-05-05',GETDATE()), 'SalesTeam Manager', '1982-10-30',32000);


INSERT INTO "Policy"
VALUES
(1,1,'2023-04-01',3,4500,0,4,1,3),
(1,2,'2023-12-01',1,6000,0,12,1,9),
(2,3,'2024-01-01',6,1500,1,5,2,4),
(2,3,'2023-10-01',2,1000,0,6,2,5),
(2,4,'2023-03-10',0,2500,0,7,2,11),
(3,5,'2015-04-01',DATEDIFF(YY,'2015-04-01',GETDATE()),800,1,8,1,6),
(3,6,'2023-02-01',2,450,0,8,1,13),
(3,7,'2024-02-01',0,1000,0,9,1,14),
(3,8,'2023-07-01',4,1800,2,9,1,14),
(4,9,'2024-05-05',0,90,0,NULL,3,7),
(4,10,'2024-02-20',0,200,1,NULL,3,7),
(1,11,'2023-12-01',10,2000,2,10,1,2),
(1,12,'2024-04-01',3,7000,0,11,1,1),
(1,13,'2023-01-01',7,2000,1,12,1,1),
(1,14,'2024-01-01',4,3500,0,12,1,10),
(2,15,'2024-01-01',15,2500,0,13,2,12),
(2,16,'2024-01-01',0,500,0,14,2,5),
(2,17,'2023-11-20',0,2000,0,15,2,4),
(3,18,'2023-05-01',7,1300,1,16,1,14),
(3,19,'2023-02-01',2,1800,0,17,1,13),
(3,20,'2023-10-01',8,2000,3,18,1,6),
(1,5,'2024-02-01',3,4000,0,19,1,1),
(1,11,'2023-09-01',6,3000,1,20,1,1),
(1,19,'2023-07-01',2,5000,0,12,1,9);
