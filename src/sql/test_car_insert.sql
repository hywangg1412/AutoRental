-- Script test thêm xe mới vào hệ thống AutoRental
-- Chạy script này để test chức năng thêm xe

-- 1. Thêm xe mới (Mazda CX-5)
INSERT INTO [Car] (
    [CarId], [BrandId], [CarModel], [YearManufactured], [TransmissionTypeId], [FuelTypeId], 
    [LicensePlate], [Seats], [Odometer], [PricePerHour], [PricePerDay], [PricePerMonth], 
    [Status], [Description], [CreatedDate], [CategoryId], [LastUpdatedBy]
)
VALUES (
    'a2b2c2d2-a2b2-a2b2-a2b2-a2b2a2b2a2b2', -- CarId mới
    '22222222-2222-2222-2222-222222222222', -- BrandId của Honda
    N'Mazda CX-5',
    2022,
    '44444444-4444-4444-4444-444444444444', -- TransmissionTypeId của Số sàn
    '66666666-6666-6666-6666-666666666666', -- FuelTypeId của Dầu diesel
    '51H-12345',
    7,
    15000,
    15.00,
    75.00,
    1500.00,
    'Available',
    N'Xe SUV 7 chỗ, mạnh mẽ và bền bỉ',
    GETDATE(),
    '88888888-8888-8888-8888-888888888888', -- CategoryId của Xe 7 chỗ
    NULL
);

-- 2. Thêm ảnh cho xe vào bảng CarImages
INSERT INTO [CarImages] (
    [ImageId], [CarId], [ImageUrl], [IsMain]
)
VALUES (
    NEWID(),
    'a2b2c2d2-a2b2-a2b2-a2b2-a2b2a2b2a2b2', -- CarId mới
    '/assets/images/images.jpg', -- Đường dẫn tương đối trong ứng dụng
    1
);

-- 3. Thêm xe thứ 2 (Toyota Camry)
INSERT INTO [Car] (
    [CarId], [BrandId], [CarModel], [YearManufactured], [TransmissionTypeId], [FuelTypeId], 
    [LicensePlate], [Seats], [Odometer], [PricePerHour], [PricePerDay], [PricePerMonth], 
    [Status], [Description], [CreatedDate], [CategoryId], [LastUpdatedBy]
)
VALUES (
    'b3c3d3e3-b3c3-b3c3-b3c3-b3c3b3c3b3c3', -- CarId mới
    '11111111-1111-1111-1111-111111111111', -- BrandId của Toyota
    N'Toyota Camry',
    2023,
    '33333333-3333-3333-3333-333333333333', -- TransmissionTypeId của Số tự động
    '55555555-5555-5555-5555-555555555555', -- FuelTypeId của Xăng
    '51H-54321',
    5,
    8000,
    12.00,
    60.00,
    1200.00,
    'Available',
    N'Sedan cao cấp, tiện nghi và an toàn',
    GETDATE(),
    '77777777-7777-7777-7777-777777777777', -- CategoryId của Xe 4 chỗ
    NULL
);

-- 4. Thêm ảnh cho xe thứ 2
INSERT INTO [CarImages] (
    [ImageId], [CarId], [ImageUrl], [IsMain]
)
VALUES (
    NEWID(),
    'b3c3d3e3-b3c3-b3c3-b3c3-b3c3b3c3b3c3',
    '/assets/images/toyota_camry.jpg',
    1
);

-- 5. Thêm xe thứ 3 (không có PricePerMonth - test trường NULL)
INSERT INTO [Car] (
    [CarId], [BrandId], [CarModel], [YearManufactured], [TransmissionTypeId], [FuelTypeId], 
    [LicensePlate], [Seats], [Odometer], [PricePerHour], [PricePerDay], [PricePerMonth], 
    [Status], [Description], [CreatedDate], [CategoryId], [LastUpdatedBy]
)
VALUES (
    'c4d4e4f4-c4d4-c4d4-c4d4-c4d4c4d4c4d4', -- CarId mới
    '99999999-9999-9999-9999-999999999999', -- BrandId của Hyundai
    N'Hyundai Tucson',
    2021,
    '33333333-3333-3333-3333-333333333333', -- TransmissionTypeId của Số tự động
    '55555555-5555-5555-5555-555555555555', -- FuelTypeId của Xăng
    '51H-98765',
    5,
    25000,
    10.00,
    50.00,
    NULL, -- PricePerMonth = NULL
    'Available',
    N'SUV nhỏ gọn, tiết kiệm nhiên liệu',
    GETDATE(),
    '77777777-7777-7777-7777-777777777777', -- CategoryId của Xe 4 chỗ
    NULL
);

-- 6. Thêm ảnh cho xe thứ 3
INSERT INTO [CarImages] (
    [ImageId], [CarId], [ImageUrl], [IsMain]
)
VALUES (
    NEWID(),
    'c4d4e4f4-c4d4-c4d4-c4d4-c4d4c4d4c4d4',
    '/assets/images/hyundai_tucson.jpg',
    1
);

-- 7. Kiểm tra dữ liệu đã thêm
SELECT 
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
    ci.ImageUrl
FROM Car c
LEFT JOIN CarBrand cb ON c.BrandId = cb.BrandId
LEFT JOIN FuelType ft ON c.FuelTypeId = ft.FuelTypeId
LEFT JOIN TransmissionType tt ON c.TransmissionTypeId = tt.TransmissionTypeId
LEFT JOIN CarImages ci ON c.CarId = ci.CarId AND ci.IsMain = 1
WHERE c.CarId IN (
    'a2b2c2d2-a2b2-a2b2-a2b2-a2b2a2b2a2b2',
    'b3c3d3e3-b3c3-b3c3-b3c3-b3c3b3c3b3c3',
    'c4d4e4f4-c4d4-c4d4-c4d4-c4d4c4d4c4d4'
)
ORDER BY c.CreatedDate DESC;

-- 8. Xóa dữ liệu test (nếu cần)
-- DELETE FROM CarImages WHERE CarId IN (
--     'a2b2c2d2-a2b2-a2b2-a2b2-a2b2a2b2a2b2',
--     'b3c3d3e3-b3c3-b3c3-b3c3-b3c3b3c3b3c3',
--     'c4d4e4f4-c4d4-c4d4-c4d4-c4d4c4d4c4d4'
-- );
-- DELETE FROM Car WHERE CarId IN (
--     'a2b2c2d2-a2b2-a2b2-a2b2-a2b2a2b2a2b2',
--     'b3c3d3e3-b3c3-b3c3-b3c3-b3c3b3c3b3c3',
--     'c4d4e4f4-c4d4-c4d4-c4d4-c4d4c4d4c4d4'
-- ); 