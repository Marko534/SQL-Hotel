CREATE FUNCTION DateIntervalProfit (@STARTDATE date, @ENDDATE date)
RETURNS int
AS
BEGIN
	DECLARE @ret int;
	WITH Interval AS(
	SELECT 
	GuestAccount.GuestAccountID, Booking.CheckIn, Booking.CheckOut,
	COALESCE( SUM(FoodDrink.Price),0) +  COALESCE(SUM(Spa.Price),0) AS 'Spent',
	((RoomType.Price+BookingType.BasePricePerDay)*DATEDIFF(Day, Booking.CheckIn, Booking.CheckOut)) AS 'RoomPrice'

	FROM SoldStuff


	LEFT JOIN FoodDrink ON SoldStuff.Product=FoodDrink.Barcode
	LEFT JOIN Spa ON SoldStuff.Servece= Spa.SpaID
	FULL JOIN Guest ON SoldStuff.Guest= Guest.GuestID
	INNER JOIN Booking ON Guest.Booking= Booking.BookingID
	INNER JOIN GuestAccount ON Booking.GuestAccount = GuestAccount.GuestAccountID
	INNER JOIN BookingType ON Booking.BookingType=BookingType.BookingTypeID
	INNER JOIN RoomType ON BookingType.RoomType = RoomType.TypeID
	WHERE Booking.CheckOut <= @ENDDATE AND Booking.CheckOut >= @STARTDATE
	GROUP BY GuestAccount.GuestAccountID, Booking.CheckIn, Booking.CheckOut, RoomType.Price, BookingType.BasePricePerDay
	)
	SELECT @Ret = (SUM(Spent)+ SUM(RoomPrice))
	FROM Interval

	RETURN @ret;
END

PRINT DateIntervalProfit('2022-01-01' , '2023-01-01')