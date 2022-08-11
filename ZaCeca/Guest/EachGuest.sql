-- Vkupno za sekoj booking kolku ima potroseno ova isto e i kako za BookingPriceCalc samo nemav togas funkci pominato i samo go kopirav
SELECT 
Booking.BookingID, GuestAccount.Name, GuestAccount.Surname, BookingType.BookingType
,COALESCE( SUM(FoodDrink.Price),0)+ COALESCE(SUM(Spa.Price),0)
+ ((RoomType.Price+BookingType.BasePricePerDay)*DATEDIFF(Day, Booking.CheckIn, Booking.CheckOut))

AS 'TotalBill', Booking.CheckOut

FROM SoldStuff

LEFT JOIN FoodDrink ON SoldStuff.Product=FoodDrink.Barcode
LEFT JOIN Spa ON SoldStuff.Servece= Spa.SpaID
INNER JOIN Guest ON SoldStuff.Guest= Guest.GuestID
INNER JOIN Booking ON Guest.Booking= Booking.BookingID
INNER JOIN GuestAccount ON Booking.GuestAccount= GuestAccount.GuestAccountID
INNER JOIN Rooms ON Guest.Room= Rooms.RoomID
INNER JOIN RoomType ON Rooms.TypeOfRoom= RoomType.TypeID
INNER JOIN BookingType ON Booking.BookingType=BookingType.BookingTypeID
--WHERE Booking.BookingID=
GROUP BY  Booking.BookingID, GuestAccount.Name, GuestAccount.Surname,  RoomType.Price, Booking.CheckIn, Booking.CheckOut, BookingType.BasePricePerDay,BookingType.BookingType
ORDER BY Booking.BookingID
