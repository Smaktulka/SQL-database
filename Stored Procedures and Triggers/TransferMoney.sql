
CREATE PROCEDURE TransferMoney @AccountID INT, @CardID INT, @money FLOAT
AS 

SELECT * FROM CustomerAccount
JOIN Customer ON CustomerAccount.CustomerID = Customer.ID
JOIN Cards ON Cards.AccountID =  CustomerAccount.ID 
WHERE CustomerAccount.ID = @AccountID

DECLARE @AvailableMoney AS FLOAT = (SELECT AmountOfMoney - 
(SELECT SUM(AmountOfMoneyOnCard) FROM Cards WHERE Cards.AccountID = CustomerAccount.ID)
FROM CustomerAccount WHERE CustomerAccount.ID = @AccountID)

IF NOT EXISTS(SELECT AmountOfMoneyOnCard FROM Cards WHERE Cards.ID = @CardID 
and Cards.AccountID = @AccountID)
BEGIN 
	RAISERROR('Card with such id does not exist.', 1, 1)
	RETURN
END

IF @AvailableMoney < @money
BEGIN 
	RAISERROR('Not enough money on customer account.', 1, 1)
	RETURN
END


BEGIN TRY
BEGIN TRANSACTION TransferingMoney

UPDATE Cards
SET AmountOfMoneyOnCard += @money
WHERE Cards.ID = @CardID

SELECT * FROM CustomerAccount
JOIN Customer ON CustomerAccount.CustomerID = Customer.ID
JOIN Cards ON Cards.AccountID =  CustomerAccount.ID 
WHERE CustomerAccount.ID = @AccountID

COMMIT
	PRINT 'Transaction is commited'
END TRY 
BEGIN CATCH
	ROLLBACK TRANSACTION
	PRINT 'Transaction is rollbacked' 
END CATCH
GO 

EXEC TransferMoney 1, 3, 100