CREATE DATABASE AutoRental

USE AutoRental
GO

CREATE TABLE [Users] (
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [Username] NVARCHAR(100) NOT NULL, --UNIQUE
        [UserDOB] DATE NULL, --CHECK ([UserDOB] <= DATEADD(YEAR, -18, GETDATE())),
        [PhoneNumber] NVARCHAR(11) NULL,
        [UserAddress] NVARCHAR(MAX) NULL,
        [UserDescription] NVARCHAR(1000) NULL,
        [AvatarUrl] NVARCHAR(255) NULL,
        [Gender] NVARCHAR(10) NULL, --CHECK ([Gender] IN ('Male', 'Female', 'Other')),
        [FirstName] NVARCHAR(256) NULL,
        [LastName] NVARCHAR(256) NULL,
        [IsBanned] BIT NOT NULL, --DEFAULT 0,
        [CreatedDate] DATETIME2 NULL, --DEFAULT GETDATE(),
        [NormalizedUserName] NVARCHAR(256) NULL,
        [Email] NVARCHAR(100) NOT NULL, --UNIQUE
        [NormalizedEmail] NVARCHAR(256) NULL,
        [EmailVerifed] BIT NOT NULL, --DEFAULT 0,
        [PasswordHash] NVARCHAR(255) NOT NULL,
        [SecurityStamp] NVARCHAR(MAX) NULL,
        [ConcurrencyStamp] NVARCHAR(MAX) NULL,
        [TwoFactorEnabled] BIT NOT NULL, --DEFAULT 0,
        [LockoutEnd] DATETIME2 NULL,
        [LockoutEnabled] BIT NOT NULL, --DEFAULT 1,
        [AccessFailedCount] INT NOT NULL, --DEFAULT 0,
        -- Role NVARCHAR(50) NOT NULL, --DEFAULT 'User' CHECK (Role IN ('User', 'Admin', 'Staff')),
        [Status] VARCHAR(20) NOT NULL, --CHECK ([Status] IN ('Active', 'Inactive', 'Banned')) DEFAULT 'Active',
        CONSTRAINT [PK_Users] PRIMARY KEY ([UserId])
    );
    GO

CREATE TABLE Car (
    CarId UNIQUEIDENTIFIER NOT NULL,
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
    CONSTRAINT PK_Car PRIMARY KEY (CarId)
);

CREATE TABLE Booking (
    BookingId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    CarId UNIQUEIDENTIFIER NOT NULL,
    RentStartDate DATE NOT NULL,
    RentEndDate DATE NOT NULL,
    PickupLocation VARCHAR(100) NOT NULL,
    ReturnLocation VARCHAR(100) NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    DiscountId UNIQUEIDENTIFIER NULL,
    CONSTRAINT PK_Booking PRIMARY KEY (BookingId),
    CONSTRAINT FK_Booking_User FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    CONSTRAINT FK_Booking_Car FOREIGN KEY (CarId) REFERENCES Car(CarId) ON DELETE SET NULL,
    CONSTRAINT FK_Booking_Discount FOREIGN KEY (DiscountId) REFERENCES Discount(DiscountId),
    --CONSTRAINT CHK_Booking_Amount CHECK (TotalAmount >= 0),
    --CONSTRAINT CHK_Booking_Status CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')),
    --CONSTRAINT CHK_Booking_Dates CHECK (EndDate >= StartDate)
);

CREATE TABLE Contract (
    ContractId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    CarId UNIQUEIDENTIFIER NULL,
    BookingId UNIQUEIDENTIFIER NOT NULL,
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
    PaymentId UNIQUEIDENTIFIER NOT NULL,
    ContractId UNIQUEIDENTIFIER NOT NULL,
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
    DiscountId UNIQUEIDENTIFIER NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PricePerHour DECIMAL(10, 2) NOT NULL,
    PricePerDay DECIMAL(10, 2) NOT NULL,
    PricePerMonth DECIMAL(10, 2) NOT NULL,
    IsActive BIT NOT NULL, --DEFAULT 1,
    CONSTRAINT PK_Discount PRIMARY KEY (DiscountId)
    --CONSTRAINT CHK_Discount_Hour CHECK (PricePerHour >= 0),
    --CONSTRAINT CHK_Discount_Day CHECK (PricePerDay >= 0),
    --CONSTRAINT CHK_Discount_Month CHECK (PricePerMonth >= 0),
    --CONSTRAINT CHK_Discount_Active CHECK (IsActive IN (0, 1)),
    --CONSTRAINT CHK_Discount_Dates CHECK (EndDate >= StartDate)
);

CREATE TABLE Reviews (
    ReviewId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    CarId UNIQUEIDENTIFIER NOT NULL,
    Rating INT NOT NULL,
    Content NVARCHAR(4000) NULL,
    ReviewDate DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    CONSTRAINT PK_Reviews PRIMARY KEY (ReviewId),
    CONSTRAINT FK_Reviews_User FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    CONSTRAINT FK_Reviews_Car FOREIGN KEY (CarId) REFERENCES Car(CarId) ON DELETE SET NULL,
    --CONSTRAINT CHK_Review_Rating CHECK (Rating >= 1 AND Rating <= 5)
);

