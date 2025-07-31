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
import Service.Role.RoleService;
import Model.Entity.Role.Role;
import Utils.SessionUtil;

@WebServlet(name = "UpdateUserAvatarServlet", urlPatterns = {"/user/update-avatar"})
@MultipartConfig
public class UpdateUserAvatarServlet extends HttpServlet {
    private CloudinaryService cloudinaryService;
    private UserService userService;
    private RoleService roleService;
    
    @Override
    public void init(){
        cloudinaryService = new CloudinaryService();
        userService = new UserService();
        roleService = new RoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        UUID userId = user.getUserId();

        Part filePart = request.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            SessionUtil.setSessionAttribute(request, "error", "No file selected!");
            response.sendRedirect(request.getContextPath() + "/user/profile");
            return;
        }

        try (InputStream fileContent = filePart.getInputStream()) {
            String avatarUrl = cloudinaryService.uploadAndGetUrlToFolder(fileContent, "user_avatars", "user_avatar_" + userId);

            boolean updateSuccess = userService.updateUserAvatar(userId, avatarUrl);

            if (updateSuccess) {
                User updatedUser = userService.findById(userId);
                SessionUtil.setSessionAttribute(request, "user", updatedUser);
                SessionUtil.setSessionAttribute(request, "success", "Avatar updated successfully!");
                String profileRedirect = "/user/profile";
                try {
                    Role userRole = roleService.findById(updatedUser.getRoleId());
                    if (userRole != null && "Staff".equalsIgnoreCase(userRole.getRoleName())) {
                        profileRedirect = "/staff/profile";
                    }
                } catch (Exception ex) {
                    // Nếu lỗi khi lấy role, giữ nguyên profileRedirect là /user/profile
                }
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            } else {
                SessionUtil.setSessionAttribute(request, "error", "Failed to update avatar in database.");
            }
        } catch (Exception e) {
            e.printStackTrace(); 
            SessionUtil.setSessionAttribute(request, "error", "Upload failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/user/profile");
    }
}
