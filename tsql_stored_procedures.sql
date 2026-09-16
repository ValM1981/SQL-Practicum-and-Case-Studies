--1. Вивести курси у порядку спадання кількості кредитів. Шаблон назви курсу передається у процедуру як параметр.
CREATE PROCEDURE GetCoursesByCredits
    @CoursePattern NVARCHAR(100)
AS
BEGIN
    SELECT Courses.Title,
           Courses.Credits
    FROM Courses
    WHERE Courses.Title LIKE '%' + @CoursePattern + '%'
    ORDER BY Courses.Credits DESC
END
GO
--Використання (клієнтська частина)
EXEC GetCoursesByCredits '%Data%'
GO

--2. Для зазначених курсів збільшити кількість кредитів на 1. Шаблон назви курсу передається у процедуру як параметр. 
CREATE PROCEDURE IncreaseCreditsForCourse
    @CoursePattern NVARCHAR(100)
AS
BEGIN
    UPDATE Courses
    SET Credits=Credits+1
    WHERE Courses.Title LIKE '%' + @CoursePattern + '%'
END
GO
--Використання (клієнтська частина)
EXEC IncreaseCreditsForCourse '%Data%'
GO

--3. Видалити курси з певною кількістю кредитів. Число кредитів передається у процедуру як параметр.
CREATE PROCEDURE DeleteCoursesByCredits
    @Credits INT
AS
BEGIN
    DELETE FROM Courses
    WHERE Credits=@Credits
END
GO
--Використання (клієнтська частина)
EXEC DeleteCoursesByCredits 3
GO

--4. Знайти студентів, які зареєстровані після заданої дати. Дата реєстрації передається у процедуру як параметр.
CREATE PROCEDURE FindStudentsByDate
    @RegistrationDate DATE
AS
BEGIN
    SELECT Students.FirstName + N' ' + Students.LastName
    FROM Students
    WHERE Students.RegistrationDate>@RegistrationDate
END
GO
--Використання (клієнтська частина)
EXEC FindStudentsByDate '01.01.2020'
GO

--5. Визначити кількість студентів на певному курсі. Шаблон назви курсу передається у процедуру як параметр. Результат слід 
--повернути через вихідний параметр.
CREATE PROCEDURE CountStudentsByCourse
    @CoursePattern NVARCHAR(100),
    @StudentsCount INT OUTPUT
AS
BEGIN
    SELECT @StudentsCount=COUNT(Students.Id)
    FROM Students
    JOIN Enrollments ON Enrollments.StudentId=Students.Id
    JOIN Courses ON Enrollments.CourseId=Courses.Id
    WHERE Courses.Title LIKE '%' + @CoursePattern + '%'
END
GO
--Використання (клієнтська частина)
DECLARE @Result INT
EXEC CountStudentsByCourse '%Data%', @Result OUTPUT
SELECT @Result AS 'Кількість студентів'
GO

--6. Визначити кількість виконаних завдань студентом, ім'я та прізвище якого передаються як параметри у процедуру. 
--Результат слід повернути через вихідний параметр.
CREATE PROCEDURE GetAssignmentsDoneByStudent
    @FirstNamePattern NVARCHAR(50),
    @LastNamePattern NVARCHAR(50),
    @AssignmentsId INT OUTPUT
AS
BEGIN
    SELECT @AssignmentsId=Assignments.Id
    FROM Assignments
    JOIN StudentAssignments ON StudentAssignments.AssignmentId=Assignments.Id
    JOIN Students ON StudentAssignments.StudentId=Students.Id
    WHERE Students.FirstName LIKE '%' + @FirstNamePattern + '%'
      AND Students.LastName LIKE '%' + @LastNamePattern + '%'
END
GO
--Використання (клієнтська частина)
DECLARE @AssignmentsDone INT
EXEC GetAssignmentsDoneByStudent '%А%', '%М%', @AssignmentsDone OUTPUT
SELECT @AssignmentsDone AS 'Кількість завдань'
GO

--7. Збільшити зарплату викладачів на 15%, якщо вони працюють більше заданої кількості років. Кількість років передається у 
--процедуру як параметр.
CREATE PROCEDURE IncreaseSalaryByExperience
    @DatePattern INT
AS
BEGIN
    UPDATE Teachers
    SET Salary=Salary*1.15
    WHERE DATEDIFF(YEAR, HireDate, GETDATE())>@DatePattern
END
GO
--Використання (клієнтська частина)
EXEC IncreaseSalaryByExperience 5
GO

--8. Знайти курс з найбільшою кількістю кредитів. Результат (кількість кредитів та назву курсу) слід повернути через вихідні 
--параметри.
CREATE PROCEDURE GetMaxCreditsCourse
    @MaxCredits INT OUTPUT,
    @CourseTitle NVARCHAR(100) OUTPUT
AS
BEGIN
    SELECT TOP 1
        @MaxCredits=Credits,
        @CourseTitle=Title
    FROM Courses
    ORDER BY Credits DESC
END
GO
--Використання (клієнтська частина)
DECLARE @Credits INT
DECLARE @Title NVARCHAR(100)
EXEC GetMaxCreditsCourse @Credits OUTPUT, @Title OUTPUT
SELECT @Title AS N'Назва курсу', @Credits AS N'Кількість кредитів'
GO

--9. Знайти найстаріший курс за датою створення. Результат (назву курсу, дату створення) слід повернути через вихідні параметри.
CREATE PROCEDURE GetOldestCourseByCreatedDate
    @Title NVARCHAR(100) OUTPUT,
    @CreatedDate DATE OUTPUT
AS
BEGIN
    SELECT TOP 1
        @Title=Courses.Title,
        @CreatedDate=Courses.CreatedDate
    FROM Courses
    ORDER BY Courses.CreatedDate ASC
END
GO
--Використання (клієнтська частина)
DECLARE @Title NVARCHAR(100)
DECLARE @CreatedDate DATE
EXEC GetOldestCourseByCreatedDate
     @Title OUTPUT,
     @CreatedDate OUTPUT
SELECT @Title AS N'Назва курсу', @CreatedDate AS N'Дата створення'

--10. Визначити середній бал студента, ім'я та прізвище якого передаються як параметри у процедуру. Результат слід 
--повернути через вихідний параметр.
CREATE PROCEDURE GetAverageGradeForStudent
    @FirstNamePattern NVARCHAR(50),
    @LastNamePattern NVARCHAR(50),
    @AverageGrade DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @AverageGrade=AVG(Enrollments.Grade)
    FROM Enrollments
    JOIN Students ON Enrollments.StudentId=Students.Id
    WHERE Students.FirstName LIKE '%' + @FirstNamePattern + '%'
      AND Students.LastName LIKE '%' + @LastNamePattern + '%'
END
GO
--Використання (клієнтська частина)
DECLARE @Avg DECIMAL(10,2)
EXEC GetAverageGradeForStudent '%І%', '%М%', @Avg OUTPUT
SELECT @Avg AS 'Середній бал студента'
GO
