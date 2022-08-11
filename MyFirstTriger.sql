CREATE TRIGGER trRoomBooked
ON Guest AFTER INSERT
AS
BEGIN
	INSERT INTO RoomTrigerTest ( RoomNumber, CheckIn, CheckOut)
	SELECT TOP 1 Guest.Room, Booking.CheckIn, Booking.CheckOut FROM Booking
	INNER JOIN Guest ON Booking.BookingID = Guest.Booking
	ORDER BY Booking.BookingID DESC
END;