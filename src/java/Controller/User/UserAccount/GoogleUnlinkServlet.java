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

@WebServlet(name = "GoogleUnlinkServlet", urlPatterns = {"/google-unlink"})
public class GoogleUnlinkServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(GoogleUnlinkServlet.class.getName());
    private UserLoginsService userLoginsService;

    @Override
    public void init() {
        userLoginsService = new UserLoginsService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }

        try {
            // Find and remove Google login record for this user
            UserLogins googleLogin = userLoginsService.findByUserIdAndProvider(currentUser.getUserId(), "google");
            if (googleLogin != null) {
                // Delete by composite key (LoginProvider, ProviderKey)
                userLoginsService.deleteByProviderAndKey(googleLogin.getLoginProvider(), googleLogin.getProviderKey());
                SessionUtil.setSessionAttribute(request, "success", "Google account unlinked successfully!");
            } else {
                SessionUtil.setSessionAttribute(request, "error", "No Google account found to unlink.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error unlinking Google account", e);
            SessionUtil.setSessionAttribute(request, "error", "Failed to unlink Google account. Please try again.");
        }
        
        response.sendRedirect(request.getContextPath() + "/user/profile");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to profile page
        response.sendRedirect(request.getContextPath() + "/user/profile");
    }
} 