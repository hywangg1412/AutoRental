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
            
            int pageSize = 4;
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            List<FavoriteCarDTO> favoriteCars = favoriteCarService.getFavoriteCarDetailsByUserId(user.getUserId());
            int totalCars = favoriteCars.size();
            int totalPages = (int) Math.ceil((double) totalCars / pageSize);

            // Đảm bảo page hợp lệ
            if (totalPages == 0) {
                page = 1;
            } else if (page > totalPages) {
                page = totalPages;
            } else if (page < 1) {
                page = 1;
            }

            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalCars);
            List<FavoriteCarDTO> pagedCars = (fromIndex < toIndex) ? favoriteCars.subList(fromIndex, toIndex) : java.util.Collections.emptyList();
            
            request.setAttribute("favoriteCars", pagedCars);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            
            request.getRequestDispatcher("/pages/user/favorite-car.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading favorite cars page", e);
            request.setAttribute("errorMessage", "Something went wrong. Please try again later.");
            request.getRequestDispatcher("/pages/user/favorite-car.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String source = request.getParameter("source");
        if ("favorite-car".equals(source)) {
            doGet(request, response);
        } else if ("car".equals(source)) {
            response.sendRedirect(request.getContextPath() + "/pages/car");
        } else {
            // fallback, hoặc redirect về trang mặc định
            doGet(request, response);
        }
    }
} 