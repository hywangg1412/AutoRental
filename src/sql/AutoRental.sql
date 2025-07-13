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
    [RoleId] UNIQUEIDENTIFIER NOT NULL,
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
    CONSTRAINT [PK_Users] PRIMARY KEY ([UserId]),
    CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleId]) REFERENCES [Roles]([RoleId]) ON DELETE CASCADE
);
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

CREATE TABLE [EmailOTPVerification] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [OTP] NVARCHAR(255) NOT NULL,
    [ExpiryTime] DATETIME NOT NULL,
    [IsUsed] BIT NOT NULL,-- DEFAULT 0,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt] DATETIME NOT NULL, -- DEFAULT GETDATE(),
    [ResendCount] INT NOT NULL, --DEFAULT 0,
    [LastResendTime] DATETIME NULL,
    [ResendBlockUntil] DATETIME NULL,
    CONSTRAINT [PK_EmailOTPVerification] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_EmailOTPVerification_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE
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
    [DiscountType] NVARCHAR(20) NOT NULL,
    [DiscountValue] DECIMAL(10,2) NOT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NOT NULL,
    [IsActive] BIT NOT NULL,-- DEFAULT 1,
    [CreatedDate] DATETIME2 NOT NULL,-- DEFAULT GETDATE(),
    [VoucherCode] NVARCHAR(20) NULL, -- Mã voucher: SAVE10, FIRST50
    [MinOrderAmount] DECIMAL(10,2) NOT NULL,-- DEFAULT 0, -- Đơn hàng tối thiểu
    [MaxDiscountAmount] DECIMAL(10,2) NULL, -- Giới hạn giảm tối đa cho phần trăm
    [UsageLimit] INT NULL, -- Số lần sử dụng tối đa
    [UsedCount] INT NOT NULL,-- DEFAULT 0, -- Số lần đã sử dụng
    [DiscountCategory] NVARCHAR(20) NOT NULL DEFAULT 'General', -- 'General', 'Voucher'
    CONSTRAINT [PK_Discount] PRIMARY KEY ([DiscountId])
    -- CONSTRAINT [CK_Discount_DiscountType] CHECK ([DiscountType] IN ('Percent', 'Fixed')),
    -- CONSTRAINT [CK_Discount_DiscountValue] CHECK ([DiscountValue] >= 0),
    -- CONSTRAINT [CK_Discount_DiscountCategory] CHECK ([DiscountCategory] IN ('General', 'Voucher'))
);
GO

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
    [IsRead] BIT NOT NULL, --DEFAULT 0,
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

CREATE TABLE [UserFavoriteCars] (
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_UserFavoriteCars] PRIMARY KEY ([UserId], [CarId]),
    CONSTRAINT [FK_UserFavoriteCars_UserId] FOREIGN KEY ([UserId]) REFERENCES [Users]([UserId]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserFavoriteCars_CarId] FOREIGN KEY ([CarId]) REFERENCES [Car]([CarId]) ON DELETE CASCADE
);
GO 