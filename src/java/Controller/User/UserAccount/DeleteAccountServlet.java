package Controller.User.UserAccount;

import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.User.AccountDeletionLog;
import Model.Entity.User.User;
import Service.User.AccountDeletionLogService;
import Service.User.UserService;
import Utils.SessionUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.UUID;

@WebServlet(name = "DeleteAccountServlet", urlPatterns = {"/user/delete-user-account"})
public class DeleteAccountServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DeleteAccountServlet.class.getName());
    private UserService userService;
    private AccountDeletionLogService logService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
        logService = new AccountDeletionLogService();
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "You must be logged in to delete an account.");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            String password = request.getParameter("password");
            if (password == null || password.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Password confirmation is required.");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            boolean isPasswordCorrect = false;
            try {
                isPasswordCorrect = userService.verifyPassword(user.getUserId(), password);
            } catch (NotFoundException e) {
                LOGGER.log(Level.WARNING, "User not found during password verification: {0}", user.getUserId());
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "User account not found.");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            if (isPasswordCorrect) {
                boolean deactivated = userService.deactivateUser(user.getUserId());
                if (deactivated) {
                    String reason = request.getParameter("reason");
                    String comments = request.getParameter("comments");
                    
                    AccountDeletionLog log = new AccountDeletionLog();
                    log.setUserId(user.getUserId());
                    log.setDeletionReason(reason != null ? reason : "User requested account deletion");
                    log.setAdditionalComments(comments);
                    
                    try {
                        AccountDeletionLog savedLog = logService.add(log);
                        if (savedLog == null) {
                            LOGGER.log(Level.WARNING, "Failed to save account deletion log for user: {0}", user.getUserId());
                        }
                    } catch (EventException | InvalidDataException e) {
                        LOGGER.log(Level.WARNING, "Error saving account deletion log for user: {0}, Error: {1}", 
                                new Object[]{user.getUserId(), e.getMessage()});
                    }

                    // Invalidate session and clear cookies
                    SessionUtil.removeSessionAttribute(request, "user");
                    SessionUtil.removeSessionAttribute(request, "isLoggedIn");
                    request.getSession().invalidate();
                    SessionUtil.deleteCookie(response, "userId", "/");

                    jsonResponse.addProperty("status", "success");
                    jsonResponse.addProperty("message", "Account successfully marked as deleted. You will be logged out.");
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    LOGGER.log(Level.SEVERE, "Failed to deactivate account for user: {0}", user.getUserId());
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    jsonResponse.addProperty("status", "error");
                    jsonResponse.addProperty("message", "Failed to deactivate account. Please try again later.");
                }
            } else {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Incorrect password. Please try again.");
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during account deletion", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "An unexpected error occurred. Please try again later.");
        } finally {
            out.print(gson.toJson(jsonResponse));
            out.flush();
        }
    }
}
