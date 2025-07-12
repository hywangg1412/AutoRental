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

import Model.Entity.User.User;
import Model.Entity.Role.Role;
import Service.User.UserService;
import Service.Role.RoleService;
import Repository.Booking.BookingRepository;

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
            // Get filter parameters
            String roleFilter = request.getParameter("role");
            String statusFilter = request.getParameter("status");
            String searchTerm = request.getParameter("search");
            
            // Use optimized repository method
            List<User> users = userService.getUsersWithFilters(roleFilter, statusFilter, searchTerm);
            
            System.out.println("Filtered user count: " + users.size());
            
            for (User user : users) {
                try {
                    // Get role name
                    if (user.getRoleId() != null) {
                        Role role = roleService.findById(user.getRoleId());
                        if (role != null) {
                            request.setAttribute("role_" + user.getUserId(), role.getRoleName());
                        }
                    }
                    
                    // Get booking count
                    List<Booking> userBookings = bookingRepository.findByUserId(user.getUserId());
                    request.setAttribute("bookingCount_" + user.getUserId(), userBookings.size());
                    
                    // Calculate total spent (sum of all booking amounts)
                    double totalSpent = userBookings.stream()
                            .mapToDouble(booking -> booking.getTotalAmount())
                            .sum();
                    request.setAttribute("totalSpent_" + user.getUserId(), totalSpent);
                    
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error getting additional info for user: " + user.getUserId(), e);
                    // Set default values if there's an error
                    request.setAttribute("role_" + user.getUserId(), "Unknown");
                    request.setAttribute("bookingCount_" + user.getUserId(), 0);
                    request.setAttribute("totalSpent_" + user.getUserId(), 0.0);
                }
            }
            
            request.setAttribute("users", users);
            
            request.getRequestDispatcher("/pages/admin/manage-users.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching users", e);
            request.setAttribute("error", "Error loading users: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/manage-users.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in user management", e);
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/manage-users.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests if needed in the future
        doGet(request, response);
    }
}
