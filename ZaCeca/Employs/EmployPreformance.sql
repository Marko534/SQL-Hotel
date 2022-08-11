-- koj Vraboten so ima prodaeno i kolku
(
	SELECT 
		Employ.Name, Employ.Surname, EmployType.EmployType, FoodDrink.Name AS 'Servece name', COUNT (FoodDrink.Barcode) AS 'SoldAmount'
	FROM SoldStuff
	INNER JOIN Employ ON SoldStuff.Employ = Employ.EmployID
	INNER JOIN EmployType ON Employ.EmployType = EmployType.EmployTypeID
	INNER JOIN FoodDrink ON SoldStuff.Product = FoodDrink.Barcode
	GROUP BY Employ.EmployID, Employ.Name, Employ.Surname, EmployType.EmployType, FoodDrink.Name
	)
UNION
	(
	SELECT
		Employ.Name, Employ.Surname, EmployType.EmployType,  Spa.Name, COUNT(Spa.SpaID)
	FROM SoldStuff
	INNER JOIN Employ ON SoldStuff.Employ = Employ.EmployID
	INNER JOIN EmployType ON Employ.EmployType = EmployType.EmployTypeID
	INNER JOIN Spa ON SoldStuff.Servece = Spa.SpaID
	GROUP BY Employ.EmployID, Employ.Name, Employ.Surname, EmployType.EmployType, Spa.Name
	)
