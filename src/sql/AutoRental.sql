CREATE DATABASE [AutoRental];
GO

USE [AutoRental];
GO

-- Users Permission Table
CREATE TABLE [Roles] (
    [RoleId] UNIQUEIDENTIFIER NOT NULL,
    [RoleName] NVARCHAR(50) NULL,
    [NormalizedName] NVARCHAR(256) NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY ([RoleId])
);
GO

-- Users Information Table
CREATE TABLE [Users] (
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [Username] NVARCHAR(100) NOT NULL, --UNIQUE
    [UserDOB] DATE NULL, --CHECK ([UserDOB] <= DATEADD(YEAR, -18, GETDATE())),
    [PhoneNumber] NVARCHAR(11) NULL,
    [AvatarUrl] NVARCHAR(255) NULL,
    [Gender] NVARCHAR(10) NULL, --CHECK ([Gender] IN ('Male', 'Female', 'Other')),
    [FirstName] NVARCHAR(256) NULL,
    [LastName] NVARCHAR(256) NULL,
    [Status] VARCHAR(20) NOT NULL,--DEFAULT 'Active', -- Thay thế IsBanned
    [CreatedDate] DATETIME2 NULL ,--DEFAULT GETDATE(),
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
    CONSTRAINT [PK_Users] PRIMARY KEY ([UserId])
);
GO

CREATE TABLE [UserRoles] (
    [UserId] uniqueidentifier NOT NULL,
    [RoleId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_UserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_UserRoles_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Roles]([RoleId]) ON DELETE CASCADE
);
GO

-- Insert default roles
INSERT INTO [Roles] ([RoleId], [RoleName], [NormalizedName])
VALUES 
    ('7c9e6679-7425-40de-944b-e07fc1f90ae7', 'Admin', 'ADMIN'),
    ('550e8400-e29b-41d4-a716-446655440000', 'Staff', 'STAFF'),
    ('6ba7b810-9dad-11d1-80b4-00c04fd430c8', 'User', 'USER');
GO

CREATE TABLE [DriverLicenses] (
    [LicenseId] UNIQUEIDENTIFIER NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [LicenseNumber] NVARCHAR(50) NULL,
    [FullName] NVARCHAR(100) NULL,
    [DOB] DATE NULL,
    [LicenseImage] NVARCHAR(MAX) NULL,
    [CreatedDate] DATETIME2 NULL,-- DEFAULT GETDATE(),
    CONSTRAINT [PK_DriverLicenses] PRIMARY KEY ([LicenseId]),
    CONSTRAINT [FK_DriverLicenses_Users] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

CREATE TABLE [PasswordResetTokens] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Token] NVARCHAR(255) NOT NULL,
    [ExpiryTime] DATETIME NOT NULL,
    [IsUsed] BIT NOT NULL DEFAULT 0,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_PasswordResetTokens] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_PasswordResetTokens_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

CREATE TABLE [EmailVerificationTokens] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Token] NVARCHAR(255) NOT NULL,
    [ExpiryTime] DATETIME NOT NULL,
    [IsUsed] BIT NOT NULL DEFAULT 0,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_EmailVerificationTokens] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_EmailVerificationTokens_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

CREATE TABLE [UserLogins] (
    [LoginProvider] NVARCHAR(128) NOT NULL,
    [ProviderKey] NVARCHAR(128) NOT NULL,
    [ProviderDisplayName] NVARCHAR(MAX) NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_UserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_UserLogins_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

-- Car Information Table
CREATE TABLE [CarBrand] (
    [BrandId] UNIQUEIDENTIFIER NOT NULL,
    [BrandName] NVARCHAR(100) NOT NULL, --UNIQUE
    CONSTRAINT [PK_CarBrand] PRIMARY KEY ([BrandId])
);
GO

CREATE TABLE [TransmissionType] (
    [TransmissionTypeId] UNIQUEIDENTIFIER NOT NULL,
    [TransmissionName] NVARCHAR(100) NOT NULL, --UNIQUE
    CONSTRAINT [PK_TransmissionType] PRIMARY KEY ([TransmissionTypeId])
);
GO

CREATE TABLE [FuelType] (
    [FuelTypeId] UNIQUEIDENTIFIER NOT NULL,
    [FuelName] NVARCHAR(100) NOT NULL, --UNIQUE
    CONSTRAINT [PK_FuelType] PRIMARY KEY ([FuelTypeId])
);
GO

CREATE TABLE [CarCategories] (
    [CategoryId] UNIQUEIDENTIFIER NOT NULL,
    [CategoryName] NVARCHAR(100) NOT NULL, --UNIQUE
    CONSTRAINT [PK_CarCategories] PRIMARY KEY ([CategoryId])
);
GO

CREATE TABLE [CarFeature] (
    [FeatureId] UNIQUEIDENTIFIER NOT NULL,
    [FeatureName] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_CarFeature] PRIMARY KEY ([FeatureId])
);
GO

CREATE TABLE [Car] (
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [BrandId] UNIQUEIDENTIFIER NOT NULL,
    [CarModel] NVARCHAR(50) NOT NULL,
    [YearManufactured] INT, --CHECK ([YearManufactured] >= 1900 AND [YearManufactured] <= 2025),
    [TransmissionTypeId] UNIQUEIDENTIFIER NOT NULL,
    [FuelTypeId] UNIQUEIDENTIFIER NOT NULL,
    [LicensePlate] NVARCHAR(20) NOT NULL, --UNIQUE
    [Seats] INT NOT NULL, --CHECK ([Seats] > 0),
    [Odometer] INT NOT NULL, --CHECK ([Odometer] >= 0),
    [PricePerHour] DECIMAL(10,2) NOT NULL, --CHECK ([PricePerHour] >= 0),
    [PricePerDay] DECIMAL(10,2) NOT NULL, --CHECK ([PricePerDay] >= 0),
    [PricePerMonth] DECIMAL(10,2) NOT NULL, --CHECK ([PricePerMonth] >= 0),
    [Status] VARCHAR(20) NOT NULL, --CHECK ([Status] IN ('Available', 'Rented', 'Unavailable')) DEFAULT 'Available',
    [Description] NVARCHAR(500) NULL,
    [CreatedDate] DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    [CategoryId] UNIQUEIDENTIFIER NULL,
    [LastUpdatedBy] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_Car] PRIMARY KEY ([CarId]),
    CONSTRAINT [FK_Car_BrandId] FOREIGN KEY ([BrandId]) REFERENCES [CarBrand]([BrandId]),
    CONSTRAINT [FK_Car_TransmissionTypeId] FOREIGN KEY ([TransmissionTypeId]) REFERENCES [TransmissionType]([TransmissionTypeId]),
    CONSTRAINT [FK_Car_FuelTypeId] FOREIGN KEY ([FuelTypeId]) REFERENCES [FuelType]([FuelTypeId]),
    CONSTRAINT [FK_Car_LastUpdatedBy] FOREIGN KEY ([LastUpdatedBy]) REFERENCES [Users]([UserId]) ON DELETE SET NULL,
    CONSTRAINT [FK_Car_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [CarCategories]([CategoryId])
);
GO

CREATE TABLE [CarImages] (
    [ImageId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [ImageUrl] NVARCHAR(255) NOT NULL,
    [IsMain] BIT NOT NULL, --DEFAULT 0,
    CONSTRAINT [PK_CarImages] PRIMARY KEY ([ImageId]),
    CONSTRAINT [FK_CarImages_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE
);
GO

CREATE TABLE [CarFeaturesMapping] (
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [FeatureId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_CarFeaturesMapping] PRIMARY KEY ([CarId], [FeatureId]),
    CONSTRAINT [FK_CarFeaturesMapping_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE,
    CONSTRAINT [FK_CarFeaturesMapping_FeatureId] FOREIGN KEY ([FeatureId]) REFERENCES [CarFeature]([FeatureId]) ON DELETE CASCADE
);
GO

CREATE TABLE [CarMaintenanceHistory] (
    [MaintenanceId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [MaintenanceDate] DATE NOT NULL DEFAULT GETDATE(),
    [Description] NVARCHAR(500) NULL,
    [Cost] DECIMAL(10,2) NULL,
    [StaffId] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_CarMaintenanceHistory] PRIMARY KEY ([MaintenanceId]),
    CONSTRAINT [FK_CarMaintenanceHistory_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE,
    CONSTRAINT [FK_CarMaintenanceHistory_StaffId] FOREIGN KEY ([StaffId]) REFERENCES [Users]([UserId]) ON DELETE SET NULL
);
GO

CREATE TABLE [CarRentalPricingRule] (
    [RuleId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NULL, -- NULL: áp dụng cho tất cả xe, hoặc chỉ định xe cụ thể
    [RuleType] NVARCHAR(50) NOT NULL, -- 'Holiday', 'Weekend', 'Special', 'Demand'
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NOT NULL,
    [PricePerDay] DECIMAL(10,2) NULL, -- Giá cố định nếu có
    [PriceMultiplier] DECIMAL(5,2) NULL, -- Hệ số nhân giá (ví dụ: 1.2 = tăng 20%)
    [MinBookings] INT NULL, -- Số booking tối thiểu để áp dụng rule (cho rule theo nhu cầu)
    [Description] NVARCHAR(255) NULL,
    CONSTRAINT [PK_CarRentalPricingRule] PRIMARY KEY ([RuleId]),
    CONSTRAINT [FK_CarRentalPricingRule_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE SET NULL
);
GO

CREATE TABLE [CarRentalPriceHistory] (
    [PriceId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NULL, -- NULL nghĩa là còn hiệu lực đến hiện tại
    [PricePerHour] DECIMAL(10,2) NOT NULL,
    [PricePerDay] DECIMAL(10,2) NOT NULL,
    [PricePerMonth] DECIMAL(10,2) NOT NULL,
    [Note] NVARCHAR(255) NULL,
    CONSTRAINT [PK_CarRentalPriceHistory] PRIMARY KEY ([PriceId]),
    CONSTRAINT [FK_CarRentalPriceHistory_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE
);
GO

CREATE TABLE [Discount] (
    [DiscountId] UNIQUEIDENTIFIER NOT NULL,
    [DiscountName] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    [DiscountType] NVARCHAR(20) NOT NULL, -- 'Percent' hoặc 'Fixed'
    [DiscountValue] DECIMAL(10,2) NOT NULL, -- Nếu là Percent thì 0-100, nếu Fixed thì là số tiền
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NOT NULL,
    [IsActive] BIT NOT NULL,-- NULL DEFAULT 1,
    [CreatedDate] DATETIME2 NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_Discount] PRIMARY KEY ([DiscountId])
);
GO

CREATE TABLE [Booking] (
    [BookingId] UNIQUEIDENTIFIER NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NULL,
    [HandledBy] UNIQUEIDENTIFIER NULL,
    [PickupDateTime] DATETIME2 NOT NULL,
    [ReturnDateTime] DATETIME2 NOT NULL,
    [TotalAmount] DECIMAL(10, 2) NOT NULL, --CHECK ([TotalAmount] >= 0),
    [Status] VARCHAR(20) NOT NULL, --CHECK ([Status] IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')) DEFAULT 'Pending',
    [DiscountId] UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    [CancelReason] NVARCHAR(255) NULL,
    [BookingCode] NVARCHAR(20) NULL, --UNIQUE
    [ExpectedPaymentMethod] NVARCHAR(50) NULL,
    CONSTRAINT [PK_Booking] PRIMARY KEY ([BookingId]),
    CONSTRAINT [FK_Booking_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_Booking_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE SET NULL,
    CONSTRAINT [FK_Booking_HandledBy] FOREIGN KEY ([HandledBy]) REFERENCES [Users]([UserId]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Booking_DiscountId] FOREIGN KEY ([DiscountId]) REFERENCES [Discount]([DiscountId]) ON DELETE SET NULL
);
GO

CREATE TABLE [BookingApproval] (
    [ApprovalId] UNIQUEIDENTIFIER NOT NULL,
    [BookingId] UNIQUEIDENTIFIER NOT NULL,
    [StaffId] UNIQUEIDENTIFIER NOT NULL,
    [ApprovalStatus] VARCHAR(20) NOT NULL, -- 'Approved', 'Rejected'
    [ApprovalDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [Note] NVARCHAR(500) NULL,
    [RejectionReason] NVARCHAR(500) NULL,
    CONSTRAINT [PK_BookingApproval] PRIMARY KEY ([ApprovalId]),
    CONSTRAINT [FK_BookingApproval_BookingId] FOREIGN KEY ([BookingId]) REFERENCES [Booking]([BookingId]) ON DELETE CASCADE,
    CONSTRAINT [FK_BookingApproval_StaffId] FOREIGN KEY ([StaffId]) REFERENCES [Users]([UserId])
);
GO

CREATE TABLE [SupportTickets] (
    [TicketId] UNIQUEIDENTIFIER NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [HandledBy] UNIQUEIDENTIFIER NULL,
    [Subject] NVARCHAR(200) NOT NULL,
    [Content] NVARCHAR(MAX) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    [Status] VARCHAR(20) NOT NULL, --CHECK ([Status] IN ('Open', 'InProgress', 'Resolved', 'Closed')) DEFAULT 'Open',
    CONSTRAINT [PK_SupportTickets] PRIMARY KEY ([TicketId]),
    CONSTRAINT [FK_SupportTickets_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_SupportTickets_HandledBy] FOREIGN KEY ([HandledBy]) REFERENCES [Users]([UserId]) ON DELETE NO ACTION
);
GO

CREATE TABLE [BookingSurcharges] (
    [SurchargeId] UNIQUEIDENTIFIER NOT NULL,
    [BookingId] UNIQUEIDENTIFIER NOT NULL,
    [SurchargeType] NVARCHAR(50) NOT NULL, -- 'LateReturn', 'OverMileage', ...
    [Amount] DECIMAL(10,2) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_BookingSurcharges] PRIMARY KEY ([SurchargeId]),
    CONSTRAINT [FK_BookingSurcharges_BookingId] FOREIGN KEY ([BookingId]) REFERENCES [Booking]([BookingId]) ON DELETE CASCADE
);
GO

CREATE TABLE [Contract] (
    [ContractId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL, 
    [BookingId] UNIQUEIDENTIFIER NOT NULL, 
    [ContractContent] NVARCHAR(MAX) NOT NULL, 
    [PickupDateTime] DATETIME2 NOT NULL, -- Ngày bắt đầu thuê xe
    [ReturnDateTime] DATETIME2 NOT NULL, -- Ngày kết thúc thuê xe
    [TotalPrice] DECIMAL(10, 2) NOT NULL, -- Tổng giá trị hợp đồng
    [DepositAmount] DECIMAL(10, 2) NOT NULL, -- Số tiền đặt cọc
    [DepositStatus] VARCHAR(20) NOT NULL, -- Pending, Paid, Failed, Refunded
    [Status] VARCHAR(20) NOT NULL, --DEFAULT 'Created', Created, Pending, Active, Completed, Cancelled, Terminated
    [CompanyRepresentativeId] UNIQUEIDENTIFIER NOT NULL, -- ID của nhân viên duyệt
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(), -- Ngày tạo hợp đồng
    [ContractFile] NVARCHAR(MAX) NULL, -- Đường dẫn file hợp đồng
    [ContractCode] NVARCHAR(20) NOT NULL, -- Mã hợp đồng
    CONSTRAINT [PK_Contract] PRIMARY KEY ([ContractId]),
    CONSTRAINT [FK_Contract_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_Contract_BookingId] FOREIGN KEY ([BookingId]) REFERENCES [Booking]([BookingId]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Contract_CompanyRepresentativeId] FOREIGN KEY ([CompanyRepresentativeId]) REFERENCES [Users]([UserId])
);
GO

CREATE TABLE [ContractCars] (
    [ContractCarId] UNIQUEIDENTIFIER NOT NULL,
    [ContractId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [PricePerCar] DECIMAL(10,2) NULL, 
    [DiscountId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_ContractCars] PRIMARY KEY ([ContractCarId]),
    CONSTRAINT [FK_ContractCars_ContractId] FOREIGN KEY ([ContractId]) REFERENCES [Contract]([ContractId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ContractCars_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ContractCars_DiscountId] FOREIGN KEY ([DiscountId]) REFERENCES [Discount]([DiscountId]) ON DELETE SET NULL
);
GO

CREATE TABLE [Payment] (
    [PaymentId] UNIQUEIDENTIFIER NOT NULL,
    [ContractId] UNIQUEIDENTIFIER NOT NULL,
    [PaymentDate] DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    [TotalAmount] DECIMAL(10, 2) NOT NULL, --CHECK ([TotalAmount] >= 0),
    [PaymentStatus] VARCHAR(20) NOT NULL, --CHECK ([PaymentStatus] IN ('Pending', 'Completed', 'Failed')) DEFAULT 'Pending',
    [PaymentMethod] VARCHAR(50) NOT NULL,
    [PaymentType] VARCHAR(20) NOT NULL, --CHECK ([PaymentType] IN ('Deposit', 'FullPayment', 'PartialPayment')),
    [TransactionId] NVARCHAR(100) NULL,
    [UserId] UNIQUEIDENTIFIER NULL,
    [Note] NVARCHAR(255) NULL,
    [Currency] NVARCHAR(10) NULL,
    [CreatedDate] DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    CONSTRAINT [PK_Payment] PRIMARY KEY ([PaymentId]),
    CONSTRAINT [FK_Payment_ContractId] FOREIGN KEY ([ContractId]) REFERENCES [Contract]([ContractId]) ON DELETE CASCADE,
    CONSTRAINT [FK_Payment_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE NO ACTION
);
GO

CREATE TABLE [CarConditionLogs] (
    [LogId] UNIQUEIDENTIFIER NOT NULL,
    [BookingId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [StaffId] UNIQUEIDENTIFIER NULL,
    [CheckType] NVARCHAR(20) NOT NULL, -- 'Pickup', 'Return'
    [CheckTime] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [Odometer] INT NULL,
    [FuelLevel] NVARCHAR(20) NULL, -- Mức xăng/dầu
    [ConditionStatus] NVARCHAR(100) NULL, -- Tình trạng tổng quát: 'Good', 'Need Maintenance', 'Damaged', ...
    [ConditionDescription] NVARCHAR(1000) NULL, -- Mô tả chi tiết
    [DamageImages] NVARCHAR(MAX) NULL, -- Link ảnh hư hại
    [Note] NVARCHAR(255) NULL, -- Ghi chú thêm
    CONSTRAINT [PK_CarConditionLogs] PRIMARY KEY ([LogId]),
    CONSTRAINT [FK_CarConditionLogs_BookingId] FOREIGN KEY ([BookingId]) REFERENCES [Booking]([BookingId]) ON DELETE CASCADE,
    CONSTRAINT [FK_CarConditionLogs_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE,
    CONSTRAINT [FK_CarConditionLogs_StaffId] FOREIGN KEY ([StaffId]) REFERENCES [Users]([UserId]) ON DELETE NO ACTION
);
GO

CREATE TABLE [Notification] (
    [NotificationId] UNIQUEIDENTIFIER NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [Message] NVARCHAR(MAX) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    CONSTRAINT [PK_Notification] PRIMARY KEY ([NotificationId]),
    CONSTRAINT [FK_Notification_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

CREATE TABLE [UserFeedback] (
    [FeedbackId] UNIQUEIDENTIFIER NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NULL,
    [Rating] INT NOT NULL, --CHECK ([Rating] >= 1 AND [Rating] <= 5),
    [Content] NVARCHAR(4000) NULL,
    [Reviewed] DATE NOT NULL, --DEFAULT GETDATE(),
    [CreatedDate] DATETIME2 NOT NULL, --DEFAULT GETDATE(),
    [IsApproved] BIT NOT NULL, --DEFAULT 0,
    CONSTRAINT [PK_UserFeedback] PRIMARY KEY ([FeedbackId]),
    CONSTRAINT [FK_UserFeedback_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserFeedback_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE SET NULL
);
GO

CREATE TABLE [AccountDeletionLogs] (
    [LogId] UNIQUEIDENTIFIER NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [DeletionReason] NVARCHAR(255) NOT NULL,
    [AdditionalComments] NVARCHAR(MAX) NULL,
    [Timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_AccountDeletionLogs] PRIMARY KEY ([LogId]),
    CONSTRAINT [FK_AccountDeletionLogs_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO 

-- Insert Staff User
INSERT INTO [Users] (
    [UserId],
    [Username],
    [Email],
    [PasswordHash],
    [FirstName],
    [LastName],
    [Status],
    [EmailVerifed],
    [TwoFactorEnabled],
    [LockoutEnabled],
    [AccessFailedCount],
    [CreatedDate]
)
VALUES (
    '11111111-1111-1111-1111-111111111111', -- Staff User ID
    'staff',
    'staff@autorental.com',
    'AQAAAAEAACcQAAAAELbXp1QrHhJ8vC8YwX8YwX8YwX8YwX8YwX8YwX8YwX8YwX8YwX8YwX8YwX8YwX8Yw==', -- Hashed password: Staff@123
    'Staff',
    'User',
    'Active',
    1, -- Email verified
    0, -- Two factor disabled
    1, -- Lockout enabled
    0, -- Access failed count
    GETDATE()
);
GO

-- Assign Staff Role
INSERT INTO [UserRoles] (
    [UserId],
    [RoleId]
)
VALUES (
    '11111111-1111-1111-1111-111111111111', -- Staff User ID
    '550e8400-e29b-41d4-a716-446655440000'  -- Staff Role ID
);
GO
-- Brand
INSERT INTO CarBrand (BrandId, BrandName) VALUES
('11111111-1111-1111-1111-111111111111', N'Toyota'),
('22222222-2222-2222-2222-222222222222', N'Honda'),
('99999999-9999-9999-9999-999999999999', N'Hyundai'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Ford');

-- TransmissionType
INSERT INTO TransmissionType (TransmissionTypeId, TransmissionName) VALUES
('33333333-3333-3333-3333-333333333333', N'Số tự động'),
('44444444-4444-4444-4444-444444444444', N'Số sàn');

-- FuelType
INSERT INTO FuelType (FuelTypeId, FuelName) VALUES
('55555555-5555-5555-5555-555555555555', N'Xăng'),
('66666666-6666-6666-6666-666666666666', N'Dầu');

-- CarCategories
INSERT INTO CarCategories (CategoryId, CategoryName) VALUES
('77777777-7777-7777-7777-777777777777', N'Xe 4 chỗ'),
('88888888-8888-8888-8888-888888888888', N'Xe 7 chỗ');

INSERT INTO Car (CarId, BrandId, CarModel, YearManufactured, TransmissionTypeId, FuelTypeId, LicensePlate, Seats, Odometer, PricePerHour, PricePerDay, PricePerMonth, Status, Description, CreatedDate, CategoryId, LastUpdatedBy)
VALUES
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '11111111-1111-1111-1111-111111111111', N'Toyota Vios', 2020, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-12345', 5, 35000, 8, 40, 900, 'Available', N'Xe gia đình tiết kiệm xăng', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '22222222-2222-2222-2222-222222222222', N'Honda City', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-23456', 5, 25000, 9, 45, 950, 'Available', N'Xe rộng rãi, phù hợp đi chơi', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '11111111-1111-1111-1111-111111111111', N'Toyota Innova', 2019, '44444444-4444-4444-4444-444444444444', '66666666-6666-6666-6666-666666666666', '30A-34567', 7, 60000, 12, 60, 1200, 'Available', N'Xe 7 chỗ cho gia đình', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', '22222222-2222-2222-2222-222222222222', N'Honda CRV', 2022, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-45678', 7, 20000, 15, 80, 1500, 'Available', N'Xe SUV mạnh mẽ', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', '11111111-1111-1111-1111-111111111111', N'Toyota Fortuner', 2018, '44444444-4444-4444-4444-444444444444', '66666666-6666-6666-6666-666666666666', '30A-56789', 7, 80000, 10, 55, 1100, 'Available', N'Xe 7 chỗ gầm cao', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '99999999-9999-9999-9999-999999999999', N'Hyundai Accent', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-11223', 5, 15000, 10, 50, 1000, 'Available', N'Sedan nhỏ gọn, tiết kiệm nhiên liệu', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', '99999999-9999-9999-9999-999999999999', N'Hyundai SantaFe', 2022, '33333333-3333-3333-3333-333333333333', '66666666-6666-6666-6666-666666666666', '30A-22334', 7, 10000, 18, 90, 1700, 'Available', N'SUV 7 chỗ, mạnh mẽ', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Ford Ranger', 2020, '44444444-4444-4444-4444-444444444444', '66666666-6666-6666-6666-666666666666', '30A-33445', 5, 30000, 20, 100, 1800, 'Available', N'Bán tải đa dụng, mạnh mẽ', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Ford Everest', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-44556', 7, 25000, 17, 85, 1600, 'Available', N'SUV 7 chỗ, tiện nghi', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '11111111-1111-1111-1111-111111111111', N'Toyota Camry', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-67890', 5, 18000, 14, 70, 1300, 'Available', N'Sedan cao cấp, sang trọng', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '99999999-9999-9999-9999-999999999999', N'Hyundai Elantra', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-55667', 5, 20000, 11, 55, 1100, 'Available', N'Sedan hiện đại, tiết kiệm nhiên liệu', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Ford EcoSport', 2022, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-66778', 5, 15000, 12, 60, 1200, 'Available', N'SUV nhỏ gọn, phù hợp cho gia đình', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL);

INSERT INTO CarImages (ImageId, CarId, ImageUrl, IsMain) VALUES
(NEWID(), 'a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '/assets/images/toyota_vios.jpg', 1),
(NEWID(), 'a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '/assets/images/honda_city.jpg', 1),
(NEWID(), 'a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '/assets/images/toyota_innova.jpg', 1),
(NEWID(), 'a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', '/assets/images/honda_CRV.jpg', 1),
(NEWID(), 'a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', '/assets/images/toyota_fortuner.jpg', 1),
(NEWID(), 'c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '/assets/images/hyundai_accent.jpg', 1),
(NEWID(), 'c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', '/assets/images/hyundai_santaFe.jpg', 1),
(NEWID(), 'd1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', '/assets/images/ford_ranger.jpg', 1),
(NEWID(), 'd2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', '/assets/images/ford_everest.jpg', 1),
(NEWID(), 'b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '/assets/images/toyota_camry.jpg', 1),
(NEWID(), 'e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '/assets/images/hyundai_elantra.jpg', 1),
(NEWID(), 'e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', '/assets/images/ford_ecosport.jpg', 1);

