-- List down all tables and bind drop table command

SELECT 'DROP TABLE "' || TABLE_NAME || '" CASCADE CONSTRAINTS;' FROM user_tables;


-------------------------- Start Fragmentation ----------------------------


-- I have 3 remote databases host for this operation using aws rds
-- maindb - main database
-- devdb - remote database 1
-- db2 - remote database 2


-------------------- main db ------------------------------------
-- create table
CREATE TABLE Staffs (

    staff_id NUMBER NOT NULL,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    contact_number NUMBER NOT NULL,
    dob DATE NOT NULL,
    venue NUMBER NOT NULL,
    
    CONSTRAINT PK_staff PRIMARY KEY(staff_id)
);

-- Insert into staffs table
INSERT INTO Staffs VALUES (1, 'Denzel', 'Washington', 123456789, TO_DATE('1954-12-28','yyyy/MM/dd'), 1);
INSERT INTO Staffs VALUES (2, 'Leonardo', 'Dicaprio', 123456789, TO_DATE('1974-11-11','yyyy/MM/dd'), 1);
INSERT INTO Staffs VALUES (3, 'Brad', 'Pitt', 123456789, TO_DATE('1963-12-18','yyyy/MM/dd'), 1);
INSERT INTO Staffs VALUES (4, 'Robert','DeNiro', 123456789, TO_DATE('1943-08-17','yyyy/MM/dd'), 2);
INSERT INTO Staffs VALUES (5, 'Al', 'Pacino', 123456789, TO_DATE('1940-04-25','yyyy/MM/dd'), 2);
INSERT INTO Staffs VALUES (6, 'Christian', 'Bale', 123456789, TO_DATE('1974-01-30','yyyy/MM/dd'), 2);
INSERT INTO Staffs VALUES (7, 'Tom', 'Hardy', 123456789, TO_DATE('1977-09-15','yyyy/MM/dd'), 2);
INSERT INTO Staffs VALUES (8, 'Daniel Dey', 'Lewis', 123456789, TO_DATE('1957-04-29','yyyy/MM/dd'), 1);
INSERT INTO Staffs VALUES (9, 'Jhonny', 'Depp', 123456789, TO_DATE('1963-06-09','yyyy/MM/dd'), 1);
INSERT INTO Staffs VALUES (10, 'Will', 'Smith', 123456789, TO_DATE('1968-09-25','yyyy/MM/dd'), 2);

-- venue value 1 is NewYork,USA
-- venue value 2 is California,USA


--create link to access remote db for newyork_usa
CREATE PUBLIC DATABASE LINK remote_newyork_usa CONNECT TO admin IDENTIFIED BY "Mhthanga" 
USING '(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = devdb.cfq4xrzdb3fb.us-east-1.rds.amazonaws.com)(PORT = 1521)) )(CONNECT_DATA =(SERVICE_NAME = ORCL)))';

--create link to access remote db for california_usa
CREATE PUBLIC DATABASE LINK remote_california_usa CONNECT TO admin IDENTIFIED BY "Mhthanga" 
USING '(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = db2.cfq4xrzdb3fb.us-east-1.rds.amazonaws.com)(PORT = 1521)) )(CONNECT_DATA =(SERVICE_NAME = ORCL)))';

-- select all links
SELECT * FROM DBA_DB_LINKS;

--------------- create to link from remote db to main db ----------------------
CREATE PUBLIC DATABASE LINK MAIN CONNECT TO admin IDENTIFIED BY "Mhthanga" 
USING '(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCP)(HOST = maindb.cfq4xrzdb3fb.us-east-1.rds.amazonaws.com)(PORT = 1521)) )(CONNECT_DATA =(SERVICE_NAME = ORCL)))';

-- drop database links
DROP PUBLIC DATABASE LINK remote_newyork_usa;
DROP PUBLIC DATABASE LINK remote_california_usa;
DROP PUBLIC DATABASE LINK MAIN;

-- i.e. execute in location link newyork_usa and create table Hor_NewYork_usa_Staffs

----------------------- Start Remote SQL execution --------------------------

--Horizontal Fragmentation for newyork_usa_staffs
CREATE TABLE Hor_NewYork_usa_Staffs AS 
SELECT * FROM Staffs@MAIN WHERE Venue=1

--Horizontal Fragmentation for california_usa_staffs
CREATE TABLE Hor_California_usa_Staffs AS 
SELECT * FROM Staffs@MAIN WHERE Venue=2

--Create SYNONYM for Horizontal Frangmentation for separate remote locations
CREATE SYNONYM Staffs FOR Hor_NewYork_usa_Staffs;
CREATE SYNONYM Staffs FOR Hor_California_usa_Staffs;


--Vertical Fragmentation for newyork_usa_staffs
CREATE TABLE Ver_NewYork_usa_Staffs AS 
SELECT staff_id, first_name, dob FROM Staffs@MAIN;

--Vertical Fragmentation for california_usa_staffs
CREATE TABLE Ver_California_usa_Staffs AS 
SELECT staff_id, last_name, contact_number, venue FROM Staffs@MAIN;

--Create SYNONYM for Vertical Frangmentation
CREATE SYNONYM Staffs FOR Ver_NewYork_usa_Staffs;
CREATE SYNONYM Staffs FOR Ver_California_usa_Staffs;

----------------------- END Remote SQL execution --------------------------


----------------------- SELECT SQL from LOCAL -------------------------------

-- query newyork staffs from remote (horizontal)
SELECT * FROM Hor_NewYork_usa_Staffs@remote_newyork_usa;

-- query california staffs from remote (horizontal)
SELECT * FROM Hor_California_usa_Staffs@remote_california_usa;

-- query newyork staffs from remote (Vertical)
SELECT * FROM Ver_NewYork_usa_Staffs@remote_newyork_usa;

-- query newyork staffs from remote (Vertical)
SELECT * FROM Ver_California_usa_Staffs@remote_california_usa;

------------------------ END SELECT ------------------------------------

------------------ Create View ----------------------------

--------------------- Horizontal --------------------
CREATE VIEW Horizontal_Global_Staffs AS
(SELECT *  FROM Staffs@remote_newyork_usa)
UNION
(SELECT * FROM Staffs@remote_california_usa);

SELECT * FROM Horizontal_Global_Staffs;

---------------------- Vertical ------------------------
CREATE VIEW Vertical_Global_Staffs AS
SELECT a.staff_id, a.first_name, b.last_name, b.contact_number, a.dob, b.venue FROM Staffs@remote_newyork_usa a
FULL OUTER JOIN Staffs@remote_california_usa b ON a.staff_id = b.staff_id;

SELECT * FROM Vertical_Global_Staffs;

------------------------ DROP TABLES ------------------------------

-- drop local
DROP TABLE Staffs FORCE;

-- drop remote
DROP TABLE Hor_NewYork_usa_Staffs FORCE;
DROP TABLE Hor_California_usa_Staffs FORCE;
DROP TABLE Ver_NewYork_usa_Staffs FORCE;
DROP TABLE Ver_NewYork_usa_Staffs FORCE;



