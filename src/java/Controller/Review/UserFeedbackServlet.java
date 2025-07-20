package Controller.Review;

import Model.DTO.UserFeedbackDTO;
import Model.Entity.UserFeedback;
import Repository.Booking.BookingRepository;
import Service.Interfaces.IUserFeedbackService;
import Service.UserFeedbackService;
import Utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling user feedback operations
 */
@WebServlet(name = "UserFeedbackServlet", urlPatterns = {"/feedback"})
public class UserFeedbackServlet extends HttpServlet {

    private final IUserFeedbackService userFeedbackService;
    private static final Logger LOGGER = Logger.getLogger(UserFeedbackServlet.class.getName());

    public UserFeedbackServlet() {
        this.userFeedbackService = new UserFeedbackService();
    }

    /**
     * Handles the HTTP GET method - Redirects to car detail page or handles actions
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Handle different actions
        if (action != null) {
            switch (action) {
                case "getEligibleBooking":
                    handleGetEligibleBooking(request, response);
                return;
                // Add other actions as needed
            }
        }
        
        // Default: redirect to car detail page
        String carId = request.getParameter("carId");
        if (carId != null && !carId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/car-detail?id=" + carId);
            } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    /**
     * Handle getting eligible booking for feedback
     * @param request servlet request
     * @param response servlet response
     * @throws IOException if an I/O error occurs
     */
    private void handleGetEligibleBooking(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        
        // Get user ID from session
        String userId = (String) SessionUtil.getSessionAttribute(request, "userId");
        if (userId == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"You must be logged in to submit feedback.\"}");
            return;
        }
        
        try {
            // Get car ID from request
            String carIdStr = request.getParameter("carId");
            if (carIdStr == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing car ID parameter.\"}");
                return;
            }
            
            UUID carId = UUID.fromString(carIdStr);
            UUID userIdObj = UUID.fromString(userId);
            
            // Get all eligible bookings
            List<UUID> bookingIds = userFeedbackService.getAllEligibleBookingsForFeedback(userIdObj, carId);
            
            if (bookingIds != null && !bookingIds.isEmpty()) {
                // Build JSON array of booking IDs
                StringBuilder jsonArray = new StringBuilder("[");
                for (int i = 0; i < bookingIds.size(); i++) {
                    jsonArray.append("\"").append(bookingIds.get(i).toString()).append("\"");
                    if (i < bookingIds.size() - 1) {
                        jsonArray.append(",");
                    }
                }
                jsonArray.append("]");
                
                // Return booking IDs as JSON
                response.getWriter().write("{\"success\": true, \"bookingIds\": " + jsonArray.toString() + ", \"bookingId\": \"" + bookingIds.get(0).toString() + "\"}");
            } else {
                // Kiểm tra xem người dùng đã có booking hoàn thành cho xe này chưa
                boolean hasCompletedBookings = false;
                try {
                    // Sử dụng BookingRepository để kiểm tra
                    BookingRepository bookingRepo = new BookingRepository();
                    hasCompletedBookings = bookingRepo.hasCompletedBookings(userIdObj, carId);
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error checking completed bookings: " + e.getMessage(), e);
                }
                
                if (hasCompletedBookings) {
                    // Người dùng đã có booking hoàn thành nhưng đã đánh giá tất cả
                    response.getWriter().write("{\"success\": false, \"message\": \"You have already submitted reviews for all your completed bookings of this car.\"}");
                } else {
                    // Người dùng chưa có booking hoàn thành
                    response.getWriter().write("{\"success\": false, \"message\": \"You don't have any completed bookings for this car yet.\"}");
                }
            }
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    /**
     * Handles the HTTP POST method - Submits a new feedback or handles other actions
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Handle different actions
        if (action != null) {
            switch (action) {
                case "update":
                    handleUpdateFeedback(request, response);
                return;
            }
        } else {
            // Default action: create new feedback
            handleCreateFeedback(request, response);
        }
    }
    
    /**
     * Handle creating a new feedback
     * @param request servlet request
     * @param response servlet response
     * @throws IOException if an I/O error occurs
     */
    private void handleCreateFeedback(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        String userId = (String) SessionUtil.getSessionAttribute(request, "userId");
        
        // Check if user is logged in
        if (userId == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"You must be logged in to submit feedback.\"}");
            return;
        }
        
        try {
            // Get parameters
            String carIdStr = request.getParameter("carId");
            String bookingIdStr = request.getParameter("bookingId");
            String ratingStr = request.getParameter("rating");
            String content = request.getParameter("content");
            
            // Validate parameters
            if (carIdStr == null || bookingIdStr == null || ratingStr == null || content == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Missing required parameters.\"}");
                return;
            }
            
            // Parse parameters
            UUID carId = UUID.fromString(carIdStr);
            UUID bookingId = UUID.fromString(bookingIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Rating must be between 1 and 5.\"}");
                return;
            }
            
            // Check if user can leave feedback for this car
            if (!userFeedbackService.canLeaveFeedback(UUID.fromString(userId), carId)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"You cannot leave feedback for this car.\"}");
                return;
            }
            
            // Create feedback
            UserFeedback feedback = new UserFeedback();
            feedback.setFeedbackId(UUID.randomUUID());
            feedback.setUserId(UUID.fromString(userId));
            feedback.setCarId(carId);
            feedback.setBookingId(bookingId);
            feedback.setRating(rating);
            feedback.setContent(content);
            feedback.setReviewed(LocalDate.now());
            feedback.setCreatedDate(LocalDateTime.now());
            
            // Save feedback
            UserFeedback savedFeedback = userFeedbackService.addFeedback(feedback);
            
            if (savedFeedback != null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Feedback submitted successfully. Thank you for your review!\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to submit feedback. Please try again.\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid rating format.\"}");
        } catch (IllegalArgumentException e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid ID format.\"}");
        } catch (Exception e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }

    /**
     * Handle updating an existing feedback
     * @param request servlet request
     * @param response servlet response
     * @throws IOException if an I/O error occurs
     */
    private void handleUpdateFeedback(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        
        // Get user ID from session
        String userId = (String) SessionUtil.getSessionAttribute(request, "userId");
        if (userId == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"You must be logged in to update feedback.\"}");
            return;
        }
        
        try {
            // Get parameters
            String feedbackIdStr = request.getParameter("feedbackId");
            String ratingStr = request.getParameter("rating");
            String content = request.getParameter("content");
            
            // Validate parameters
            if (feedbackIdStr == null || ratingStr == null || content == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing required parameters.\"}");
                return;
            }
        
            // Parse parameters
            UUID feedbackId = UUID.fromString(feedbackIdStr);
            int rating = Integer.parseInt(ratingStr);
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                response.getWriter().write("{\"success\": false, \"message\": \"Rating must be between 1 and 5.\"}");
                return;
            }
            
            // Get existing feedback
            UserFeedback existingFeedback = userFeedbackService.findById(feedbackId);
            if (existingFeedback == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Feedback not found.\"}");
                return;
            }
            
            // Check if user owns this feedback
            if (!existingFeedback.getUserId().toString().equals(userId)) {
                response.getWriter().write("{\"success\": false, \"message\": \"You can only update your own feedback.\"}");
                return;
            }
            
            // Update feedback
            existingFeedback.setRating(rating);
            existingFeedback.setContent(content);
            existingFeedback.setReviewed(LocalDate.now());
                
            // Save updated feedback
            boolean updated = userFeedbackService.updateFeedback(existingFeedback);
            
            if (updated) {
                response.getWriter().write("{\"success\": true, \"message\": \"Feedback updated successfully.\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update feedback. Please try again.\"}");
            }
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid rating format.\"}");
        } catch (IllegalArgumentException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid ID format.\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred: " + e.getMessage() + "\"}");
        }
    }
    
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "UserFeedback Servlet for handling user feedback operations";
    }
} 