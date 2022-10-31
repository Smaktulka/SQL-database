-- 1 task
USE fridge
SELECT * FROM Fridges
INNER JOIN FridgeModels On Fridges.ModelId = FridgeModels.FridgeModelId
INNER JOIN FridgeProducts On FridgeProducts.FridgeId = Fridges.FridgeId
WHERE LEFT(FridgeModels.Name, 1) = 'A'


--2 task
SELECT * FROM Fridges
INNER JOIN FridgeProducts ON FridgeProducts.FridgeId = Fridges.FridgeId
INNER JOIN Products ON FridgeProducts.ProductId = Products.ProductId
WHERE (Products.Default_Quantity > FridgeProducts.Quantity)


--3 task
SELECT TOP(1) SUM(Quantity) SumOfProducts, FridgeProducts.FridgeId, FridgeModels.Year 
FROM FridgeProducts
INNER JOIN Fridges ON Fridges.FridgeId = FridgeProducts.FridgeId
INNER JOIN FridgeModels ON FridgeModels.FridgeModelId = Fridges.ModelId
GROUP BY FridgeProducts.FridgeId, FridgeModels.Year, FridgeModels.FridgeModelId
ORDER BY SUM(Quantity) DESC


--4 task
WITH ProductsInFridge AS 
(
	SELECT  COUNT(Quantity) as Quantity, Fridges.Owner_Name, ProductId,
	SUM(COUNT(Quantity)) OVER (PARTITION BY Fridges.Owner_Name) as Units FROM FridgeProducts
	INNER JOIN Fridges ON Fridges.FridgeId = FridgeProducts.FridgeId 
	GROUP BY Fridges.Owner_Name, ProductId 
)	

SELECT Units, ProductId, Owner_Name FROM ProductsInFridge
WHERE Units = (SELECT MAX(Units) FROM ProductsInFridge)

--2nd part--
--1 task
SELECT * FROM FridgeProducts
WHERE FridgeId = 'c968bd7b-d69b-4f4b-93b3-08dab98aa839'

--2 task
SELECT f.FridgeId, f.Owner_Name, fp.ProductId, fp.Quantity FROM Fridges as f
LEFT JOIN FridgeProducts as fp ON fp.FridgeId = f.FridgeId

--3 task
SELECT SUM(Quantity)as SumOfProducts, FridgeProducts.FridgeId FROM FridgeProducts
INNER JOIN Fridges ON Fridges.FridgeId = FridgeProducts.FridgeId
GROUP BY FridgeProducts.FridgeId
ORDER BY SUM(Quantity) DESC

--4 task 
SELECT 
(SELECT Count(Quantity) FROM FridgeProducts as fp WHERE fp.FridgeId = f.FridgeId) as QuantityOfProducts,
f.Name, fm.Year, f.FridgeId
FROM Fridges as f
INNER JOIN FridgeModels as fm ON fm.FridgeModelId = f.ModelId

--5 task
SELECT f.FridgeId, p.Default_Quantity, fp.Quantity FROM Fridges as f
INNER JOIN FridgeProducts as fp ON fp.FridgeId = f.FridgeId
INNER JOIN Products as p ON fp.ProductId = p.ProductId
WHERE (p.Default_Quantity > fp.Quantity)

--6 task
WITH ProductsWithLessQuantity AS
(
SELECT f.FridgeId, 
(SELECT COUNT(Quantity) FROM FridgeProducts as fp WHERE fp.FridgeId = f.FridgeId) as CountOfProducts,
fp.FridgeProductsId, p.Name, p.Default_Quantity
FROM Fridges as f
JOIN FridgeProducts as fp ON fp.FridgeId = f.FridgeId
JOIN Products as p ON p.ProductId = fp.ProductId
)

SELECT FridgeId, FridgeProductsId, CountOfProducts, Name, Default_Quantity
FROM ProductsWithLessQuantity
WHERE CountOfProducts > Default_Quantity
