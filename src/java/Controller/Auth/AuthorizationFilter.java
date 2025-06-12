package Controller.Auth;

import Exception.NotFoundException;
import Model.Constants.RoleConstants;
import Model.Entity.Role.UserRole;
import Model.Entity.User;
import Service.Role.RoleService;
import Service.Role.UserRoleService;
import Utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

// /authorizationFilter
public class AuthorizationFilter implements Filter {

    private static final boolean debug = true;
    private FilterConfig filterConfig = null;
    private RoleService roleService = new RoleService();
    private UserRoleService userRoleService = new UserRoleService();

    // Role constants
    private static final String ROLE_ADMIN = "Admin";
    private static final String ROLE_STAFF = "Staff";
    private static final String ROLE_USER = "User";

    // Role IDs as UUIDs
    private static final String ROLE_ADMIN_ID = "7c9e6679-7425-40de-944b-e07fc1f90ae7";
    private static final String ROLE_STAFF_ID = "550e8400-e29b-41d4-a716-446655440000";
    private static final String ROLE_USER_ID = "6ba7b810-9dad-11d1-80b4-00c04fd430c8";

    // Path sets for better performance
    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
            // Authentication pages
            "/pages/authen/SignIn.jsp",
            "/pages/authen/SignUp.jsp",
            "/pages/authen/ResetPassword.jsp",
            "/pages/authen/RequestPassword.jsp",
            "/pages/user/UserProfile.jsp",
            "/pages/user/FavoriteCar.jsp",
            "/pages/user/MyTrip.jsp",
            "/pages/user/Notification.jsp",
            "/requestPassword",
            "/resetPassword",
            "/setPassword",
            "/facebookLogin",
            "/googleLogin",
            "/normalLogin",
            "/normalRegister",
            "/facebookRegister",
            "/googleRegister",
            // Public pages
            "/pages/index.jsp",
            "/pages/main.jsp",
            "/pages/pricing.jsp",
            "/pages/car.jsp",
            "/pages/car-single.jsp",
            "/pages/contact.jsp",
            "/pages/about.jsp",
            // Static resources
            "/assets/",
            "/styles/",
            "/scripts/",
            "/scss/"
    ));

    private static final Set<String> ADMIN_PATHS = new HashSet<>(Arrays.asList(
            "/pages/admin/"
    ));

    private static final Set<String> STAFF_PATHS = new HashSet<>(Arrays.asList(
            "/pages/staff/staff-dashboard.jsp",
            "/pages/staff/staff-booking.jsp",
            "/pages/staff/car-availability.jsp",
            "/pages/staff/car-condition.jsp",
            "/pages/staff/customer-support.jsp"
    ));

    // Error pages
    private static final String LOGIN_PAGE = "/pages/authen/SignIn.jsp";
    private static final String FORBIDDEN_PAGE = "/pages/Error.jsp";

    public AuthorizationFilter() {
    }

    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AuthorizationFilter:DoBeforeProcessing");
        }

    }

    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("AuthorizationFilter:DoAfterProcessing");
        }
    }

    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {
        if (debug) {
            log("AuthorizationFilter:doFilter()");
        }

        doBeforeProcessing(request, response);

        Throwable problem = null;
        try {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            String requestURI = httpRequest.getRequestURI();

            if (isPublicPath(requestURI)) {
                chain.doFilter(request, response);
                return;
            }

            User user = (User) SessionUtil.getSessionAttribute(httpRequest, "user");
            if (user == null) {
                redirectToLogin(httpRequest, httpResponse);
                return;
            }

            UserRole userRole = userRoleService.findByUserId(user.getUserId());
            if (userRole == null) {
                redirectToForbidden(httpRequest, httpResponse);
                return;
            }

            // Get role object and check permission
            Model.Entity.Role.Role role = roleService.findById(userRole.getRoleId());
            if (role == null || !hasPathPermission(role.getRoleName(), requestURI)) {
                redirectToForbidden(httpRequest, httpResponse);
                return;
            }

            chain.doFilter(request, response);
        } catch (Throwable t) {
            problem = t;
            t.printStackTrace();
        }

        doAfterProcessing(request, response);

        if (problem != null) {
            if (problem instanceof ServletException) {
                throw (ServletException) problem;
            }
            if (problem instanceof IOException) {
                throw (IOException) problem;
            }
            sendProcessingError(problem, response);
        }
    }

    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    public void destroy() {
    }

    private boolean isPublicPath(String requestURI) {
        return PUBLIC_PATHS.stream()
                .anyMatch(path -> requestURI.contains(path));
    }

    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
        if (filterConfig != null && debug) {
            log("AuthorizationFilter:Initializing filter");
        }
    }

    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("AuthorizationFilter()");
        }
        StringBuffer sb = new StringBuffer("AuthorizationFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }

    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);

        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n"); //NOI18N

                // PENDING! Localize this for next official release
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");
                pw.print(stackTrace);
                pw.print("</pre></body>\n</html>"); //NOI18N
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        }
    }

    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
        }
        return stackTrace;
    }

    public void log(String msg) {
        filterConfig.getServletContext().log(msg);
    }

    private boolean hasPathPermission(String userRole, String requestPath) {
        if (userRole.equals(ROLE_ADMIN)) {
            return true; // Admin can access everything
        }
        if (userRole.equals(ROLE_STAFF)) {
            // Staff can access staff pages and all user pages (not admin)
            return isStaffPath(requestPath) || isUserPath(requestPath);
        }
        // User can only access user pages
        return isUserPath(requestPath);
    }

    private boolean isAdminPath(String requestURI) {
        return ADMIN_PATHS.stream()
                .anyMatch(path -> requestURI.contains(path));
    }

    private boolean isStaffPath(String requestURI) {
        return STAFF_PATHS.stream()
                .anyMatch(path -> requestURI.contains(path));
    }

    private boolean isUserPath(String requestURI) {
        // If path is not admin or staff path, it's considered a user path
        return !isAdminPath(requestURI) && !isStaffPath(requestURI);
    }

    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + LOGIN_PAGE);
    }

    private void redirectToForbidden(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + FORBIDDEN_PAGE);
    }
}
