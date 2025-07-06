-- Script test thêm xe không có ảnh
-- Sử dụng khi gặp lỗi file upload

-- Test Case 1: Thêm xe với đầy đủ thông tin (bao gồm PricePerMonth)
INSERT INTO [Car] (
    [CarId], [BrandId], [CarModel], [YearManufactured], [TransmissionTypeId], [FuelTypeId],
    [LicensePlate], [Seats], [Odometer], [PricePerHour], [PricePerDay], [PricePerMonth],
    [Status], [Description], [CreatedDate], [CategoryId], [LastUpdatedBy]
)
VALUES (
    'b3c3d3e3-b3c3-b3c3-b3c3-b3c3b3c3b3c3',
    '22222222-2222-2222-2222-222222222222', -- Honda
    N'Mazda CX-5',
    2022,
    '44444444-4444-4444-4444-444444444444', -- Số sàn
    '66666666-6666-6666-6666-666666666666', -- Dầu diesel
    '51H-54321',
    7,
    15000,
    15.00,
    75.00,
    1500.00,
    'Available',
    N'Xe SUV 7 chỗ, mạnh mẽ và bền bỉ',
    GETDATE(),
    '88888888-8888-8888-8888-888888888888', -- Xe 7 chỗ
    NULL
);

-- Test Case 2: Thêm xe không có PricePerMonth (để NULL)
INSERT INTO [Car] (
    [CarId], [BrandId], [CarModel], [YearManufactured], [TransmissionTypeId], [FuelTypeId],
    [LicensePlate], [Seats], [Odometer], [PricePerHour], [PricePerDay], [PricePerMonth],
    [Status], [Description], [CreatedDate], [CategoryId], [LastUpdatedBy]
)
VALUES (
    'c4d4e4f4-c4d4-c4d4-c4d4-c4d4c4d4c4d4',
    '11111111-1111-1111-1111-111111111111', -- Toyota
    N'Toyota Camry',
    2021,
    '33333333-3333-3333-3333-333333333333', -- Số tự động
    '55555555-5555-5555-5555-555555555555', -- Xăng
    '51H-67890',
    5,
    25000,
    12.00,
    60.00,
    NULL, -- Không có giá theo tháng
    'Available',
    N'Xe sedan 5 chỗ, tiết kiệm nhiên liệu',
    GETDATE(),
    '77777777-7777-7777-7777-777777777777', -- Xe 4 chỗ
    NULL
);

-- Test Case 3: Thêm xe không có Category (để NULL)
INSERT INTO [Car] (
    [CarId], [BrandId], [CarModel], [YearManufactured], [TransmissionTypeId], [FuelTypeId],
    [LicensePlate], [Seats], [Odometer], [PricePerHour], [PricePerDay], [PricePerMonth],
    [Status], [Description], [CreatedDate], [CategoryId], [LastUpdatedBy]
)
VALUES (
    'd5e5f5g5-d5e5-d5e5-d5e5-d5e5d5e5d5e5',
    '99999999-9999-9999-9999-999999999999', -- Hyundai
    N'Hyundai Tucson',
    2023,
    '33333333-3333-3333-3333-333333333333', -- Số tự động
    '55555555-5555-5555-5555-555555555555', -- Xăng
    '51H-11111',
    5,
    8000,
    18.00,
    90.00,
    1800.00,
    'Available',
    N'Xe SUV 5 chỗ, thiết kế hiện đại',
    GETDATE(),
    NULL, -- Không có category
    NULL
);

-- Kiểm tra kết quả
SELECT 
    c.CarId,
    c.CarModel,
    cb.BrandName,
    ft.FuelName,
    tt.TransmissionName,
    cc.CategoryName,
    c.Seats,
    c.YearManufactured,
    c.LicensePlate,
    c.Odometer,
    c.PricePerDay,
    c.PricePerHour,
    c.PricePerMonth,
    c.Status,
    c.Description
FROM [Car] c
LEFT JOIN [CarBrand] cb ON c.BrandId = cb.BrandId
LEFT JOIN [FuelType] ft ON c.FuelTypeId = ft.FuelTypeId
LEFT JOIN [TransmissionType] tt ON c.TransmissionTypeId = tt.TransmissionTypeId
LEFT JOIN [CarCategories] cc ON c.CategoryId = cc.CategoryId
WHERE c.CarId IN (
    'b3c3d3e3-b3c3-b3c3-b3c3-b3c3b3c3b3c3',
    'c4d4e4f4-c4d4-c4d4-c4d4-c4d4c4d4c4d4',
    'd5e5f5g5-d5e5-d5e5-d5e5-d5e5d5e5d5e5'
)
ORDER BY c.CreatedDate DESC;

-- Xóa dữ liệu test (nếu cần)
-- DELETE FROM [Car] WHERE CarId IN (
--     'b3c3d3e3-b3c3-b3c3-b3c3-b3c3b3c3b3c3',
--     'c4d4e4f4-c4d4-c4d4-c4d4-c4d4c4d4c4d4',
--     'd5e5f5g5-d5e5-d5e5-d5e5-d5e5d5e5d5e5'
-- ); 