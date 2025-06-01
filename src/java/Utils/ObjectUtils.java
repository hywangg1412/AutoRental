package Utils;

import Exception.EventException;
import Exception.NotFoundException;
import Model.Entity.User;
import Service.UserService;
import at.favre.lib.crypto.bcrypt.BCrypt;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ObjectUtils {

    private UserService userService = new UserService();

    public static String hashPassword(String password) {
        return BCrypt.withDefaults().hashToString(12, password.toCharArray());
    }

    public static boolean verifyPassword(String password, String hashedPassword) {
        BCrypt.Result result = BCrypt.verifyer().verify(password.toCharArray(), hashedPassword);
        return result.verified;
    }

    public boolean login(String email, String password) {
        User user = userService.findByEmail(email);

        if (user == null) {
            return false;
        }

        boolean isPasswordMatch = ObjectUtils.verifyPassword(password, user.getPasswordHash());

        if (isPasswordMatch) {
            try {
//            user.setLastLogin(LocalDateTime.now());
                userService.update(user);
            } catch (EventException ex) {
                Logger.getLogger(ObjectUtils.class.getName()).log(Level.SEVERE, null, ex);
            } catch (NotFoundException ex) {
                Logger.getLogger(ObjectUtils.class.getName()).log(Level.SEVERE, null, ex);
            }
            return true;
        }

        return false;
    }
}
