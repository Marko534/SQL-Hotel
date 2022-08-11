DECLARE  @DAY DATE 
SET @DAY = '2022-07-15';
WITH CTE_test AS 
(SELECT 
SUM( FoodDrink.Price) + SUM (Spa.Price) AS 'Services'

FROM SoldStuff

LEFT JOIN FoodDrink ON SoldStuff.Product=FoodDrink.Barcode
LEFT JOIN Spa ON SoldStuff.Servece= Spa.SpaID
INNER JOIN Guest ON SoldStuff.Guest= Guest.GuestID
INNER JOIN Booking ON Guest.Booking= Booking.BookingID
WHERE (CONVERT(DATE, SoldStuff.DateModified )= @DAY)
UNION 

SELECT 
SUM(RoomType.Price)+SUM(BookingType.BasePricePerDay) AS 'Room'
FROM Rooms
INNER JOIN Guest ON Guest.Room=Rooms.RoomID
INNER JOIN RoomCleaning ON Rooms.RoomID=RoomCleaning.RoomCleaningID
INNER JOIN RoomType ON Rooms.TypeOfRoom = RoomType.TypeID
INNER JOIN Booking ON Guest.Booking= Booking.BookingID
INNER JOIN BookingType ON Booking.BookingID= BookingType.BookingTypeID
WHERE Booking.CheckIn<= @DAY AND  Booking.CheckOut>= @DAY
)
SELECT 
SUM(CTE_test.Services ) AS 'Daily'
FROM CTE_test