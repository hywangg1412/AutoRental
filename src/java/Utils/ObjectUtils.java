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

}
