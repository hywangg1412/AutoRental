-- Script để drop bảng Discount một cách an toàn
-- Chạy từng câu lệnh một theo thứ tự

USE [AutoRental];
GO

-- Bước 1: Kiểm tra xem có bảng nào tham chiếu đến Discount không
SELECT 
    fk.name AS FK_Name,
    OBJECT_NAME(fk.parent_object_id) AS Table_Name,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS Column_Name,
    OBJECT_NAME(fk.referenced_object_id) AS Referenced_Table_Name,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS Referenced_Column_Name
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.referenced_object_id) = 'Discount';
GO

-- Bước 2: Drop foreign key constraint từ bảng Booking (nếu có)
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Booking_DiscountId')
BEGIN
    ALTER TABLE [Booking] DROP CONSTRAINT [FK_Booking_DiscountId];
    PRINT 'Đã drop foreign key FK_Booking_DiscountId từ bảng Booking';
END
ELSE
BEGIN
    PRINT 'Không tìm thấy foreign key FK_Booking_DiscountId';
END
GO

-- Bước 3: Drop foreign key constraint từ bảng ContractCars (nếu có)
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ContractCars_DiscountId')
BEGIN
    ALTER TABLE [ContractCars] DROP CONSTRAINT [FK_ContractCars_DiscountId];
    PRINT 'Đã drop foreign key FK_ContractCars_DiscountId từ bảng ContractCars';
END
ELSE
BEGIN
    PRINT 'Không tìm thấy foreign key FK_ContractCars_DiscountId';
END
GO

-- Bước 4: Drop bảng Discount
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Discount')
BEGIN
    DROP TABLE [Discount];
    PRINT 'Đã drop bảng Discount thành công';
END
ELSE
BEGIN
    PRINT 'Bảng Discount không tồn tại';
END
GO

-- Bước 5: Tạo lại bảng Discount mới
CREATE TABLE [Discount] (
    [DiscountId] UNIQUEIDENTIFIER NOT NULL,
    [DiscountName] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(255) NULL,
    [DiscountType] NVARCHAR(20) NOT NULL,
    [DiscountValue] DECIMAL(10,2) NOT NULL,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NOT NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [VoucherCode] NVARCHAR(20) NULL,
    [MinOrderAmount] DECIMAL(10,2) NOT NULL DEFAULT 0,
    [MaxDiscountAmount] DECIMAL(10,2) NULL,
    [UsageLimit] INT NULL,
    [UsedCount] INT NOT NULL DEFAULT 0,
    [DiscountCategory] NVARCHAR(20) NOT NULL DEFAULT 'General',
    CONSTRAINT [PK_Discount] PRIMARY KEY ([DiscountId])
);
GO

-- Tạo lại foreign key constraint cho bảng Booking
ALTER TABLE [Booking] 
ADD CONSTRAINT [FK_Booking_DiscountId] 
FOREIGN KEY ([DiscountId]) REFERENCES [Discount]([DiscountId]) ON DELETE SET NULL;
GO

PRINT 'Đã tạo lại bảng Discount và foreign key constraint'; 