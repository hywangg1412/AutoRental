package Controller.User.UserAccount;

import Service.External.CloudinaryService;
import Service.User.UserService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import Model.Entity.User.User;
import java.util.UUID;
import jakarta.servlet.annotation.MultipartConfig;

@WebServlet(name = "UpdateUserAvatarServlet", urlPatterns = {"/user/update-avatar"})
@MultipartConfig
public class UpdateUserAvatarServlet extends HttpServlet {
    private CloudinaryService cloudinaryService;
    private UserService userService;
    
    @Override
    public void init(){
        cloudinaryService = new CloudinaryService();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        UUID userId = user.getUserId();

        Part filePart = request.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            request.getSession().setAttribute("error", "No file selected!");
            response.sendRedirect(request.getContextPath() + "/user/profile");
            return;
        }

        try (InputStream fileContent = filePart.getInputStream()) {
            String avatarUrl = cloudinaryService.uploadAndGetUrlToFolder(fileContent, "user_avatars", "user_avatar_" + userId);

            boolean updateSuccess = userService.updateUserAvatar(userId, avatarUrl);

            if (updateSuccess) {
                User updatedUser = userService.findById(userId);
                request.getSession().setAttribute("user", updatedUser);
                request.getSession().setAttribute("success", "Avatar updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to update avatar in database.");
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            request.getSession().setAttribute("error", "Upload failed: " + e.getMessage());
        }

        String fromStaffProfile = request.getParameter("fromStaffProfile");
        if ("true".equals(fromStaffProfile)) {
            response.sendRedirect(request.getContextPath() + "/staff/profile");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/profile");
        }
    }
}
