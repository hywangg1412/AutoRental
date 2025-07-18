package Controller.User.UserAccount;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.External.CloudinaryService;
import Model.Entity.User.CitizenIdCard;
import Service.User.CitizenIdCardService;
import Model.Entity.User.User;
import Exception.NotFoundException;
import java.util.UUID;
import jakarta.servlet.http.HttpSession;
import java.io.InputStream;
import jakarta.servlet.http.Part;
import com.google.gson.Gson;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import Utils.FormatUtils;

@WebServlet(name = "UpdateCitizenIdCardServlet", urlPatterns = {"/user/update-citizen-id"})
@MultipartConfig
public class UpdateCitizenIdCardServlet extends HttpServlet {
    private CloudinaryService cloudinaryService;
    private CitizenIdCardService citizenIdCardService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        cloudinaryService = new CloudinaryService();
        citizenIdCardService = new CitizenIdCardService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }

        try {
            // Lấy các part ảnh
            Part frontPart = request.getPart("citizenIdImage");
            Part backPart = request.getPart("citizenIdBackImage");
            String citizenIdNumber = request.getParameter("citizenIdNumber");
            String fullName = request.getParameter("citizenFullName");
            String dob = request.getParameter("citizenDob");
            String issueDate = request.getParameter("citizenIssueDate");
            String placeOfIssue = request.getParameter("citizenPlaceOfIssue");

            // Validate
            if (citizenIdNumber == null || !citizenIdNumber.matches("^[0-9]{12}$")) {
                handleError(request, response, session, "Citizen ID number must be exactly 12 digits");
                return;
            }
            if (fullName == null || !fullName.matches("^[\\p{L} ]+$")) {
                handleError(request, response, session, "Full name must not contain special characters or numbers");
                return;
            }
            if (dob == null || issueDate == null || placeOfIssue == null) {
                handleError(request, response, session, "All fields are required");
                return;
            }
            if (placeOfIssue == null || !placeOfIssue.matches("^[\\p{L} ]+$")) {
                handleError(request, response, session, "Place of issue must not contain numbers or special characters");
                return;
            }

            CitizenIdCard card = null;
            boolean isNew = false;
            try {
                card = citizenIdCardService.findByUserId(user.getUserId());
            } catch (NotFoundException e) {
                card = new CitizenIdCard();
                card.setId(UUID.randomUUID());
                card.setUserId(user.getUserId());
                card.setCreatedDate(LocalDateTime.now());
                isNew = true;
            }

            // Xử lý ảnh mặt trước
            String frontUrl = card.getCitizenIdImageUrl();
            if (frontPart != null && frontPart.getSize() > 0) {
                try (InputStream frontStream = frontPart.getInputStream()) {
                    String publicIdFront = "cccd_front_" + user.getUserId();
                    frontUrl = cloudinaryService.uploadAndGetUrlToFolder(frontStream, "citizen_id_cards", publicIdFront);
                }
            }
            // Xử lý ảnh mặt sau
            String backUrl = card.getCitizenIdBackImageUrl();
            if (backPart != null && backPart.getSize() > 0) {
                try (InputStream backStream = backPart.getInputStream()) {
                    String publicIdBack = "cccd_back_" + user.getUserId();
                    backUrl = cloudinaryService.uploadAndGetUrlToFolder(backStream, "citizen_id_cards", publicIdBack);
                }
            }

            // Nếu không có cả ảnh cũ lẫn mới cho 1 mặt thì báo lỗi
            if ((frontUrl == null || frontUrl.isEmpty()) || (backUrl == null || backUrl.isEmpty())) {
                handleError(request, response, session, "Both front and back images are required");
                return;
            }

            card.setCitizenIdNumber(citizenIdNumber);
            card.setFullName(fullName);
            
            // Xử lý Date of Birth với định dạng dd/MM/yyyy
            LocalDate dobDate = FormatUtils.parseDateSafely(dob);
            if (dobDate == null) {
                handleError(request, response, session, "Invalid date of birth format. Please use dd/MM/yyyy format");
                return;
            }
            
            // Validate age 18+
            LocalDate today = LocalDate.now();
            if (dobDate.isAfter(today)) {
                handleError(request, response, session, "Date of birth cannot be in the future");
                return;
            }
            
            int age = today.getYear() - dobDate.getYear();
            if (today.getMonthValue() < dobDate.getMonthValue() || 
                (today.getMonthValue() == dobDate.getMonthValue() && today.getDayOfMonth() < dobDate.getDayOfMonth())) {
                age--;
            }
            
            if (age < 14) {
                handleError(request, response, session, "You must be at least 14 years old to register a Citizen ID");
                return;
            }
            
            card.setDob(dobDate);
            
            card.setCitizenIdImageUrl(frontUrl);
            card.setCitizenIdBackImageUrl(backUrl);
            
            // Xử lý Issue Date với định dạng dd/MM/yyyy
            LocalDate issueDateObj = FormatUtils.parseDateSafely(issueDate);
            if (issueDateObj == null) {
                handleError(request, response, session, "Invalid issue date format. Please use dd/MM/yyyy format");
                return;
            }
            // Validate issue date không được lớn hơn ngày hiện tại
            if (issueDateObj.isAfter(today)) {
                handleError(request, response, session, "Issue date cannot be in the future");
                return;
            }
            card.setCitizenIdIssuedDate(issueDateObj);
            
            card.setCitizenIdIssuedPlace(placeOfIssue);

            if (isNew) {
                citizenIdCardService.add(card);
            } else {
                citizenIdCardService.update(card);
            }

            session.setAttribute("success", "Citizen ID updated successfully");
            response.sendRedirect(request.getContextPath() + "/user/profile");
        } catch (Exception e) {
            handleError(request, response, session, "Failed to update Citizen ID: " + e.getMessage());
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, HttpSession session, String errorMessage)
            throws IOException {
        session.setAttribute("error", errorMessage);
        response.sendRedirect(request.getContextPath() + "/user/profile");
    }
} 