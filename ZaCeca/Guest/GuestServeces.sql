-- koj so ima potroseno i go napraj i kolku ima da kazuva broj
(
SELECT GuestAccount.Name, GuestAccount.Surname, FoodDrink.Name AS 'ServeceName', COUNT (FoodDrink.Barcode) AS 'AmountSold'
	FROM SoldStuff
	INNER JOIN FoodDrink  ON SoldStuff.Product = FoodDrink.Barcode
	INNER JOIN Guest ON SoldStuff.Guest = Guest.GuestID
	INNER JOIN Booking ON Guest.Booking = Booking.BookingID
	INNER JOIN GuestAccount ON Booking.GuestAccount = GuestAccount.GuestAccountID
	GROUP BY GuestAccount.Name, GuestAccount.Surname, FoodDrink.Name
)
UNION
(
SELECT GuestAccount.Name, GuestAccount.Surname, Spa.Name AS 'ServeceName', COUNT (Spa.SpaID) AS 'AmountSold'
	FROM SoldStuff
	INNER JOIN Spa ON SoldStuff.Servece = Spa.SpaID
	INNER JOIN Guest ON SoldStuff.Guest = Guest.GuestID
	INNER JOIN Booking ON Guest.Booking = Booking.BookingID
	INNER JOIN GuestAccount ON Booking.GuestAccount = GuestAccount.GuestAccountID
	GROUP BY GuestAccount.Name, GuestAccount.Surname, Spa.Name
)