
USE FinalBank

INSERT Bank VALUES
(
	'Tinkoff', 'Brest'
)

INSERT Bank VALUES
(
	'BelinvestBank', 'Brest'
)

INSERT Bank VALUES
(
	'Tinkoff', 'Brest'
)

INSERT Bank VALUES 
(
	'BelinvestBank', 'Minsk'
)

INSERT Bank VALUES
(
	'Tinkoff', 'Minsk'
)

SELECT * FROM Bank

--Output table with banks in certain city
SELECT NameOfBank, City FROM Bank
GROUP BY City, NameOfBank
HAVING City = 'Brest'

--SocialStatus INSERTS
INSERT SocialStatus VALUES
(
	'Belarusian'
)

INSERT SocialStatus VALUES
(
	'Ukrainian'
)

INSERT SocialStatus VALUES
(
	'Russian'
)

INSERT SocialStatus VALUES
(
	'Japanese'
)

INSERT SocialStatus VALUES
(
	'Chinese'
)

SELECT * FROM SocialStatus

--Customer INSERTS
INSERT Customer VALUES 
(
	'Valia', 'Karotkaia', 1
)

INSERT Customer VALUES 
(
	'Wo', 'Kong', 5
)

INSERT Customer VALUES
(
	'Xi', 'Pi', 5
)

INSERT Customer VALUES 
(
	'Mikola', 'Mirny', 1
)

INSERT Customer VALUES
(
	'Naruto', 'Uchiha', 4
)

SELECT * FROM Customer

--CustomerAccount INSERTS

INSERT CustomerAccount VALUES
(
	1, 1, 1000
)

INSERT CustomerAccount VALUES
(
	2, 1, 1500
)

INSERT CustomerAccount VALUES
(
	3, 2, 1500
)

INSERT CustomerAccount VALUES
(
	4, 5, 1000
)

INSERT CustomerAccount VALUES
(
	5, 3, 2000
)

SELECT * FROM CustomerAccount
JOIN Customer ON Customer.ID = CustomerAccount.CustomerID

--Cards INSERTS

INSERT Cards VALUES
(
	1, 1, 100
)

INSERT Cards VALUES
(
	1, 1, 100
)

INSERT Cards VALUES
(
	2, 5, 200
)

INSERT Cards VALUES
(
	2, 5, 200
)

INSERT Cards VALUES 
(
	4, 1, 100
)

INSERT Cards VALUES
(
	5, 4, 300
)

SELECT * FROM Cards

--Output table with cards, bank, customer and money on card
SELECT FirstName, LastName, AmountOfMoneyOnCard, NameOfBank FROM Cards
JOIN Customer ON Customer.ID = (SELECT CustomerID FROM CustomerAccount 
WHERE CustomerAccount.ID = Cards.AccountID)
JOIN Bank ON Bank.ID = (SELECT BankID FROM CustomerAccount 
WHERE CustomerAccount.ID = Cards.AccountID)

--Output customer account where account's money do not equal to sum of money on account's cards
--show how much is available 
SELECT (AmountOfMoney - (SELECT SUM(AmountOfMoneyOnCard) 
FROM Cards WHERE Cards.AccountID = CustomerAccount.ID))
as Available, CustomerID, BankID, FirstName, LastName FROM CustomerAccount
JOIN Customer ON Customer.ID = CustomerAccount.CustomerID 
WHERE EXISTS (SELECT * FROM Cards WHERE Cards.AccountID = CustomerAccount.ID)


--Table with count of cards for social status (GROUP BY)
SELECT NameOfStatus, SocialStatusOfCustomer, Count(*) as TotalCountOfCards FROM Cards 
JOIN SocialStatus ON SocialStatus.ID = SocialStatusOfCustomer
GROUP BY SocialStatusOfCustomer, NameOfStatus

--Table with count of cards for social status(subquery)
SELECT NameOfStatus, 
(SELECT Count(*) FROM Cards WHERE Cards.SocialStatusOfCustomer = SocialStatus.ID) as TotalCountOfCards
FROM SocialStatus

--PROC to add 10$ for customer accounts with specific social status
EXEC AddMoneyOnAcc 1;

--PROC to show available money
EXEC AvailableMoney;

--PROC to transfer money to card
EXEC TransferMoney 2, 1, 300;


INSERT Cards VALUES
(
	13, 4, 10
)



--SELECT * FROM CustomerAccount
--UPDATE CustomerAccount
--SET AmountOfMoney = 0
--WHERE CustomerAccount.ID = 15

--UPDATE Cards
--SET AmountOfMoneyOnCard = 10
--WHERE Cards.AccountID = 15

--INSERT Cards VALUES
--(
--	15, 4, 10
--)

--INSERT CustomerAccount VALUES
--(
--	5, 2, 1
--)


