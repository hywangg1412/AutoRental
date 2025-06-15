package Controller.Auth;

import Mapper.UserMapper;
import Model.Entity.OAuth.FacebookUser;
import Model.Entity.User;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
import Service.UserService;
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
import Service.Auth.UserLoginsService;

//facebookLogin
public class FacebookRegisterServlet extends HttpServlet {

    private FacebookAuthService facebookAuthService;
    private UserMapper userMapper;
    private UserService userService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;
    private UserRoleService userRoleService;

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
                String errorMsg = existingUser.isBanned() ?
                    "This email is associated with a banned account. Please contact support." :
                    "Email already exists!";
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }
            User newUser = userMapper.mapFacebookUserToUser(facebookUser);
            User addedUser = userService.add(newUser);
            if (addedUser != null) {
                // Gán role User cho người dùng mới
                Role userRole = roleService.findByRoleName("User");
                if (userRole != null) {
                    UserRole newUserRole = new UserRole(addedUser.getUserId(), userRole.getRoleId());
                    userRoleService.add(newUserRole);
                }

                UserLogins userLogins = new UserLogins();
                userLogins.setUserId(addedUser.getUserId());
                userLogins.setLoginProvider("facebook");
                userLogins.setProviderKey(facebookUser.getFacebookId());
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
            request.setAttribute("error", "Facebook register failed - " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
        }
    }

}
