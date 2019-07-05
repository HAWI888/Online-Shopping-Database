create database if not exists OnlineShopping;
use OnlineShopping;


create table if not exists Company(
  RegisterNumber int not null AUTO_INCREMENT,
  CompanyName varchar(20) not null,
  Address varchar(20),
  Phone1 numeric(15),
  Phone2 numeric(15),
  primary key(RegisterNumber)
);
create table if not exists CompanyLog(
  Old_RegisterNumber int,
  New_RegisterNumber int,
  Old_CompanyName varchar(20),
  New_CompanyName varchar(20),
  Old_Address varchar(20),
  New_Address varchar(20),
  Old_Phone1 numeric(15),
  New_Phone1 numeric(15),
  Old_Phone2 numeric(15),
  New_Phone2 numeric(15),
  operation VARCHAR(15),
  changedTime DATETIME
);


drop TRIGGER if EXISTS Company_trg_ai;
create TRIGGER Company_trg_ai after INSERT on Company
FOR EACH ROW
  BEGIN
    INSERT INTO CompanyLog VALUES (
      null,
      new.RegisterNumber,
      null,
      new.CompanyName,
      null,
      new.Address,
      null,
      new.Phone1,
      null,
      new.Phone2,
      'insert',
      now()
    );
  END;
drop TRIGGER if EXISTS Company_trg_au;
create TRIGGER Company_trg_au AFTER UPDATE ON Company
  FOR EACH ROW
  BEGIN
    INSERT INTO CompanyLog VALUES (
      old.RegisterNumber,
      new.RegisterNumber,
      old.CompanyName,
      new.CompanyName,
      old.Address,
      new.Address,
      old.Phone1,
      new.Phone1,
      old.Phone2,
      new.Phone2,
      'update',
      now()
    );
  END;
drop TRIGGER if EXISTS Company_trg_ad;
create TRIGGER Company_trg_ad AFTER UPDATE ON Company
FOR EACH ROW
  BEGIN
    INSERT INTO CompanyLog VALUES (
      old.RegisterNumber,
      NULL ,
      old.CompanyName,
      NULL,
      old.Address,
      NULL,
      old.Phone1,
      NULL,
      old.Phone2,
      NULL,
      'delete',
      now()
    );
  END;

create table if not exists Product(
  PID int not null AUTO_INCREMENT,
  ProductName varchar(20) not null,
  Price numeric(8,2),
  Discount int(3),
  Stock int(5),
  RegisterNumber int(5),
  primary key (PID),
  foreign key (RegisterNumber) references Company(RegisterNumber)
);

CREATE TABLE IF NOT EXISTS ProductLog (
  Old_PID INT,
  New_PID INT,
  Old_ProductName VARCHAR(20),
  New_ProductName VARCHAR(20),
  Old_Price NUMERIC(8 , 2 ),
  New_Price NUMERIC(8 , 2 ),
  Old_Discount INT(3),
  New_Discount INT(3),
  Old_Stock INT(5),
  New_Stock INT(5),
  OLD_RegisterNumber int(5),
  NEW_RegisterNumber int(5),
  changedTime datetime
);
DROP TRIGGER IF EXISTS  `product_trg_ai`;
CREATE
TRIGGER `product_trg_ai` AFTER INSERT ON `product`
FOR EACH ROW BEGIN
  insert into ProductLog values(
    null,
    new.PID,
    null,
    new.ProductName,
    null,
    new.Price,
    null,
    new.Discount,
    null,
    new.Stock,
    null,
    new.RegisterNumber,
    now()
  );
END;



create table if not exists DigitalProduct(
  PID int not null AUTO_INCREMENT,
  primary key (PID),
  foreign key (PID) references Product(PID)
);

CREATE TABLE DigitalProductLog (
  old_pid int,
  new_pid int,
  updated_on DATETIME,
  operation char(30)
);
CREATE
TRIGGER `DigitalProduct_trg_ai` AFTER INSERT ON `DigitalProduct`
FOR EACH ROW BEGIN
  insert into DigitalProductLog values(
    null,
    new.PID,
    now(),
    'insert'
  );
END;

CREATE
TRIGGER `DigitalProduct_trg_au` AFTER UPDATE ON `DigitalProduct`
FOR EACH ROW BEGIN
  insert into DigitalProductLog values(
    old.PID,
    new.PID,
    now(),
    'update'
  );
END;

CREATE
TRIGGER `DigitalProduct_trg_ad` AFTER DELETE ON `DigitalProduct`
FOR EACH ROW BEGIN
  insert into DigitalProductLog values(
    old.PID,
    NULL ,
    now(),
    'delete'
  );
END;


create table if not exists HomeProduct(
  PID int not null AUTO_INCREMENT,
  BuildDate date,
  primary key (PID),
  foreign key (PID) references Product(PID)
);
create table if not exists SportProduct(
  PID int not null AUTO_INCREMENT,
  Color varchar(10),
  primary key (PID),
  foreign key (PID) references Product(PID)
);
create table if not exists Person(
  ID int not null AUTO_INCREMENT,
  FullName varchar(20),
  primary key (ID)
);

create table if not exists PersonLog(
  OLD_ID int ,
  NEW_ID int ,
  OLD_FullName varchar(20),
  NEW_FullName varchar(20),
  changedTime DATETIME
);


CREATE
TRIGGER `person_trg_ai` AFTER INSERT ON `person`
FOR EACH ROW BEGIN
  insert into personLog values(
    null,
    new.ID,
    null,
    new.FullName,
    now()
  );
END;


create table if not exists Employee(
  SSN int not null AUTO_INCREMENT,
  CompanyName varchar(20) not null,
  ID int ,
  primary key(SSN),
  foreign key(ID) references Person(ID)
);

create table if not exists EmployeeLog(

  OLD_SSN int,
  NEW_SSN int,
  OLD_CompanyName varchar(20),
  NEW_CompanyName varchar(20),
  OLD_ID  int,
  NEW_ID  int,
  changedTime DATETIME

);
DROP  TRIGGER  if EXISTS  `Employee_trg_ai` ;
CREATE
TRIGGER `Employee_trg_ai` AFTER INSERT ON `Employee`
FOR EACH ROW BEGIN
  insert into EmployeeLog values(
    null,
    new.SSN,
    null,
    new.CompanyName,
    null,
    new.ID,
    now()
  );
END;
DROP  TRIGGER  if EXISTS  `Employee_trg_au` ;
CREATE
TRIGGER `Employee_trg_au` AFTER UPDATE ON `Employee`
FOR EACH ROW BEGIN
  insert into EmployeeLog values(
    old.SSN,
    new.SSN,
    old.CompanyName,
    new.CompanyName,
    old.ID,
    new.ID,
    now()
  );
END;

CREATE
TRIGGER `Employee_trg_ad` AFTER delete ON `Employee`
FOR EACH ROW BEGIN
  insert into EmployeeLog values(
    old.SSN,
    null,
    old.CompanyName,
    null,
    old.ID,
    null,
    now()
  );
END;


create table if not exists Manager(
  SSN int,
  primary key(SSN),
  foreign key(SSN) references Employee(SSN)
);
create table if not exists Rating(
  Username varchar(20),
  PID int,
  Rate int(2),
  foreign key(PID) references Product(PID),
  foreign key(Username) references customeraccountinformation(Username),
  primary key(PID,Username)
);
create table if not exists Responsible(
  SSN int ,
  Phone1 numeric(15),
  Phone2 numeric(15),
  primary key(SSN),
  foreign key(SSN) references Employee(SSN)
);
create table if not exists Supporter(
  SSN int,
  primary key(SSN),
  foreign key(SSN) references Employee(SSN)
);
create table if not exists OnlineSupporter(
  SSN int,
  OnlineTime datetime,
  primary key(SSN, OnlineTime),
  foreign key(SSN) references supporter(SSN)
);
create table if not exists Driver(
  SSN int,
  Phone1 numeric(15),
  Phone2 numeric(15),
  Address varchar(30),
  primary key(SSN),
  foreign key(SSN) references Employee(SSN)
);

CREATE TABLE IF NOT EXISTS driverLog(
  old_SSN int,
  new_SSN int,
  old_Phone1 numeric(15),
  new_Phone1 numeric(15),
  old_Phone2 numeric(15),
  new_Phone2 numeric(15),
  old_Address varchar(30),
  new_Address varchar(30),
  operation VARCHAR(14),
  changedate DATETIME
);

CREATE
TRIGGER `driver_trg_au` AFTER UPDATE ON `driver`
FOR EACH ROW BEGIN
  insert into driverLog values(
    old.ssn,
    new.ssn,
    old.phone1,
    new.phone1,
    old.phone2,
    new.phone2,
    old.Address,
    new.Address,
    now(),
    'update'
  );
END;

CREATE
TRIGGER `driver_trg_au` AFTER UPDATE ON `driver`
FOR EACH ROW BEGIN
  insert into driverLog values(
    old.ssn,
    new.ssn,
    old.phone1,
    new.phone1,
    old.phone2,
    new.phone2,
    old.Address,
    new.Address,
    now(),
    'update'
  );
END;

CREATE
TRIGGER `driver_trg_ai` AFTER INSERT ON `driver`
FOR EACH ROW BEGIN
  insert into driverLog values(
    null,
    new.ssn,
    null,
    new.phone1,
    null,
    new.phone2,
    null,
    new.Address,
    now(),
    'insert'
  );
END;

CREATE
TRIGGER `driver_trg_ad` AFTER delete ON `driver`
FOR EACH ROW BEGIN
  insert into driverLog values(
    old.ssn,
    null,
    old.phone1,
    null,
    old.phone2,
    null,
    old.Address,
    null,
    now(),
    'delete'
  );
END;

create table if not exists Car(
  CarTag varchar(10),
  CarType varchar(10),
  DriverID int(10) not null,
  primary key(CarTag),
  foreign key(DriverID) references Driver(SSN)
);
CREATE TABLE IF NOT EXISTS carLog(
  Old_CarTAg VARCHAR(10),
  New_CarTAg VARCHAR(10),
  Old_CarType VARCHAR(10),
  New_CarType VARCHAR(10),
  Old_driverId INT(10),
  New_driverId INT(10),
  operation VARCHAR(15),
  changedTime DATETIME
);
DROP TRIGGER IF EXISTS car_trg_au;
CREATE TRIGGER car_trg_au AFTER UPDATE
  ON car
  FOR EACH ROW
  BEGIN
    INSERT INTO carLog  VALUES (
      old.CarTag,
      new.CarTag,
      old.CarType,
      new.CarType,
      old.DriverID,
      new.DriverID,
      'update',
      now()
    );
  END;

DROP TRIGGER IF EXISTS car_trg_ai;
CREATE TRIGGER car_trg_ai AFTER UPDATE
  ON car
FOR EACH ROW
  BEGIN
    INSERT INTO carLog  VALUES (
      null,
      new.CarTag,
      null,
      new.CarType,
      null,
      new.DriverID,
      'insert',
      now()
    );
  END;

DROP TRIGGER IF EXISTS car_trg_ad;
CREATE TRIGGER car_trg_ad AFTER UPDATE
  ON car
FOR EACH ROW
  BEGIN
    INSERT INTO carLog  VALUES (
      old.CarTag,
      new.CarTag,
      old.CarType,
      new.CarType,
      old.DriverID,
      new.DriverID,
      'delete',
      now()
    );
  END;


create table if not exists Customer(
  SupportSSN int,
  CustomerID int not null AUTO_INCREMENT,
  ID int ,
  primary key(CustomerID),
  foreign key(SupportSSN) references Supporter(SSN),
  foreign key(ID) references Person(ID)
);

CREATE TABLE IF NOT EXISTS CustomerLog(

  Old_SupportSSn int,
  New_SupportSSn int,
  Old_CustomerId int,
  New_CustomerId int,
  Old_id int,
  New_id int,
  operation VARCHAR(15),
  changedTime DATETIME
);

DROP TRIGGER IF EXISTS customer_trg_au;
CREATE TRIGGER customer_trg_au AFTER UPDATE
  ON customer
FOR EACH ROW
  BEGIN
    INSERT INTO carLog  VALUES (
      old.SupportSSn,
      new.SupportSSn,
      old.CustomerId,
      new.CustomerId,
      old.id,
      new.id,
      'update',
      now()
    );
  END;

DROP TRIGGER IF EXISTS customer_trg_ai;
CREATE TRIGGER customer_trg_ai AFTER insert
  ON customer
FOR EACH ROW
  BEGIN
    INSERT INTO carLog  VALUES (
      old.SupportSSn,
      new.SupportSSn,
      old.CustomerId,
      new.CustomerId,
      old.id,
      new.id,
      'insert',
      now()
    );
  END;

DROP TRIGGER IF EXISTS customer_trg_ad;
CREATE TRIGGER customer_trg_au AFTER delete
  ON customer
FOR EACH ROW
  BEGIN
    INSERT INTO carLog  VALUES (
      old.SupportSSn,
      null,
      old.CustomerId,
      null,
      old.id,
      null,
      'delete',
      now()
    );
  END;




create table if not exists CustomerAccount(
  CustomerID int,
  Username varchar(20) ,
  primary key (Username),
  foreign key(CustomerID) references Customer(CustomerID)
);

CREATE TABLE IF NOT EXISTS CustomerAccountLog(

  old_customerID int,
  new_customerID int,
  old_username VARCHAR(20),
  new_username VARCHAR(20),
  operation VARCHAR(20),
  changedDate DATETIME

);

DROP TRIGGER IF EXISTS customerAccount_trg_au;
CREATE TRIGGER customerAccount_trg_au AFTER update
  ON customerAccount
FOR EACH ROW
  BEGIN
    INSERT INTO customerAccountLog  VALUES (
      old.customerID,
      null,
      old.username,
      null,
      'update',
      now()
    );
  END;

CREATE TRIGGER customerAccount_trg_ai AFTER insert
  ON customerAccount
FOR EACH ROW
  BEGIN
    INSERT INTO customerAccountLog  VALUES (
      old.customerID,
      new.customerID,
      old.username,
      new.username,
      'update',
      now()
    );
  END;

CREATE TRIGGER customerAccount_trg_ad AFTER delete
  ON customerAccount
FOR EACH ROW
  BEGIN
    INSERT INTO customerAccountLog  VALUES (
      old.customerID,
      null,
      old.username,
      null,
      'delete',
      now()
    );
  END;

create table if not exists CustomerAccountInformation(
  Username varchar(20),
  Credit numeric(15,2),
  Phone1 numeric(15),
  Phone2 numeric(15),
  Address1 varchar(30),
  Address2 varchar(30),
  RegisterDate varchar(20),
  deletedAccount int default 0,
  primary key (Username),
  foreign key(Username) references CustomerAccount(Username)
);


CREATE TABLE IF NOT EXISTS CustomerAccountInformationLog(

  old_Username varchar(20),
  new_Username varchar(20),
  old_Credit numeric(15,2),
  new_Credit numeric(15,2),
  old_Phone1 numeric(15),
  new_Phone1 numeric(15),
  old_Phone2 numeric(15),
  new_Phone2 numeric(15),
  old_Address1 varchar(30),
  new_Address1 varchar(30),
  old_Address2 varchar(30),
  new_Address2 varchar(30),
  old_RegisterDate varchar(20),
  new_RegisterDate varchar(20),
  old_deletedAccount int,
  new_deletedAccount int,
  operation VARCHAR(20),
  changedDate DATETIME

);

DROP TRIGGER IF EXISTS customerAccountInformation_trg_au;
CREATE TRIGGER customerAccountInformation_trg_au AFTER update
  ON customerAccountInformation
FOR EACH ROW
  BEGIN
    INSERT INTO customerAccountInformationLog  VALUES (
      old.Username,
      new.Username,
      old.Credit ,
      new.Credit,
      old.Phone1,
      new.Phone1,
      old.Phone2,
      new.Phone2,
      old.Address1,
      new.Address1,
      old.Address2,
      new.Address2,
      old.RegisterDate,
      new.RegisterDate,
      old.deletedAccount,
      new.deletedAccount,
      'update',
      now()
    );
  END;


DROP TRIGGER IF EXISTS customerAccountInformation_trg_ai;
CREATE TRIGGER customerAccountInformation_trg_ai AFTER INSERT
  ON customerAccountInformation
FOR EACH ROW
  BEGIN
    INSERT INTO customerAccountInformationLog  VALUES (
      null,
      new.Username,
      null ,
      new.Credit,
      null,
      new.Phone1,
      null,
      new.Phone2,
      null,
      new.Address1,
      null,
      new.Address2,
      null,
      new.RegisterDate,
      null,
      new.deletedAccount,
      'update',
      now()
    );
  END;



DROP TRIGGER IF EXISTS customerAccountInformation_trg_ad;
CREATE TRIGGER customerAccountInformation_trg_ad AFTER delete
  ON customerAccountInformation
FOR EACH ROW
  BEGIN
    INSERT INTO customerAccountInformationLog  VALUES (
      old.Username,
      null,
      old.Credit ,
      null,
      old.Phone1,
      null,
      old.Phone2,
      null,
      old.Address1,
      null,
      old.Address2,
      null,
      old.RegisterDate,
      null,
      old.deletedAccount,
      null,
      'delete',
      now()
    );
  END;





create table if not exists Complain(
  ComplainID int not null AUTO_INCREMENT,
  ComplainText text,
  SSN int,
  CustomerID int ,
  SupportDate date,
  foreign key(SSN) references Supporter(SSN),
  foreign key(CustomerID) references Customer(CustomerID),
  primary key(ComplainID));

CREATE TABLE IF NOT EXISTS complainLog(
  Old_ComplainID int,
  New_ComplainID int,
  Old_complainText text,
  New_complainText text,
  Old_Ssn int,
  New_Ssn int,
  Old_CustomerID int,
  New_CustomerID int,
  Old_SupportDate date,
  New_SupportDate date,
  operation VARCHAR(15),
  updated_by VARCHAR(60),
  changedDate DATETIME
);

DROP TRIGGER IF EXISTS complain_trg_au;

create TRIGGER complain_trg_au AFTER update ON  complain
  FOR EACH ROW
    BEGIN
      INSERT INTO complainLog
      VALUES (
        old.ComplainID,
        new.ComplainID,
        old.ComplainText,
        new.ComplainText,
        old.ssn,
        new.SSN,
        old.CustomerID,
        new.CustomerID,
        old.SupportDate,
        new.SupportDate,
        'update',
        CURRENT_USER(),
        NOW()
      );
   END;

DROP TRIGGER IF EXISTS complain_trg_ai;

create TRIGGER complain_trg_ai AFTER INSERT ON  complain
FOR EACH ROW
  BEGIN
    INSERT INTO complainLog
    VALUES (
      null,
      new.ComplainID,
      null,
      new.ComplainText,
      null,
      new.SSN,
      null,
      new.CustomerID,
      null,
      new.SupportDate,
      'insert',
      CURRENT_USER(),
      NOW()
    );
  END;

DROP TRIGGER IF EXISTS complain_trg_ad;

create TRIGGER complain_trg_ad AFTER delete ON  complain
FOR EACH ROW
  BEGIN
    INSERT INTO complainLog
    VALUES (
      old.ComplainID,
      null,
      old.ComplainText,
      null,
      old.ssn,
      null,
      old.CustomerID,
      null,
      old.SupportDate,
      null,
      'delete',
      CURRENT_USER(),
      NOW()
    );
  END;


create table if not exists Introduce(
  ManagerID int ,
  ResponsibleID int,
  ResgisterNumber int,
  foreign key(ManagerID) references manager(SSN),
  foreign key(ResponsibleID) references responsible(SSN),
  foreign key(ResgisterNumber) references company(RegisterNumber),
  primary key(ManagerID,ResponsibleID,ResgisterNumber)
);
create table if not exists AddToCart(
  CartID int not null AUTO_INCREMENT,
  PID int not null,
  CustomerID int not null ,
  AddCount int,
  AddTime date,
  primary key(CartID,PID,CustomerID,AddTime),
  foreign key(PID) references Product(PID),
  foreign key(CustomerID) references Customer(CustomerID)
);
CREATE TABLE IF NOT EXISTS AddToCartLog(
  Old_CartID int,
  New_CartID int,
  Old_PID int,
  new_PID int,
  Old_CustomerID int,
  New_CustomerID int,
  Old_Addcount int,
  New_Addcount int,
  Old_AddTime date,
  new_AddTime date,
  operation VARCHAR(15),
  changeTime DATETIME
);

drop TRIGGER if EXISTS AddToCart_trg_ai;
create TRIGGER AddToCart_trg_ai after INSERT on AddToCart
FOR EACH ROW
  BEGIN
    INSERT INTO AddToCartLog VALUES (
      null,
      new.CartID,
      null,
      new.PID,
      null,
      new.CustomerID,
      null,
      new.AddCount,
      null,
      new.AddTime,
      'insert',
      now()
    );
  END;
drop TRIGGER if EXISTS AddToCart_trg_au;
create TRIGGER AddToCart_trg_au AFTER UPDATE ON AddToCart
FOR EACH ROW
  BEGIN
    INSERT INTO CompanyLog VALUES (
      old.CartID,
      new.CartID,
      old.PID,
      new.PID,
      old.CustomerID,
      new.CustomerID,
      old.AddCount,
      new.AddCount,
      old.AddTime,
      new.AddTime,
      'update',
      now()
    );
  END;
drop TRIGGER if EXISTS AddToCart_trg_ad;
create TRIGGER AddToCart_trg_ad AFTER UPDATE ON AddToCart
FOR EACH ROW
  BEGIN
    INSERT INTO AddToCartLog VALUES (
      old.CartID,
      NULL ,
      old.PID,
      NULL,
      old.CustomerID,
      NULL,
      old.AddCount,
      NULL,
      old.AddTime,
      NULL,
      'delete',
      now()
    );
  END;





create table if not exists Cart(
  CartID int not null ,
  DriverSSN int,
  Destination Text,
  DeliveryDate Date,
  PaymentationType varchar(20) default "online",
  foreign key(CartID) references addtocart(CartID),
  foreign key(DriverSSN) references Driver(SSN),
  primary key(CartID));
CREATE TABLE IF NOT EXISTS cartLog(
  Old_CartId int,
  new_CartId int,
  Old_DriverSSN int,
  new_DriverSSN int,
  Old_Destination TEXT,
  new_Destination TEXT,
  Old_paymentationType VARCHAR(20),
  new_paymentationType VARCHAR(20),
  operation VARCHAR(20),
  changedDate DATETIME

);
DROP TRIGGER IF EXISTS cart_trg_au;
create TRIGGER Cart_trg_au AFTER UPDATE ON Cart
FOR EACH ROW
  BEGIN
    INSERT INTO CartLog VALUES (
      old.CartId,
      new.CartId,
      old.DriverSSN,
      new.DriverSSN,
      old.Destination,
      new.Destination,
      old.paymentationType,
      new.paymentationType,
      'update',
      now()
    );
  END;

DROP TRIGGER IF EXISTS cart_trg_ai;
create TRIGGER Cart_trg_ai AFTER INSERT ON Cart
FOR EACH ROW
  BEGIN
    INSERT INTO CartLog VALUES (
      null,
      new.CartId,
      null,
      new.DriverSSN,
      null,
      new.Destination,
      null,
      new.paymentationType,
      'insert',
      now()
    );
  END;

DROP TRIGGER IF EXISTS cart_trg_ad;
create TRIGGER Cart_trg_ad AFTER delete ON Cart
FOR EACH ROW
  BEGIN
    INSERT INTO CartLog VALUES (
      old.CartId,
      null,
      old.DriverSSN,
      null,
      old.Destination,
      null,
      old.paymentationType,
      null,
      'delete',
      now()
    );
  END;


CREATE TABLE HomeProductLog (
  old_pid int,
  new_pid int,
  old_BuildDate date,
  new_BuildDate date,
  updated_on DATETIME,
  operation char(30)

);
CREATE
TRIGGER `HomeProduct_trg_ai` AFTER INSERT ON `HomeProduct`
FOR EACH ROW BEGIN
  insert into HomeProductLog values(
    null,
    new.PID,
    null,
    new.BuildDate,
    now(),
    'insert'
  );
END;

CREATE
TRIGGER `HomeProduct_trg_au` AFTER UPDATE ON `HomeProduct`
FOR EACH ROW BEGIN
  insert into HomeProductLog values(
    old.PID,
    new.PID,
    old.BuildDate,
    new.BuildDate,
    now(),
    'update'
  );
END;

CREATE
TRIGGER `HomeProduct_trg_ad` AFTER DELETE ON `HomeProduct`
FOR EACH ROW BEGIN
  insert into HomeProductLog values(
    old.PID,
    NULL ,
    old.BuildDate,
    NULL,
    now(),
    'delete'
  );
END;
create table if not exists Product(
  PID int not null AUTO_INCREMENT,
  ProductName varchar(20) not null,
  Price numeric(8,2),
  Discount int(3),
  Stock int(5),
  RegisterNumber int(5),
  primary key (PID),
  foreign key (RegisterNumber) references Company(RegisterNumber)
);

CREATE TABLE IF NOT EXISTS ProductLog (
  Old_PID INT,
  New_PID INT,
  Old_ProductName VARCHAR(20),
  New_ProductName VARCHAR(20),
  Old_Price NUMERIC(8 , 2 ),
  New_Price NUMERIC(8 , 2 ),
  Old_Discount INT(3),
  New_Discount INT(3),
  Old_Stock INT(5),
  New_Stock INT(5),
  OLD_RegisterNumber int(5),
  NEW_RegisterNumber int(5),
  changedTime datetime,
  operation varchar(15)
);
DROP TRIGGER IF EXISTS  `product_trg_ai`;
CREATE
TRIGGER `product_trg_ai` AFTER INSERT ON `product`
FOR EACH ROW

  BEGIN
    insert into ProductLog values(
      null,
      new.PID,
      null,
      new.ProductName,
      null,
      new.Price,
      null,
      new.Discount,
      null,
      new.Stock,
      null,
      new.RegisterNumber,
      now(),
      'insert'
    );
  END;
CREATE
TRIGGER `product_trg_au` AFTER UPDATE ON `product`
FOR EACH ROW

  BEGIN
    insert into ProductLog values(
      old.PID,
      new.PID,
      old.ProductName,
      new.ProductName,
      old.Price,
      new.Price,
      old.Discount,
      new.Discount,
      old.Stock,
      new.Stock,
      old.RegisterNumber,
      new.RegisterNumber,
      now(),
      'update'
    );
  END;
CREATE
TRIGGER `product_trg_ad` AFTER DELETE ON `product`
FOR EACH ROW

  BEGIN
    insert into ProductLog values(
      old.PID,
      NULL ,
      old.ProductName,
      NULL,
      old.Price,
      NULL,
      old.Discount,
      NULL,
      old.Stock,
      NULL,
      old.RegisterNumber,
      NULL,
      now(),
      'delete'
    );
  END;
create table if not exists SportProductLog(
  OLD_pID int ,
  NEW_pID int ,
  OLD_Color varchar(10),
  NEW_Color varchar(10),
  changedTime DATETIME ,
  operation CHAR(15)
);
CREATE
TRIGGER `SportProduct_trg_ai` AFTER INSERT ON `SportProduct`
FOR EACH ROW BEGIN
  insert into SportProductLog values(
    null,
    new.pID,
    null,
    new.Color,
    now(),
    'insert'
  );
END;
CREATE
TRIGGER `SportProduct_trg_au` AFTER UPDATE ON `SportProduct`
FOR EACH ROW BEGIN
  insert into SportProductLog values(
    old.PID,
    new.pID,
    old.Color,
    new.Color,
    now(),
    'update'
  );
END;
CREATE
TRIGGER `SportProduct_trg_ad` AFTER DELETE ON `SportProduct`
FOR EACH ROW BEGIN
  insert into SportProductLog values(
    old.PID,
    NULL ,
    old.Color,
    NULL,
    now(),
    'delete'
  );
END;
create table if not exists Person(
  ID int not null AUTO_INCREMENT,
  FullName varchar(20),
  primary key (ID)
);

create table if not exists PersonLog(
  OLD_ID int ,
  NEW_ID int ,
  OLD_FullName varchar(20),
  NEW_FullName varchar(20),
  changedTime DATETIME ,
  operation CHAR(15)
);


CREATE
TRIGGER `person_trg_ai` AFTER INSERT ON `person`
FOR EACH ROW BEGIN
  insert into personLog values(
    null,
    new.ID,
    null,
    new.FullName,
    now(),
    'insert'
  );
END;

CREATE
TRIGGER `person_trg_au` AFTER UPDATE ON `person`
FOR EACH ROW BEGIN
  insert into personLog values(
    old.ID,
    new.ID,
    old.FullName,
    new.FullName,
    now(),
    'update'
  );
END;
CREATE
TRIGGER `person_trg_ad` AFTER DELETE ON `person`
FOR EACH ROW BEGIN
  insert into personLog values(
    old.ID,
    NULL ,
    old.FullName,
    NULL,
    now(),
    'delete'
  );
END;
CREATE TABLE ManagerLog (
  old_SSN int,
  new_SSN int,
  operation char(30),
  changedTime DATETIME
);
CREATE TRIGGER Manager_Trigger_AI AFTER INSERT
  ON Manager
FOR EACH ROW
  BEGIN
    INSERT INTO ManagerLog
    VALUES (
      NULL,
      NEW.SSN,
      'insert',
      NOW()
    );
  END;
CREATE TRIGGER Manager_Trigger_AU AFTER UPDATE
  ON Manager
FOR EACH ROW
  BEGIN
    INSERT INTO ManagerLog
    VALUES (
      old.SSN,
      NEW.SSN,
      'update',
      NOW()
    );
  END;
CREATE TRIGGER Manager_Trigger_AD AFTER DELETE
  ON Manager
FOR EACH ROW
  BEGIN
    INSERT INTO ManagerLog
    VALUES (
      old.SSN,
      NULL ,
      'delete',
      NOW()
    );
  END;
CREATE TABLE RatingLog (
  old_Username VARCHAR(20),
  new_Username VARCHAR(20),
  old_pid INT,
  new_pid INT,
  old_rate INT(2),
  new_rate INT(2),
  operation CHAR(30),
  updated_on DATETIME
);
CREATE TRIGGER Rating_trg_ai AFTER INSERT
  ON Rating
FOR EACH ROW
  BEGIN
    INSERT INTO RatingLog
    VALUES (
      NULL,
      NEW.Username,
      NULL,
      NEW.PID,
      NULL,
      NEW.Rate,
      'insert',
      NOW()
    );
  END;

CREATE TRIGGER Rating_trg_au AFTER UPDATE
  ON Rating
FOR EACH ROW
  BEGIN
    INSERT INTO RatingLog
    VALUES (
      old.Username,
      NEW.Username,
      old.PID,
      NEW.PID,
      old.Rate,
      NEW.Rate,
      'update',
      NOW()
    );
  END;
CREATE TRIGGER Rating_trg_ad AFTER DELETE
  ON Rating
FOR EACH ROW
  BEGIN
    INSERT INTO RatingLog
    VALUES (
      old.Username,
      NULL ,
      old.PID,
      NULL,
      old.Rate,
      NULL,
      'delete',
      NOW()
    );
  END;
CREATE TABLE ResponsibleLog (
  old_SSN int,
  new_SSN int,
  old_Phone1 numeric(15),
  new_Phone1 numeric(15),
  old_Phone2 numeric(15),
  new_Phone2 numeric(15),
  operation CHAR(30),
  updated_on DATETIME
);

CREATE TRIGGER Responsible_trg_ai AFTER INSERT
  ON Responsible
FOR EACH ROW
  BEGIN
    INSERT INTO ResponsibleLog
    VALUES (
      NULL,
      NEW.ssn,
      NULL,
      NEW.Phone1,
      NULL,
      NEW.Phone2,
      'insert',
      NOW()
    );
  END;

CREATE TRIGGER Responsible_trg_au AFTER UPDATE
  ON Responsible
FOR EACH ROW
  BEGIN
    INSERT INTO ResponsibleLog
    VALUES (
      old.ssn,
      NEW.ssn,
      old.Phone1,
      NEW.phone1,
      old.phone2,
      NEW.phone2,
      'update',
      NOW()
    );
  END;
CREATE TRIGGER Responsible_trg_ad AFTER DELETE
  ON Responsible
FOR EACH ROW
  BEGIN
    INSERT INTO ResponsibleLog
    VALUES (
      old.ssn,
      NULL ,
      old.Phone1,
      NULL,
      old.phone2,
      NULL,
      'delete',
      NOW()
    );
  END;
CREATE TABLE SupporterLog (
  old_SSN int,
  new_SSN int,
  operation CHAR(30),
  updated_on DATETIME
);
CREATE TRIGGER Supporter_Trigger_AI AFTER INSERT
  ON Supporter
FOR EACH ROW
  BEGIN
    INSERT INTO SupporterLog
    VALUES (
      NULL,
      NEW.SSN,
      'insert',
      NOW()
    );
  END;
CREATE TRIGGER Supporter_Trigger_Au AFTER UPDATE
  ON Supporter
FOR EACH ROW
  BEGIN
    INSERT INTO SupporterLog
    VALUES (
      old.SSN,
      NEW.SSN,
      'update',
      NOW()
    );
  END;
CREATE TRIGGER Supporter_Trigger_Ad AFTER DELETE
  ON Supporter
FOR EACH ROW
  BEGIN
    INSERT INTO SupporterLog
    VALUES (
      old.SSN,
      null,
      'delete',
      NOW()
    );
  END;




CREATE TABLE OnlineSupporterLog (
  old_SSN int,
  new_SSN int,
  old_OnlineTime datetime,
  new_OnlineTime datetime,
  operation CHAR(30),
  updated_on DATETIME
);

CREATE TRIGGER OnlineSupporterLog_Trigger_AI AFTER INSERT
  ON OnlineSupporter
FOR EACH ROW
  BEGIN
    INSERT INTO OnlineSupporterLog
    VALUES (
      NULL,
      NEW.SSN,
      NULL,
      NEW.OnlineTime,
      'insert',
      NOW()
    );
  END;
CREATE TRIGGER OnlineSupporterLog_Trigger_AU AFTER UPDATE
  ON OnlineSupporter
FOR EACH ROW
  BEGIN
    INSERT INTO OnlineSupporterLog
    VALUES (
      old.SSN,
      NEW.SSN,
      old.OnlineTime,
      NEW.OnlineTime,
      'update',
      NOW()
    );
  END;
CREATE TRIGGER OnlineSupporterLog_Trigger_AD AFTER DELETE
  ON OnlineSupporter
FOR EACH ROW
  BEGIN
    INSERT INTO OnlineSupporterLog
    VALUES (
      old.SSN,
      NULL ,
      old.OnlineTime,
      NULL ,
      'delete',
      NOW()
    );
  END;
CREATE TABLE IntroduceLog (
  old_ManagerID int,
  new_ManagerID int,
  old_ResponsibleID INT,
  new_ResponsibleID INT,
  old_ResgisterNumber INT,
  new_ResgisterNumber INT,
  operation char(30),
  changedTime DATETIME
);

CREATE TRIGGER Introduce_Trigger_AI AFTER INSERT
  ON Introduce
FOR EACH ROW
  BEGIN
    INSERT INTO IntroduceLog
    VALUES (
      NULL,
      NEW.ManagerID,
      NULL,
      NEW.ResponsibleID,
      NULL,
      NEW.ResgisterNumber,
      'insert',
      NOW()
    );
  END;

CREATE TRIGGER Introduce_Trigger_AU AFTER UPDATE
  ON Introduce
FOR EACH ROW
  BEGIN
    INSERT INTO IntroduceLog
    VALUES (
      old.ManagerID,
      NEW.ManagerID,
      old.ResponsibleID,
      NEW.ResponsibleID,
      old.ResgisterNumber,
      NEW.ResgisterNumber,
      'update',
      NOW()
    );
  END;
CREATE TRIGGER Introduce_Trigger_AD AFTER DELETE
  ON Introduce
FOR EACH ROW
  BEGIN
    INSERT INTO IntroduceLog
    VALUES (
      old.ManagerID,
      NULL,
      old.ResponsibleID,
      NULL,
      old.ResgisterNumber,
      NULL,
      'delete',
      NOW()
    );
  END;





/*
# Soale 5.1
(SELECT Count(prod.PID) as Count , sum(prod.Price) as PriceSum, 'SportProduct' as ProductType
from addtocart addto, Product prod , SportProduct sport
  where addto.PID = sport.PID and sport.PID = prod.PID)
  union
(SELECT Count(prod.PID) as Count , sum(prod.Price) as PriceSum, 'DigitalProduct' as ProductType
from addtocart addto, Product prod , DigitalProduct Digit
  where addto.PID = Digit.PID and Digit.PID = prod.PID)
  union
(SELECT Count(prod.PID) as Count , sum(prod.Price) as PriceSum, 'HomeProduct' as ProductType
from addtocart addto, Product prod , HomeProduct home
  where addto.PID = home.PID and home.PID = prod.PID);
#soale 5.2 :
Select p.FullName , info.RegisterDate from customeraccountinformation ,
customeraccount as customAcc, customeraccountinformation as info , customer cust ,person p
  where   customAcc.Username = info.Username and cust.CustomerID = customAcc.CustomerID and cust.ID = p.ID;
#soale 5.3
Select p.FullName , customAcc.Username from
customeraccount as customAcc, customer cust ,person p , employee e
where customAcc.CustomerID = cust.CustomerID and cust.ID = p.ID and p.ID = e.ID;
#soale 5.4
select c.CartID, addto.AddTime, c.Destination, c.DeliveryDate from
addtocart addto , cart c where
  addto.CartID = c.CartID; #dar inja mitavan driverSSN ra lahaaz nemood
#5.5
select * from customeraccountinformation where deletedAccount = 1;
#5.6
select AVG(rt.rate) , sp.PID from
  sportproduct sp, rating rt where
    sp.PID = rt.PID
      group by (rt.PID);
#5.7
###############################################


#5.8
select cart.CartID , addtocart.AddTime , person.FullName, customer.CustomerID from
  addtocart, cart, customer, person where
    addtocart.CartID = cart.CartID and addtocart.CustomerID = customer.CustomerID and customer.ID = person.ID
      and cart.PaymentationType = 'credit';
#5.9
select * from complain ;
#5.10


(select "Sport" as ProductType ,product.ProductName , product.Discount , product.Discount , product.PID , product.Price - product.Discount  as newPrice from
  product , sportproduct where sportproduct.PID = product.PID)
  union
(select "Home"as ProductType,product.ProductName , product.Discount , product.Discount , product.PID , product.Price - product.Discount as newPrice from
  product, homeproduct where homeproduct.PID = product.PID)
  union
(select "Digital"as ProductType,product.ProductName , product.Discount , product.Discount , product.PID , product.Price - product.Discount as newPrice from
  product,digitalproduct where digitalproduct.PID = product.PID);

#5.11
select * from onlinesupporter where
  DATEDIFF(now() , onlinesupporter.OnlineTime) < 30;
#5.12
select sum((product.price - product.discount)*addtocart.AddCount) from  product, addtocart where
  product.PID = addtocart.PID and DATEDIFF(now() , addtocart.AddTime) < 60;
#5.13
select (sum( (product.price-product.discount) *addtocart.AddCount ) )* 0.09 as tax, addtocart.cartID,
  (product.price-product.discount) *addtocart.AddCount
  from
  addtocart , product where product.PID = addtocart.PID
      group by (addtocart.CartID);
#5.14'

#5.15

(select person.FullName, "Bi eshteraak" as NoeEshteraak, product.PID from
  person , customer, addtocart,customeraccount, product where
    customer.ID = person.ID and addtocart.CustomerID = customer.CustomerID
          and product.pid = addtocart.PID   and customer.CustomerID not in (select CustomerID from customeraccount))
union
  (select person.FullName, "Ba eshteraak" as NoeEshteraak , product.PID from
  person , customer, addtocart,customeraccount, product where
    customer.ID = person.ID and addtocart.CustomerID = customer.CustomerID
          and product.pid = addtocart.PID   and customer.CustomerID and customer.CustomerID in (select CustomerID from customeraccount));

#5.16
select product.PID , product.productname , product.stock from product, homeproduct where
  product.PID = homeproduct.PID ;
#5.17
select  *
  from employee e ,person p,customer c,addtocart a
  where e.ID=p.id and p.ID=c.ID and c.CustomerID=a.CustomerID
;
*/


