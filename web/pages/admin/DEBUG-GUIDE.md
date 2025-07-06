# 🔧 Hướng Dẫn Debug Lỗi Upload Ảnh

## 📍 Vị Trí Lỗi

Lỗi "Error processing form data" xuất hiện ở **dòng 292** trong file `CarManagementServlet.java`:

```java
} catch (Exception e) {
    logger.error("Error processing form data: {}", e.getMessage(), e);
    redirectWithError(request, response, "Error processing form data: " + e.getMessage());
}
```

## 🔍 Các Nguyên Nhân Có Thể

### 1. **Lỗi Database**

- Kết nối database bị lỗi
- Bảng không tồn tại
- Constraint violation
- SQL syntax error

### 2. **Lỗi File System**

- Thư mục upload không có quyền ghi
- Disk space đầy
- Path không hợp lệ

### 3. **Lỗi Multipart Processing**

- File quá lớn
- Số lượng file vượt quá giới hạn
- Content type không hợp lệ

### 4. **Lỗi Validation**

- UUID không hợp lệ
- Dữ liệu form không đúng format
- Required fields bị thiếu

## 🛠️ Cách Debug

### Bước 1: Kiểm Tra Log Server

```bash
# Tìm log của CarManagementServlet
grep "CarManagementServlet" server.log
grep "Error processing form data" server.log
```

### Bước 2: Sử Dụng Debug Upload Page

Truy cập: `/pages/admin/debug-upload.jsp`

Các test case:

- **Test 1**: Upload 1 ảnh nhỏ
- **Test 2**: Upload nhiều ảnh
- **Test 3**: Không upload ảnh
- **Test 4**: Upload ảnh lớn (>10MB)
- **Test 5**: Upload file không phải ảnh

### Bước 3: Kiểm Tra Database

```sql
-- Kiểm tra bảng Car
SELECT COUNT(*) FROM Car;

-- Kiểm tra bảng CarImage
SELECT COUNT(*) FROM CarImage;

-- Kiểm tra bảng CarBrand
SELECT * FROM CarBrand LIMIT 5;

-- Kiểm tra bảng FuelType
SELECT * FROM FuelType LIMIT 5;

-- Kiểm tra bảng TransmissionType
SELECT * FROM TransmissionType LIMIT 5;
```

### Bước 4: Kiểm Tra File System

```bash
# Kiểm tra thư mục upload
ls -la /path/to/webapp/Uploads/car-images/

# Kiểm tra quyền ghi
touch /path/to/webapp/Uploads/car-images/test.txt
rm /path/to/webapp/Uploads/car-images/test.txt

# Kiểm tra disk space
df -h
```

## 🚨 Các Lỗi Thường Gặp

### 1. **"Invalid UUID format"**

```java
// Lỗi: UUID không hợp lệ
UUID.fromString("invalid-uuid");
```

**Giải pháp**: Kiểm tra các UUID trong form data

### 2. **"Table doesn't exist"**

```java
// Lỗi: Bảng không tồn tại
carService.add(car);
```

**Giải pháp**: Chạy script SQL để tạo bảng

### 3. **"Permission denied"**

```java
// Lỗi: Không có quyền ghi file
Files.createDirectories(Paths.get(uploadPath));
```

**Giải pháp**: Cấp quyền ghi cho thư mục upload

### 4. **"File size exceeds limit"**

```java
// Lỗi: File quá lớn
if (filePart.getSize() > 10 * 1024 * 1024) {
    throw new IllegalArgumentException("Image size exceeds 10MB limit");
}
```

**Giải pháp**: Giảm kích thước file hoặc tăng limit

## 📋 Checklist Debug

- [ ] Kiểm tra log server
- [ ] Test với debug upload page
- [ ] Kiểm tra kết nối database
- [ ] Kiểm tra quyền thư mục upload
- [ ] Kiểm tra disk space
- [ ] Validate form data
- [ ] Kiểm tra UUID format
- [ ] Test với file nhỏ
- [ ] Test với file lớn
- [ ] Test với nhiều file

## 🔧 Cách Sửa Lỗi

### 1. **Thêm Log Chi Tiết**

```java
try {
    // Code xử lý
} catch (Exception e) {
    logger.error("Error processing form data: {}", e.getMessage(), e);
    logger.error("Stack trace: ", e);
    logger.error("Request details: contentType={}, method={}",
                request.getContentType(), request.getMethod());
    redirectWithError(request, response, "Error processing form data: " + e.getMessage());
}
```

### 2. **Kiểm Tra Database Connection**

```java
try {
    carService.add(car);
} catch (SQLException e) {
    logger.error("Database error: {}", e.getMessage(), e);
    redirectWithError(request, response, "Database error: " + e.getMessage());
}
```

### 3. **Validate File Upload**

```java
if (filePart != null && filePart.getSize() > 0) {
    String contentType = filePart.getContentType();
    if (contentType == null || !contentType.startsWith("image/")) {
        throw new IllegalArgumentException("Only image files are allowed");
    }
}
```

## 📞 Liên Hệ Hỗ Trợ

Nếu vẫn gặp lỗi, vui lòng cung cấp:

1. Log lỗi chi tiết từ server
2. Screenshot lỗi
3. Thông tin môi trường (OS, Java version, Server)
4. Các bước tái hiện lỗi
