-- Insert default roles
INSERT INTO [Roles] ([RoleId], [RoleName], [NormalizedName])
VALUES 
    ('7c9e6679-7425-40de-944b-e07fc1f90ae7', 'Admin', 'ADMIN'),
    ('550e8400-e29b-41d4-a716-446655440000', 'Staff', 'STAFF'),
    ('6ba7b810-9dad-11d1-80b4-00c04fd430c8', 'User', 'USER');
GO

-- Insert data into Insurance table
-- Chèn dữ liệu vào bảng Insurance
INSERT INTO [Insurance] (InsuranceId, InsuranceName, InsuranceType, BaseRatePerDay, PercentageRate, CoverageAmount, ApplicableCarSeats, Description, IsActive) VALUES
    -- Physical damage insurance (MANDATORY for customers)
    (NEWID(), N'Physical Damage Insurance', 'VatChat', 0, 2.0, 500000000, NULL, N'Physical damage insurance at 2% of car value per year - MANDATORY', 1),
    -- Accident insurance for mini cars (VOLUNTARY)
    (NEWID(), N'Accident Insurance for Mini Cars', 'TaiNan', 30000, NULL, 300000000, '1-5', N'Accident insurance at 30,000 VND/day for all seats in cars with fewer than 6 seats - VOLUNTARY', 1),
    -- Accident insurance for large cars (VOLUNTARY)
    (NEWID(), N'Accident Insurance for Large Cars', 'TaiNan', 40000, NULL, 300000000, '6-11', N'Accident insurance at 40,000 VND/day for all seats in cars with 6-11 seats - VOLUNTARY', 1),
    -- Accident insurance for premium cars (VOLUNTARY)
    (NEWID(), N'Accident Insurance for Premium Cars', 'TaiNan', 50000, NULL, 300000000, '12+', N'Accident insurance at 50,000 VND/day for all seats in premium cars - VOLUNTARY', 1);
GO

-- Insert data into Discount table
INSERT INTO [Discount] (DiscountId, DiscountName, Description, DiscountType, DiscountValue, StartDate, EndDate, IsActive, VoucherCode, MinOrderAmount, MaxDiscountAmount, UsageLimit, UsedCount, DiscountCategory) VALUES
    (NEWID(), N'10% Off', N'10% off for orders over 2000 VND', 'Percent', 10, GETDATE(), DATEADD(MONTH, 6, GETDATE()), 1, 'SAVE10', 2000, 500, 1000, 0, 'Voucher'),
    (NEWID(), N'50 VND Off', N'50 VND off for new customers', 'Fixed', 50, GETDATE(), DATEADD(MONTH, 3, GETDATE()), 1, 'FIRST50', 0, NULL, 500, 0, 'Voucher'),
    (NEWID(), N'20% Weekend Discount', N'20% off for weekend bookings', 'Percent', 20, GETDATE(), DATEADD(MONTH, 12, GETDATE()), 1, 'WEEKEND20', 1000, 1000, NULL, 0, 'Voucher'),
    (NEWID(), N'15% Student Discount', N'15% off for students', 'Percent', 15, GETDATE(), DATEADD(MONTH, 12, GETDATE()), 1, 'STUDENT15', 500, 300, NULL, 0, 'Voucher');
GO

INSERT INTO [Terms] (TermsId, Version, Title, ShortContent, FullContent, EffectiveDate, IsActive) VALUES 
    (NEWID(), 'v1.0', N'Terms and Conditions', 
    N'<h4>Basic Booking Deposit Terms</h4><ul><li><strong>Deposit:</strong> 30% of the total value, non-refundable if canceled</li><li><strong>Payment:</strong> Completed after staff approval</li><li><strong>Contract Signing:</strong> Required within 6 hours after deposit</li><li><strong>Final Payment:</strong> Remaining 70% upon contract signing</li><li><strong>Cancellation:</strong> Full deposit will be lost if the contract is not signed</li></ul><p><strong>Note:</strong> The deposit is non-refundable under any circumstances</p>',
    N'Full terms and conditions for the AutoRental car rental system. Customers must agree to the following: 1. Deposit 30% of the total booking value, non-refundable if canceled. 2. Pay the remaining 70% upon contract signing. 3. The contract must be signed within 6 hours after the deposit. 4. Any damages caused by the customer must be compensated according to the regulations.', 
    GETDATE(), 1);
GO
-- Brand
INSERT INTO CarBrand (BrandId, BrandName) VALUES
('11111111-1111-1111-1111-111111111111', N'Toyota'),
('22222222-2222-2222-2222-222222222222', N'Honda'),
('99999999-9999-9999-9999-999999999999', N'Hyundai'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Ford'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', N'Kia'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', N'Mazda'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', N'Mitsubishi'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', N'VinFast'),
('ffffffff-ffff-ffff-ffff-ffffffffffff', N'Chevrolet');

-- TransmissionType
INSERT INTO TransmissionType (TransmissionTypeId, TransmissionName) VALUES
('33333333-3333-3333-3333-333333333333', N'Manual'),
('44444444-4444-4444-4444-444444444444', N'Automatic');

-- FuelType
INSERT INTO FuelType (FuelTypeId, FuelName) VALUES
('55555555-5555-5555-5555-555555555555', N'Gasoline'),
('66666666-6666-6666-6666-666666666666', N'Petroleum'),
('77777777-7777-7777-7777-777777777777', N'Electronic');

-- CarCategories
INSERT INTO CarCategories (CategoryId, CategoryName) VALUES
('77777777-7777-7777-7777-777777777777', N'4-seat car'),
('88888888-8888-8888-8888-888888888888', N'7-seat car');

INSERT INTO Car (CarId, BrandId, CarModel, YearManufactured, TransmissionTypeId, FuelTypeId, LicensePlate, Seats, Odometer, PricePerHour, PricePerDay, PricePerMonth, Status, Description, CreatedDate, CategoryId, LastUpdatedBy)
VALUES
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '11111111-1111-1111-1111-111111111111', N'Toyota Vios', 2020, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-12345', 5, 35000, 80, 800, 20000, 'Available', N'Toyota Vios is a compact sedan renowned for its outstanding fuel efficiency, smooth and durable operation. Ideal for small families or individuals frequently traveling in the city. The modern interior, comfortable seats, and spacious trunk ensure peace of mind on every journey.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '22222222-2222-2222-2222-222222222222', N'Honda City', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-23456', 5, 25000, 90, 900, 22500, 'Available', N'Honda City features a youthful, dynamic design with a powerful yet economical engine. The car is equipped with many safety features such as ABS brakes, electronic stability control, and hill-start assist. Spacious interior, cool air conditioning, and a modern entertainment system provide a great experience for the whole family.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '11111111-1111-1111-1111-111111111111', N'Toyota Innova', 2019, '44444444-4444-4444-4444-444444444444', '66666666-6666-6666-6666-666666666666', '30A-34567', 7, 60000, 120, 1200, 30000, 'Available', N'Toyota Innova is the ideal choice for large families or groups of friends thanks to its spacious 7-seat cabin, large luggage compartment, and stable performance on various terrains. The car is equipped with multi-zone air conditioning, flexible seating, and many entertainment amenities, ensuring comfort on every long trip.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', '22222222-2222-2222-2222-222222222222', N'Honda CRV', 2022, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-45678', 7, 20000, 150, 1500, 37500, 'Available', N'Honda CRV is a powerful SUV with a sporty design, fuel-efficient engine, and flexible handling. The car is equipped with many safety features such as a reversing camera, collision sensors, and cruise control. Luxurious interior, premium leather seats, and spacious space let you enjoy every trip, whether in the city or on the highway.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', '11111111-1111-1111-1111-111111111111', N'Toyota Fortuner', 2018, '44444444-4444-4444-4444-444444444444', '66666666-6666-6666-6666-666666666666', '30A-56789', 7, 80000, 100, 1000, 25000, 'Available', N'Toyota Fortuner is a 7-seat high-clearance SUV, famous for its powerful, durable, and fuel-efficient performance. The car is suitable for long trips, picnics, or traveling with large families. Equipped with advanced safety systems, spacious interior, modern amenities, and a large trunk, you are always ready for any journey.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '99999999-9999-9999-9999-999999999999', N'Hyundai Accent', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-11223', 5, 15000, 100, 1000, 25000, 'Available', N'Hyundai Accent is a compact sedan with a youthful, modern design, suitable for individuals or small families. The car stands out for its fuel efficiency, smooth operation, and diverse entertainment system. Comfortable interior, cozy seats, and a sufficiently large trunk for weekend trips.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', '99999999-9999-9999-9999-999999999999', N'Hyundai SantaFe', 2022, '33333333-3333-3333-3333-333333333333', '66666666-6666-6666-6666-666666666666', '30A-22334', 7, 10000, 180, 1800, 45000, 'Available', N'Hyundai SantaFe is a premium 7-seat SUV with a powerful engine and stable performance on various terrains. The car is equipped with many safety features such as ABS brakes, electronic balance, and hill descent assist. Luxurious interior, premium leather seats, multi-zone air conditioning, and a spacious trunk make it ideal for family trips.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Ford Ranger', 2020, '44444444-4444-4444-4444-444444444444', '66666666-6666-6666-6666-666666666666', '30A-33445', 5, 30000, 200, 2000, 50000, 'Available', N'Ford Ranger is a versatile pickup truck, outstanding for its large cargo capacity, powerful and durable engine. The car is suitable for both work and outdoor trips, exploring difficult terrains. Comfortable interior, spacious seats, modern entertainment system, and many safety features give you peace of mind on every road.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Ford Everest', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-44556', 7, 25000, 170, 1700, 42500, 'Available', N'Ford Everest is a 7-seat SUV with a strong, luxurious design, equipped with many modern safety technologies such as blind spot warning and automatic parking assist. The car has a spacious interior, premium leather seats, multi-zone air conditioning, and a large trunk, suitable for long trips with family or friends.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '11111111-1111-1111-1111-111111111111', N'Toyota Camry', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-67890', 5, 18000, 140, 1400, 35000, 'Available', N'Toyota Camry is a premium, luxurious sedan, outstanding for its elegant design, powerful engine, and excellent sound insulation. The car is equipped with many modern amenities such as electric leather seats, high-end entertainment system, automatic air conditioning, and advanced safety features, delivering a wonderful driving experience.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '99999999-9999-9999-9999-999999999999', N'Hyundai Elantra', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-55667', 5, 20000, 110, 1100, 27500, 'Available', N'Hyundai Elantra is a modern sedan with a youthful design, fuel-efficient and stable operation. The car has a comfortable interior, cozy seats, diverse entertainment system, and a spacious trunk, suitable for dynamic young people or small families.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Ford EcoSport', 2022, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-66778', 5, 15000, 120, 1200, 30000, 'Available', N'Ford EcoSport is a compact, flexible SUV, easy to move in the city as well as the suburbs. The car has a sporty design, comfortable interior, modern entertainment system, and many safety features, suitable for young families or individuals who love to explore.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('10000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', N'Kia Morning', 2022, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-88881', 5, 12000, 70, 700, 17500, 'Available', N'The Kia Morning is a compact hatchback, renowned for its fuel efficiency and agile maneuverability, making it ideal for city driving. With a modern design, comfortable seating for five, and a surprisingly spacious trunk, it is perfect for daily commutes and small families. The car is equipped with essential safety features and a user-friendly entertainment system, ensuring a pleasant experience on every journey.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('10000000-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', N'Kia Seltos', 2023, '44444444-4444-4444-4444-444444444444', '55555555-5555-5555-5555-555555555555', '30A-88882', 5, 8000, 120, 1200, 30000, 'Available', N'The Kia Seltos is a stylish urban SUV featuring a youthful design and advanced safety technologies such as lane-keeping assist and blind-spot monitoring. Its spacious interior, high ground clearance, and powerful yet economical engine make it suitable for both city and suburban adventures. The Seltos offers a premium sound system, automatic climate control, and flexible cargo space for all your needs.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('10000000-0000-0000-0000-000000000003', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', N'Kia Sorento', 2021, '44444444-4444-4444-4444-444444444444', '66666666-6666-6666-6666-666666666666', '30A-88883', 7, 20000, 150, 1500, 37500, 'Available', N'The Kia Sorento is a spacious 7-seater SUV, perfect for large families or group trips. It boasts a robust engine, smooth handling, and a luxurious interior with leather seats and multi-zone air conditioning. The Sorento is equipped with advanced safety features, a panoramic sunroof, and a large luggage compartment, ensuring comfort and convenience on every long journey.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('10000000-0000-0000-0000-000000000004', 'cccccccc-cccc-cccc-cccc-cccccccccccc', N'Mazda 3', 2022, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-88884', 5, 10000, 90, 900, 22500, 'Available', N'The Mazda 3 is a C-segment sedan that stands out with its elegant design and stable performance. It features a fuel-efficient engine, responsive steering, and a quiet, comfortable cabin. The car is equipped with a modern infotainment system, advanced safety technologies, and premium materials throughout the interior, making it a top choice for those seeking both style and substance.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('10000000-0000-0000-0000-000000000005', 'cccccccc-cccc-cccc-cccc-cccccccccccc', N'Mazda CX-5', 2023, '44444444-4444-4444-4444-444444444444', '55555555-5555-5555-5555-555555555555', '30A-88885', 5, 7000, 130, 1300, 32500, 'Available', N'The Mazda CX-5 is a modern 5-seater SUV, known for its dynamic design and a host of amenities. It offers a powerful yet economical engine, all-wheel drive, and a spacious, well-appointed interior. The CX-5 comes with a premium Bose sound system, adaptive cruise control, and a large touchscreen display, providing a luxurious and safe driving experience for families and adventurers alike.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('10000000-0000-0000-0000-000000000006', 'cccccccc-cccc-cccc-cccc-cccccccccccc', N'Mazda 6', 2021, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-88886', 5, 15000, 110, 1100, 27500, 'Available', N'The Mazda 6 is a premium sedan offering a spacious and refined interior, smooth ride quality, and advanced safety features. Its powerful engine and responsive handling make it enjoyable to drive, while the luxurious leather seats, dual-zone climate control, and advanced infotainment system ensure maximum comfort for all passengers.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('10000000-0000-0000-0000-000000000007', 'dddddddd-dddd-dddd-dddd-dddddddddddd', N'Mitsubishi Xpander', 2022, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-88887', 7, 9000, 100, 1000, 25000, 'Available', N'The Mitsubishi Xpander is a 7-seater MPV, highly regarded for its fuel efficiency and spacious cabin. It is ideal for families, offering flexible seating arrangements, a large luggage compartment, and a comfortable ride. The Xpander is equipped with modern safety features, a user-friendly entertainment system, and excellent air conditioning for all rows.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('10000000-0000-0000-0000-000000000008', 'dddddddd-dddd-dddd-dddd-dddddddddddd', N'Mitsubishi Outlander', 2021, '44444444-4444-4444-4444-444444444444', '55555555-5555-5555-5555-555555555555', '30A-88888', 5, 18000, 120, 1200, 30000, 'Available', N'The Mitsubishi Outlander is a versatile 5-seater SUV, offering stable performance and a wealth of amenities. It features a robust engine, advanced safety systems, and a spacious, comfortable interior. The Outlander is perfect for both city driving and long-distance travel, with flexible cargo space and a premium sound system.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('10000000-0000-0000-0000-000000000009', 'dddddddd-dddd-dddd-dddd-dddddddddddd', N'Mitsubishi Attrage', 2020, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-88889', 5, 22000, 60, 600, 15000, 'Available', N'The Mitsubishi Attrage is a compact sedan, well-known for its affordable price and excellent fuel economy. It is easy to maneuver in urban environments, offers a comfortable interior, and comes with essential safety features. The Attrage is a great choice for young professionals and small families looking for reliability and value.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('10000000-0000-0000-0000-000000000010', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', N'VinFast Fadil', 2022, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-88890', 5, 6000, 80, 800, 20000, 'Available', N'VinFast Fadil is a compact hatchback designed for urban mobility, featuring agile handling and a fuel-efficient engine. The car offers a modern interior, comfortable seating, and a range of safety features, making it ideal for city dwellers and small families. Its compact size allows for easy parking, while the spacious trunk accommodates daily needs and weekend getaways.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('10000000-0000-0000-0000-000000000011', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', N'VinFast Lux A2.0', 2021, '44444444-4444-4444-4444-444444444444', '55555555-5555-5555-5555-555555555555', '30A-88891', 5, 14000, 140, 1400, 35000, 'Available', N'The VinFast Lux A2.0 is a premium sedan with a luxurious design and powerful engine. It features a spacious, high-quality interior with leather seats, advanced infotainment, and a host of safety technologies. The Lux A2.0 delivers a smooth and quiet ride, making it perfect for business professionals and those seeking comfort and style.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('10000000-0000-0000-0000-000000000012', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', N'VinFast VF e34', 2023, '44444444-4444-4444-4444-444444444444', '77777777-7777-7777-7777-777777777777', '30A-88892', 5, 3000, 160, 1600, 40000, 'Available', N'The VinFast VF e34 is a modern electric SUV, equipped with cutting-edge technology and eco-friendly performance. It offers a quiet, emission-free ride, spacious interior, and advanced driver-assistance features. The VF e34 is ideal for environmentally conscious drivers who want both comfort and innovation in their daily commute or family trips.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('10000000-0000-0000-0000-000000000013', 'ffffffff-ffff-ffff-ffff-ffffffffffff', N'Chevrolet Spark', 2020, '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', '30A-88893', 5, 25000, 60, 600, 15000, 'Available', N'The Chevrolet Spark is a compact city car, perfect for navigating crowded streets and tight parking spaces. It is known for its excellent fuel economy, easy handling, and practical interior. The Spark features a comfortable cabin, modern infotainment, and essential safety systems, making it a smart choice for students and urban commuters.', GETDATE(), '77777777-7777-7777-7777-777777777777', NULL),
('10000000-0000-0000-0000-000000000014', 'ffffffff-ffff-ffff-ffff-ffffffffffff', N'Chevrolet Colorado', 2021, '44444444-4444-4444-4444-444444444444', '66666666-6666-6666-6666-666666666666', '30A-88894', 5, 18000, 130, 1300, 32500, 'Available', N'The Chevrolet Colorado is a versatile pickup truck, offering strong performance and durability for both work and leisure. It features a spacious cabin, advanced safety features, and a powerful engine capable of handling tough terrains. The Colorado is ideal for those who need a reliable vehicle for both daily driving and outdoor adventures.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL),
('10000000-0000-0000-0000-000000000015', 'ffffffff-ffff-ffff-ffff-ffffffffffff', N'Chevrolet Trailblazer', 2022, '44444444-4444-4444-4444-444444444444', '55555555-5555-5555-5555-555555555555', '30A-88895', 7, 9000, 150, 1500, 37500, 'Available', N'The Chevrolet Trailblazer is a robust 7-seater SUV, designed for families and adventure seekers. It offers a powerful engine, spacious interior, and a range of modern amenities including a premium sound system and advanced safety technologies. The Trailblazer is perfect for long trips, providing comfort, safety, and ample cargo space for all your travel needs.', GETDATE(), '88888888-8888-8888-8888-888888888888', NULL);

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
(NEWID(), 'e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', '/assets/images/ford_ecosport.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000001', '/assets/images/kia_morning.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000002', '/assets/images/kia_seltos.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000003', '/assets/images/kia_sorento.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000004', '/assets/images/mazda3.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000005', '/assets/images/mazda_cx5.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000006', '/assets/images/mazda6.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000007', '/assets/images/mitsubishi_xpander.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000008', '/assets/images/mitsubishi_outlander.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000009', '/assets/images/mitsubishi_attrage.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000010', '/assets/images/vinfast_fadil.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000011', '/assets/images/vinfast_luxa20.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000012', '/assets/images/vinfast_vfe34.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000013', '/assets/images/chevrolet_spark.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000014', '/assets/images/chevrolet_colorado.jpg', 1),
(NEWID(), '10000000-0000-0000-0000-000000000015', '/assets/images/chevrolet_trailblazer.jpg', 1);


INSERT INTO CarFeature (FeatureId, FeatureName) VALUES
('11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Map'),
('22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Bluetooth'),
('33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'360 Camera'),
('44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Side Camera'),
('55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Dash Cam'),
('66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Rearview Camera'),
('77777777-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Tire Pressure Sensor'),
('88888888-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Collision Sensor'),
('99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Speed Warning'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Sunroof'),
('bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'GPS Navigation'),
('cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'ETC'),
('dddddddd-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Child Seat'),
('eeeeeeee-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'USB Port'),
('ffffffff-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'Spare Tire'),
('11111111-bbbb-bbbb-bbbb-bbbbbbbbbbbb', N'DVD Screen'),
('22222222-bbbb-bbbb-bbbb-bbbbbbbbbbbb', N'Pickup Truck Bed Cover'),
('33333333-bbbb-bbbb-bbbb-bbbbbbbbbbbb', N'Airbag');

-- Xe 1: Toyota Vios
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '77777777-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '88888888-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'dddddddd-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'eeeeeeee-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a1a1a1a1-a1a1-a1a1-a1a1-a1a1a1a1a1a1', 'ffffffff-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 2: Honda City
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '77777777-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '88888888-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a2a2a2a2-a2a2-a2a2-a2a2-a2a2a2a2a2a2', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 3: Toyota Innova
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '77777777-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a3a3a3a3-a3a3-a3a3-a3a3-a3a3a3a3a3a3', '88888888-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 4: Honda CRV
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a4a4a4a4-a4a4-a4a4-a4a4-a4a4a4a4a4a4', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 5: Toyota Fortuner
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', '88888888-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('a5a5a5a5-a5a5-a5a5-a5a5-a5a5a5a5a5a5', 'ffffffff-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 6: Hyundai Accent
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '88888888-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c1c1c1c1-c1c1-c1c1-c1c1-c1c1c1c1c1c1', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 7: Hyundai SantaFe
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('c2c2c2c2-c2c2-c2c2-c2c2-c2c2c2c2c2c2', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 8: Ford Ranger
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', '88888888-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', 'dddddddd-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d1d1d1d1-d1d1-d1d1-d1d1-d1d1d1d1d1d1', 'ffffffff-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 9: Ford Everest
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('d2d2d2d2-d2d2-d2d2-d2d2-d2d2d2d2d2d2', 'eeeeeeee-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 10: Toyota Camry
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('b1b1b1b1-b1b1-b1b1-b1b1-b1b1b1b1b1b1', '77777777-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 11: Hyundai Elantra
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e1e1e1e1-e1e1-e1e1-e1e1-e1e1e1e1e1e1', 'dddddddd-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

-- Xe 12: Ford EcoSport
INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('e2e2e2e2-e2e2-e2e2-e2e2-e2e2e2e2e2e2', 'ffffffff-aaaa-aaaa-aaaa-aaaaaaaaaaaa');

INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES
-- Kia Morning
('10000000-0000-0000-0000-000000000001', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000001', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000001', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000001', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000001', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Kia Seltos
('10000000-0000-0000-0000-000000000002', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000002', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000002', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000002', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000002', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Kia Sorento
('10000000-0000-0000-0000-000000000003', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000003', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000003', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000003', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000003', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Mazda 3
('10000000-0000-0000-0000-000000000004', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000004', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000004', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000004', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000004', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Mazda CX-5
('10000000-0000-0000-0000-000000000005', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000005', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000005', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000005', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000005', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Mazda 6
('10000000-0000-0000-0000-000000000006', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000006', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000006', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000006', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000006', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Mitsubishi Xpander
('10000000-0000-0000-0000-000000000007', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000007', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000007', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000007', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000007', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Mitsubishi Outlander
('10000000-0000-0000-0000-000000000008', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000008', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000008', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000008', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000008', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Mitsubishi Attrage
('10000000-0000-0000-0000-000000000009', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000009', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000009', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000009', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000009', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- VinFast Fadil
('10000000-0000-0000-0000-000000000010', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000010', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000010', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000010', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000010', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- VinFast Lux A2.0
('10000000-0000-0000-0000-000000000011', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000011', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000011', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000011', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000011', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- VinFast VF e34
('10000000-0000-0000-0000-000000000012', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000012', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000012', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000012', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000012', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Chevrolet Spark
('10000000-0000-0000-0000-000000000013', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000013', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000013', '66666666-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000013', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000013', 'bbbbbbbb-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Chevrolet Colorado
('10000000-0000-0000-0000-000000000014', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000014', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000014', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000014', '99999999-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000014', 'cccccccc-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
-- Chevrolet Trailblazer
('10000000-0000-0000-0000-000000000015', '11111111-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000015', '22222222-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000015', '33333333-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000015', '44444444-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('10000000-0000-0000-0000-000000000015', '55555555-aaaa-aaaa-aaaa-aaaaaaaaaaaa');