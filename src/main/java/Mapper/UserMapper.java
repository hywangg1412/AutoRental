package Mapper;

import Model.Entity.OAuth.FacebookUser;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.User;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Date;
import java.util.UUID;

public class UserMapper {

    public User mapGoogleUserToUser(GoogleUser googleUser) {
        User user = new User();

        user.setUserId(UUID.randomUUID());
        user.setEmail(googleUser.getEmail());
        user.setFirstName(googleUser.getFirstName());
        user.setLastName(googleUser.getLastName());
        user.setEmailVerifed(googleUser.isEmailVerified());
        user.setAvatarUrl(googleUser.getAvatarUrl());
        user.setStatus("Active");

        user.setCreatedDate(LocalDateTime.now());
        user.setTwoFactorEnabled(false);
        user.setLockoutEnabled(true);
        user.setAccessFailedCount(0);
        user.setPasswordHash("");
        user.setSecurityStamp(UUID.randomUUID().toString());
        user.setConcurrencyStamp(UUID.randomUUID().toString());

        user.setPhoneNumber(null);
        user.setUserAddress(null);
        user.setUserDescription(null);
        user.setGender(null);
        user.setUserDOB(null);
        user.setLockoutEnd(null);

        String email = googleUser.getEmail();
        String username = email.substring(0, email.indexOf('@'));
        user.setUsername(username);
        user.setNormalizedUserName(username.toLowerCase());
        user.setNormalizedEmail(email.toLowerCase());

        return user;
    }

    public User mapFacebookUserToUser(FacebookUser facebookUser) {
        User user = new User();
        String[] nameParts = splitName(facebookUser.getFullName());

        user.setUserId(UUID.randomUUID());
        user.setEmail(facebookUser.getEmail());
        user.setFirstName(nameParts[0]);
        user.setLastName(nameParts[1]);
        user.setEmailVerifed(false);
        user.setAvatarUrl(facebookUser.getAvatarUrl());
        user.setStatus("Active");

        user.setCreatedDate(LocalDateTime.now());
        user.setTwoFactorEnabled(false);
        user.setLockoutEnabled(true);
        user.setAccessFailedCount(0);
        user.setPasswordHash("");
        user.setSecurityStamp(UUID.randomUUID().toString());
        user.setConcurrencyStamp(UUID.randomUUID().toString());

        user.setPhoneNumber(null);
        user.setUserAddress(null);
        user.setUserDescription(null);
        user.setGender(null);
        user.setUserDOB(null);
        user.setLockoutEnd(null);

        String email = facebookUser.getEmail();
        String username = email.substring(0, email.indexOf('@'));
        user.setUsername(username);
        user.setNormalizedUserName(username.toLowerCase());
        user.setNormalizedEmail(email.toLowerCase());

        return user;
    }

    private String[] splitName(String fullname) {
        if (fullname == null || fullname.trim().isEmpty()) {
            return new String[]{"", ""};
        }

        String[] parts = fullname.trim().split("\\s+");
        String firstName = parts[0];
        String lastName = parts.length > 1
                ? String.join(" ", Arrays.copyOfRange(parts, 1, parts.length))
                : "";

        return new String[]{firstName, lastName};
    }

}
