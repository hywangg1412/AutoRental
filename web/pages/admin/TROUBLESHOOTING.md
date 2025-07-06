# 🔧 Hướng Dẫn Khắc Phục Lỗi Car Management

## 🚨 Các Lỗi Thường Gặp

### 1. Lỗi "Invalid request type"

**Nguyên nhân:** Form không có `enctype="multipart/form-data"` nhưng servlet yêu cầu multipart
**Giải pháp:**

- Form có ảnh → thêm `enctype="multipart/form-data"`
- Form không ảnh → không cần enctype hoặc dùng `application/x-www-form-urlencoded`

### 2. Lỗi "File upload failed"

**Nguyên nhân:** File quá lớn hoặc quá nhiều file
**Giải pháp:**

- Giảm kích thước file (tối đa 5MB/file)
- Giảm số lượng file (tối đa 10 file)
- Dùng form không có ảnh để test

### 3. Lỗi "All required fields must be filled"

**Nguyên nhân:** Thiếu trường bắt buộc
**Giải pháp:** Điền đầy đủ các trường có dấu \*

### 4. Lỗi "Invalid UUID format"

**Nguyên nhân:** UUID không đúng định dạng
**Giải pháp:** Dùng UUID từ database hoặc để trống (cho thêm mới)

### 5. Lỗi "Cannot insert the value NULL into column 'PricePerMonth'"

**Nguyên nhân:** Database yêu cầu PricePerMonth NOT NULL nhưng code đang insert NULL
**Giải pháp:**

- Đã sửa code để tự động đặt giá trị mặc định = 0
- Luôn điền giá trị cho PricePerMonth (có thể là 0)
- Cập nhật tất cả form test để có trường PricePerMonth

### 6. Lỗi "FileCountLimitExceededException: attachment"

**Nguyên nhân:** Số lượng file upload vượt quá giới hạn (mặc định 10 file)
**Giải pháp:**

- Đã thêm `maxFileCount = 10` vào `@MultipartConfig`
- Cải thiện xử lý lỗi để bắt được exception cụ thể
- Tạo trang test riêng cho upload ảnh
- Kiểm tra giới hạn: 10 ảnh, 5MB/ảnh, 50MB tổng

## 🧪 Các Trang Test

### 1. Quick Test (Khuyến nghị)

- **Link:** `/pages/admin/quick-test.jsp`
- **Đặc điểm:** Form đơn giản, dữ liệu mẫu, không ảnh
- **Dùng cho:** Test nhanh chức năng cơ bản

### 2. Simple Test

- **Link:** `/pages/admin/simple-test.jsp`
- **Đặc điểm:** Form đầy đủ, không ảnh
- **Dùng cho:** Test validation và xử lý form

### 3. Test Add Car (No Image)

- **Link:** `/pages/admin/test-add-car-no-image.jsp`
- **Đặc điểm:** Form đầy đủ, không ảnh
- **Dùng cho:** Test chức năng thêm xe

### 4. Test Add Car (With Image)

- **Link:** `/pages/admin/test-add-car.jsp`
- **Đặc điểm:** Form có upload ảnh
- **Dùng cho:** Test upload ảnh

### 5. Test with Images ⭐ MỚI

- **Link:** `/pages/admin/test-add-car-with-images.jsp`
- **Đặc điểm:** Form đơn giản, upload ảnh bắt buộc
- **Dùng cho:** Test upload ảnh đơn giản
- **Giới hạn:** 10 ảnh, 5MB/ảnh, 50MB tổng

## 📋 Quy Trình Test

### Bước 1: Test Cơ Bản

1. Vào trang **Quick Test**
2. Click "Add Car (Quick Test)"
3. Kiểm tra thông báo thành công

### Bước 2: Test Validation

1. Vào trang **Simple Test**
2. Thử bỏ trống các trường bắt buộc
3. Kiểm tra thông báo lỗi

### Bước 3: Test Upload Ảnh

1. Vào trang **Test Add Car**
2. Chọn ảnh nhỏ (< 5MB)
3. Submit form

## 🔍 Kiểm Tra Database

### Xem UUID hiện có:

```sql
-- Xem brands
SELECT BrandId, BrandName FROM CarBrand;

-- Xem fuel types
SELECT FuelTypeId, FuelName FROM FuelType;

-- Xem transmission types
SELECT TransmissionTypeId, TransmissionName FROM TransmissionType;

-- Xem cars
SELECT CarId, CarModel, LicensePlate FROM Car;
```

### Xem xe vừa thêm:

```sql
SELECT
    c.CarId,
    c.CarModel,
    cb.BrandName,
    ft.FuelName,
    tt.TransmissionName,
    c.LicensePlate,
    c.Status
FROM Car c
LEFT JOIN CarBrand cb ON c.BrandId = cb.BrandId
LEFT JOIN FuelType ft ON c.FuelTypeId = ft.FuelTypeId
LEFT JOIN TransmissionType tt ON c.TransmissionTypeId = tt.TransmissionTypeId
ORDER BY c.CreatedDate DESC;
```

## ⚠️ Lưu Ý Quan Trọng

1. **License Plate phải unique** - thay đổi nếu bị trùng
2. **PricePerMonth có thể NULL** - không bắt buộc
3. **Category có thể NULL** - không bắt buộc
4. **Ảnh có thể không có** - không bắt buộc

## 🆘 Nếu Vẫn Lỗi

1. Kiểm tra log server
2. Kiểm tra database connection
3. Kiểm tra quyền truy cập (Admin/Staff)
4. Restart server nếu cần

## 📞 Hỗ Trợ

Nếu vẫn gặp lỗi, hãy:

1. Chụp màn hình lỗi
2. Copy log lỗi
3. Ghi lại bước thực hiện
4. Liên hệ admin
