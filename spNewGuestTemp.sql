CREATE PROCEDURE spNewBooking
	@NAME varchar(20),
	@SURNAME varchar(20),
	@BOOKING varchar(20),
	@ROOMSIZE int,
	@PAYMENT varchar(20),
	@RESERVATION varchar(20),
	@CHECKIN date,
	@CHECKOUT date
AS
BEGIN

	DECLARE @ACCOUNTID int
	SET @ACCOUNTID = (SELECT GuestAccountID
	FROM GuestAccount
	WHERE @NAME = Name AND @SURNAME = Surname)

	DECLARE @PAYMENTID int
	SET @PAYMENTID = (SELECT PaymentTypeID
	FROM PaymentType
	WHERE PaymentType = @PAYMENT)

	DECLARE @RESERVATIONID int
	SET @RESERVATIONID = (SELECT ReservatiomTypeID
	FROM ReservatiomType
	WHERE ReservatiomType = @RESERVATION)

	DECLARE @BOOKINGTYPEID int;
	SET @BOOKINGTYPEID= (SELECT RoomType.TypeID
	FROM BookingType
	INNER JOIN RoomType ON BookingType.RoomType = RoomType.TypeID
	WHERE BookingType.BookingType = @BOOKING AND RoomType.Size = @ROOMSIZE)
	
	DECLARE @ROOM int
	SET @ROOM = (SELECT DISTINCT TOP 1
		Rooms.RoomID 
		FROM Rooms
		FULL JOIN Guest ON Rooms.RoomID = Guest.Room
		FULL JOIN Booking ON Guest.Booking = Booking.BookingID
		FULL JOIN RoomCleaning ON Rooms.RoomID = RoomCleaning.RoomCleaningID
		FULL JOIN RoomType ON Rooms.TypeOfRoom = RoomType.TypeID
		INNER JOIN BookingType ON RoomType.TypeID = BookingType.RoomType
		Group BY Rooms.RoomID , RoomType.Size , RoomType.Price, Rooms.Floor, RoomType.TypeID, BookingType.BookingType
		HAVING  COALESCE(MAX(Booking.CheckOut),'2000-01-01') < @CHECKIN AND 
			@ROOMSIZE = RoomType.Size AND
			@BOOKING = BookingType.BookingType
			)

		DECLARE @BOOKINGID int
	IF @ROOM IS NOT NULL
		BEGIN
			INSERT INTO Booking (GuestAccount, PaymentType, ReservatiomType, BookingType, CheckIn, CheckOut)
			VALUES ( @ACCOUNTID, @PAYMENTID, @RESERVATIONID, @BOOKINGTYPEID, @CHECKIN, @CHECKOUT );
			SET @BOOKINGID = (SELECT TOP 1 BookingID FROM Booking ORDER BY BookingID DESC);
			INSERT INTO Guest(Booking, Room)
			VALUES (@BOOKINGID, @ROOM );
		END
	ELSE
		BEGIN
			SET @ROOM = (SELECT TOP 1 Rooms.RoomID
			FROM Booking
			INNER JOIN Guest ON Booking.BookingID = Guest.Booking
			INNER JOIN Rooms ON Guest.Room = Rooms.RoomID
			INNER JOIN RoomType ON Rooms.TypeOfRoom = RoomType.TypeID
			INNER JOIN BookingType ON Booking.BookingType = BookingType.BookingTypeID
			WHERE  Booking.CheckOut > @CHECKIN AND @CHECKOUT < Booking.CheckIn AND
			@ROOMSIZE = RoomType.Size AND
			@BOOKING = BookingType.BookingType
			ORDER BY Booking.BookingID DESC)
			IF @ROOM IS NOT NULL
				BEGIN
					INSERT INTO Booking (GuestAccount, PaymentType, ReservatiomType, BookingType, CheckIn, CheckOut)
					VALUES ( @ACCOUNTID, @PAYMENTID, @RESERVATIONID, @BOOKINGTYPEID, @CHECKIN, @CHECKOUT );
					SET @BOOKINGID = (SELECT TOP 1 BookingID FROM Booking ORDER BY BookingID DESC);
					INSERT INTO Guest(Booking, Room)
					VALUES (@BOOKINGID, @ROOM );
				END
			ELSE
				BEGIN
					PRINT 'SE OTKAZUVAM';
				END
		END
	
END


EXEC spNewBooking 'Hristi', 'Petkoski', 'Full', 1000, 'Cash', 'Online', '2016-07-14' , '2016-08-14'

CREATE PROCEDURE spNewGuestBooking
	@NAME varchar(20),
	@SURNAME varchar(20),
	@COUNTRY varchar(20),
	@CITY varchar(20),
	@ADDRES varchar(20),
	@BOOKING varchar(20),
	@ROOMSIZE int,
	@PAYMENT varchar(20),
	@RESERVATION varchar(20),
	@CHECKIN date,
	@CHECKOUT date
AS
BEGIN
	INSERT INTO GuestAccount ( Name, Surname, Country, City, Address)
	VALUES (@NAME, @SURNAME, @COUNTRY, @CITY, @ADDRES)

	EXEC spNewBooking @NAME, @SURNAME, @BOOKING, @ROOMSIZE, @PAYMENT, @RESERVATION, @CHECKIN, @CHECKOUT
END

EXEC spNewGuestBooking 'Hristi', 'Petkoski', 'Portugale', 'Porto', 'AAAAaaaaAA', 'Full', 750, 'Cash', 'Online', '2015-07-14', '2015-07-14'

SELECT * FROM Guest
SELECT * FROM GuestAccount