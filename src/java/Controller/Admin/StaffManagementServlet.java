package Controller.Admin;

import Model.Constants.RoleConstants;
import Model.Constants.UserStatusConstants;
import Model.Entity.Role.Role;
import Model.Entity.User.User;
import Service.Role.RoleService;
import Service.User.UserService;
import Utils.ObjectUtils;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/StaffServlet")
public class StaffManagementServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(StaffManagementServlet.class.getName());
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!isAuthorized(request)) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/access-denied.jsp");
            return;
        }
        
        try {
            // Lấy danh sách tất cả staff
            Role staffRole = null;
            List<User> staffList = new ArrayList<>();
            
            try {
                staffRole = roleService.findByRoleName(RoleConstants.STAFF);
                staffList = userService.findByRoleId(staffRole.getRoleId());
            } catch (Exception roleException) {
                LOGGER.log(Level.WARNING, "Không thể tìm role Staff bằng tên, thử tìm bằng UUID", roleException);
                
                // Fallback: thử tìm role Staff bằng UUID cố định từ data.sql
                try {
                    UUID staffRoleId = UUID.fromString("550e8400-e29b-41d4-a716-446655440000");
                    staffRole = roleService.findById(staffRoleId);
                    if (staffRole != null) {
                        staffList = userService.findByRoleId(staffRole.getRoleId());
                        LOGGER.info("Đã tìm thấy role Staff bằng UUID fallback");
                    }
                } catch (Exception fallbackException) {
                    LOGGER.log(Level.SEVERE, "Không thể tìm role Staff bằng UUID fallback", fallbackException);
                    throw new Exception("Không thể tìm thấy role Staff trong database. Vui lòng chạy script CHECK_AND_FIX_STAFF_ROLE.sql");
                }
            }
            
            // Tính toán thống kê
            long totalStaff = staffList.size();
            long activeStaff = staffList.stream().filter(user -> UserStatusConstants.ACTIVE.equals(user.getStatus())).count();
            long disabledStaff = staffList.stream().filter(user -> UserStatusConstants.BANNED.equals(user.getStatus())).count();
            
            request.setAttribute("staffList", staffList);
            request.setAttribute("totalStaff", totalStaff);
            request.setAttribute("activeStaff", activeStaff);
            request.setAttribute("disabledStaff", disabledStaff);
            
            // Hiển thị thông báo nếu có
            String successMessage = (String) SessionUtil.getSessionAttribute(request, "success");
            String errorMessage = (String) SessionUtil.getSessionAttribute(request, "error");
            
            if (successMessage != null) {
                request.setAttribute("success", successMessage);
                SessionUtil.removeSessionAttribute(request, "success");
            }
            if (errorMessage != null) {
                request.setAttribute("error", errorMessage);
                SessionUtil.removeSessionAttribute(request, "error");
            }
            
            request.getRequestDispatcher("/pages/admin/manage-staff.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading staff management page", e);
            String errorMessage = "Không thể tải trang quản lý nhân viên: " + e.getMessage();
            
            // Log chi tiết lỗi
            if (e.getCause() != null) {
                LOGGER.log(Level.SEVERE, "Root cause: " + e.getCause().getMessage(), e.getCause());
            }
            
            request.setAttribute("errorMsg", errorMessage);
            request.getRequestDispatcher("/pages/Error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!isAuthorized(request)) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    handleAddStaff(request, response);
                    break;
                case "update":
                    handleUpdateStaff(request, response);
                    break;
                case "disable":
                    handleDisableStaff(request, response);
                    break;
                case "enable":
                    handleEnableStaff(request, response);
                    break;
                case "delete":
                    handleDeleteStaff(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    return;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing staff management action: " + action, e);
            
            // Log chi tiết lỗi
            if (e.getCause() != null) {
                LOGGER.log(Level.SEVERE, "Root cause: " + e.getCause().getMessage(), e.getCause());
            }
            
            String errorMessage = "Lỗi xử lý yêu cầu: " + e.getMessage();
            
            // Kiểm tra các loại lỗi cụ thể
            if (e.getMessage().contains("Role not found") || e.getMessage().contains("role Staff")) {
                errorMessage = "Lỗi cấu hình role. Vui lòng liên hệ quản trị viên.";
            } else if (e.getMessage().contains("connection") || e.getMessage().contains("database")) {
                errorMessage = "Lỗi kết nối database. Vui lòng kiểm tra cấu hình database.";
            } else if (e.getMessage().contains("Email đã được sử dụng")) {
                errorMessage = "Email đã được sử dụng. Vui lòng chọn email khác.";
            } else if (e.getMessage().contains("Tên đăng nhập đã được sử dụng")) {
                errorMessage = "Tên đăng nhập đã được sử dụng. Vui lòng chọn tên đăng nhập khác.";
            }
            
            SessionUtil.setSessionAttribute(request, "error", errorMessage);
            response.sendRedirect(request.getContextPath() + "/StaffServlet");
        }
    }
    
    private void handleAddStaff(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("userDOB");
            
            LOGGER.info("Adding new staff member: " + email);
            
            // Validate input
            if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng điền đầy đủ thông tin bắt buộc");
            }
            
            // Kiểm tra email đã tồn tại chưa
            if (userService.findByEmail(email) != null) {
                throw new IllegalArgumentException("Email đã được sử dụng");
            }
            
            // Kiểm tra username đã tồn tại chưa
            if (userService.findByUsername(username) != null) {
                throw new IllegalArgumentException("Tên đăng nhập đã được sử dụng");
            }
            
            // Tạo user mới
            User newStaff = new User();
            newStaff.setUserId(UUID.randomUUID());
            newStaff.setFirstName(firstName.trim());
            newStaff.setLastName(lastName.trim());
            newStaff.setEmail(email.trim());
            newStaff.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
            newStaff.setUsername(username.trim());
            newStaff.setPasswordHash(ObjectUtils.hashPassword(password));
            newStaff.setGender(gender != null ? gender.trim() : null);
            newStaff.setStatus(UserStatusConstants.ACTIVE);
            newStaff.setCreatedDate(LocalDateTime.now());
            newStaff.setEmailVerifed(false);
            newStaff.setSecurityStamp(UUID.randomUUID().toString());
            newStaff.setConcurrencyStamp(UUID.randomUUID().toString());
            newStaff.setTwoFactorEnabled(false);
            newStaff.setLockoutEnabled(true);
            newStaff.setAccessFailedCount(0);
            newStaff.setNormalizedUserName(username.trim().toUpperCase());
            newStaff.setNormalizedEmail(email.trim().toUpperCase());
            
            // Parse ngày sinh nếu có
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    LocalDate dob = LocalDate.parse(dobStr);
                    newStaff.setUserDOB(dob);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Invalid date format for DOB: " + dobStr, e);
                }
            }
            
            // Lấy role Staff
            LOGGER.info("Finding Staff role...");
            Role staffRole = roleService.findByRoleName(RoleConstants.STAFF);
            newStaff.setRoleId(staffRole.getRoleId());
            LOGGER.info("Staff role found with ID: " + staffRole.getRoleId());
            
            // Lưu vào database
            LOGGER.info("Saving staff member to database...");
            User savedStaff = userService.add(newStaff);
            if (savedStaff == null) {
                throw new Exception("Không thể tạo tài khoản nhân viên");
            }
            
            LOGGER.info("Staff member added successfully: " + savedStaff.getUserId());
            SessionUtil.setSessionAttribute(request, "success", "Tạo tài khoản nhân viên thành công");
            response.sendRedirect(request.getContextPath() + "/StaffServlet");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding staff member", e);
            throw e;
        }
    }
    
    private void handleUpdateStaff(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String userIdStr = request.getParameter("userId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phoneNumber = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("userDOB");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID nhân viên không hợp lệ");
        }
        
        UUID userId = UUID.fromString(userIdStr);
        User existingStaff = userService.findById(userId);
        if (existingStaff == null) {
            throw new IllegalArgumentException("Không tìm thấy nhân viên");
        }
        
        // Cập nhật thông tin
        if (firstName != null && !firstName.trim().isEmpty()) {
            existingStaff.setFirstName(firstName.trim());
        }
        if (lastName != null && !lastName.trim().isEmpty()) {
            existingStaff.setLastName(lastName.trim());
        }
        existingStaff.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
        existingStaff.setGender(gender != null ? gender.trim() : null);
        
        // Parse ngày sinh nếu có
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                LocalDate dob = LocalDate.parse(dobStr);
                existingStaff.setUserDOB(dob);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Invalid date format for DOB: " + dobStr, e);
            }
        }
        
        // Lưu thay đổi
        boolean updated = userService.update(existingStaff);
        if (!updated) {
            throw new Exception("Không thể cập nhật thông tin nhân viên");
        }
        
        SessionUtil.setSessionAttribute(request, "success", "Cập nhật thông tin nhân viên thành công");
        response.sendRedirect(request.getContextPath() + "/StaffServlet");
    }
    
    private void handleDisableStaff(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String userIdStr = request.getParameter("userId");
        String reason = request.getParameter("reason");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID nhân viên không hợp lệ");
        }
        
        UUID userId = UUID.fromString(userIdStr);
        User staff = userService.findById(userId);
        if (staff == null) {
            throw new IllegalArgumentException("Không tìm thấy nhân viên");
        }
        
        // Vô hiệu hóa tài khoản
        staff.setStatus(UserStatusConstants.BANNED);
        boolean updated = userService.update(staff);
        if (!updated) {
            throw new Exception("Không thể vô hiệu hóa tài khoản nhân viên");
        }
        
        String message = "Đã vô hiệu hóa tài khoản nhân viên";
        if (reason != null && !reason.trim().isEmpty()) {
            message += ". Lý do: " + reason.trim();
        }
        
        SessionUtil.setSessionAttribute(request, "success", message);
        response.sendRedirect(request.getContextPath() + "/StaffServlet");
    }
    
    private void handleEnableStaff(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID nhân viên không hợp lệ");
        }
        
        UUID userId = UUID.fromString(userIdStr);
        User staff = userService.findById(userId);
        if (staff == null) {
            throw new IllegalArgumentException("Không tìm thấy nhân viên");
        }
        
        // Kích hoạt lại tài khoản
        staff.setStatus(UserStatusConstants.ACTIVE);
        boolean updated = userService.update(staff);
        if (!updated) {
            throw new Exception("Không thể kích hoạt tài khoản nhân viên");
        }
        
        SessionUtil.setSessionAttribute(request, "success", "Đã kích hoạt lại tài khoản nhân viên");
        response.sendRedirect(request.getContextPath() + "/StaffServlet");
    }
    
    private void handleDeleteStaff(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID nhân viên không hợp lệ");
        }
        
        UUID userId = UUID.fromString(userIdStr);
        User staff = userService.findById(userId);
        if (staff == null) {
            throw new IllegalArgumentException("Không tìm thấy nhân viên");
        }
        
        // Mark user as deleted first
        boolean markedAsDeleted = userService.markUserAsDeleted(userId);
        if (!markedAsDeleted) {
            throw new Exception("Không thể đánh dấu tài khoản nhân viên để xóa");
        }
        
        // Xóa tài khoản (thực tế là anonymize)
        boolean deleted = userService.anonymizeDeletedUser(userId);
        if (!deleted) {
            throw new Exception("Không thể xóa tài khoản nhân viên");
        }
        
        SessionUtil.setSessionAttribute(request, "success", "Đã xóa tài khoản nhân viên");
        response.sendRedirect(request.getContextPath() + "/StaffServlet");
    }
    
    private boolean isAuthorized(HttpServletRequest request) {
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        if (user == null) {
            return false;
        }
        
        try {
            Role userRole = roleService.findById(user.getRoleId());
            return userRole != null && RoleConstants.ADMIN.equalsIgnoreCase(userRole.getRoleName());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error checking user role", e);
            return false;
        }
    }
} 