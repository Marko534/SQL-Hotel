SELECT DISTINCT 
Rooms.RoomID , Rooms.Floor, RoomType.Size , RoomType.Price,
COALESCE(MAX(Booking.CheckIn),'2000-01-01') 'CheckIn' , COALESCE(MAX(Booking.CheckOut),'2000-01-01') AS 'CheckOut'
, (CASE
	WHEN COALESCE(MAX(Booking.CheckOut),'2000-01-01') > COALESCE(MAX(RoomCleaning.DateCleaned),'2000-01-01')
		THEN 'Needs Cleaning'
	WHEN CURRENT_TIMESTAMP > COALESCE(MAX(Booking.CheckOut),'2000-01-01')
		THEN 'Free'
	ELSE 'ERROR'
END)
	AS 'Status'
FROM Rooms
FULL JOIN Guest ON Rooms.RoomID = Guest.Room
FULL JOIN Booking ON Guest.Booking = Booking.BookingID
FULL JOIN RoomCleaning ON Rooms.RoomID = RoomCleaning.RoomCleaningID
FULL JOIN RoomType ON Rooms.TypeOfRoom = RoomType.TypeID
Group BY Rooms.RoomID , RoomType.Size , RoomType.Price, Rooms.Floor
HAVING  COALESCE(MAX(Booking.CheckOut),'2000-01-01') < CURRENT_TIMESTAMP

UNION

SELECT Rooms.RoomID ,Rooms.Floor, RoomType.Size, RoomType.Price,
Booking.CheckIn AS 'CheckIn',Booking.CheckOut AS 'CheckOut' , 'Booked' AS 'Status'
FROM Rooms
INNER JOIN Guest ON Guest.Room=Rooms.RoomID
INNER JOIN RoomCleaning ON Rooms.RoomID=RoomCleaning.RoomCleaningID
INNER JOIN RoomType ON Rooms.TypeOfRoom = RoomType.TypeID
INNER JOIN Booking ON Guest.Booking= Booking.BookingID
WHERE Booking.CheckIn> CURRENT_TIMESTAMP

UNION

SELECT Rooms.RoomID ,Rooms.Floor, RoomType.Size, RoomType.Price, Booking.CheckIn AS 'CheckIn',Booking.CheckOut AS 'CheckOut' , 'Booked' AS 'Status'
FROM Rooms
INNER JOIN Guest ON Guest.Room=Rooms.RoomID
INNER JOIN RoomCleaning ON Rooms.RoomID=RoomCleaning.RoomCleaningID
INNER JOIN RoomType ON Rooms.TypeOfRoom = RoomType.TypeID
INNER JOIN Booking ON Guest.Booking= Booking.BookingID
WHERE Booking.CheckIn < CURRENT_TIMESTAMP AND Booking.CheckOut >CURRENT_TIMESTAMP