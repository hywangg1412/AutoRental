package Controller.Auth;

import Model.Entity.User;
import Service.UserService;
import Utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

@WebFilter("/*")
public class SessionFilter implements Filter {
    private UserService userService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userService = new UserService();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        User user = (User) SessionUtil.getSessionAttribute(httpRequest, "user");
        Boolean isLoggedIn = (Boolean) SessionUtil.getSessionAttribute(httpRequest, "isLoggedIn");

        if ((user == null || isLoggedIn == null || !isLoggedIn) && SessionUtil.getCookie(httpRequest, "userId") != null) {
            try {
                String userIdStr = SessionUtil.getCookie(httpRequest, "userId");
                UUID userId = UUID.fromString(userIdStr);
                user = userService.findById(userId);
                
                if (user != null && !user.isBanned()) {
                    SessionUtil.setSessionAttribute(httpRequest, "user", user);
                    SessionUtil.setSessionAttribute(httpRequest, "isLoggedIn", true);
                } else {
                    SessionUtil.deleteCookie(httpResponse, "userId", "/");
                }
            } catch (Exception e) {
                SessionUtil.deleteCookie(httpResponse, "userId", "/");
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
} 