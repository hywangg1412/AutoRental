package Controller.User.UserAccount;

import java.io.IOException;
import Service.User.UserService;
import Utils.FirebaseUtil;
import Utils.SessionUtil;
import com.google.firebase.auth.FirebaseToken;
import org.json.JSONObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.Entity.User.User;

@WebServlet(name = "VerifyPhoneServlet", urlPatterns = {"/user/verify-phone"})
public class VerifyPhoneServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        JSONObject jsonResponse = new JSONObject();
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            JSONObject json = new JSONObject(sb.toString());
            String idToken = json.optString("idToken", null);
            String phoneNumber = json.optString("phoneNumber", null);
            if (idToken == null || phoneNumber == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("error", "Missing idToken or phoneNumber");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            // Xác thực token với Firebase
            FirebaseToken decodedToken = FirebaseUtil.verifyIdToken(idToken);
            Object phoneObj = decodedToken.getClaims().get("phone_number");
            String firebasePhone = phoneObj != null ? phoneObj.toString() : null;
            System.out.println("Firebase phone: " + firebasePhone);
            System.out.println("All claims: " + decodedToken.getClaims());
            if (firebasePhone == null || !firebasePhone.equals(phoneNumber)) {
                jsonResponse.put("success", false);
                jsonResponse.put("error", "Phone number does not match Firebase record");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            // Lấy user từ session bằng SessionUtil
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            if (user == null) {
                jsonResponse.put("success", false);
                jsonResponse.put("error", "User not logged in");
                response.getWriter().write(jsonResponse.toString());
                return;
            }
            // Cập nhật số điện thoại và trạng thái xác thực
            boolean updateSuccess = userService.updatePhoneNumber(user.getUserId(), phoneNumber);
            if (updateSuccess) {
                User updatedUser = userService.findById(user.getUserId());
                updatedUser.setPhoneVerified(true);
                userService.update(updatedUser);
                SessionUtil.setSessionAttribute(request, "user", updatedUser);
                jsonResponse.put("success", true);
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("error", "Failed to update phone number");
            }
        } catch (Exception ex) {
            jsonResponse.put("success", false);
            jsonResponse.put("error", ex.getMessage());
        }
        response.getWriter().write(jsonResponse.toString());
    }
}
