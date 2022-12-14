CREATE DATABASE FinalBank

USE FinalBank
CREATE TABLE Bank
(
	ID INT PRIMARY KEY IDENTITY(1, 1),
	NameOfBank NVARCHAR(30) NOT NULL,
	City NVARCHAR(30) NOT NULL
)

CREATE TABLE SocialStatus
(
	ID INT PRIMARY KEY IDENTITY(1, 1),
	NameOfStatus NVARCHAR(30) NOT NULL
)

CREATE TABLE Customer
(
	ID INT PRIMARY KEY IDENTITY(1, 1),
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	SocialStatus INT NOT NULL,
	FOREIGN KEY(SocialStatus) REFERENCES SocialStatus(ID)
)

CREATE TABLE CustomerAccount
(
	ID INT PRIMARY KEY IDENTITY(1, 1),
	CustomerID INT NOT NULL,
	BankID INT NOT NULL,
	AmountOfMoney FLOAT NOT NULL CHECK(AmountofMoney >= 0),
	FOREIGN KEY(CustomerID) REFERENCES Customer(ID),
	FOREIGN KEY(BankID) REFERENCES Bank(ID)
)

CREATE TABLE Cards
(
	ID INT IDENTITY(1, 1),
	AccountID INT NOT NULL,
	SocialStatusOfCustomer INT NOT NULL,
	AmountOfMoneyOnCard FLOAT NOT NULL CHECK(AmountOfMoneyOnCard >= 0),
	FOREIGN KEY(AccountID) REFERENCES CustomerAccount(ID),
)