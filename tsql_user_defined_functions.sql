--1. Користувацька функція приймає три числа та повертає середньоарифметичне трьох чисел.
CREATE FUNCTION dbo.AvgThreeNumbers
(
    @a DECIMAL(10,2),
    @b DECIMAL(10,2),
    @c DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN ((@a + @b + @c)/3.0)
END
GO

--Клієнтська частина (використання)
DECLARE @number1 DECIMAL(10,2)
SET @number1 = 5
DECLARE @number2 DECIMAL(10,2)
SET @number2 = 10
DECLARE @number3 DECIMAL(10,2)
SET @number3 = 15

SELECT dbo.AvgThreeNumbers(@number1, @number2, @number3)
SELECT dbo.AvgThreeNumbers(33, 22, 10)
GO

--2. Користувацька функція переводить гривні на євро. Курс євро та сума у гривнях передаються у функцію через параметри.
CREATE FUNCTION dbo.UahToEur
(
    @AmountUAH DECIMAL(18,2),
    @Rate DECIMAL(18,4)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    RETURN @AmountUAH/@Rate
END
GO

--Клієнтська частина (використання)
DECLARE @EuroRate DECIMAL(18,4) = 50.58
DECLARE @AmountUAH DECIMAL(18,4) = 1000

SELECT dbo.UahToEur(@AmountUAH, @EuroRate)
GO

--3. Користувацька функція приймає два числа та повертає максимальне значення.
CREATE FUNCTION dbo.GetMaxValue
(
    @Number1 DECIMAL(18,2),
    @Number2 DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Result DECIMAL(18,2)

    IF (@Number1>@Number2)
        SET @Result=@Number1
    ELSE
        SET @Result=@Number2
    RETURN @Result
END
GO

--Клієнтська частина (використання)
DECLARE @Number1 DECIMAL(18,4)=10
DECLARE @Number2 DECIMAL(18,4)=20

SELECT dbo.GetMaxValue(@Number1, @Number2)
GO

--4. Користувацька функція повертає інформацію про поточний день (дата місяця).
CREATE FUNCTION dbo.GetCurrentDayMonth()
RETURNS TABLE
AS
RETURN
(
    SELECT    
        DATEPART(DAY, GETDATE()) AS CurrentDay,       
        DATEPART(MONTH, GETDATE()) AS CurrentMonth  
)
GO

--Клієнтська частина (використання)
SELECT *
FROM dbo.GetCurrentDayMonth()
GO

--5. Користувацька функція повертає повну інформацію про поточну дату.
CREATE FUNCTION dbo.GetCurrentDateInfo()
RETURNS TABLE
AS
RETURN
(
    SELECT    
        DATEPART(YEAR, GETDATE()) AS CurrentYear,       
        DATEPART(MONTH, GETDATE()) AS CurrentMonth,  
        DATEPART(DAY, GETDATE()) AS CurrentDay,
        DATENAME(WEEKDAY, GETDATE()) AS DayName
)
GO

--Клієнтська частина (використання)
SELECT *
FROM dbo.GetCurrentDateInfo()
GO

--6. Користувацька функція приймає два різні числа і повертає максимальне значення, мінімальне значення та середнє значення.
CREATE FUNCTION dbo.GetMaxMinAvg
(
    @Number1 DECIMAL(18,2),
    @Number2 DECIMAL(18,2)
)
RETURNS @Result TABLE
(
    MaxValue DECIMAL(18,2),
    MinValue DECIMAL(18,2),
    AvgValue DECIMAL(18,2)
)
AS
BEGIN
    DECLARE @MaxValue DECIMAL(18,2)

    IF (@Number1>@Number2)
        SET @MaxValue=@Number1
    ELSE
        SET @MaxValue=@Number2

    DECLARE @MInValue DECIMAL(18,2)

    IF (@Number1<@Number2)
        SET @MinValue=@Number1
    ELSE
        SET @MinValue=@Number2

    DECLARE @AvgValue DECIMAL(18,2)
    SET @AvgValue=(@Number1+@Number2)/2.0

    INSERT INTO @Result
    VALUES
    (
        @MaxValue,   
        @MinValue,   
        @AvgValue              
    )

    RETURN
END
GO

--Клієнтська частина (використання)
SELECT *
FROM dbo.GetMaxMinAvg(10,20)
GO

--7. Користувацька функція повертає інформацію про заданий вид товарів конкретного виробника (база даних Спортивний магазин).
--Вид товару та назва виробника передаються у функцію через параметри.
CREATE FUNCTION dbo.GetProductTypeAndManufacturer
(
    @ProductType NVARCHAR(100),        
    @ManufacturerName NVARCHAR(150)   
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.Name AS ProductName,
        p.QuantityInStock AS ProductQuantityInStock,
        p.SalePrice AS ProductSalePrice,
        pt.TypeName AS ProductType,
        m.Name AS ManufacturerName
        FROM ProductTypes pt
        JOIN Products p ON p.ProductTypeId=pt.Id
        JOIN Manufacturers m ON p.ManufacturerId=m.Id
        WHERE pt.TypeName=@ProductType AND m.Name=@ManufacturerName
)
GO

--Клієнтська частина (використання)
SELECT *
FROM dbo.GetProductTypeAndManufacturer('Одяг', 'Nike')
GO
