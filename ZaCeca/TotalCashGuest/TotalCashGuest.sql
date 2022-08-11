-- Kolku ima nekoj vkupno potroseno vo negovite site prestoj

SELECT Name, Surname, HotelWord.dbo.GuestGivenCash( GuestAccountID) AS 'Cash'
FROM GuestAccount