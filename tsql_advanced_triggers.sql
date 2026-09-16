--1. Заборонити видалення наявних клієнтів.Зробити треба двома способами - за допомогою тригера INSTEAD OF DELETE,
--а також за допомогою тригера AFTER DELETE.
--Тригер INSTEAD OF DELETE
CREATE TRIGGER trg_NoDeleteRegisteredCustomers
ON Customers
INSTEAD OF DELETE
AS
BEGIN
    IF (
        SELECT COUNT(*)
        FROM Customers c
        JOIN deleted d
          ON c.FullName=d.FullName
         AND c.Email=d.Email
    ) > 0
    BEGIN
        RAISERROR('Заборонено видаляти наявного клієнта!',16,1)
        RETURN
    END
    DELETE FROM Customers
    WHERE Id IN (SELECT Id FROM deleted)
END
GO

--Перевірка роботи тригера
DELETE FROM Customers
WHERE Id=2
GO

--Тригер AFTER DELETE
CREATE TRIGGER trg_NoDeleteAnyRegisteredCustomers
ON Customers
AFTER DELETE
AS
BEGIN
    IF (
        SELECT COUNT(*)
        FROM Customers c
        JOIN deleted d
          ON c.FullName=d.FullName
         AND c.Email=d.Email
    ) > 0
    BEGIN
        RAISERROR('Заборонено видаляти наявного клієнта!',16,1)
        ROLLBACK TRAN
        RETURN
    END
END
GO

--Перевірка роботи тригера
DELETE FROM Customers
WHERE Id=2
GO

--2.При новій покупці товару потрібно перевіряти загальну суму покупок клієнта. Якщо сума перевищила 50000,
--необхідно встановити відсоток знижки в 15%. Зробити треба за допомогою тригера AFTER INSERT.
CREATE TRIGGER trg_UpdateCustomerDiscount
ON Sales
AFTER INSERT
AS
BEGIN
    UPDATE c
    SET c.DiscountPercent=15
    FROM Customers c
    JOIN (
        SELECT i.CustomerId, SUM(s.Quantity*p.SalePrice) AS TotalAmount
        FROM inserted i
        JOIN Sales s ON i.CustomerId=s.CustomerId
        JOIN Products p ON s.ProductId=p.Id
        GROUP BY i.CustomerId
    ) totals ON c.Id=totals.CustomerId
    WHERE totals.TotalAmount > 50000
END

--Перевірка роботи тригера
INSERT INTO Sales (ProductId, EmployeeId, CustomerId, Quantity, SaleDate)
VALUES (2, 1, 1, 11, GETDATE());

SELECT DiscountPercent FROM Customers WHERE Id=1;

--3. Заборонити додавати товар конкретної фірми. Наприклад, товар фірми "Спорт, сонце і штанга".
--Зробити треба двома способами - за допомогою тригера INSTEAD OF INSERT, а також за допомогою тригера AFTER INSERT.
INSERT INTO Manufacturers (Name)
VALUES ('Asus');

--Тригер INSTEAD OF INSERT
CREATE TRIGGER trg_BlockAsusProducts
ON Products
INSTEAD OF INSERT
AS
BEGIN
    IF (
        SELECT COUNT(*)
        FROM inserted i
        JOIN Manufacturers m ON i.ManufacturerId = m.Id
        WHERE m.Name='Asus'
    )>0
BEGIN
    RAISERROR('Додавання Asus заборонено!',16,1)
    RETURN
END
    INSERT INTO Products (Name, ProductTypeId, ManufacturerId, QuantityInStock, CostPrice, SalePrice)
    SELECT Name, ProductTypeId, ManufacturerId, QuantityInStock, CostPrice, SalePrice
    FROM inserted
END
GO

--Перевірка роботи тригера
INSERT INTO Products (Name, ProductTypeId, ManufacturerId, QuantityInStock, CostPrice, SalePrice)
VALUES ('Ноутбук Asus', 1, (SELECT Id FROM Manufacturers WHERE Name='Asus'), 10, 20000, 25000)

--Тригер AFTER INSERT
CREATE TRIGGER trg_BlockAsusProductsAfter
ON Products
AFTER INSERT
AS
BEGIN
    DELETE p
    FROM Products p
    JOIN inserted i ON p.Id=i.Id
    JOIN Manufacturers m ON i.ManufacturerId=m.Id
    WHERE m.Name='Asus'

    IF @@ROWCOUNT>0
    BEGIN
        RAISERROR('Додавання товарів виробника Asus заборонено!',16,1)
        ROLLBACK TRAN
        RETURN
    END
END
GO

--Перевірка роботи тригера
INSERT INTO Products (Name, ProductTypeId, ManufacturerId, QuantityInStock, CostPrice, SalePrice)
VALUES ('Ноутбук Asus', 1, (SELECT Id FROM Manufacturers WHERE Name='Asus'), 10, 20000, 25000)

--4. У разі звільнення співробітника перенести інформацію про звільненого співробітника в таблицю "Архів співробітників".
--Зробити треба за допомогою тригера AFTER DELETE.
CREATE TRIGGER trg_FiredEmployeeToArchive
ON Employees
AFTER DELETE
AS
BEGIN
    INSERT INTO EmployeesArchive (EmployeeId, FullName, PositionId, HireDate, Gender, Salary, FiredAt)
    SELECT Id, FullName, PositionId, HireDate, Gender, Salary, GETDATE()
    FROM deleted
END

--Перевірка роботи тригера
INSERT INTO Employees (FullName, PositionId, HireDate, Gender, Salary)
VALUES (N'Іван Іваненко', 1, '2020-05-10', N'Чоловік', 15000)
GO

SELECT * FROM Employees WHERE FullName=N'Іван Іваненко'
GO

DELETE FROM Employees WHERE FullName=N'Іван Іваненко'
GO

SELECT * FROM EmployeesArchive
GO

--5. Заборонити додавати нового продавця-консультанта, якщо кількість наявних продавців-консультантів більша за 7.
--Зробити треба двома способами - за допомогою тригера INSTEAD OF INSERT, а також за допомогою тригера AFTER INSERT.
--Тригер INSTEAD OF INSERT
CREATE TRIGGER trg_BlockNewSalesConsultant
ON Employees
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @Count INT

    SELECT @Count = COUNT(*)
    FROM Employees e
    JOIN Positions p ON e.PositionId=p.Id
    WHERE p.PositionName=N'Продавець-консультант'

    IF @Count>=7
    BEGIN
        RAISERROR(N'Неможливо додати нового продавця-консультанта: ліміт 7!',16,1)
        RETURN
    END
    
    
    INSERT INTO Employees (FullName, PositionId, HireDate, Gender, Salary)
    SELECT FullName, PositionId, HireDate, Gender, Salary
    FROM inserted
END
GO

--Перевірка роботи тригера
INSERT INTO Employees (FullName, PositionId, HireDate, Gender, Salary)
VALUES (N'Іван Петренко', 
        (SELECT Id FROM Positions WHERE PositionName = N'Продавець-консультант'),
        GETDATE(), N'Чоловік', 12000)
GO

--Тригер AFTER INSERT
CREATE TRIGGER trg_BlockNewSalesConsultantAfter
ON Employees
AFTER INSERT
AS
BEGIN
    DECLARE @Count INT

    SELECT @Count = COUNT(*)
    FROM Employees e
    JOIN Positions p ON e.PositionId = p.Id
    WHERE p.PositionName=N'Продавець-консультант'

    IF @Count>7
    BEGIN
        RAISERROR(N'Неможливо додати нового продавця-консультанта: ліміт 7!',16,1)
        ROLLBACK TRANSACTION
    END
END

--Перевірка роботи тригера
INSERT INTO Employees (FullName, PositionId, HireDate, Gender, Salary)
VALUES (N'Іван Петренко', 
        (SELECT Id FROM Positions WHERE PositionName = N'Продавець-консультант'),
        GETDATE(), N'Чоловік', 12000)
GO




















