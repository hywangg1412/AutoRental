package Controller.Admin;

import Model.Constants.RoleConstants;
import Model.Constants.UserStatusConstants;
import Model.Entity.Role.Role;
import Model.Entity.User.User;
import Repository.Role.RoleRepository;
import Service.User.UserService;
import Utils.ObjectUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "StaffManagementServlet", urlPatterns = {"/admin/manage-staff"})
public class StaffManagementServlet extends HttpServlet {
    private RoleRepository roleRepo;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        roleRepo = new RoleRepository();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        System.out.println("[DEBUG] Raw status param: [" + status + "]");
        
        List<User> staffList = new ArrayList<>();
        try {
            Role staffRole = roleRepo.findByRoleName(RoleConstants.STAFF);
            if (staffRole != null) {
                List<User> allStaff = userService.findByRoleId(staffRole.getRoleId());
                System.out.println("[DEBUG] Total staff found: " + allStaff.size());
                
                if (status == null || status.trim().isEmpty() || status.equalsIgnoreCase("all")) {
                    staffList = allStaff;
                    System.out.println("[DEBUG] Showing all staff: " + staffList.size());
                } else {
                    // Normalize status để match với UserStatusConstants
                    String normalizedStatus = normalizeStatus(status.trim());
                    System.out.println("[DEBUG] Normalized status: " + normalizedStatus);
                    
                    for (User u : allStaff) {
                        System.out.println("[DEBUG] Staff: " + u.getUserId() + ", status: [" + u.getStatus() + "]");
                        if (u.getStatus() != null && u.getStatus().equalsIgnoreCase(normalizedStatus)) {
                            staffList.add(u);
                        }
                    }
                    System.out.println("[DEBUG] Filtered staff count: " + staffList.size());
                }
            }
        } catch (Exception e) {
            System.err.println("[ERROR] Exception in staff filtering: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/pages/admin/manage-staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                handleAddStaff(request, response);
            } else if ("edit".equals(action)) {
                handleEditStaff(request, response);
            } else if ("delete".equals(action)) {
                handleDeleteStaff(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-staff");
            }
        } catch (Exception e) {
            System.err.println("[ERROR] Exception in staff management: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }

    private void handleAddStaff(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String userDOB = request.getParameter("userDOB");
            
        // Validate input
        if (firstName == null || firstName.trim().isEmpty()) {
            throw new Exception("First name is required");
        }
        if (lastName == null || lastName.trim().isEmpty()) {
            throw new Exception("Last name is required");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new Exception("Email is required");
        }
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("Username is required");
        }
        if (password == null || password.trim().isEmpty()) {
            throw new Exception("Password is required");
        }
        
        // Kiểm tra username và email đã tồn tại chưa
        if (userService.findByUsername(username.trim()) != null) {
            throw new Exception("Username already exists");
        }
        if (userService.findByEmail(email.trim()) != null) {
            throw new Exception("Email already exists");
        }
        
        // Lấy role Staff
        Role staffRole = roleRepo.findByRoleName(RoleConstants.STAFF);
        if (staffRole == null) {
            throw new Exception("Staff role not found");
        }
            
        // Tạo user mới với role Staff
        User user = new User();
        user.setUserId(UUID.randomUUID());
        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setEmail(email.trim());
        user.setUsername(username.trim());
        user.setNormalizedUserName(username.trim().toUpperCase());
        user.setNormalizedEmail(email.trim().toUpperCase());
        user.setPhoneNumber(phone != null ? phone.trim() : "");
        user.setGender(gender != null ? gender : "");
        
        // Chuyển đổi userDOB từ String sang LocalDate
        LocalDate dob = null;
        if (userDOB != null && !userDOB.trim().isEmpty()) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                dob = LocalDate.parse(userDOB.trim(), formatter);
            } catch (DateTimeParseException e) {
                // Nếu format không đúng, thử format khác
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    dob = LocalDate.parse(userDOB.trim(), formatter);
                } catch (DateTimeParseException ex) {
                    // Nếu vẫn không parse được, để null
                    dob = null;
                }
            }
        }
        user.setUserDOB(dob);
        user.setStatus(UserStatusConstants.ACTIVE);
        user.setRoleId(staffRole.getRoleId());
        
        // Set các trường bắt buộc khác
        user.setCreatedDate(java.time.LocalDateTime.now());
        user.setEmailVerifed(false);
        user.setPasswordHash(ObjectUtils.hashPassword(password));
        user.setSecurityStamp(UUID.randomUUID().toString());
        user.setConcurrencyStamp(UUID.randomUUID().toString());
        user.setTwoFactorEnabled(false);
        user.setLockoutEnabled(true);
        user.setAccessFailedCount(0);
        
        // Lưu user
        userService.add(user);
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-staff?success=add");
    }
    
    private void handleEditStaff(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UUID userId = UUID.fromString(request.getParameter("userId"));
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String phone = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String userDOB = request.getParameter("userDOB");
        
        // Validate input
        if (firstName == null || firstName.trim().isEmpty()) {
            throw new Exception("First name is required");
        }
        if (lastName == null || lastName.trim().isEmpty()) {
            throw new Exception("Last name is required");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new Exception("Email is required");
        }
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("Username is required");
        }
        
        // Cập nhật user
        User user = userService.findById(userId);
        if (user == null) {
            throw new Exception("Staff not found");
        }
        
        // Kiểm tra username và email có trùng với user khác không
        User existingUserWithUsername = userService.findByUsername(username.trim());
        if (existingUserWithUsername != null && !existingUserWithUsername.getUserId().equals(userId)) {
            throw new Exception("Username already exists");
        }
        
        User existingUserWithEmail = userService.findByEmail(email.trim());
        if (existingUserWithEmail != null && !existingUserWithEmail.getUserId().equals(userId)) {
            throw new Exception("Email already exists");
        }
        
        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setEmail(email.trim());
        user.setUsername(username.trim());
        user.setNormalizedUserName(username.trim().toUpperCase());
        user.setNormalizedEmail(email.trim().toUpperCase());
        user.setPhoneNumber(phone != null ? phone.trim() : "");
        user.setGender(gender != null ? gender : "");
        
        // Chuyển đổi userDOB từ String sang LocalDate
        LocalDate dob = null;
        if (userDOB != null && !userDOB.trim().isEmpty()) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                dob = LocalDate.parse(userDOB.trim(), formatter);
            } catch (DateTimeParseException e) {
                // Nếu format không đúng, thử format khác
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    dob = LocalDate.parse(userDOB.trim(), formatter);
                } catch (DateTimeParseException ex) {
                    // Nếu vẫn không parse được, để null
                    dob = null;
                }
            }
        }
        user.setUserDOB(dob);
        
        userService.update(user);
        response.sendRedirect(request.getContextPath() + "/admin/manage-staff?success=edit");
    }
    
    private void handleDeleteStaff(HttpServletRequest request, HttpServletResponse response) throws Exception {
        UUID userId = UUID.fromString(request.getParameter("userId"));
        
        // Kiểm tra user có tồn tại không
        User user = userService.findById(userId);
        if (user == null) {
            throw new Exception("Staff not found");
        }
        
        // Xóa user (set status thành DELETED thay vì xóa thật)
        user.setStatus(UserStatusConstants.DELETED);
        userService.update(user);
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-staff?success=delete");
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isEmpty()) return null;
        
        // Normalize về dạng chữ cái đầu viết hoa để match với UserStatusConstants
        String lowerStatus = status.toLowerCase();
        switch (lowerStatus) {
            case "active":
                return UserStatusConstants.ACTIVE; // "Active"
            case "banned":
                return UserStatusConstants.BANNED; // "Banned"
            case "inactive":
                return UserStatusConstants.INACTIVE; // "Inactive"
            case "deleted":
                return UserStatusConstants.DELETED; // "Deleted"
            default:
                // Nếu đã đúng format UserStatusConstants rồi
                if (status.equals(UserStatusConstants.ACTIVE) || 
                    status.equals(UserStatusConstants.BANNED) || 
                    status.equals(UserStatusConstants.INACTIVE) || 
                    status.equals(UserStatusConstants.DELETED)) {
                    return status;
                }
                System.err.println("[WARN] Unknown status: " + status);
                return status;
        }
    }
} 