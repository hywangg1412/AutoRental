CREATE DATABASE AutoRental

USE AutoRental
GO

CREATE TABLE [Users] (
    UserId INT IDENTITY(1,1),
    Username NVARCHAR(256) NOT NULL, 
	UserDOB DATE NULL,
    PhoneNumber NVARCHAR(11) NOT NULL,
    UserAddress NVARCHAR(MAX) NULL,
	UserAvatar NVARCHAR(MAX) NULL,
    Email NVARCHAR(256) UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Gender BIT NULL,
    Role NVARCHAR(50) NOT NULL, --DEFAULT 'User',
    CreatedDate DATETIME2 NOT NULL,
    Status VARCHAR(20) NOT NULL, 
	DriverLicenseNumber NVARCHAR(12) NOT NULL,
    DriverLicenseImage NVARCHAR(MAX) NOT NULL,
    VerificationStatus VARCHAR(20) NOT NULL,
	CONSTRAINT PK_User PRIMARY KEY (UserId)
);

--CREATE TABLE [DriverLicenses] (
    --LicenseId INT IDENTITY(1,1),
    --UserId INT NOT NULL,
	--LicenseName NVARCHAR(MAX) NOT NULL,
    --LicenseNumber NVARCHAR(12) NOT NULL,
    --LicenseImagePath NVARCHAR(MAX) NULL,
    --IssueDate DATE NULL,
    --ExpiryDate DATE NULL,
    --VerificationStatus VARCHAR(20) NOT NULL,

	--CONSTRAINT PK_DriverLicense PRIMARY KEY (LicenseId),
    --CONSTRAINT FK_DriverLicense_User FOREIGN KEY (UserId) REFERENCES Users(UserId)
--);

CREATE TABLE Car (
    CarId INT IDENTITY(1,1),
    Brand VARCHAR(50) NOT NULL,
    CarModel VARCHAR(50) NOT NULL,
    YearManufactured INT NULL, --CHECK (YearManufactured >= 1900 AND YearManufactured <= 2025),
    TransmissionType VARCHAR(20) NOT NULL,
    FuelType VARCHAR(20) NOT NULL,
    Color VARCHAR(30),
    LicensePlate NVARCHAR(20) NOT NULL, --UNIQUE,
    Seats INT NULL, --CHECK (Seats > 0),
    Odometer INT NULL, --CHECK (Odometer >= 0),
    CarImage NVARCHAR(MAX) NULL,
    PricePerHour DECIMAL(10,2) NOT NULL, --CHECK (PricePerHour >= 0),
    PricePerDay DECIMAL(10,2) NOT NULL, --CHECK (PricePerDay >= 0),
    PricePerMonth DECIMAL(10,2) NOT NULL, --CHECK (PricePerMonth >= 0),
    Status VARCHAR(20) NOT NULL, --CHECK (Status IN ('Available', 'Rented', 'Unavailable')) DEFAULT 'Available',
    Description NVARCHAR(MAX) NULL,

	CONSTRAINT PK_Car PRIMARY KEY (CarId),
);

CREATE TABLE Booking (
    BookingId INT IDENTITY(1,1),
    UserId INT NOT NULL,
    CarId INT NOT NULL,
    RentStartDate DATE NOT NULL,
    RentEndDate DATE NOT NULL,
    PickupLocation VARCHAR(100) NOT NULL,
    ReturnLocation VARCHAR(100) NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    DiscountId INT NULL,

    CONSTRAINT PK_Booking PRIMARY KEY (BookingId),
    CONSTRAINT FK_Booking_User FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    CONSTRAINT FK_Booking_Car FOREIGN KEY (CarId) REFERENCES Car(CarId) ON DELETE SET NULL,
    CONSTRAINT FK_Booking_Discount FOREIGN KEY (DiscountId) REFERENCES Discount(DiscountId),
    --CONSTRAINT CHK_Booking_Amount CHECK (TotalAmount >= 0),
    --CONSTRAINT CHK_Booking_Status CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')),
    --CONSTRAINT CHK_Booking_Dates CHECK (EndDate >= StartDate)
);

CREATE TABLE Contract (
    ContractId INT IDENTITY(1,1),
    UserId INT NOT NULL,
    CarId INT NULL,
    BookingId INT NOT NULL,
    ContractContent NVARCHAR(MAX) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TotalEstimatedPrice DECIMAL(10, 2) NOT NULL,
    CompanyRepresentative NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_Contract PRIMARY KEY (ContractId),
    CONSTRAINT FK_Contract_User FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    CONSTRAINT FK_Contract_Car FOREIGN KEY (CarId) REFERENCES Car(CarId) ON DELETE SET NULL,
    CONSTRAINT FK_Contract_Booking FOREIGN KEY (BookingId) REFERENCES Booking(BookingId) ON DELETE NO ACTION,
    --CONSTRAINT CHK_Contract_Price CHECK (TotalEstimatedPrice >= 0),
    --CONSTRAINT CHK_Contract_Dates CHECK (EndDate >= StartDate)
);

CREATE TABLE Payment (
    PaymentId INT IDENTITY(1,1),
    ContractId INT NOT NULL,
    PaymentDate DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL, --DEFAULT 'Pending',
    PaymentMethod VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Payment PRIMARY KEY (PaymentId),
    CONSTRAINT FK_Payment_Contract FOREIGN KEY (ContractId) REFERENCES Contract(ContractId) ON DELETE CASCADE,
    --CONSTRAINT CHK_Payment_Amount CHECK (TotalAmount >= 0),
    --CONSTRAINT CHK_Payment_Status CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed')),
    --INDEX IDX_Payment_PaymentDate (PaymentDate)
);

CREATE TABLE Discount (
    DiscountId INT IDENTITY(1,1),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PricePerHour DECIMAL(10, 2) NOT NULL,
    PricePerDay DECIMAL(10, 2) NOT NULL,
    PricePerMonth DECIMAL(10, 2) NOT NULL,
    IsActive BIT NOT NULL --DEFAULT 1,

    CONSTRAINT PK_Discount PRIMARY KEY (DiscountId),
    --CONSTRAINT CHK_Discount_Hour CHECK (PricePerHour >= 0),
    --CONSTRAINT CHK_Discount_Day CHECK (PricePerDay >= 0),
    --CONSTRAINT CHK_Discount_Month CHECK (PricePerMonth >= 0),
    --CONSTRAINT CHK_Discount_Active CHECK (IsActive IN (0, 1)),
    --CONSTRAINT CHK_Discount_Dates CHECK (EndDate >= StartDate)
);

CREATE TABLE Reviews (
    ReviewId INT IDENTITY(1,1),
    UserId INT NOT NULL,
    CarId INT NOT NULL,
    Rating INT NOT NULL,
    Content NVARCHAR(4000) NULL,
    ReviewDate DATETIME2 NOT NULL, --DEFAULT GETDATE(),

    CONSTRAINT PK_Review PRIMARY KEY (ReviewId),
    CONSTRAINT FK_Review_User FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    CONSTRAINT FK_Review_Car FOREIGN KEY (CarId) REFERENCES Car(CarId) ON DELETE SET NULL,
    --CONSTRAINT CHK_Review_Rating CHECK (Rating >= 1 AND Rating <= 5)
);

