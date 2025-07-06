# Hướng dẫn Test Multipart Configuration

## Vấn đề hiện tại

Bạn đang gặp lỗi "Too many files uploaded" khi sử dụng `maxFileParts` trong servlet.

## Giải pháp đã áp dụng

### 1. Thay đổi cấu hình Multipart

- **Trước:** `maxFileParts = 20` (không ổn định)
- **Sau:** `maxFileCount = 10` (ổn định hơn)

### 2. Cập nhật Servlet Configuration

```java
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB per file
    maxRequestSize = 1024 * 1024 * 100,  // 100MB total
    maxFileCount = 10                    // Maximum 10 files
)
```

### 3. Cập nhật web.xml

```xml
<multipart-config>
    <max-file-size>10485760</max-file-size> <!-- 10MB -->
    <max-request-size>104857600</max-request-size> <!-- 100MB -->
    <file-size-threshold>2097152</file-size-threshold> <!-- 2MB -->
    <max-file-count>10</max-file-count> <!-- Maximum 10 files -->
</multipart-config>
```

## Các file test đã tạo

### 1. Debug Test (`debug-test.jsp`)

- Test nhiều trường hợp khác nhau
- Upload 1 file, nhiều file, file lớn, file không phải ảnh
- Hiển thị thông tin chi tiết về file

### 2. Simple Multipart Test (`simple-multipart-test.jsp`)

- Test đơn giản với thông tin cấu hình
- Hiển thị thông tin file trước khi upload
- Validation client-side

## Cách test

### Bước 1: Restart Server

```bash
# Restart server để áp dụng cấu hình mới
```

### Bước 2: Clear Browser Cache

- Xóa cache trình duyệt
- Hoặc mở tab ẩn danh

### Bước 3: Test từng trường hợp

#### Test 1: Upload 1 file

1. Vào trang Car Management
2. Click "🔧 Debug Test"
3. Chọn "Test 1: Upload 1 file"
4. Chọn 1 file ảnh
5. Click "Test Upload 1 File"

#### Test 2: Upload nhiều file

1. Chọn "Test 2: Upload nhiều file (2-3 files)"
2. Chọn 2-3 file ảnh
3. Click "Test Upload Multiple Files"

#### Test 3: Không upload file

1. Chọn "Test 3: Không upload file"
2. Click "Test No File Upload"

#### Test 4: File lớn

1. Chọn "Test 4: File lớn (>5MB)"
2. Chọn file >5MB
3. Click "Test Large File"

#### Test 5: File không phải ảnh

1. Chọn "Test 5: File không phải ảnh"
2. Chọn file .txt, .pdf, etc.
3. Click "Test Non-Image File"

### Bước 4: Kiểm tra logs

Xem logs server để debug:

```
=== MULTIPART DEBUG INFO ===
Part - Name: 'action', Size: 3, Content-Type: 'text/plain', SubmittedFileName: 'null', IsImageFile: false
Part - Name: 'carImage', Size: 1024000, Content-Type: 'image/jpeg', SubmittedFileName: 'test.jpg', IsImageFile: true
Total request size: 1024003 bytes
Total image files: 1
=== END MULTIPART DEBUG INFO ===
```

## Lưu ý quan trọng

### 1. Sự khác biệt giữa maxFileParts và maxFileCount

- **maxFileParts:** Đếm tất cả các part (bao gồm cả form fields)
- **maxFileCount:** Chỉ đếm file uploads

### 2. Validation

- Client-side: Kiểm tra số lượng file, kích thước, loại file
- Server-side: Xử lý multipart và validation

### 3. Error Handling

- FileCountLimitExceededException: Quá nhiều file
- SizeLimitExceededException: File quá lớn
- IllegalArgumentException: Validation errors

## Troubleshooting

### Nếu vẫn gặp lỗi:

1. **Kiểm tra logs:** Xem thông tin debug trong console
2. **Test với Simple Test:** Sử dụng simple-multipart-test.jsp
3. **Kiểm tra cấu hình:** Đảm bảo web.xml và servlet annotation đồng bộ
4. **Restart server:** Đảm bảo cấu hình mới được áp dụng

### Common Issues:

- **"Too many files uploaded":** Giảm maxFileCount hoặc kiểm tra validation
- **"File size exceeds limit":** Kiểm tra maxFileSize và maxRequestSize
- **"Invalid file type":** Kiểm tra accept="image/\*" và server-side validation

## Kết quả mong đợi

- Upload 1-10 file ảnh thành công
- Validation đúng với giới hạn
- Error messages rõ ràng
- Logs debug chi tiết
