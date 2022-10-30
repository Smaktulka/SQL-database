CREATE TRIGGER CheckMoney_On_Cards
ON Cards 
AFTER INSERT, UPDATE
AS 
DECLARE @AmountOfMoneyOnCard AS FLOAT
SELECT @AmountOfMoneyOnCard = inserted.AmountOfMoneyOnCard FROM inserted
DECLARE @AccountID AS INT
SELECT @AccountID = inserted.AccountID FROM inserted
DECLARE @CardID AS INT = (SELECT ID FROM inserted)

SELECT * FROM inserted

DECLARE @AmountOfMoneyOnAcc AS FLOAT
SELECT @AmountOfMoneyOnAcc = CustomerAccount.AmountOfMoney FROM CustomerAccount 
WHERE CustomerAccount.ID = @AccountID

DECLARE @SumOfMoneyOnCards AS FLOAT
SELECT @SumOfMoneyOnCards = SUM(AmountOfMoneyOnCard) FROM Cards 
WHERE Cards.AccountID = @AccountID

IF @SumOfMoneyOnCards > @AmountOfMoneyOnAcc
BEGIN
UPDATE Cards
SET AmountOfMoneyOnCard = 0
WHERE Cards.ID = @CardID
PRINT 'Amount of money on card that you have inputted is changed to 0'
END