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

@WebServlet(name = "SocialUnlinkServlet", urlPatterns = {"/user/social-unlink"})
public class SocialUnlinkServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SocialUnlinkServlet.class.getName());
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
        
        // Check if user is logged in
        User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        
        // Validate provider parameter
        String provider = request.getParameter("provider");
        if (provider == null || provider.trim().isEmpty()) {
            SessionUtil.setSessionAttribute(request, "error", "Provider parameter is required.");
            redirectToProfile(request, response, currentUser);
            return;
        }
        
        // Normalize and validate provider
        provider = provider.toLowerCase().trim();
        if (!provider.equals("facebook") && !provider.equals("google")) {
            SessionUtil.setSessionAttribute(request, "error", "Invalid provider. Only 'facebook' and 'google' are supported.");
            redirectToProfile(request, response, currentUser);
            return;
        }
        
        try {
            // Find and delete UserLogins record
            UserLogins userLogin = userLoginsService.findByUserIdAndProvider(currentUser.getUserId(), provider);
            
            if (userLogin == null) {
                SessionUtil.setSessionAttribute(request, "error", "No " + provider + " account is currently linked to your profile.");
                redirectToProfile(request, response, currentUser);
                return;
            }
            
            // Delete the record
            boolean deleted = userLoginsService.deleteByProviderAndKey(userLogin.getLoginProvider(), userLogin.getProviderKey());
            
            if (deleted) {
                String providerName = provider.substring(0, 1).toUpperCase() + provider.substring(1);
                SessionUtil.setSessionAttribute(request, "success", providerName + " account has been successfully unlinked from your profile.");
                LOGGER.info("User " + currentUser.getUserId() + " unlinked " + provider + " account successfully");
            } else {
                SessionUtil.setSessionAttribute(request, "error", "Failed to unlink " + provider + " account. Please try again.");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error unlinking " + provider + " account for user " + currentUser.getUserId(), e);
            SessionUtil.setSessionAttribute(request, "error", "An error occurred while unlinking your " + provider + " account. Please try again later.");
        }
        
        redirectToProfile(request, response, currentUser);
    }

    private void redirectToProfile(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException {
        String profileRedirect = "/user/profile";
        
        try {
            Role userRole = roleService.findById(currentUser.getRoleId());
            if (userRole != null && "Staff".equalsIgnoreCase(userRole.getRoleName())) {
                profileRedirect = "/staff/profile";
            } else if (userRole != null && "Admin".equalsIgnoreCase(userRole.getRoleName())) {
                profileRedirect = "/admin/profile";
            }
        } catch (Exception ex) {
            LOGGER.log(Level.WARNING, "Error determining user role for profile redirect", ex);
        }
        
        response.sendRedirect(request.getContextPath() + profileRedirect);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        redirectToProfile(request, response, currentUser);
    }
}
