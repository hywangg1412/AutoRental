# Hướng dẫn Quản lý Xe - AutoRental

## Tổng quan

Hệ thống quản lý xe cho phép Admin và Staff thêm, sửa, xóa và xem danh sách xe trong hệ thống AutoRental.

## Các chức năng chính

### 1. Xem danh sách xe

- Truy cập: `/manageCarsServlet`
- Hiển thị danh sách xe với phân trang
- Thông tin hiển thị: Hình ảnh, Model, Brand, Transmission, Fuel, Year, Seats, Price/Day, Status
- Có thể sắp xếp và lọc theo nhiều tiêu chí

### 2. Thêm xe mới

- Có 2 cách thêm xe:
  - **Modal form**: Click nút "Add Car" trên trang chính
  - **Test form**: Click nút "Test Add" để sử dụng form test đơn giản

#### Thông tin bắt buộc:

- Car Model (tên xe)
- Brand (thương hiệu)
- Fuel Type (loại nhiên liệu)
- Transmission Type (loại hộp số)
- Seats (số ghế)
- Year Manufactured (năm sản xuất)
- License Plate (biển số xe)
- Odometer (số km đã đi)
- Price Per Day (giá theo ngày)
- Price Per Hour (giá theo giờ)
- Status (trạng thái)

#### Thông tin tùy chọn:

- Category (danh mục xe)
- Price Per Month (giá theo tháng) - có thể để trống
- Description (mô tả)
- Car Images (hình ảnh xe) - tối đa 10 ảnh, mỗi ảnh tối đa 5MB

### 3. Cập nhật xe

- Click nút "Edit" (biểu tượng bút chì) trên dòng xe cần sửa
- Form sẽ được điền sẵn thông tin hiện tại
- Có thể thay đổi bất kỳ thông tin nào
- Khi cập nhật, tất cả ảnh cũ sẽ bị xóa và thay thế bằng ảnh mới (nếu có)

### 4. Xóa xe

- Click nút "Delete" (biểu tượng thùng rác) trên dòng xe cần xóa
- Xác nhận xóa trong popup
- Khi xóa xe, tất cả ảnh liên quan cũng sẽ bị xóa

## Cấu trúc Database

### Bảng Car

```sql
CREATE TABLE [Car] (
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [BrandId] UNIQUEIDENTIFIER NOT NULL,
    [CarModel] NVARCHAR(50) NOT NULL,
    [YearManufactured] INT,
    [TransmissionTypeId] UNIQUEIDENTIFIER NOT NULL,
    [FuelTypeId] UNIQUEIDENTIFIER NOT NULL,
    [LicensePlate] NVARCHAR(20) NOT NULL,
    [Seats] INT NOT NULL,
    [Odometer] INT NOT NULL,
    [PricePerHour] DECIMAL(10,2) NOT NULL,
    [PricePerDay] DECIMAL(10,2) NOT NULL,
    [PricePerMonth] DECIMAL(10,2) NULL, -- Có thể NULL
    [Status] VARCHAR(20) NOT NULL,
    [Description] NVARCHAR(500) NULL,
    [CreatedDate] DATETIME2 NOT NULL,
    [CategoryId] UNIQUEIDENTIFIER NULL,
    [LastUpdatedBy] UNIQUEIDENTIFIER NULL
);
```

### Bảng CarImages

```sql
CREATE TABLE [CarImages] (
    [ImageId] UNIQUEIDENTIFIER NOT NULL,
    [CarId] UNIQUEIDENTIFIER NOT NULL,
    [ImageUrl] NVARCHAR(255) NOT NULL,
    [IsMain] BIT NOT NULL
);
```

## Validation Rules

### Form Validation

- **Seats**: 1-50
- **Year**: 1900 đến năm hiện tại + 1
- **Odometer**: >= 0
- **Prices**: >= 0
- **License Plate**: Không được trống
- **Images**: Tối đa 10 ảnh, mỗi ảnh tối đa 5MB, chỉ chấp nhận file ảnh

### Database Constraints

- **License Plate**: UNIQUE
- **Status**: Chỉ chấp nhận 'Available', 'Rented', 'Unavailable'
- **Foreign Keys**: BrandId, FuelTypeId, TransmissionTypeId, CategoryId, LastUpdatedBy

## Xử lý lỗi

### Common Errors

1. **"All required fields must be filled"**: Kiểm tra các trường bắt buộc
2. **"Invalid numeric format"**: Kiểm tra định dạng số
3. **"License plate already exists"**: Biển số xe đã tồn tại
4. **"Maximum 10 images allowed"**: Giảm số lượng ảnh
5. **"Image size exceeds 5MB limit"**: Giảm kích thước ảnh

### Debug

- Kiểm tra console log để xem chi tiết lỗi
- Logs sẽ hiển thị thông tin về quá trình thêm/cập nhật xe
- Kiểm tra database để xác nhận dữ liệu đã được lưu

## Test Data

### Dữ liệu mẫu để test

```sql
-- Thêm xe mới
INSERT INTO [Car] (
    [CarId], [BrandId], [CarModel], [YearManufactured], [TransmissionTypeId], [FuelTypeId],
    [LicensePlate], [Seats], [Odometer], [PricePerHour], [PricePerDay], [PricePerMonth],
    [Status], [Description], [CreatedDate], [CategoryId], [LastUpdatedBy]
)
VALUES (
    'a2b2c2d2-a2b2-a2b2-a2b2-a2b2a2b2a2b2',
    '22222222-2222-2222-2222-222222222222', -- Honda
    N'Mazda CX-5',
    2022,
    '44444444-4444-4444-4444-444444444444', -- Số sàn
    '66666666-6666-6666-6666-666666666666', -- Dầu diesel
    '51H-12345',
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

-- Thêm ảnh cho xe
INSERT INTO [CarImages] (
    [ImageId], [CarId], [ImageUrl], [IsMain]
)
VALUES (
    NEWID(),
    'a2b2c2d2-a2b2-a2b2-a2b2-a2b2a2b2a2b2',
    '/assets/images/images.jpg',
    1
);
```

## Quyền truy cập

- **Admin**: Có đầy đủ quyền
- **Staff**: Có đầy đủ quyền
- **User thường**: Không có quyền truy cập

## File Upload

- Thư mục upload: `Uploads/car-images/`
- Tên file: `{CarId}_{timestamp}.{extension}`
- Đường dẫn lưu trong DB: `Uploads/car-images/{filename}`

### Giới hạn Upload

- Tối đa 10 ảnh cho mỗi xe
- Kích thước tối đa: 5MB mỗi ảnh
- Định dạng hỗ trợ: JPG, PNG, GIF
- Tổng kích thước request: 50MB

### Xử lý Lỗi File Upload

Nếu gặp lỗi "File upload failed", hãy thử:

1. **Giảm kích thước ảnh** xuống dưới 5MB
2. **Sử dụng trang test không có ảnh**: `/pages/admin/test-add-car-no-image.jsp`
3. **Kiểm tra định dạng file**: chỉ JPG, PNG, GIF
4. **Kiểm tra logs server** để xem lỗi chi tiết
5. **Kiểm tra quyền thư mục upload**: đảm bảo server có quyền ghi vào thư mục

### Xử lý Lỗi "Invalid request type"

Lỗi này xảy ra khi:

- Form có upload ảnh nhưng không có `enctype="multipart/form-data"`
- Form không có upload ảnh nhưng có `enctype="multipart/form-data"`

**Giải pháp:**

- **Form có ảnh**: Đảm bảo có `enctype="multipart/form-data"`
- **Form không có ảnh**: Không cần `enctype` hoặc dùng `enctype="application/x-www-form-urlencoded"`
- **Sử dụng trang test phù hợp**:
  - `/pages/admin/test-add-car.jsp` - cho form có ảnh
  - `/pages/admin/test-add-car-no-image.jsp` - cho form không có ảnh

## Troubleshooting

### Lỗi thường gặp

1. **Form không submit được**: Kiểm tra validation JavaScript
2. **Ảnh không hiển thị**: Kiểm tra đường dẫn và quyền thư mục
3. **Lỗi database**: Kiểm tra connection string và quyền database
4. **Session timeout**: Đăng nhập lại

### Logs

- Server logs: Kiểm tra console của server
- Browser logs: F12 -> Console để xem lỗi JavaScript
- Database logs: Kiểm tra SQL Server logs
