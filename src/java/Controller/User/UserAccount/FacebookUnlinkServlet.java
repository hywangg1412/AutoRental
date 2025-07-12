package Controller.User.UserAccount;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.Auth.UserLoginsService;
import Model.Entity.OAuth.UserLogins;
import Utils.SessionUtil;
import Model.Entity.User.User;
import java.util.logging.Level;
import java.util.logging.Logger;
import Service.Role.RoleService;
import Model.Entity.Role.Role;

@WebServlet(name = "FacebookUnlinkServlet", urlPatterns = {"/facebook-unlink"})
public class FacebookUnlinkServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(FacebookUnlinkServlet.class.getName());
    private UserLoginsService userLoginsService;
    private RoleService roleService;

    @Override
    public void init() {
        userLoginsService = new UserLoginsService();
        roleService = new RoleService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        String profileRedirect = "/user/profile";
        try {
            Role userRole = roleService.findById(currentUser.getRoleId());
            if (userRole != null && "Staff".equalsIgnoreCase(userRole.getRoleName())) {
                profileRedirect = "/staff/profile";
            }
        } catch (Exception ex) {
            // Nếu lỗi khi lấy role, giữ nguyên profileRedirect là /user/profile
        }
        try {
            // Find and remove Facebook login record for this user
            UserLogins facebookLogin = userLoginsService.findByUserIdAndProvider(currentUser.getUserId(), "facebook");
            if (facebookLogin != null) {
                // Delete by composite key (LoginProvider, ProviderKey)
                userLoginsService.deleteByProviderAndKey(facebookLogin.getLoginProvider(), facebookLogin.getProviderKey());
                SessionUtil.setSessionAttribute(request, "success", "Facebook account unlinked successfully!");
            } else {
                SessionUtil.setSessionAttribute(request, "error", "No Facebook account found to unlink.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error unlinking Facebook account", e);
            SessionUtil.setSessionAttribute(request, "error", "Failed to unlink Facebook account. Please try again.");
        }
        
        response.sendRedirect(request.getContextPath() + profileRedirect);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to profile page
        String profileRedirect = "/user/profile";
        User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
        if (currentUser != null) {
            try {
                Role userRole = roleService.findById(currentUser.getRoleId());
                if (userRole != null && "Staff".equalsIgnoreCase(userRole.getRoleName())) {
                    profileRedirect = "/staff/profile";
                }
            } catch (Exception ex) {
                // Nếu lỗi khi lấy role, giữ nguyên profileRedirect là /user/profile
            }
        }
        response.sendRedirect(request.getContextPath() + profileRedirect);
    }
} 