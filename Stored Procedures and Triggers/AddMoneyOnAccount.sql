DROP PROCEDURE AddMoneyOnAcc 

CREATE PROCEDURE AddMoneyOnAcc @id int
AS
SELECT * FROM CustomerAccount
RIGHT JOIN Customer ON Customer.ID = CustomerAccount.CustomerID 
WHERE CustomerID IS NOT NULL

BEGIN TRY 
IF NOT EXISTS (SELECT * FROM SocialStatus
WHERE (ID = @id))
BEGIN
RAISERROR ('Social status is not founded', 1, 1)
RETURN
END
END TRY 
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000)
	DECLARE @ErrorSeverity INT
SELECT 
	@ErrorMessage = ERROR_MESSAGE(),
	@ErrorSeverity = ERROR_SEVERITY();
END CATCH

BEGIN TRY 
IF NOT EXISTS (SELECT * FROM Cards
WHERE (SocialStatusOfCustomer = @id))
BEGIN
RAISERROR ('There are no cards with such social status', 1, 1)
RETURN
END
END TRY 
BEGIN CATCH
	DECLARE @ErrorMessage2 NVARCHAR(4000)
	DECLARE @ErrorSeverity2 INT
SELECT 
	@ErrorMessage2 = ERROR_MESSAGE(),
	@ErrorSeverity2 = ERROR_SEVERITY();
END CATCH

UPDATE CustomerAccount 
SET	AmountOfMoney += 10
FROM CustomerAccount
WHERE CustomerAccount.CustomerID IN (SELECT ID FROM Customer WHERE Customer.SocialStatus = @id)

SELECT * FROM Customer
JOIN CustomerAccount ON CustomerAccount.CustomerID = Customer.ID
WHERE Customer.SocialStatus = @id

GO

EXEC AddMoneyOnAcc 1;