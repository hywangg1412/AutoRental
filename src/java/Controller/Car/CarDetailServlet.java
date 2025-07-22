package Controller.Car;

import Model.DTO.CarDetailDTO;
import Model.DTO.UserFeedbackDTO;
import Service.Car.CarDetailService;
import Service.Interfaces.IUserFeedbackService;
import Service.UserFeedbackService;
import Utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.UUID;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/pages/car-single")
public class CarDetailServlet extends HttpServlet {

    private CarDetailService carDetailService;
    private IUserFeedbackService feedbackService;

    @Override
    public void init() throws ServletException {
        carDetailService = new CarDetailService();
        feedbackService = new UserFeedbackService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        System.out.println("📥 Received request with id: " + idParam);

        if (idParam == null || idParam.trim().isEmpty()) {
            System.out.println("❌ ID is null or empty");
            response.sendRedirect(request.getContextPath() + "/notfound.jsp");
            return;
        }

        try {
            UUID carId = UUID.fromString(idParam);
            System.out.println("✅ Valid ID: " + carId);

            CarDetailDTO car = carDetailService.getCarDetail(carId);
            if (car == null) {
                System.out.println("❌ Car not found in CarDetailService");
                response.sendRedirect(request.getContextPath() + "/notfound.jsp");
                return;
            }

            // Log DTO information for verification
            System.out.println("🚗 Car model: " + car.getCarModel());
            System.out.println("🏷 Brand: " + car.getBrandName());
            System.out.println("⛽ Fuel: " + car.getFuelName());
            System.out.println("⚙ Transmission: " + car.getTransmissionName());
            System.out.println("🖼 Number of images: " + (car.getImageUrls() != null ? car.getImageUrls().size() : 0));

            // Get current user from session
            UUID currentUserId = null;
            String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
            String userName = (String) SessionUtil.getSessionAttribute(request, "fullName");
            
            if (userName == null) {
                userName = "User"; // Default name if not found in session
            }
            
                if (userIdStr != null) {
                    currentUserId = UUID.fromString(userIdStr);
            }

            // Load reviews for this car
            List<UserFeedbackDTO> reviews = new ArrayList<>();
            UserFeedbackDTO userReview = null;
            double averageRating = 0.0;
            int totalReviews = 0;
            boolean canReview = false;

            try {
                // Get approved reviews for this car
                reviews = feedbackService.getApprovedFeedbackByCarId(carId);
                averageRating = feedbackService.getAverageRatingForCar(carId);
                totalReviews = feedbackService.countFeedbackForCar(carId);

                System.out.println("📝 Found " + reviews.size() + " reviews, avg rating: " + averageRating);

                if (currentUserId != null) {
                    // Check if user can leave feedback
                    canReview = feedbackService.canLeaveFeedback(currentUserId, carId);
                    
                    // Get user's existing reviews for this car
                    List<UserFeedbackDTO> userReviews = new ArrayList<>();
                    for (UserFeedbackDTO review : feedbackService.getFeedbackByUserId(currentUserId)) {
                        if (review.getCarId().equals(carId)) {
                            // Set the username explicitly
                            if (review.getUsername() == null || review.getUsername().isEmpty()) {
                                review.setUsername(userName);
                            }
                            userReviews.add(review);
                        }
                    }
                    
                    // If user has reviews for this car
                    if (!userReviews.isEmpty()) {
                        // Sort by created date descending (newest first)
                        userReviews.sort((r1, r2) -> r2.getCreatedDate().compareTo(r1.getCreatedDate()));
                        
                        // Get the latest review
                        userReview = userReviews.get(0);
                        
                        // Get other reviews (if any)
                        List<UserFeedbackDTO> userOtherReviews = new ArrayList<>();
                        if (userReviews.size() > 1) {
                            for (int i = 1; i < userReviews.size(); i++) {
                                userOtherReviews.add(userReviews.get(i));
                            }
                            // Pass other reviews to JSP
                            request.setAttribute("userOtherReviews", userOtherReviews);
                        }
                        
                        // Remove user's reviews from the general list to avoid duplication
                        for (UserFeedbackDTO review : userReviews) {
                            final UUID reviewId = review.getFeedbackId();
                            reviews.removeIf(r -> r.getFeedbackId().equals(reviewId));
                        }
                }

                System.out.println("✅ Can review: " + canReview);
                    System.out.println("👤 User reviews count: " + userReviews.size());
                    System.out.println("👤 Latest user review: " + (userReview != null ? userReview.getFeedbackId() : "null"));
                }

            } catch (Exception e) {
                System.out.println("⚠️ Error loading reviews: " + e.getMessage());
                e.printStackTrace();
            }

            // Pass data to JSP
            request.setAttribute("car", car);
            request.setAttribute("reviews", reviews);
            request.setAttribute("userReview", userReview);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("canReview", canReview);
            request.setAttribute("userName", userName);

            request.getRequestDispatcher("/pages/car-single.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            System.out.println("❌ Invalid UUID format: " + idParam);
            response.sendRedirect(request.getContextPath() + "/notfound.jsp");

        } catch (Exception e) {
            System.out.println("❌ Error processing car details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/notfound.jsp");
        }
    }
}
