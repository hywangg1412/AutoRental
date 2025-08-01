package Controller.Admin;

import Model.Entity.Booking.Booking;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.UUID;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import Model.Entity.User.User;
import Model.Entity.Role.Role;
import Service.User.UserService;
import Service.Role.RoleService;
import Repository.Booking.BookingRepository;
import java.util.stream.Collectors;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/admin/user-management"})
public class UserManagementServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(UserManagementServlet.class.getName());
    private UserService userService;
    private RoleService roleService;
    private BookingRepository bookingRepository;

    @Override
    public void init() {
        userService = new UserService();
        roleService = new RoleService();
        bookingRepository = new BookingRepository();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String editId = request.getParameter("edit");
            if (editId != null && !editId.isEmpty()) {
                User editUser = userService.findById(UUID.fromString(editId));
                request.setAttribute("editUser", editUser);
            }
            String status = request.getParameter("status");
            List<User> users = userService.getAllUsers();
            UUID userRoleId = UUID.fromString("6BA7B810-9DAD-11D1-80B4-00C04FD430C8");
            List<User> filteredUsers = users.stream()
                .filter(u -> userRoleId.equals(u.getRoleId()))
                .filter(u -> {
                    if (status == null || status.equalsIgnoreCase("all") || status.isEmpty()) return true;
                    if (status.equalsIgnoreCase("active")) return u.getStatus() != null && u.getStatus().equalsIgnoreCase("Active");
                    if (status.equalsIgnoreCase("banned")) return u.getStatus() != null && u.getStatus().equalsIgnoreCase("Banned");
                    return true;
                })
                .collect(Collectors.toList());
            request.setAttribute("users", filteredUsers);
            request.getRequestDispatcher("/pages/admin/manage-users.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/manage-users.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                // Validate phone number uniqueness for new user
                String phoneNumber = request.getParameter("phoneNumber");
                if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
                    if (!userService.isPhoneNumberUnique(phoneNumber.trim(), null)) {
                        request.setAttribute("error", "Số điện thoại đã tồn tại trong hệ thống!");
                        response.sendRedirect(request.getContextPath() + "/admin/user-management");
                        return;
                    }
                }
                
                User user = new User();
                user.setUserId(UUID.randomUUID());
                user.setUsername(request.getParameter("username"));
                user.setEmail(request.getParameter("email"));
                user.setPhoneNumber(request.getParameter("phoneNumber"));
                user.setGender(request.getParameter("gender"));
                user.setStatus(request.getParameter("status"));
                user.setRoleId(UUID.fromString("6BA7B810-9DAD-11D1-80B4-00C04FD430C8"));
                user.setPasswordHash(request.getParameter("passwordHash"));
                user.setCreatedDate(java.time.LocalDateTime.now());
                String userDOB = request.getParameter("userDOB");
                if (userDOB != null && !userDOB.isEmpty()) {
                    user.setUserDOB(java.time.LocalDate.parse(userDOB));
                }
                userService.add(user);
                request.setAttribute("success", "Thêm user thành công!");
            } else if ("update".equals(action)) {
                String userId = request.getParameter("userId");
                String phoneNumber = request.getParameter("phoneNumber");
                
                // Validate phone number uniqueness for update (exclude current user)
                if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
                    UUID userIdUUID = UUID.fromString(userId);
                    if (!userService.isPhoneNumberUnique(phoneNumber.trim(), userIdUUID)) {
                        request.setAttribute("error", "Số điện thoại đã tồn tại trong hệ thống!");
                        response.sendRedirect(request.getContextPath() + "/admin/user-management");
                        return;
                    }
                }
                
                User user = userService.findById(UUID.fromString(userId));
                if (user != null) {
                    user.setUsername(request.getParameter("username"));
                    user.setEmail(request.getParameter("email"));
                    user.setPhoneNumber(request.getParameter("phoneNumber"));
                    user.setGender(request.getParameter("gender"));
                    user.setStatus(request.getParameter("status"));
                    user.setRoleId(UUID.fromString("6BA7B810-9DAD-11D1-80B4-00C04FD430C8"));
                    String userDOB = request.getParameter("userDOB");
                    if (userDOB != null && !userDOB.isEmpty()) {
                        user.setUserDOB(java.time.LocalDate.parse(userDOB));
                    }
                    userService.update(user);
                    request.setAttribute("success", "Cập nhật user thành công!");
                }
            } else if ("ban".equals(action)) {
                String userId = request.getParameter("userId");
                User user = userService.findById(UUID.fromString(userId));
                if (user != null) {
                    user.setStatus(Model.Constants.UserStatusConstants.BANNED);
                    userService.update(user);
                    request.setAttribute("success", "User has been banned!");
                } else {
                    request.setAttribute("error", "User not found!");
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi thao tác: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/user-management");
    }
}
