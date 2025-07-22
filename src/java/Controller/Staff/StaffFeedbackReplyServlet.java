package Controller.Staff;

import Config.DBContext;
import Model.DTO.UserFeedbackDTO;
import Service.Interfaces.IUserFeedbackService;
import Service.UserFeedbackService;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet for handling staff replies to user feedback
 */
@WebServlet(name = "StaffFeedbackReplyServlet", urlPatterns = {"/staff/feedback-reply"})
public class StaffFeedbackReplyServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(StaffFeedbackReplyServlet.class.getName());
    private final IUserFeedbackService userFeedbackService;
    private boolean hasStaffReplyColumn = false;
    
    public StaffFeedbackReplyServlet() {
        this.userFeedbackService = new UserFeedbackService();
    }
    
    @Override
    public void init() throws ServletException {
        super.init();
        
        // Check if the UserFeedback table has the StaffReply column
        try {
            DBContext dbContext = new DBContext();
            try (Connection conn = dbContext.getConnection()) {
                DatabaseMetaData metaData = conn.getMetaData();
                ResultSet columns = metaData.getColumns(null, null, "UserFeedback", "StaffReply");
                
                if (columns.next()) {
                    hasStaffReplyColumn = true;
                } else {
                    LOGGER.log(Level.WARNING, "StaffReply column does NOT exist in UserFeedback table!");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking UserFeedback table structure: " + e.getMessage(), e);
        }
    }

    /**
     * Handles the HTTP GET request - displays the customer feedback page
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (!hasStaffReplyColumn) {
                request.getRequestDispatcher("/pages/staff/db-update-required.jsp").forward(request, response);
                return;
            }
            
            // Get filter parameter
            String filterType = request.getParameter("filter");
            if (filterType == null) {
                filterType = "all"; // Default filter
            }
            
            // Get rating filter parameter
            String ratingParam = request.getParameter("rating");
            Integer rating = null;
            if (ratingParam != null && !ratingParam.isEmpty()) {
                try {
                    rating = Integer.parseInt(ratingParam);
                    if (rating < 1 || rating > 5) {
                        rating = null;
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid rating parameter: " + ratingParam);
                }
            }
            
            List<UserFeedbackDTO> feedbackList;
            
            // Apply filters
            switch (filterType) {
                case "pending":
                    feedbackList = userFeedbackService.getPendingReplies();
                    break;
                case "responded":
                    feedbackList = userFeedbackService.getRespondedFeedback();
                    break;
                case "rating":
                    if (rating != null) {
                        feedbackList = userFeedbackService.getFeedbackByRating(rating);
                    } else {
                        feedbackList = userFeedbackService.getAllFeedback();
                    }
                    break;
                case "all":
                default:
                    feedbackList = userFeedbackService.getAllFeedback();
                    break;
            }
            
            request.setAttribute("pendingFeedback", feedbackList);
            request.setAttribute("currentFilter", filterType);
            request.setAttribute("currentRating", rating);
            
            // Forward to the customer support page
            request.getRequestDispatcher("/pages/staff/staff-customer-support.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading customer feedback: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Failed to load customer feedback: " + e.getMessage());
            request.getRequestDispatcher("/pages/staff/staff-dashboard.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP POST request - processes the staff reply
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            
            if ("bulk-reply".equals(action)) {
                // Handle bulk reply
                handleBulkReply(request, response);
            } else {
                // Handle single reply
                handleSingleReply(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing request: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Failed to process request: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * Handle a single reply to a feedback
     */
    private void handleSingleReply(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get parameters from the request
            String feedbackIdStr = request.getParameter("feedbackId");
            String replyContent = request.getParameter("replyContent");
            
            // Validate parameters
            if (feedbackIdStr == null || feedbackIdStr.isEmpty() || replyContent == null || replyContent.isEmpty()) {
                request.setAttribute("errorMessage", "Feedback ID and reply content are required");
                doGet(request, response);
                return;
            }
            
            // Convert feedbackId to UUID
            UUID feedbackId = UUID.fromString(feedbackIdStr);
            
            // Add the staff reply
            boolean success = userFeedbackService.addStaffReply(feedbackId, replyContent);
            
            if (success) {
                request.setAttribute("successMessage", "Reply submitted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to submit reply");
            }
            
            // Redirect back to the customer support page
            response.sendRedirect(request.getContextPath() + "/staff/feedback-reply");
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Invalid feedback ID format: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Invalid feedback ID format");
            doGet(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error submitting reply: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Failed to submit reply: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * Handle bulk reply to multiple feedbacks
     */
    private void handleBulkReply(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get parameters
            String replyContent = request.getParameter("bulkReplyContent");
            String ratingParam = request.getParameter("bulkRating");
            String[] selectedFeedbackIds = request.getParameterValues("selectedFeedbacks");
            
            // Validate parameters
            if (replyContent == null || replyContent.isEmpty()) {
                request.setAttribute("errorMessage", "Reply content is required for bulk reply");
                doGet(request, response);
                return;
            }
            
            List<UUID> feedbackIds = new ArrayList<>();
            
            // If specific feedbacks are selected
            if (selectedFeedbackIds != null && selectedFeedbackIds.length > 0) {
                for (String idStr : selectedFeedbackIds) {
                    try {
                        feedbackIds.add(UUID.fromString(idStr));
                    } catch (IllegalArgumentException e) {
                        LOGGER.log(Level.WARNING, "Invalid feedback ID: " + idStr);
                    }
                }
            } 
            // If replying by rating
            else if (ratingParam != null && !ratingParam.isEmpty()) {
                try {
                    int rating = Integer.parseInt(ratingParam);
                    if (rating >= 1 && rating <= 5) {
                        List<UserFeedbackDTO> feedbacksByRating = userFeedbackService.getFeedbackByRating(rating);
                        for (UserFeedbackDTO feedback : feedbacksByRating) {
                            // Only add feedbacks that don't already have a reply
                            if (!feedback.hasStaffReply()) {
                                feedbackIds.add(feedback.getFeedbackId());
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid rating parameter: " + ratingParam);
                }
            }
            
            if (feedbackIds.isEmpty()) {
                request.setAttribute("errorMessage", "No valid feedbacks selected for bulk reply");
                doGet(request, response);
                return;
            }
            
            // Add bulk replies
            boolean success = userFeedbackService.addBulkStaffReply(feedbackIds, replyContent);
            
            if (success) {
                request.setAttribute("successMessage", "Bulk reply submitted successfully to " + feedbackIds.size() + " feedbacks");
            } else {
                request.setAttribute("errorMessage", "Some replies may not have been submitted successfully");
            }
            
            // Redirect back to the customer support page
            response.sendRedirect(request.getContextPath() + "/staff/feedback-reply");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error submitting bulk reply: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Failed to submit bulk reply: " + e.getMessage());
            doGet(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Staff Feedback Reply Servlet";
    }
} 