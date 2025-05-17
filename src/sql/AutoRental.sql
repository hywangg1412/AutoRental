CREATE DATABASE AutoRental

USE AutoRental
GO

CREATE TABLE [Users] (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    PhoneNumber NVARCHAR(11) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Gender BIT NULL,
    Role NVARCHAR(50) NOT NULL DEFAULT 'User',
    FullName AS (FirstName + ' ' + LastName) PERSISTED,
    UserAddress NVARCHAR(255) NULL,
    DriverLicenseNumber NVARCHAR(50) NOT NULL,
    DriverLicenseImage NVARCHAR(MAX) NOT NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    Status VARCHAR(20) NOT NULL CHECK (Status IN (
        'Active',
        'Inactive',
        'Banned'
    )) DEFAULT 'Active'
);

CREATE TABLE Car (
    CarId INT IDENTITY(1,1) PRIMARY KEY,
    Brand VARCHAR(50) NOT NULL,
    CarModel VARCHAR(50) NOT NULL,
    YearManufactured INT CHECK (YearManufactured >= 1900 AND YearManufactured <= 2025),
    TransmissionType VARCHAR(20) NOT NULL,
    FuelType VARCHAR(20) NOT NULL,
    Color VARCHAR(30),
    LicensePlate NVARCHAR(20) NOT NULL UNIQUE,
    Seats INT NOT NULL CHECK (Seats > 0),
    Odometer INT NOT NULL CHECK (Odometer >= 0),
    ImgUrl NVARCHAR(255),
    PricePerHour DECIMAL(10,2) NOT NULL CHECK (PricePerHour >= 0),
    PricePerDay DECIMAL(10,2) NOT NULL CHECK (PricePerDay >= 0),
    PricePerMonth DECIMAL(10,2) NOT NULL CHECK (PricePerMonth >= 0),
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Available', 'Rented', 'Unavailable')) DEFAULT 'Available',
    Description NVARCHAR(500) NULL,
    INDEX IDX_Car_LicensePlate (LicensePlate)
);

CREATE TABLE Booking (
    BookingId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CarId INT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PickupLocation VARCHAR(100) NOT NULL,
    ReturnLocation VARCHAR(100) NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL CHECK (TotalAmount >= 0),
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')) DEFAULT 'Pending',
    DiscountId INT NULL,
    FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    FOREIGN KEY (CarId) REFERENCES Car(CarId) ON DELETE SET NULL,
    CONSTRAINT CHK_Booking_Dates CHECK (EndDate >= StartDate)
);

CREATE TABLE Contract (
    ContractId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CarId INT NULL,
    BookingId INT NOT NULL,
    ContractContent NVARCHAR(MAX) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TotalEstimatedPrice DECIMAL(10, 2) NOT NULL CHECK (TotalEstimatedPrice >= 0),
    CompanyRepresentative NVARCHAR(100) NOT NULL,
    FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    FOREIGN KEY (CarId) REFERENCES Car(CarId) ON DELETE SET NULL,
    FOREIGN KEY (BookingId) REFERENCES Booking(BookingId) ON DELETE NO ACTION, -- Thay đổi để tránh cycle/multiple cascade paths
    CONSTRAINT CHK_Contract_Dates CHECK (EndDate >= StartDate)
);

CREATE TABLE Payment (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    ContractId INT NOT NULL,
    PaymentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL CHECK (TotalAmount >= 0),
    PaymentStatus VARCHAR(20) NOT NULL CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed')) DEFAULT 'Pending',
    PaymentMethod VARCHAR(50) NOT NULL,
    FOREIGN KEY (ContractId) REFERENCES Contract(ContractId) ON DELETE CASCADE,
    INDEX IDX_Payment_PaymentDate (PaymentDate)
);

CREATE TABLE Discount (
    DiscountId INT IDENTITY(1,1) PRIMARY KEY,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PricePerHour DECIMAL(10, 2) NOT NULL CHECK (PricePerHour >= 0),
    PricePerDay DECIMAL(10, 2) NOT NULL CHECK (PricePerDay >= 0),
    PricePerMonth DECIMAL(10, 2) NOT NULL CHECK (PricePerMonth >= 0),
    IsActive BIT NOT NULL DEFAULT 1 CHECK (IsActive IN (0,1)),
    CONSTRAINT CHK_Discount_Dates CHECK (EndDate >= StartDate)
);

CREATE TABLE Review (
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CarId INT NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Content NVARCHAR(4000) NULL,
    Reviewed DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    FOREIGN KEY (CarId) REFERENCES Car(CarId) ON DELETE SET NULL
);

