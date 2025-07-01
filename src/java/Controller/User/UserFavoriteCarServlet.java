package Controller.User;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.UUID;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import Model.Entity.User.UserFavoriteCar;
import Model.Entity.User.User;
import Service.User.UserFavoriteCarService;
import Exception.EventException;
import Exception.NotFoundException;
import Exception.InvalidDataException;
import java.sql.SQLException;
import jakarta.servlet.annotation.MultipartConfig;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet(name = "UserFavoriteCarServlet", urlPatterns = {"/user/favorite-car"})
@MultipartConfig
public class UserFavoriteCarServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(UserFavoriteCarServlet.class.getName());
    private final UserFavoriteCarService favoriteCarService = new UserFavoriteCarService();
    
    @Override
    public void init(){
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/car");
    }
    
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
            
            String action = request.getParameter("action");
            String carIdStr = request.getParameter("carId");
            String source = request.getParameter("source");
            
            if (action == null || carIdStr == null) {
                // Redirect back to car page with error
                response.sendRedirect(request.getContextPath() + "/pages/car?error=missing_params");
                return;
            }
            
            UUID carId = UUID.fromString(carIdStr);
            
            String redirectUrl;
            switch (action.toLowerCase()) {
                case "add": {
                    UserFavoriteCar newFavorite = new UserFavoriteCar(user.getUserId(), carId);
                    favoriteCarService.add(newFavorite);
                    if ("favorite-car".equals(source)) {
                        redirectUrl = request.getContextPath() + "/user/favorite-car-page?success=added_to_favorites";
                    } else {
                        redirectUrl = request.getContextPath() + "/pages/car?success=added_to_favorites";
                    }
                    break;
                }
                case "remove": {
                    boolean deleted = favoriteCarService.delete(user.getUserId(), carId);
                    if ("favorite-car".equals(source)) {
                        redirectUrl = request.getContextPath() + "/user/favorite-car-page?success=removed_from_favorites";
                    } else {
                        redirectUrl = deleted ? 
                            request.getContextPath() + "/pages/car?success=removed_from_favorites" :
                            request.getContextPath() + "/pages/car?error=favorite_not_found";
                    }
                    break;
                }
                default:
                    redirectUrl = request.getContextPath() + "/pages/car?error=invalid_action";
            }
            
            response.sendRedirect(redirectUrl);
            
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid UUID format", e);
            response.sendRedirect(request.getContextPath() + "/pages/car?error=invalid_car_id");
        } catch (EventException e) {
            LOGGER.log(Level.SEVERE, "Error processing favorite car action", e);
            response.sendRedirect(request.getContextPath() + "/pages/car?error=database_error");
        } catch (NotFoundException e) {
            LOGGER.log(Level.WARNING, "Favorite car not found", e);
            response.sendRedirect(request.getContextPath() + "/pages/car?error=favorite_not_found");
        } catch (InvalidDataException e) {
            LOGGER.log(Level.WARNING, "Invalid data provided", e);
            if (e.getMessage().contains("already in favorites")) {
                response.sendRedirect(request.getContextPath() + "/pages/car?error=already_favorited");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/car?error=invalid_data");
            }
        }
    }
}
