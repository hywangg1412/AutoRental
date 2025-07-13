
-- ===================================================================
-- AUTORENTAL DATABASE - PHIÊN BẢN HỢP NHẤT VỚI TÍNH NĂNG DEPOSIT
-- Phiên bản: 2.5
-- Mô tả: Cơ sở dữ liệu hoàn chỉnh cho hệ thống thuê xe ô tô, giữ nguyên các bảng liên quan đến booking, deposit và discount từ AutoRental_verDeposit.sql, thay thế bảng BookingSurcharges theo yêu cầu, các bảng không liên quan sửa CHECK constraints thành comment để tương thích với AutoRental.sql. Sửa lỗi cú pháp, xung đột bảng, và khóa chính.
-- Tương thích: SQL Server 2019+
-- Cập nhật lần cuối: 09/07/2025
-- ===================================================================

-- Xóa database nếu đã tồn tại
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'AutoRental4')
BEGIN
    DROP DATABASE [AutoRental4];
    PRINT 'Đã xóa cơ sở dữ liệu AutoRental4';
END
GO

-- Tạo database mới
CREATE DATABASE [AutoRental4];
GO

USE [AutoRental4];
GO

-- ===================================================================
-- PHẦN 1: TẠO CÁC BẢNG KHÔNG PHỤ THUỘC HOẶC PHỤ THUỘC ĐƠN GIẢN
-- ===================================================================

-- Bảng Roles
CREATE TABLE [Roles] (
    [RoleId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [RoleName] NVARCHAR(50) NULL,
    [NormalizedName] NVARCHAR(256) NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY ([RoleId])
);
GO

-- Bảng CarBrand
CREATE TABLE [CarBrand] (
   [BrandId] UNIQUEIDENTIFIER NOT NULL,
    [BrandName] NVARCHAR(100) NOT NULL, --UNIQUE
    CONSTRAINT [PK_CarBrand] PRIMARY KEY ([BrandId])
);
GO

-- Bảng TransmissionType
CREATE TABLE [TransmissionType] (
    [TransmissionTypeId] UNIQUEIDENTIFIER NOT NULL,
    [TransmissionName] NVARCHAR(100) NOT NULL, --UNIQUE
    CONSTRAINT [PK_TransmissionType] PRIMARY KEY ([TransmissionTypeId])
);
GO

-- Bảng FuelType
CREATE TABLE [FuelType] (
    [FuelTypeId] UNIQUEIDENTIFIER NOT NULL,
    [FuelName] NVARCHAR(100) NOT NULL, --UNIQUE
    CONSTRAINT [PK_FuelType] PRIMARY KEY ([FuelTypeId])
);
GO

-- Bảng CarCategories
CREATE TABLE [CarCategories] (
    [CategoryId] UNIQUEIDENTIFIER NOT NULL,
    [CategoryName] NVARCHAR(100) NOT NULL, --UNIQUE
    CONSTRAINT [PK_CarCategories] PRIMARY KEY ([CategoryId])
);
GO

-- Bảng CarFeature
CREATE TABLE [CarFeature] (
    [FeatureId] UNIQUEIDENTIFIER NOT NULL,
    [FeatureName] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_CarFeature] PRIMARY KEY ([FeatureId])
);
GO

-- Bảng Insurance
CREATE TABLE [Insurance] (
    InsuranceId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    InsuranceName NVARCHAR(100) NOT NULL,
    InsuranceType NVARCHAR(50) NOT NULL,
    BaseRatePerDay DECIMAL(10,2) NOT NULL,
    PercentageRate DECIMAL(5,2) NULL,
    CoverageAmount DECIMAL(15,2) NOT NULL,
    ApplicableCarSeats NVARCHAR(50) NULL,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Insurance PRIMARY KEY (InsuranceId)
);
GO

-- Bảng Discount
CREATE TABLE [Discount] (
    DiscountId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    DiscountName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    DiscountType NVARCHAR(20) NOT NULL,
    DiscountValue DECIMAL(10,2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    VoucherCode NVARCHAR(20) NULL UNIQUE,
    MinOrderAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    MaxDiscountAmount DECIMAL(10,2) NULL,
    UsageLimit INT NULL,
    UsedCount INT NOT NULL DEFAULT 0,
    DiscountCategory NVARCHAR(20) NOT NULL DEFAULT 'General',
    CONSTRAINT PK_Discount PRIMARY KEY (DiscountId)
    -- CONSTRAINT CHK_Discount_Type CHECK (DiscountType IN ('Percent', 'Fixed')),
    -- CONSTRAINT CHK_Discount_Value CHECK (DiscountValue >= 0)
);
GO

-- Bảng Terms
CREATE TABLE [Terms] (
    TermsId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    Version NVARCHAR(10) NOT NULL UNIQUE,
    Title NVARCHAR(200) NOT NULL,
    ShortContent NVARCHAR(MAX) NULL,
    FullContent NVARCHAR(MAX) NOT NULL,
    EffectiveDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Terms PRIMARY KEY (TermsId)
);
GO

-- ===================================================================
-- PHẦN 2: TẠO CÁC BẢNG PHỤ THUỘC VÀO ROLES, CARBRAND, V.V.
-- ===================================================================

-- Bảng Users
CREATE TABLE [Users] (
    [UserId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [Username] NVARCHAR(100) NOT NULL UNIQUE,
    [UserDOB] DATE NULL,
    [PhoneNumber] NVARCHAR(11) NULL,
    [AvatarUrl] NVARCHAR(255) NULL,
    [Gender] NVARCHAR(10) NULL,
    [FirstName] NVARCHAR(256) NULL,
    [LastName] NVARCHAR(256) NULL,
    [Status] VARCHAR(20) NOT NULL DEFAULT 'Active',
    [RoleId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDate] DATETIME2 NULL DEFAULT GETDATE(),
    [NormalizedUserName] NVARCHAR(256) NULL,
    [Email] NVARCHAR(100) NOT NULL UNIQUE,
    [NormalizedEmail] NVARCHAR(256) NULL,
    [EmailVerifed] BIT NOT NULL DEFAULT 0,
    [PasswordHash] NVARCHAR(255) NOT NULL,
    [SecurityStamp] NVARCHAR(MAX) NULL,
    [ConcurrencyStamp] NVARCHAR(MAX) NULL,
    [TwoFactorEnabled] BIT NOT NULL DEFAULT 0,
    [LockoutEnd] DATETIME2 NULL,
    [LockoutEnabled] BIT NOT NULL DEFAULT 1,
    [AccessFailedCount] INT NOT NULL DEFAULT 0,
    CONSTRAINT [PK_Users] PRIMARY KEY ([UserId]),
    CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleId]) REFERENCES [Roles]([RoleId]) ON DELETE CASCADE
    -- CONSTRAINT [CHK_Users_DOB] CHECK ([UserDOB] <= DATEADD(YEAR, -18, GETDATE())),
    -- CONSTRAINT [CHK_Users_Gender] CHECK ([Gender] IN ('Male', 'Female', 'Other'))
);
GO

-- Bảng Car
CREATE TABLE [Car] (
   [CarId] UNIQUEIDENTIFIER NOT NULL,
    [BrandId] UNIQUEIDENTIFIER NOT NULL,
    [CarModel] NVARCHAR(50) NOT NULL,
    [YearManufactured] INT,
    [TransmissionTypeId] UNIQUEIDENTIFIER NOT NULL,
    [FuelTypeId] UNIQUEIDENTIFIER NOT NULL,
    [LicensePlate] NVARCHAR(20) NOT NULL UNIQUE,
    [Seats] INT NOT NULL,
    [Odometer] INT NOT NULL,
    [PricePerHour] DECIMAL(10,2) NOT NULL,
    [PricePerDay] DECIMAL(10,2) NOT NULL,
    [PricePerMonth] DECIMAL(10,2) NOT NULL,
    [Status] VARCHAR(20) NOT NULL DEFAULT 'Available',
    [Description] NVARCHAR(500) NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [CategoryId] UNIQUEIDENTIFIER NULL,
    [LastUpdatedBy] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_Car] PRIMARY KEY ([CarId]),
    CONSTRAINT [FK_Car_BrandId] FOREIGN KEY ([BrandId]) REFERENCES [CarBrand]([BrandId]),
    CONSTRAINT [FK_Car_TransmissionTypeId] FOREIGN KEY ([TransmissionTypeId]) REFERENCES [TransmissionType]([TransmissionTypeId]),
    CONSTRAINT [FK_Car_FuelTypeId] FOREIGN KEY ([FuelTypeId]) REFERENCES [FuelType]([FuelTypeId]),
    CONSTRAINT [FK_Car_LastUpdatedBy] FOREIGN KEY ([LastUpdatedBy]) REFERENCES [Users]([UserId]) ON DELETE SET NULL,
    CONSTRAINT [FK_Car_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [CarCategories]([CategoryId])
    -- CONSTRAINT [CHK_Car_Year] CHECK ([YearManufactured] >= 1900 AND [YearManufactured] <= 2025),
    -- CONSTRAINT [CHK_Car_Seats] CHECK ([Seats] > 0),
    -- CONSTRAINT [CHK_Car_Odometer] CHECK ([Odometer] >= 0),
    -- CONSTRAINT [CHK_Car_Prices] CHECK ([PricePerHour] >= 0 AND [PricePerDay] >= 0 AND [PricePerMonth] >= 0),
    -- CONSTRAINT [CHK_Car_Status] CHECK ([Status] IN ('Available', 'Rented', 'Unavailable'))
);
GO

-- ===================================================================
-- PHẦN 3: TẠO CÁC BẢNG LIÊN QUAN ĐẾN BOOKING/DEPOSIT/DISCOUNT
-- ===================================================================

-- Bảng Booking
CREATE TABLE [Booking] (
    BookingId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    CarId UNIQUEIDENTIFIER NOT NULL,
    HandledBy UNIQUEIDENTIFIER NULL,
    PickupDateTime DATETIME2 NOT NULL,
    ReturnDateTime DATETIME2 NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    DiscountId UNIQUEIDENTIFIER NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    CancelReason NVARCHAR(500) NULL,
    BookingCode NVARCHAR(20) NOT NULL UNIQUE,
    ExpectedPaymentMethod NVARCHAR(50) NULL,
    RentalType NVARCHAR(10) NOT NULL DEFAULT 'daily',
    CustomerName NVARCHAR(100) NULL,
    CustomerPhone NVARCHAR(15) NULL,
    CustomerAddress NVARCHAR(255) NULL,
    CustomerEmail NVARCHAR(100) NULL,
    DriverLicenseImageUrl NVARCHAR(500) NULL,
    TermsAgreed BIT NOT NULL DEFAULT 0,
    TermsAgreedAt DATETIME2 NULL,
    TermsVersion NVARCHAR(10) NULL DEFAULT 'v1.0',
    CONSTRAINT PK_Booking PRIMARY KEY (BookingId),
    CONSTRAINT FK_Booking_Users FOREIGN KEY (UserId) REFERENCES [Users](UserId) ON DELETE CASCADE,
    CONSTRAINT FK_Booking_Car FOREIGN KEY (CarId) REFERENCES [Car](CarId) ON DELETE NO ACTION,
    CONSTRAINT FK_Booking_HandledBy FOREIGN KEY (HandledBy) REFERENCES [Users](UserId) ON DELETE NO ACTION,
    CONSTRAINT FK_Booking_DiscountId FOREIGN KEY (DiscountId) REFERENCES [Discount](DiscountId) ON DELETE SET NULL,
    CONSTRAINT CHK_Booking_RentalType CHECK (RentalType IN ('hourly', 'daily', 'monthly')),
    CONSTRAINT CHK_Booking_Amount CHECK (TotalAmount >= 0)
);
GO

-- Bảng Contract
CREATE TABLE [Contract] (
    ContractId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    BookingId UNIQUEIDENTIFIER NOT NULL,
    ContractNumber NVARCHAR(20) NOT NULL UNIQUE,
    SignedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    ContractTerms NVARCHAR(MAX) NULL,
    CustomerSignature NVARCHAR(500) NULL,
    StaffSignature NVARCHAR(500) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Draft',
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    TotalPrice DECIMAL(10,2) NOT NULL,
    DepositAmount DECIMAL(10,2) NOT NULL,
    DepositStatus NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_Contract PRIMARY KEY (ContractId),
    CONSTRAINT FK_Contract_Booking FOREIGN KEY (BookingId) REFERENCES [Booking](BookingId) ON DELETE CASCADE,
    CONSTRAINT CHK_Contract_Amounts CHECK (TotalPrice >= 0 AND DepositAmount >= 0)
);
GO

-- Bảng ContractCars
CREATE TABLE [ContractCars] (
    ContractCarId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    ContractId UNIQUEIDENTIFIER NOT NULL,
    CarId UNIQUEIDENTIFIER NOT NULL,
    PricePerCar DECIMAL(10,2) NULL,
    DiscountId UNIQUEIDENTIFIER NULL,
    CONSTRAINT PK_ContractCars PRIMARY KEY (ContractCarId),
    CONSTRAINT FK_ContractCars_ContractId FOREIGN KEY (ContractId) REFERENCES [Contract](ContractId) ON DELETE CASCADE,
    CONSTRAINT FK_ContractCars_CarId FOREIGN KEY (CarId) REFERENCES [Car](CarId) ON DELETE CASCADE,
    CONSTRAINT FK_ContractCars_DiscountId FOREIGN KEY (DiscountId) REFERENCES [Discount](DiscountId) ON DELETE SET NULL
);
GO

-- Bảng BookingInsurance
CREATE TABLE [BookingInsurance] (
    BookingInsuranceId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    BookingId UNIQUEIDENTIFIER NOT NULL,
    InsuranceId UNIQUEIDENTIFIER NOT NULL,
    PremiumAmount DECIMAL(10,2) NOT NULL,
    RentalDays DECIMAL(10,2) NOT NULL,
    CarSeats INT NOT NULL,
    EstimatedCarValue DECIMAL(15,2) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_BookingInsurance PRIMARY KEY (BookingInsuranceId),
    CONSTRAINT FK_BookingInsurance_Booking FOREIGN KEY (BookingId) REFERENCES [Booking](BookingId) ON DELETE CASCADE,
    CONSTRAINT FK_BookingInsurance_Insurance FOREIGN KEY (InsuranceId) REFERENCES [Insurance](InsuranceId)
);
GO

-- Bảng BookingSurcharges
CREATE TABLE [BookingSurcharges] (
    SurchargeId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    BookingId UNIQUEIDENTIFIER NOT NULL,
    SurchargeType NVARCHAR(50) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Description NVARCHAR(255) NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    SurchargeCategory NVARCHAR(50) NULL,
    IsSystemGenerated BIT NOT NULL DEFAULT 0,
    CONSTRAINT PK_BookingSurcharges PRIMARY KEY (SurchargeId),
    CONSTRAINT FK_BookingSurcharges_Booking FOREIGN KEY (BookingId) REFERENCES [Booking](BookingId) ON DELETE CASCADE,
    -- CONSTRAINT CHK_BookingSurcharges_Category CHECK (SurchargeCategory IN ('Tax', 'Insurance', 'Penalty', 'Service')) -- Comment để backend Java xử lý
    CONSTRAINT CHK_BookingSurcharges_Amount CHECK (Amount >= 0)
);
GO

-- Bảng BookingApproval
CREATE TABLE [BookingApproval] (
    ApprovalId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    BookingId UNIQUEIDENTIFIER NOT NULL,
    StaffId UNIQUEIDENTIFIER NOT NULL,
    ApprovalStatus NVARCHAR(20) NOT NULL,
    ApprovalDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    Note NVARCHAR(500) NULL,
    RejectionReason NVARCHAR(500) NULL,
    CONSTRAINT PK_BookingApproval PRIMARY KEY (ApprovalId),
    CONSTRAINT FK_BookingApproval_BookingId FOREIGN KEY (BookingId) REFERENCES [Booking](BookingId) ON DELETE CASCADE,
    CONSTRAINT FK_BookingApproval_StaffId FOREIGN KEY (StaffId) REFERENCES [Users](UserId)
);
GO

-- Bảng Payment
CREATE TABLE [Payment] (
    [PaymentId] UNIQUEIDENTIFIER NOT NULL,                -- ID của payment
    [BookingId] UNIQUEIDENTIFIER NOT NULL,                -- Link tới booking
    [ContractId] UNIQUEIDENTIFIER NULL,                   -- Link tới contract (chỉ có khi thanh toán 70% sau ký hợp đồng)
    [Amount] DECIMAL(10,2) NOT NULL,                      -- Số tiền thanh toán (30% hoặc 70% tổng giá trị)
    [PaymentMethod] NVARCHAR(50) NOT NULL,                -- Phương thức thanh toán (PayOS)
    [PaymentStatus] NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Trạng thái: Pending, Completed, Failed, Cancelled
    [PaymentType] VARCHAR(20) NOT NULL DEFAULT 'Deposit', -- Loại: Deposit (đặt cọc 30%) hoặc FullPayment (thanh toán 70%)
    [TransactionId] NVARCHAR(100) NULL,                   -- Mã giao dịch từ PayOS
    [PaymentDate] DATETIME2 NULL,                         -- Thời điểm thanh toán thành công
    [UserId] UNIQUEIDENTIFIER NULL,                       -- Người thực hiện thanh toán
    [Notes] NVARCHAR(500) NULL,                          -- Ghi chú thanh toán
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),   -- Ngày tạo payment

    CONSTRAINT [PK_Payment] PRIMARY KEY ([PaymentId]),
    CONSTRAINT [FK_Payment_Booking] FOREIGN KEY ([BookingId]) 
        REFERENCES [Booking]([BookingId]) ON DELETE CASCADE,
    CONSTRAINT [FK_Payment_ContractId] FOREIGN KEY ([ContractId]) 
        REFERENCES [Contract]([ContractId]) ON DELETE NO ACTION,
    CONSTRAINT [FK_Payment_UserId] FOREIGN KEY ([UserId]) 
        REFERENCES [Users]([UserId]) ON DELETE NO ACTION
);
GO

-- ===================================================================
-- PHẦN 4: TẠO CÁC BẢNG PHỤ THUỘC VÀO BOOKING, CAR, USERS
-- ===================================================================

-- Bảng CarConditionLogs
CREATE TABLE [CarConditionLogs] (
    [LogId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [BookingId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [StaffId] UNIQUEIDENTIFIER NULL,
    [CheckType] NVARCHAR(20) NOT NULL,
    [CheckTime] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [Odometer] INT NULL,
    [FuelLevel] NVARCHAR(20) NULL,
    [ConditionStatus] NVARCHAR(100) NULL,
    [ConditionDescription] NVARCHAR(1000) NULL,
    [DamageImages] NVARCHAR(MAX) NULL,
    [Note] NVARCHAR(255) NULL,
    CONSTRAINT [PK_CarConditionLogs] PRIMARY KEY ([LogId]),
    CONSTRAINT [FK_CarConditionLogs_BookingId] FOREIGN KEY ([BookingId]) REFERENCES [Booking](BookingId) ON DELETE CASCADE,
    CONSTRAINT [FK_CarConditionLogs_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE,
    CONSTRAINT [FK_CarConditionLogs_StaffId] FOREIGN KEY ([StaffId]) REFERENCES [Users]([UserId]) ON DELETE NO ACTION
    -- CONSTRAINT [CHK_CarConditionLogs_CheckType] CHECK ([CheckType] IN ('Pickup', 'Return'))
);
GO

-- ===================================================================
-- PHẦN 5: TẠO CÁC BẢNG CÒN LẠI
-- ===================================================================

-- Bảng DriverLicenses
CREATE TABLE [DriverLicenses] (
    [LicenseId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [LicenseNumber] NVARCHAR(50) NULL,
    [FullName] NVARCHAR(100) NULL,
    [DOB] DATE NULL,
    [LicenseImage] NVARCHAR(MAX) NULL,
    [CreatedDate] DATETIME2 NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_DriverLicenses] PRIMARY KEY ([LicenseId]),
    CONSTRAINT [FK_DriverLicenses_Users] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

-- Bảng PasswordResetTokens
CREATE TABLE [PasswordResetTokens] (
    [Id] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [Token] NVARCHAR(255) NOT NULL,
    [ExpiryTime] DATETIME NOT NULL,
    [IsUsed] BIT NOT NULL DEFAULT 0,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_PasswordResetTokens] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_PasswordResetTokens_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

-- Bảng EmailOTPVerification
CREATE TABLE [EmailOTPVerification] (
    [Id] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [OTP] NVARCHAR(255) NOT NULL,
    [ExpiryTime] DATETIME NOT NULL,
    [IsUsed] BIT NOT NULL DEFAULT 0,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    [ResendCount] INT NOT NULL DEFAULT 0,
    [LastResendTime] DATETIME NULL,
    [ResendBlockUntil] DATETIME NULL,
    CONSTRAINT [PK_EmailOTPVerification] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_EmailOTPVerification_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

-- Bảng UserLogins
CREATE TABLE [UserLogins] (
    [LoginProvider] NVARCHAR(128) NOT NULL,
    [ProviderKey] NVARCHAR(128) NOT NULL,
    [ProviderDisplayName] NVARCHAR(MAX) NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_UserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_UserLogins_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

-- Bảng CarImages
CREATE TABLE [CarImages] (
    [ImageId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [ImageUrl] NVARCHAR(255) NOT NULL,
    [IsMain] BIT NOT NULL DEFAULT 0,
    CONSTRAINT [PK_CarImages] PRIMARY KEY ([ImageId]),
    CONSTRAINT [FK_CarImages_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE
);
GO

-- Bảng CarFeaturesMapping
CREATE TABLE [CarFeaturesMapping] (
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [FeatureId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_CarFeaturesMapping] PRIMARY KEY ([CarId], [FeatureId]),
    CONSTRAINT [FK_CarFeaturesMapping_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE,
    CONSTRAINT [FK_CarFeaturesMapping_FeatureId] FOREIGN KEY ([FeatureId]) REFERENCES [CarFeature]([FeatureId]) ON DELETE CASCADE
);
GO

-- Bảng CarMaintenanceHistory
CREATE TABLE [CarMaintenanceHistory] (
    [MaintenanceId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
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

-- Bảng CarRentalPricingRule
CREATE TABLE [CarRentalPricingRule] (
    [RuleId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [CarId] UNIQUEIDENTIFIER NULL,
    [RuleType] NVARCHAR(50) NOT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NOT NULL,
    [PricePerDay] DECIMAL(10,2) NULL,
    [PriceMultiplier] DECIMAL(5,2) NULL,
    [MinBookings] INT NULL,
    [Description] NVARCHAR(255) NULL,
    CONSTRAINT [PK_CarRentalPricingRule] PRIMARY KEY ([RuleId]),
    CONSTRAINT [FK_CarRentalPricingRule_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE SET NULL
);
GO

-- Bảng CarRentalPriceHistory
CREATE TABLE [CarRentalPriceHistory] (
    [PriceId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NULL,
    [PricePerHour] DECIMAL(10,2) NOT NULL,
    [PricePerDay] DECIMAL(10,2) NOT NULL,
    [PricePerMonth] DECIMAL(10,2) NOT NULL,
    [Note] NVARCHAR(255) NULL,
    CONSTRAINT [PK_CarRentalPriceHistory] PRIMARY KEY ([PriceId]),
    CONSTRAINT [FK_CarRentalPriceHistory_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE
);
GO

-- Bảng Notification
CREATE TABLE [Notification] (
    [NotificationId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [Message] NVARCHAR(MAX) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [IsRead] BIT NOT NULL DEFAULT 0,
    CONSTRAINT [PK_Notification] PRIMARY KEY ([NotificationId]),
    CONSTRAINT [FK_Notification_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

-- Bảng UserFeedback
CREATE TABLE [UserFeedback] (
    [FeedbackId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NULL,
    [Rating] INT NOT NULL,
    [Content] NVARCHAR(4000) NULL,
    [Reviewed] DATE NOT NULL DEFAULT GETDATE(),
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [IsApproved] BIT NOT NULL DEFAULT 0,
    CONSTRAINT [PK_UserFeedback] PRIMARY KEY ([FeedbackId]),
    CONSTRAINT [FK_UserFeedback_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserFeedback_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE SET NULL
    -- CONSTRAINT [CHK_UserFeedback_Rating] CHECK ([Rating] >= 1 AND [Rating] <= 5)
);
GO

-- Bảng AccountDeletionLogs
CREATE TABLE [AccountDeletionLogs] (
    [LogId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [DeletionReason] NVARCHAR(255) NOT NULL,
    [AdditionalComments] NVARCHAR(MAX) NULL,
    [Timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_AccountDeletionLogs] PRIMARY KEY ([LogId]),
    CONSTRAINT [FK_AccountDeletionLogs_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
);
GO

-- Bảng UserFavoriteCars
CREATE TABLE [UserFavoriteCars] (
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_UserFavoriteCars] PRIMARY KEY ([UserId], [CarId]),
    CONSTRAINT [FK_UserFavoriteCars_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserFavoriteCars_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE
);
GO

-- Bảng SupportTickets
CREATE TABLE [SupportTickets] (
    [TicketId] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [HandledBy] UNIQUEIDENTIFIER NULL,
    [Subject] NVARCHAR(200) NOT NULL,
    [Content] NVARCHAR(MAX) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [Status] VARCHAR(20) NOT NULL DEFAULT 'Open',
    CONSTRAINT [PK_SupportTickets] PRIMARY KEY ([TicketId]),
    CONSTRAINT [FK_SupportTickets_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_SupportTickets_HandledBy] FOREIGN KEY ([HandledBy]) REFERENCES [Users]([UserId]) ON DELETE NO ACTION
    -- CONSTRAINT [CHK_SupportTickets_Status] CHECK ([Status] IN ('Open', 'InProgress', 'Resolved', 'Closed'))
);
GO

-- ===================================================================
-- PHẦN 6: TẠO CÁC CHỈ MỤC (INDEX)
-- ===================================================================

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Discount_VoucherCode' AND object_id = OBJECT_ID('Discount'))
    DROP INDEX IX_Discount_VoucherCode ON [Discount];
GO
CREATE UNIQUE INDEX IX_Discount_VoucherCode ON [Discount](VoucherCode) WHERE VoucherCode IS NOT NULL;
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Booking_BookingCode' AND object_id = OBJECT_ID('Booking'))
    DROP INDEX IX_Booking_BookingCode ON [Booking];
GO
CREATE UNIQUE INDEX IX_Booking_BookingCode ON [Booking](BookingCode);
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Car_LicensePlate' AND object_id = OBJECT_ID('Car'))
    DROP INDEX IX_Car_LicensePlate ON [Car];
GO
CREATE UNIQUE INDEX IX_Car_LicensePlate ON [Car](LicensePlate);
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Users_Email' AND object_id = OBJECT_ID('Users'))
    DROP INDEX IX_Users_Email ON [Users];
GO
CREATE UNIQUE INDEX IX_Users_Email ON [Users](Email);
GO

-- ===================================================================
-- PHẦN 7: CHÈN DỮ LIỆU MẪU
-- ===================================================================

-- Chèn dữ liệu vào bảng Roles
INSERT INTO [Roles] (RoleId, RoleName, NormalizedName) VALUES
    (NEWID(), 'Admin', 'ADMIN'),
    (NEWID(), 'Staff', 'STAFF'),
    (NEWID(), 'Customer', 'CUSTOMER');
GO

-- Chèn dữ liệu vào bảng CarBrand
INSERT INTO [CarBrand] (BrandId, BrandName) VALUES
    (NEWID(), 'Toyota'),
    (NEWID(), 'Honda'),
    (NEWID(), 'Hyundai'),
    (NEWID(), 'Ford'),
    (NEWID(), 'Mazda');
GO

-- Chèn dữ liệu vào bảng Insurance
INSERT INTO [Insurance] (InsuranceId, InsuranceName, InsuranceType, BaseRatePerDay, PercentageRate, CoverageAmount, ApplicableCarSeats, Description, IsActive) VALUES
    (NEWID(), N'TNDS xe 1-5 chỗ', 'TNDS', 10, NULL, 150000000, '1-5', N'Bảo hiểm TNDS bắt buộc xe dưới 6 chỗ - 10 VND/ngày', 1),
    (NEWID(), N'TNDS xe 6-11 chỗ', 'TNDS', 15, NULL, 150000000, '6-11', N'Bảo hiểm TNDS bắt buộc xe 6-11 chỗ - 15 VND/ngày', 1),
    (NEWID(), N'TNDS xe 12+ chỗ', 'TNDS', 20, NULL, 150000000, '12+', N'Bảo hiểm TNDS bắt buộc xe trên 12 chỗ - 20 VND/ngày', 1),
    (NEWID(), N'Bảo hiểm vật chất xe', 'VatChat', 0, 2.0, 500000000, NULL, N'Bảo hiểm vật chất 2% giá xe/năm', 1),
    (NEWID(), N'Bảo hiểm tai nạn', 'TaiNan', 5, NULL, 200000000, NULL, N'Bảo hiểm tai nạn người trên xe - 5 VND/ngày', 1);
GO

-- Chèn dữ liệu vào bảng Discount
INSERT INTO [Discount] (DiscountId, DiscountName, Description, DiscountType, DiscountValue, StartDate, EndDate, IsActive, VoucherCode, MinOrderAmount, MaxDiscountAmount, UsageLimit, UsedCount, DiscountCategory) VALUES
    (NEWID(), N'Giảm 10%', N'Giảm 10% cho đơn hàng trên 2000 VND', 'Percent', 10, GETDATE(), DATEADD(MONTH, 6, GETDATE()), 1, 'SAVE10', 2000, 500, 1000, 0, 'Voucher'),
    (NEWID(), N'Giảm 50 VND', N'Giảm 50 VND cho khách hàng mới', 'Fixed', 50, GETDATE(), DATEADD(MONTH, 3, GETDATE()), 1, 'FIRST50', 0, NULL, 500, 0, 'Voucher'),
    (NEWID(), N'Giảm 20% cuối tuần', N'Giảm 20% cho booking cuối tuần', 'Percent', 20, GETDATE(), DATEADD(MONTH, 12, GETDATE()), 1, 'WEEKEND20', 1000, 1000, NULL, 0, 'Voucher'),
    (NEWID(), N'Giảm 15% sinh viên', N'Giảm 15% cho sinh viên', 'Percent', 15, GETDATE(), DATEADD(MONTH, 12, GETDATE()), 1, 'STUDENT15', 500, 300, NULL, 0, 'Voucher');
GO

-- Chèn dữ liệu vào bảng Terms
INSERT INTO [Terms] (TermsId, Version, Title, ShortContent, FullContent, EffectiveDate, IsActive) VALUES 
    (NEWID(), 'v1.0', N'Điều khoản và điều kiện', 
    N'<h4>Điều khoản đặt cọc cơ bản</h4><ul><li><strong>Đặt cọc:</strong> 30% tổng giá trị, không hoàn lại khi hủy</li><li><strong>Thanh toán:</strong> Hoàn tất sau khi được staff duyệt</li><li><strong>Ký hợp đồng:</strong> Bắt buộc trong 6 giờ sau khi đặt cọc</li><li><strong>Thanh toán cuối:</strong> 70% còn lại khi ký hợp đồng</li><li><strong>Hủy bỏ:</strong> Mất toàn bộ tiền cọc nếu không ký hợp đồng</li></ul><p><strong>Lưu ý:</strong> Tiền cọc không được hoàn lại trong mọi trường hợp</p>',
    N'Điều khoản và điều kiện đầy đủ cho hệ thống thuê xe AutoRental. Khách hàng phải đồng ý với các điều khoản sau: 1. Đặt cọc 30% tổng giá trị booking, không hoàn lại nếu hủy. 2. Thanh toán 70% còn lại khi ký hợp đồng. 3. Hợp đồng phải được ký trong vòng 6 giờ sau khi đặt cọc. 4. Mọi thiệt hại phát sinh do khách hàng gây ra sẽ được bồi thường theo quy định.', 
    GETDATE(), 1);
GO

-- Chèn dữ liệu vào bảng Users
DECLARE @AdminRoleId UNIQUEIDENTIFIER, @StaffRoleId UNIQUEIDENTIFIER, @CustomerRoleId UNIQUEIDENTIFIER;

SELECT @AdminRoleId = RoleId FROM [Roles] WHERE RoleName = 'Admin';
SELECT @StaffRoleId = RoleId FROM [Roles] WHERE RoleName = 'Staff';
SELECT @CustomerRoleId = RoleId FROM [Roles] WHERE RoleName = 'Customer';

INSERT INTO [Users] (
    [UserId], 
    [Username], 
    [Email], 
    [PasswordHash], 
    [RoleId], 
    [CreatedDate], 
    [Status], 
    [NormalizedUserName], 
    [NormalizedEmail], 
    [EmailVerifed], 
    [LockoutEnabled], 
    [AccessFailedCount]
)
VALUES
    (
        NEWID(), 
        N'user1', 
        N'user1@autorental.com', 
        N'$2a$12$dAHkLxTzTTxTay5bBmg/7.25VRKRxkCSYCTBdvpIsofWyGrYVarQm', 
        @CustomerRoleId, 
        GETDATE(), 
        'Active', 
        N'USER1', 
        N'USER1@AUTORENTAL.COM', 
        0, 
        1, 
        0
    ),
    (
        NEWID(), 
        N'staff3', 
        N'staff3@autorental.com', 
        N'$2a$12$dAHkLxTzTTxTay5bBmg/7.25VRKRxkCSYCTBdvpIsofWyGrYVarQm', 
        @StaffRoleId, 
        GETDATE(), 
        'Active', 
        N'STAFF3', 
        N'STAFF3@AUTORENTAL.COM', 
        0, 
        1, 
        0
    );
GO

-- ===================================================================
-- PHẦN 8: KIỂM TRA KẾT QUẢ
-- ===================================================================

DECLARE @TableCount INT, @InsuranceCount INT, @VoucherCount INT;

SELECT @TableCount = COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo';
SELECT @InsuranceCount = COUNT(*) FROM Insurance;
SELECT @VoucherCount = COUNT(*) FROM Discount WHERE DiscountCategory = 'Voucher';

PRINT '==================================================';
PRINT 'THIẾT LẬP CƠ SỞ DỮ LIỆU AUTORENTAL HOÀN TẤT!';
PRINT '==================================================';
PRINT 'Số bảng đã tạo: ' + CAST(@TableCount AS NVARCHAR(10));
PRINT 'Số loại bảo hiểm: ' + CAST(@InsuranceCount AS NVARCHAR(10));
PRINT 'Số voucher: ' + CAST(@VoucherCount AS NVARCHAR(10));
PRINT '==================================================';
PRINT 'CÁC TÍNH NĂNG BAO GỒM:';
PRINT '- Quản lý người dùng (Admin, Staff, Customer)';
PRINT '- Quản lý xe với thương hiệu, tính năng, bảo trì';
PRINT '- Hệ thống đặt xe với loại thuê (hourly, daily, monthly)';
PRINT '- Hệ thống giảm giá/voucher';
PRINT '- Hệ thống bảo hiểm (TNDS, vật chất, tai nạn)';
PRINT '- Hệ thống đồng ý điều khoản trong Booking';
PRINT '- Hệ thống hợp đồng và thanh toán với deposit (30%)';
PRINT '- Quản lý đánh giá và hỗ trợ khách hàng';
PRINT '==================================================';
PRINT 'SẴN SÀNG CHO TÍNH NĂNG DEPOSIT!';
PRINT '==================================================';

-- Kiểm tra dữ liệu trong bảng Users
SELECT 
    [UserId], 
    [Username], 
    [Email], 
    [RoleId], 
    [Status], 
    [CreatedDate] 
FROM [Users] 
WHERE [Email] IN ('user1@autorental.com', 'staff3@autorental.com');

PRINT '==================================================';
PRINT 'ĐÃ CHÈN THÀNH CÔNG 2 TÀI KHOẢN VÀO BẢNG USERS!';
PRINT '1. user1@autorental.com (Customer)';
PRINT '2. staff3@autorental.com (Staff)';
PRINT '==================================================';
GO

-- ===================================================================
-- GHI CHÚ CUỐI
-- - Sửa lỗi cú pháp backtick (`) trong mã
-- - Thêm DROP DATABASE để xóa database cũ
-- - Thêm DROP TABLE và DROP INDEX để tránh xung đột
-- - Sử dụng NEWID() cho RoleId trong bảng Roles để tránh trùng lặp
-- - Sửa lỗi chèn dữ liệu vào bảng Users bằng cách lấy RoleId động
-- - Thay thế bảng BookingSurcharges theo yêu cầu với ràng buộc CHECK cho SurchargeCategory được comment
-- - Giữ nguyên thứ tự tạo bảng để tránh lỗi khóa ngoại
-- - Các bảng liên quan đến booking, deposit và discount được giữ nguyên từ AutoRental_verDeposit.sql
-- - Các bảng không liên quan sửa CHECK constraints thành comment để tương thích với AutoRental.sql
-- - Tích hợp tính năng deposit (30% tổng chi phí)
-- - Bảng Booking đã được mở rộng để lưu thông tin điều khoản (TermsAgreed, TermsAgreedAt, TermsVersion)
-- - Dữ liệu mẫu được chèn cho Roles, CarBrand, Insurance, Discount, Users, Terms
-- ===================================================================