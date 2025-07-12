package Controller.Admin;

import Model.Constants.RoleConstants;
import Model.Constants.UserStatusConstants;
import Model.Entity.Role.Role;
import Model.Entity.User.User;
import Repository.Role.RoleRepository;
import Service.User.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "StaffListFragmentServlet", urlPatterns = {"/admin/staff-list-fragment"})
public class StaffListFragmentServlet extends HttpServlet {
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
        request.getRequestDispatcher("/pages/admin/staff-table-rows.jsp").forward(request, response);
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