----------- ORDBMS -----------

----------------- Create Object types ---------------------

CREATE TYPE CustomerPaymentDetail_objtyp AS OBJECT (

    card_number NUMBER ,
    card_type VARCHAR2(15) ,
    card_network VARCHAR2(15) ,
    card_issuer VARCHAR2(30) ,
    card_name VARCHAR2(20) ,
    card_holder_name VARCHAR2(50) ,
    cvv NUMBER

) NOT FINAL;
/

CREATE TYPE CustomerPayment_varray_typ AS VARRAY(2) OF CustomerPaymentDetail_objtyp;
/

CREATE OR REPLACE TYPE Customer_objtyp AS OBJECT (

    customer_id NUMBER,
    customer_payment_list CustomerPayment_varray_typ,
    dob Date,
    address VARCHAR2(50),
    mobile_number NUMBER,
    tel_number NUMBER,
    age NUMBER

) NOT FINAL;
/

CREATE TYPE Venue_objtyp AS OBJECT (

    venue_id NUMBER,
    venue_name VARCHAR2(100),
    city VARCHAR2(100),
    country VARCHAR2(100),
    address VARCHAR2(200)

) NOT FINAL;
/

CREATE TYPE Artist_objtyp AS OBJECT (

    artist_id NUMBER ,
    artist_name VARCHAR2(100) ,
    dob DATE ,
    registered_number NUMBER ,
    contact_number NUMBER ,
    senior VARCHAR2(5) ,
    genre VARCHAR2(100)

) NOT FINAL;
/

CREATE TYPE MusicBand_objtyp AS OBJECT (

    band_id NUMBER ,
    registered_date DATE ,
    band_name VARCHAR2(100) ,
    genre VARCHAR2(50) ,
    members_total NUMBER

) NOT FINAL;
/

CREATE TYPE Meal_objtyp AS OBJECT (

    meal_id NUMBER ,
    meal_name VARCHAR2(100) ,
    escription VARCHAR2(200)  ,
    meal_type VARCHAR2(100) ,
    availability VARCHAR2(5)

) NOT FINAL;
/

CREATE OR REPLACE TYPE CustomerMembership_objtyp AS OBJECT (

    membership_id NUMBER ,
    customer_ref REF Customer_objtyp,
    membership_type VARCHAR2(25) ,
    membership_name VARCHAR2(25) ,
    renew VARCHAR2(5) ,
    membership_duration VARCHAR2(25) ,
    start_date DATE,
    end_date DATE

) NOT FINAL;
/

CREATE OR REPLACE TYPE CustomerPaymentRecord_objtyp AS OBJECT (

    record_id NUMBER ,
    customer_ref REF Customer_objtyp,
    date_of_payment DATE ,
    amount_payed FLOAT ,
    status VARCHAR2(15)

) NOT FINAL;
/

CREATE OR REPLACE TYPE Booking_objtyp AS OBJECT (

    booking_id NUMBER ,
    customer_ref REF Customer_objtyp,
    record_ref REF CustomerPaymentRecord_objtyp ,
    description VARCHAR2(100),
    booking_date DATE ,
    payed VARCHAR2(5),
    status VARCHAR2(20)

) NOT FINAL;
/

CREATE OR REPLACE TYPE Event_objtyp AS OBJECT (

    event_id NUMBER ,
    venue_ref REF Venue_objtyp,
    event_name VARCHAR2(100) ,
    description VARCHAR2(200),
    minimum_age NUMBER ,
    event_date DATE ,
    start_time TIMESTAMP ,
    end_time TIMESTAMP ,
    tickets_available NUMBER ,
    tickets_sold NUMBER ,
    total_tickets NUMBER

) NOT FINAL;
/

CREATE OR REPLACE TYPE TicketReservation_objtyp AS OBJECT (

    ticket_id NUMBER ,
    booking_ref REF  Booking_objtyp,
    event_ref REF  Event_objtyp,
    issued_date TIMESTAMP ,
    ticket_price FLOAT ,
    total_tickets NUMBER ,
    total_amount FLOAT

) NOT FINAL;
/

CREATE OR REPLACE TYPE Employee_objtyp AS OBJECT (

    employee_id NUMBER ,
    venue_ref REF Venue_objtyp,
    employee_name VARCHAR2(100) ,
    join_date DATE ,
    Designation VARCHAR2(100) ,
    id_number NUMBER ,
    dob DATE ,
    employee_number NUMBER ,
    address VARCHAR2(100) ,
    Salary FLOAT

) NOT FINAL;
/

CREATE OR REPLACE TYPE EmployeeAssignment_objtyp AS OBJECT (

    assignment_id NUMBER ,
    employee_ref REF  Employee_objtyp,
    artist_ref REF Artist_objtyp,
    ticket_ref REF TicketReservation_objtyp,
    assigned_date DATE ,
    start_time TIMESTAMP ,
    end_time TIMESTAMP ,
    assignee_type VARCHAR2(50) ,
    status VARCHAR2(50)

) NOT FINAL;
/

CREATE OR REPLACE TYPE BandArtist_objtyp AS OBJECT (

    id NUMBER ,
    band_ref REF MusicBand_objtyp ,
    artist_ref REF Artist_objtyp

) NOT FINAL;
/

CREATE OR REPLACE TYPE PerformersPayments_objtyp AS OBJECT (

    payment_id NUMBER ,
    band_ref REF MusicBand_objtyp ,
    artist_ref REF Artist_objtyp,
    payment_date DATE ,
    description VARCHAR2(200) ,
    payment_type VARCHAR2(100) ,
    issued_date DATE ,
    status VARCHAR2(50) ,
    is_band VARCHAR2(5) ,
    amount_payed FLOAT

) NOT FINAL;
/

CREATE OR REPLACE TYPE MealReservation_objtyp AS OBJECT (

    id NUMBER ,
    meal_ref REF Meal_objtyp ,
    ticket_ref REF TicketReservation_objtyp

) NOT FINAL;
/


--------------------- END Create Object Types --------------------------

--------------------- Start Create Object Tables --------------------------


CREATE TABLE Artist_objtab OF Artist_objtyp (artist_id PRIMARY KEY)
    OBJECT IDENTIFIER is PRIMARY KEY;
/

CREATE TABLE Venue_objtab OF Venue_objtyp (venue_id PRIMARY KEY)
    OBJECT IDENTIFIER is PRIMARY KEY;
/

CREATE TABLE Meal_objtab OF Meal_objtyp (meal_id PRIMARY KEY)
    OBJECT IDENTIFIER is PRIMARY KEY;
/

CREATE TABLE Customer_objtab OF Customer_objtyp (customer_id PRIMARY KEY)
    OBJECT IDENTIFIER is PRIMARY KEY;
/

CREATE TABLE MusicBand_objtab OF MusicBand_objtyp (band_id PRIMARY KEY)
    OBJECT IDENTIFIER is PRIMARY KEY;
/

-- CREATE TABLE Customer_objtab OF Customer_objtyp (customer_id PRIMARY KEY)
--     OBJECT IDENTIFIER is PRIMARY KEY;
--     NESTED TABLE CustomerPaymentList_ntab STORE AS PaymentDetails_ntab (
--    (PRIMARY KEY (NESTED_TABLE_ID, payment_detail_id)));
-- /

-- CREATE TABLE CustomerPaymentDetail_objtab OF CustomerPaymentDetail_objtyp (
-- 	PRIMARY KEY (payment_detail_id),
-- 	FOREIGN KEY (customer_ref) REFERENCES Customer_objtab)
-- 	OBJECT IDENTIFIER IS PRIMARY KEY;
-- /

CREATE TABLE CustomerMembership_objtab OF CustomerMembership_objtyp (
	PRIMARY KEY (membership_id),
	FOREIGN KEY (customer_ref) REFERENCES Customer_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE CustomerPaymentRecord_objtab OF CustomerPaymentRecord_objtyp (
	PRIMARY KEY (record_id),
	FOREIGN KEY (customer_ref) REFERENCES Customer_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE Booking_objtab OF Booking_objtyp (
	PRIMARY KEY (booking_id),
	FOREIGN KEY (customer_ref) REFERENCES Customer_objtab,
    FOREIGN KEY (record_ref) REFERENCES CustomerPaymentRecord_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE Event_objtab OF Event_objtyp (
	PRIMARY KEY (event_id),
	FOREIGN KEY (venue_ref) REFERENCES Venue_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/


CREATE TABLE TicketReservation_objtab OF TicketReservation_objtyp (
	PRIMARY KEY (ticket_id),
	FOREIGN KEY (booking_ref) REFERENCES Booking_objtab,
    FOREIGN KEY (event_ref) REFERENCES Event_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE Employee_objtab OF Employee_objtyp (
	PRIMARY KEY (employee_id),
	FOREIGN KEY (venue_ref) REFERENCES Venue_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE EmployeeAssignment_objtab OF EmployeeAssignment_objtyp (
	PRIMARY KEY (assignment_id),
	FOREIGN KEY (ticket_ref) REFERENCES TicketReservation_objtab,
    FOREIGN KEY (employee_ref) REFERENCES Employee_objtab,
    FOREIGN KEY (artist_ref) REFERENCES Artist_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE BandArtist_objtab OF BandArtist_objtyp (
	PRIMARY KEY (id),
	FOREIGN KEY (band_ref) REFERENCES MusicBand_objtab,
    FOREIGN KEY (artist_ref) REFERENCES Artist_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE PerformersPayments_objtab OF PerformersPayments_objtyp (
	PRIMARY KEY (payment_id),
	FOREIGN KEY (band_ref) REFERENCES MusicBand_objtab,
    FOREIGN KEY (artist_ref) REFERENCES Artist_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/

CREATE TABLE MealReservation_objtab OF MealReservation_objtyp (
	PRIMARY KEY (id),
	FOREIGN KEY (meal_ref) REFERENCES Meal_objtab,
    FOREIGN KEY (ticket_ref) REFERENCES TicketReservation_objtab)
	OBJECT IDENTIFIER IS PRIMARY KEY;
/


-- Drop SQL

DROP TABLE CustomerMembership_objtab FORCE;
/

DROP TABLE Booking_objtab PURGE;
/

DROP TABLE CustomerPaymentRecord_objtab PURGE;
/

DROP TABLE Customer_objtab PURGE;
/

DROP TABLE Event_objtab FORCE;
/

DROP TABLE TicketReservation_objtab FORCE;
/

DROP TABLE Employee_objtab FORCE;
/

DROP TABLE EmployeeAssignment_objtab FORCE;
/

DROP TABLE BandArtist_objtab FORCE;
/

DROP TABLE PerformersPayments_objtab FORCE;
/

DROP TABLE MealReservation_objtab FORCE;
/

DROP TABLE Artist_objtab FORCE;
/

DROP TABLE Venue_objtab FORCE;
/

DROP TABLE Meal_objtab FORCE;
/

DROP TABLE MusicBand_objtab FORCE;
/

DROP TYPE Artist_objtyp FORCE;
/

DROP TYPE Venue_objtyp FORCE;
/

DROP TYPE Meal_objtyp FORCE;
/

DROP TYPE CustomerPaymentDetail_objtyp FORCE;
/

DROP TYPE CustomerPayment_varray_typ FORCE;
/

DROP TYPE Customer_objtyp FORCE;
/

DROP TYPE MusicBand_objtyp FORCE;
/

DROP TYPE CustomerMembership_objtyp FORCE;
/

DROP TYPE CustomerPaymentRecord_objtyp FORCE;
/

DROP TYPE Booking_objtyp FORCE;
/

DROP TYPE Event_objtyp FORCE;
/

DROP TYPE TicketReservation_objtyp FORCE;
/

DROP TYPE Employee_objtyp FORCE;
/

DROP TYPE EmployeeAssignment_objtyp FORCE;
/

DROP TYPE BandArtist_objtyp FORCE;
/

DROP TYPE PerformersPayments_objtyp FORCE;
/

DROP TYPE MealReservation_objtyp FORCE;
/

-------------------- Test Data ------------------------

INSERT INTO Customer_objtab VALUES (
   100,
   CustomerPayment_varray_typ( CustomerPaymentDetail_objtyp (1, 'test', 'master', 'bank1', 'card1', 'thanga', 233),
                    CustomerPaymentDetail_objtyp (2, 'test1', 'master', 'bank1', 'card2', 'thanga', 233)),
    TO_DATE('1954-12-28','yyyy/MM/dd'),
    'adress 1',
    123456789,
    123456789,
    28);

INSERT INTO Booking_objtab
 SELECT  1001, REF(c),
         SYSDATE,
         ReservationList_ntabtyp(),
         12000
  FROM   Customer_objtab c
  WHERE  c.id = 1 ;
/  
INSERT INTO TABLE (
 SELECT  b.ReservationList_ntab
  FROM   Booking_objtab b
  WHERE  b.bookingno = 1001
 )
 SELECT  1, REF(e),NULL,5,1000,0
  FROM   event_objtab e
  WHERE  e.id = 1 ;
/
INSERT INTO TABLE (
 SELECT  b.ReservationList_ntab
  FROM   Booking_objtab b
  WHERE  b.bookingno = 1001
 )
 SELECT  2, REF(e),NULL,5,1000,0
  FROM   event_objtab e
  WHERE  e.id = 1 ;
/
