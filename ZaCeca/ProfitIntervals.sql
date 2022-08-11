-- Ovde e za profit vo ogranicen interval racno gi ispolnuvav tabelite oti nez kako loop se praj za datum da se menuva 
SELECT HotelWord.dbo.DateIntervalProfit('2022-01-01' , '2022-09-01') FROM 

CREATE TABLE ProfitYear(
	ProfitYearID int IDENTITY(1,1) PRIMARY KEY,
	Year int ,
	Profit int 
)

INSERT INTO ProfitYear (Year, Profit)
VALUES (2022, HotelWord.dbo.DateIntervalProfit('2022-01-01' , '2023-01-01'))
SELECT * FROM ProfitYear

SELECT HotelWord.dbo.DateIntervalProfit('2022-01-01' , '2023-01-01')