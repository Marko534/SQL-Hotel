SELECT HotelWord..Employ.Name, HotelWord..Employ.Surname, HotelWord..Employ.PayPerDay, HotelWord..EmployType.WorkingHours, HotelWord..EmployType.EmployType
FROM HotelWord..Employ
INNER JOIN  HotelWord..EmployType ON HotelWord..Employ.EmployType=HotelWord..EmployType.EmployTypeID