-- 🚗 Quick Test Car Insert Script
-- Script này dùng để test thêm xe nhanh vào database

-- 1. Thêm xe test với UUID ngẫu nhiên
INSERT INTO [Car] (
    [CarId], [BrandId], [CarModel], [YearManufactured], [TransmissionTypeId], [FuelTypeId],
    [LicensePlate], [Seats], [Odometer], [PricePerHour], [PricePerDay], [PricePerMonth],
    [Status], [Description], [CreatedDate], [CategoryId], [LastUpdatedBy]
)
VALUES (
    NEWID(), -- CarId ngẫu nhiên
    '11111111-1111-1111-1111-111111111111', -- Toyota
    N'Toyota Camry Quick Test',
    2023,
    '33333333-3333-3333-3333-333333333333', -- Số tự động
    '55555555-5555-5555-5555-555555555555', -- Xăng
    '51H-QUICK' + CAST(RAND() * 1000 AS VARCHAR(3)), -- License plate ngẫu nhiên
    5,
    5000,
    10.00,
    50.00,
    NULL, -- PricePerMonth = NULL
    'Available',
    N'Xe test nhanh - Quick Test',
    GETDATE(),
    NULL, -- Không có category
    NULL
);

-- 2. Kiểm tra xe vừa thêm
SELECT TOP 5
    c.CarId,
    c.CarModel,
    cb.BrandName,
    ft.FuelName,
    tt.TransmissionName,
    c.LicensePlate,
    c.Seats,
    c.YearManufactured,
    c.PricePerDay,
    c.PricePerHour,
    c.PricePerMonth,
    c.Status,
    c.Description,
    c.CreatedDate
FROM Car c
LEFT JOIN CarBrand cb ON c.BrandId = cb.BrandId
LEFT JOIN FuelType ft ON c.FuelTypeId = ft.FuelTypeId
LEFT JOIN TransmissionType tt ON c.TransmissionTypeId = tt.TransmissionTypeId
WHERE c.CarModel LIKE '%Quick Test%'
ORDER BY c.CreatedDate DESC;

-- 3. Xóa xe test (nếu cần)
-- DELETE FROM Car WHERE CarModel LIKE '%Quick Test%';

-- 4. Kiểm tra UUID hiện có
SELECT 'Brands:' as Info;
SELECT BrandId, BrandName FROM CarBrand;

SELECT 'Fuel Types:' as Info;
SELECT FuelTypeId, FuelName FROM FuelType;

SELECT 'Transmission Types:' as Info;
SELECT TransmissionTypeId, TransmissionName FROM TransmissionType;

SELECT 'Categories:' as Info;
SELECT CategoryId, CategoryName FROM CarCategories; 