package Controller.Auth;

import Mapper.UserMapper;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.User.User;
import Model.Entity.OAuth.UserLogins;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
import Service.User.UserService;
import Service.Auth.GoogleAuthService;
import Service.Auth.UserLoginsService;
import Service.Role.RoleService;
import Service.Role.UserRoleService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Utils.SessionUtil;

// googleRegister
public class GoogleRegisterServlet extends HttpServlet {

    private GoogleAuthService googleAuthService;
    private UserMapper userMapper;
    private UserService userService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;
    private UserRoleService userRoleService;

    @Override
    public void init() {
        googleAuthService = new GoogleAuthService();
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
            response.sendRedirect(googleAuthService.getAuthorizationRegisterUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfoRegister(code);
            User existingUser = userService.findByEmail(googleUser.getEmail());
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
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }

            User newUser = userMapper.mapGoogleUserToUser(googleUser);
            User addedUser = userService.add(newUser);
            if (addedUser != null) {
                Role userRole = roleService.findByRoleName("User");
                if (userRole != null) {
                    UserRole newUserRole = new UserRole(addedUser.getUserId(), userRole.getRoleId());
                    userRoleService.add(newUserRole);
                }

                UserLogins userLogins = new UserLogins();
                userLogins.setUserId(addedUser.getUserId());
                userLogins.setLoginProvider("google");
                userLogins.setProviderKey(googleUser.getGoogleId());
                try {
                    userLoginsService.add(userLogins);
                    request.getSession().setAttribute("userId", addedUser.getUserId().toString());
                    request.getRequestDispatcher("/pages/authen/SetPassword.jsp").forward(request, response);
                } catch (Exception ex) {
                    userService.delete(addedUser.getUserId());
                    request.setAttribute("error", "Register failed (user login): " + ex.getMessage());
                    request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Register failed. Please try again.");
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Google register failed - " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
