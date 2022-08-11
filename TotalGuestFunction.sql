
ALTER FUNCTION GuestGivenCash(@GuestID int)
RETURNS int
AS
-- Returns the stock level for the product.
BEGIN
DECLARE @ret int;
WITH EachGuest AS(
SELECT 
	GuestAccount.GuestAccountID, Booking.CheckIn, Booking.CheckOut,
	COALESCE( SUM(FoodDrink.Price),0) +  COALESCE(SUM(Spa.Price),0) AS 'Spent',
	((RoomType.Price+BookingType.BasePricePerDay)*DATEDIFF(Day, Booking.CheckIn, Booking.CheckOut)) AS 'RoomPrice'
		/*COALESCE( SUM(FoodDrink.Price),0)+ COALESCE(SUM(Spa.Price),0)
		+ ((RoomType.Price+BookingType.BasePricePerDay)*DATEDIFF(Day, Booking.CheckIn, Booking.CheckOut))

AS 'TotalBill', Booking.CheckOut */

FROM SoldStuff


LEFT JOIN FoodDrink ON SoldStuff.Product=FoodDrink.Barcode
LEFT JOIN Spa ON SoldStuff.Servece= Spa.SpaID
FULL JOIN Guest ON SoldStuff.Guest= Guest.GuestID
INNER JOIN Booking ON Guest.Booking= Booking.BookingID
INNER JOIN GuestAccount ON Booking.GuestAccount = GuestAccount.GuestAccountID
INNER JOIN BookingType ON Booking.BookingType=BookingType.BookingTypeID
INNER JOIN RoomType ON BookingType.RoomType = RoomType.TypeID
WHERE GuestAccount.GuestAccountID=@GuestID

GROUP BY GuestAccount.GuestAccountID, Booking.CheckIn, Booking.CheckOut, RoomType.Price, BookingType.BasePricePerDay
)
	SELECT @ret = (SUM(Spent) + SUM (RoomPrice)) 
	FROM EachGuest;
	RETURN @ret;
END;