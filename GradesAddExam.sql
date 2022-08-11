CREATE PROCEDURE spAddExam
	@NAME varchar(50),
	@SURNAME varchar(50),
	@SUBJECT varchar(25),
	@GRADE int
AS
BEGIN
	INSERT INTO Exams
	SELECT Students.StudentID, Subjects.SubjectID, @GRADE
	FROM Exams
	INNER JOIN Students ON Exams.StudentID = Students.StudentID
	INNER JOIN Subjects ON Exams.SubjectID = Subjects.SubjectID	
	WHERE Students.Name = @NAME AND Students.Surname = @SURNAME AND Subjects.Name = @SUBJECT AND @GRADE >= 1 AND @GRADE <= 5;
END;

EXEC spAddExam 'David', 'David', 'Art' , 2
SELECT *
FROM Exams


