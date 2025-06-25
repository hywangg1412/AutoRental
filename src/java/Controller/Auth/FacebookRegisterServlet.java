package Controller.Auth;

import Mapper.UserMapper;
import Model.Entity.OAuth.FacebookUser;
import Model.Entity.User.User;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
import Service.User.UserService;
import Service.Auth.FacebookAuthService;
import Service.Role.RoleService;
import Service.Role.UserRoleService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Utils.SessionUtil;
import Model.Entity.OAuth.UserLogins;
import Service.Auth.EmailOTPVerificationService;
import Service.Auth.UserLoginsService;

//facebookLogin
public class FacebookRegisterServlet extends HttpServlet {

    private FacebookAuthService facebookAuthService;
    private UserMapper userMapper;
    private UserService userService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;
    private UserRoleService userRoleService;
    private EmailOTPVerificationService emailOTPVerificationService;

    @Override
    public void init() {
        facebookAuthService = new FacebookAuthService();
        userMapper = new UserMapper();
        userService = new UserService();
        userLoginsService = new UserLoginsService();
        roleService = new RoleService();
        userRoleService = new UserRoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(facebookAuthService.getAuthorizationRegisterUrl());
            return;
        }
        try {
            FacebookUser facebookUser = facebookAuthService.getRegisterUserInfo(code);
            User existingUser = userService.findByEmail(facebookUser.getEmail());
            if (existingUser != null) {
                String errorMsg;
                if (existingUser.isDeleted()) {
                    errorMsg = "This email is associated with a deleted account and cannot be reused.";
                } else if (existingUser.isBanned()) {
                    errorMsg = "This email is associated with a banned account. Please contact support.";
                } else {
                    errorMsg = "An account with this email already exists.";
                }
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            User newUser = userMapper.mapFacebookUserToUser(facebookUser);
            UserLogins userLogins = new UserLogins();
            userLogins.setLoginProvider("facebook");
            userLogins.setProviderKey(facebookUser.getFacebookId());

            // Lưu tạm vào session, KHÔNG add vào DB
            request.getSession().setAttribute("pendingUserType", "facebook");
            request.getSession().setAttribute("pendingUser", newUser);
            request.getSession().setAttribute("pendingUserLogins", userLogins);
            request.getSession().setAttribute("pendingUserRoleName", "User");

            response.sendRedirect(request.getContextPath() + "/pages/authen/verify-otp");
            return;
        } catch (Exception e) {
            request.setAttribute("error", "Facebook register failed - " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
        }
    }

}
