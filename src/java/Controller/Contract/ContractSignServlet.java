package Controller.Contract;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.Constants.BookingStatusConstants;
import Model.Entity.Booking.Booking;
import Model.Entity.Contract;
import Model.Entity.User.User;
import Service.Booking.BookingService;
import Service.ContractService;
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
            String termsVersion = request.getParameter("termsVersion");
            String termsFileUrl = request.getParameter("termsFileUrl");
            if (signatureData == null || signatureData.trim().isEmpty()) {
                request.setAttribute("error", "Please provide your signature before signing.");
                request.setAttribute("bookingId", bookingIdStr);
                request.getRequestDispatcher("/pages/contract/contract-sign.jsp").forward(request, response);
                return;
            }

            Contract contract = new Contract();
            contract.setContractId(UUID.randomUUID());
            contract.setContractCode(contractService.generateUniqueContractCode());
            contract.setUserId(user.getUserId());
            contract.setBookingId(bookingId);
            contract.setCreatedDate(LocalDateTime.now());
            contract.setStatus("Active");
            contract.setTermsAccepted(true);
            contract.setTermsAcceptedDate(LocalDateTime.now());
            contract.setTermsVersion(termsVersion);
            contract.setTermsFileUrl(termsFileUrl);
            contract.setSignatureData(signatureData);
            contract.setSignatureMethod("Canvas");
            contractService.add(contract);

            bookingService.updateBookingStatus(bookingId, BookingStatusConstants.CONTRACT_SIGNED);

            response.sendRedirect(request.getContextPath() + "/user/my-trip");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error signing contract", e);
            request.setAttribute("error", "Internal server error: " + e.getMessage());
            request.getRequestDispatcher("/pages/contract/contract-sign.jsp").forward(request, response);
        }
    }
}
