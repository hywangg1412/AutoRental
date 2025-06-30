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

@WebServlet(name = "FacebookUnlinkServlet", urlPatterns = {"/facebook-unlink"})
public class FacebookUnlinkServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(FacebookUnlinkServlet.class.getName());
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
        
        response.sendRedirect(request.getContextPath() + "/user/profile");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to profile page
        response.sendRedirect(request.getContextPath() + "/user/profile");
    }
} 