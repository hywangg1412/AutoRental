package Controller.Contract;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.Constants.BookingStatusConstants;
import Model.Entity.Booking.Booking;
import Model.Entity.Contract.Contract;
import Model.Entity.Contract.ContractDocument;
import Model.Entity.User.User;
import Model.Entity.User.DriverLicense;
import Model.Entity.User.CitizenIdCard;
import Service.Booking.BookingService;
import Service.Contract.ContractService;
import Service.Contract.ContractDocumentService;
import Service.External.ContractDocService;
import Service.External.MailService;
import Service.User.DriverLicenseService;
import Service.User.CitizenIdCardService;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ContractSignServlet", urlPatterns = {"/contract/sign"})
public class ContractSignServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ContractSignServlet.class.getName());
    private final ContractService contractService = new ContractService();
    private final BookingService bookingService = new BookingService();
    private final ContractDocumentService contractDocumentService = new ContractDocumentService();
    private final ContractDocService contractDocService = new ContractDocService();
    private final MailService mailService = new MailService();
    private final DriverLicenseService driverLicenseService = new DriverLicenseService();
    private final CitizenIdCardService citizenIdCardService = new CitizenIdCardService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }

            String bookingIdStr = request.getParameter("bookingId");
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing booking ID");
                return;
            }
            UUID bookingId = UUID.fromString(bookingIdStr);
            Booking booking = bookingService.findById(bookingId);
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return;
            }
            if (!booking.getUserId().equals(user.getUserId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            String signatureData = request.getParameter("signatureData");
            String fullName = request.getParameter("fullName");
            if (signatureData == null || signatureData.trim().isEmpty()) {
                request.setAttribute("error", "Please provide your signature before signing.");
                request.setAttribute("bookingId", bookingIdStr);
                request.getRequestDispatcher("/pages/contract/contract-sign.jsp").forward(request, response);
                return;
            }

            // 2. Render hợp đồng HTML với chữ ký
            request.setAttribute("userSignature", signatureData);
            request.setAttribute("userFullName", fullName != null ? fullName : user.getFullName());
            String html = contractDocService.renderContractJspToHtml(request, response, bookingIdStr);
            // Escape ký tự & chưa hợp lệ để tránh lỗi XML entity
            html = html.replaceAll("&(?!(amp;|lt;|gt;|quot;|apos;|nbsp;))", "&amp;");

            // 3. Convert HTML sang PDF (truyền đúng đường dẫn font)
            String fontPath = request.getServletContext().getRealPath("/assets/fonts/dejavu/DejaVuLGCSans.ttf");
            byte[] pdfBytes = contractDocService.htmlToPdf(html, fontPath);

            // 4. Upload PDF lên Cloudinary bảo mật
            ContractDocService.DocumentUploadResult uploadResult = contractDocService.uploadSecureDocument(
                pdfBytes, "CONTRACT_PDF", user.getUserId().toString()
            );
            String pdfUrl = uploadResult.getDocumentUrl();

            if (pdfUrl == null || pdfUrl.isEmpty()) {
                request.setAttribute("error", "Không thể lưu hợp đồng. Vui lòng thử lại.");
                request.setAttribute("bookingId", bookingIdStr);
                request.getRequestDispatcher("/pages/contract/contract-sign.jsp").forward(request, response);
                return;
            }

            // 5. Lưu hợp đồng vào DB (set luôn link PDF)
            Contract contract = new Contract();
            contract.setContractId(UUID.randomUUID());
            contract.setContractCode(contractService.generateUniqueContractCode());
            contract.setUserId(user.getUserId());
            contract.setBookingId(bookingId);
            contract.setCreatedDate(LocalDateTime.now());
            contract.setStatus("Active");
            contract.setTermsAccepted(true);
            contract.setSignatureData(signatureData);
            contract.setSignatureMethod("Canvas"); // hoặc lấy từ request nếu có nhiều phương thức
            contract.setContractPdfUrl(pdfUrl);
            contractService.add(contract);

            // 6. Đổi trạng thái booking
            bookingService.updateBookingStatus(bookingId, BookingStatusConstants.CONTRACT_SIGNED);

            // 7. Lấy thông tin giấy tờ của user và lưu ContractDocument
            DriverLicense driverLicense = null;
            CitizenIdCard citizenIdCard = null;
            try {
                driverLicense = driverLicenseService.findByUserId(user.getUserId());
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Không tìm thấy bằng lái cho user: " + user.getUserId(), ex);
            }
            try {
                citizenIdCard = citizenIdCardService.findByUserId(user.getUserId());
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Không tìm thấy CCCD cho user: " + user.getUserId(), ex);
            }

            ContractDocument contractDocument = new ContractDocument();
            contractDocument.setDocumentId(UUID.randomUUID());
            contractDocument.setContractId(contract.getContractId());
            if (driverLicense != null) {
                contractDocument.setDriverLicenseImageUrl(driverLicense.getLicenseImage());
                contractDocument.setDriverLicenseNumber(driverLicense.getLicenseNumber());
//                contractDocument.setDriverLicenseImageHash(driverLicense.getImageHash());
            }
            if (citizenIdCard != null) {
                contractDocument.setCitizenIdFrontImageUrl(citizenIdCard.getCitizenIdImageUrl());
                contractDocument.setCitizenIdBackImageUrl(citizenIdCard.getCitizenIdBackImageUrl());
                contractDocument.setCitizenIdNumber(citizenIdCard.getCitizenIdNumber());
                contractDocument.setCitizenIdIssuedDate(citizenIdCard.getCitizenIdIssuedDate());
                contractDocument.setCitizenIdIssuedPlace(citizenIdCard.getCitizenIdIssuedPlace());
//                contractDocument.setCitizenIdFrontImageHash(citizenIdCard.getFrontImageHash());
//                contractDocument.setCitizenIdBackImageHash(citizenIdCard.getBackImageHash());
            }
            contractDocumentService.add(contractDocument);

            // 8. Gửi email cho user với file PDF đính kèm
            String subject = "Your Car Rental Contract";
            String body = "<div style='font-family: Arial, sans-serif;'>"
                + "<h3>Your car rental contract has been successfully signed!</h3>"
                + "<p>Please see the attached contract file.</p>"
                + "</div>";
            mailService.sendContractEmailWithAttachment(
                user.getEmail(),
                subject,
                body,
                pdfBytes,
                "contract.pdf"
            );

            response.sendRedirect(request.getContextPath() + "/user/my-trip");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error signing contract", e);
            request.setAttribute("error", "Internal server error: " + e.getMessage());
            request.getRequestDispatcher("/pages/contract/contract-sign.jsp").forward(request, response);
        }
    }
}
