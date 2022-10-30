CREATE PROCEDURE AvailableMoney
AS 
SELECT * FROM CustomerAccount
JOIN Cards ON CustomerAccount.ID = Cards.AccountID

SELECT CustomerID, BankID, FirstName, LastName, AmountOfMoneyOnCard, AmountOfMoney,
(AmountOfMoney - (SELECT SUM(AmountOfMoneyOnCard) 
FROM Cards WHERE Cards.AccountID = CustomerAccount.ID))
as Available FROM CustomerAccount
JOIN Customer ON Customer.ID = CustomerAccount.CustomerID 
JOIN Cards ON Cards.AccountID = CustomerAccount.ID
WHERE EXISTS (SELECT * FROM Cards WHERE Cards.AccountID = CustomerAccount.ID)

GO

EXEC AvailableMoney;