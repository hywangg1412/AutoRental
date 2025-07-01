package Controller.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import Model.Entity.User.User;
import Model.DTO.User.FavoriteCarDTO;
import Service.User.UserFavoriteCarService;

@WebServlet(name = "FavoriteCarPageServlet", urlPatterns = {"/user/favorite-car-page"})
public class FavoriteCarPageServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(FavoriteCarPageServlet.class.getName());
    private final UserFavoriteCarService favoriteCarService = new UserFavoriteCarService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            if (user == null) {
                LOGGER.warning("User not logged in, redirecting to login page");
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }
            
            LOGGER.info("Loading favorite cars for user: " + user.getUserId());
            
            List<FavoriteCarDTO> favoriteCars = favoriteCarService.getFavoriteCarDetailsByUserId(user.getUserId());
            
            LOGGER.info("Found " + favoriteCars.size() + " favorite cars for user: " + user.getUserId());
            
            request.setAttribute("favoriteCars", favoriteCars);
            request.getRequestDispatcher("/pages/user/favorite-car.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading favorite cars page", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải trang xe yêu thích. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/pages/user/favorite-car.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 