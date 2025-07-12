package Controller.Admin;

import Model.Constants.RoleConstants;
import Model.Constants.UserStatusConstants;
import Model.Entity.Role.Role;
import Model.Entity.User.User;
import Service.Role.RoleService;
import Service.User.UserService;
import Utils.ObjectUtils;
import Utils.SessionUtil;
import Utils.FormatUtils;
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

@WebServlet("/admin/staff-management")
public class StaffManagementServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(StaffManagementServlet.class.getName());
    private UserService userService;
    private RoleService roleService;
    

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        roleService = new RoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userId = (String) SessionUtil.getSessionAttribute(request, "userId");
        if (userId == null || userId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/login.jsp");
            return;
        }
        
        try {
            Role staffRole = roleService.findByRoleName(RoleConstants.STAFF);
            List<User> staffList = userService.findByRoleId(staffRole.getRoleId());
            
            int totalStaff = 0, activeStaff = 0, disabledStaff = 0;
            for (User user : staffList) {
                totalStaff++;
                if (UserStatusConstants.ACTIVE.equals(user.getStatus())) activeStaff++;
                else if (UserStatusConstants.BANNED.equals(user.getStatus())) disabledStaff++;
            }
            
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
            
            List<String> statusList = new ArrayList<>();
            statusList.add(UserStatusConstants.ACTIVE);
            statusList.add(UserStatusConstants.BANNED);
            statusList.add(UserStatusConstants.INACTIVE);
            statusList.add(UserStatusConstants.DELETED);
            request.setAttribute("statusList", statusList);
            
            request.getRequestDispatcher("/pages/admin/manage-staff.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading staff management page", e);
            String errorMessage = "Không thể tải trang quản lý nhân viên: " + e.getMessage();
            
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
        String userId = (String) SessionUtil.getSessionAttribute(request, "userId");
        if (userId == null || userId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/login.jsp");
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
            response.sendRedirect(request.getContextPath() + "/admin/staff-management");
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
                throw new IllegalArgumentException("Please fill in all required fields");
            }
            
            if (userService.findByEmail(email) != null) {
                throw new IllegalArgumentException("Email is already in use");
            }
            
            if (userService.findByUsername(username) != null) {
                throw new IllegalArgumentException("Username is already in use");
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
            
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    LocalDate dob = FormatUtils.parseDate(dobStr);
                    newStaff.setUserDOB(dob);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Invalid date format for DOB: " + dobStr, e);
                }
            }
            
            Role staffRole = roleService.findByRoleName(RoleConstants.STAFF);
            newStaff.setRoleId(staffRole.getRoleId());
            LOGGER.info("Staff role found with ID: " + staffRole.getRoleId());
            
            // Lưu vào database
            LOGGER.info("Saving staff member to database...");
            User savedStaff = userService.add(newStaff);
            if (savedStaff == null) {
                throw new Exception("Failed to create staff account");
            }
            
            LOGGER.info("Staff member added successfully: " + savedStaff.getUserId());
            SessionUtil.setSessionAttribute(request, "success", "Staff account created successfully");
            response.sendRedirect(request.getContextPath() + "/admin/staff-management");
            
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
            throw new IllegalArgumentException("Invalid staff ID");
        }
        
        UUID userId = UUID.fromString(userIdStr);
        User existingStaff = userService.findById(userId);
        if (existingStaff == null) {
            throw new IllegalArgumentException("Staff not found");
        }
        
        if (firstName != null && !firstName.trim().isEmpty()) {
            existingStaff.setFirstName(firstName.trim());
        }
        if (lastName != null && !lastName.trim().isEmpty()) {
            existingStaff.setLastName(lastName.trim());
        }
        existingStaff.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : null);
        existingStaff.setGender(gender != null ? gender.trim() : null);
        
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                LocalDate dob = FormatUtils.parseDate(dobStr);
                existingStaff.setUserDOB(dob);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Invalid date format for DOB: " + dobStr, e);
            }
        }
        
        boolean updated = userService.update(existingStaff);
        if (!updated) {
            throw new Exception("Failed to update staff information");
        }
        
        SessionUtil.setSessionAttribute(request, "success", "Staff information updated successfully");
        response.sendRedirect(request.getContextPath() + "/admin/staff-management");
    }
    
    private void handleDisableStaff(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String userIdStr = request.getParameter("userId");
        String reason = request.getParameter("reason");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid staff ID");
        }
        
        UUID userId = UUID.fromString(userIdStr);
        User staff = userService.findById(userId);
        if (staff == null) {
            throw new IllegalArgumentException("Staff not found");
        }
        
        staff.setStatus(UserStatusConstants.BANNED);
        boolean updated = userService.update(staff);
        if (!updated) {
            throw new Exception("Failed to disable staff account");
        }
        
        String message = "Đã vô hiệu hóa tài khoản nhân viên";
        if (reason != null && !reason.trim().isEmpty()) {
            message += ". Reason: " + reason.trim();
        }
        
        SessionUtil.setSessionAttribute(request, "success", "Staff account disabled successfully");
        response.sendRedirect(request.getContextPath() + "/admin/staff-management");
    }
    
    private void handleEnableStaff(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid staff ID");
        }
        
        UUID userId = UUID.fromString(userIdStr);
        User staff = userService.findById(userId);
        if (staff == null) {
            throw new IllegalArgumentException("Staff not found");
        }
        
        staff.setStatus(UserStatusConstants.ACTIVE);
        boolean updated = userService.update(staff);
        if (!updated) {
            throw new Exception("Failed to enable staff account");
        }
        
        SessionUtil.setSessionAttribute(request, "success", "Staff account enabled successfully");
        response.sendRedirect(request.getContextPath() + "/admin/staff-management");
    }
    
    private void handleDeleteStaff(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        
        String userIdStr = request.getParameter("userId");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid staff ID");
        }
        
        UUID userId = UUID.fromString(userIdStr);
        User staff = userService.findById(userId);
        if (staff == null) {
            throw new IllegalArgumentException("Staff not found");
        }
        
        boolean markedAsDeleted = userService.markUserAsDeleted(userId);
        if (!markedAsDeleted) {
            throw new Exception("Failed to mark staff account for deletion");
        }
        
        boolean deleted = userService.anonymizeDeletedUser(userId);
        if (!deleted) {
            throw new Exception("Failed to delete staff account");
        }
        
        SessionUtil.setSessionAttribute(request, "success", "Staff account deleted successfully");
        response.sendRedirect(request.getContextPath() + "/admin/staff-management");
    }
} 