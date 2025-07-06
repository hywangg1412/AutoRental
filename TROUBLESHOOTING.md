# Hướng dẫn khắc phục lỗi - AutoRental

## Lỗi FileCountLimitExceededException

**Mô tả:** Lỗi xảy ra khi upload quá nhiều file ảnh cùng lúc.

**Nguyên nhân:**

- Tomcat giới hạn số lượng file upload theo cấu hình web.xml
- Servlet không kiểm tra số lượng file trước khi xử lý

**Cách khắc phục đã thực hiện:**

1. **Tách chức năng upload ảnh ra servlet riêng** - CarImageUploadServlet
2. **Xóa xử lý multipart khỏi CarManagementServlet** - Chỉ xử lý form thường
3. **Tạo trang upload ảnh riêng biệt** - upload-images.jsp
4. **Thêm nút upload ảnh vào trang quản lý xe** - Link đến trang upload riêng

**Quy trình mới:**

1. Thêm/sửa xe (không có ảnh) → CarManagementServlet
2. Upload ảnh riêng → CarImageUploadServlet
3. Xem ảnh → Hiển thị trong danh sách xe

**Ưu điểm:**

- Tránh lỗi FileCountLimitExceededException
- Tách biệt chức năng, dễ bảo trì
- Upload ảnh linh hoạt, có thể thêm/sửa/xóa ảnh riêng

## Lỗi "Cannot insert the value NULL into column 'PricePerMonth'"

**Mô tả:** Lỗi database khi thêm xe mà không có giá trị PricePerMonth.

**Nguyên nhân:** Cột PricePerMonth trong database có ràng buộc NOT NULL.

**Cách khắc phục:**

- Servlet tự động gán giá trị 0 cho PricePerMonth khi null
- Các trang test đã có giá trị mặc định cho PricePerMonth

## Lỗi "Invalid request type"

**Mô tả:** Lỗi khi submit form không có ảnh nhưng servlet yêu cầu multipart/form-data.

**Nguyên nhân:** Servlet chỉ xử lý multipart request.

**Cách khắc phục:**

- Servlet đã được sửa để xử lý cả multipart và form thường
- Form không có ảnh không cần enctype multipart
- Form có ảnh phải có enctype="multipart/form-data"

## Test Pages

### Test Add Car (test-add-car.jsp)

- **Mục đích**: Test thêm xe mới với form đầy đủ
- **Đặc điểm**:
  - Form đầy đủ các trường
  - Không có upload ảnh (ảnh upload riêng biệt)
  - Validation chặt chẽ
  - Nút fill test data
  - Giao diện đẹp
- **Sử dụng**: Test chức năng thêm xe mới
- **Cách sử dụng**:
  1. Điền thông tin xe hoặc click "Fill Test Data"
  2. Click "Add Car" để thêm xe
  3. Upload ảnh riêng biệt sau khi thêm xe thành công

### Test Update Car (test-update-car.jsp)

- **Mục đích**: Test cập nhật thông tin xe với form đầy đủ
- **Đặc điểm**:
  - Chọn xe từ danh sách
  - Load dữ liệu hiện tại
  - Validation chặt chẽ
  - Nút fill test data
  - Hiển thị thông tin xe hiện tại
- **Sử dụng**: Test chức năng update xe với giao diện đẹp
- **Cách sử dụng**:
  1. Chọn xe từ dropdown
  2. Xem thông tin xe hiện tại
  3. Sửa thông tin cần thiết
  4. Hoặc click "Fill Test Data" để điền dữ liệu mẫu
  5. Click "Update Car" để cập nhật

### Simple Update Test (simple-update-test.jsp)

- **Mục đích**: Test cập nhật thông tin xe với form đơn giản
- **Đặc điểm**:
  - Form đơn giản, dễ debug
  - Hiển thị tất cả field dưới dạng text input
  - Console logging để debug
  - Validation cơ bản
- **Sử dụng**: Debug và test chức năng update cơ bản
- **Cách sử dụng**:
  1. Chọn xe từ dropdown
  2. Form sẽ hiển thị với dữ liệu hiện tại
  3. Sửa thông tin cần thiết
  4. Click "Update Car" để cập nhật
  5. Kiểm tra console để debug

## Thứ tự test khuyến nghị

1. **Test Add Car** (test-add-car.jsp) - Test thêm xe mới
2. **Simple Update Test** (simple-update-test.jsp) - Test cập nhật xe đơn giản để debug
3. **Test Update Car** (test-update-car.jsp) - Test cập nhật xe với giao diện đầy đủ

## Cấu hình hiện tại

- **Max file size:** 10MB per file
- **Max request size:** 100MB total
- **Max image count:** 10 images
- **File size threshold:** 2MB
- **Supported formats:** JPG, PNG, GIF
