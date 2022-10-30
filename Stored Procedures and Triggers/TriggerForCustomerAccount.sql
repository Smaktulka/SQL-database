DROP TRIGGER CheckMoneyOnCardAndAcc 
CREATE TRIGGER CheckMoneyOnCardAndAcc 
ON CustomerAccount
AFTER INSERT, UPDATE 
AS 

DECLARE @AmountOfMoney AS FLOAT 
SELECT @AmountOfMoney = inserted.AmountOfMoney FROM inserted
DECLARE @AccountID AS INT = (SELECT ID FROM inserted)
DECLARE @CustomerID AS INT
SELECT @CustomerID = inserted.CustomerID FROM inserted
DECLARE @BankID AS INT
SELECT @BankID = inserted.BankID FROM inserted

SELECT * FROM inserted

IF EXISTS (SELECT * FROM CustomerAccount WHERE CustomerAccount.BankID = @BankID 
and CustomerAccount.CustomerID = @CustomerID and CustomerAccount.ID != @AccountID)
BEGIN
RAISERROR ('The customer already has an account with this bank.', 1, 1)
DELETE CustomerAccount
WHERE CustomerAccount.ID = @AccountID
RETURN 
END

IF NOT EXISTS(SELECT AmountOfMoneyOnCard FROM Cards WHERE Cards.AccountID = @AccountID)
BEGIN
RAISERROR ('This Customer account do not have any cards.', 1, 1)
RETURN
END


DECLARE @AmountOfMoneyOnCards AS FLOAT = (SELECT SUM(AmountOfMoneyOnCard) FROM Cards
WHERE Cards.AccountID = @AccountID)

IF @AmountOfMoneyOnCards > @AmountOfMoney
BEGIN
UPDATE CustomerAccount
SET AmountOfMoney = @AmountOfMoneyOnCards
WHERE CustomerAccount.ID = @AccountID
PRINT 'Amount of money on card is set to sum of money on cards.'
END
