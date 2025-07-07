package Mapper;

import Model.Entity.OAuth.FacebookUser;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.OAuth.UserLogins;
import Model.Entity.User.User;
import Service.User.UserService;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Date;
import java.util.UUID;

public class UserMapper {

    public User mapGoogleUserToUser(GoogleUser googleUser, UserService userService) {
        User user = new User();

        user.setUserId(UUID.randomUUID());
        user.setEmail(googleUser.getEmail());
        user.setFirstName(googleUser.getFirstName());
        user.setLastName(googleUser.getLastName());
        user.setEmailVerifed(false);
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
        user.setGender(null);
        user.setUserDOB(null);
        user.setLockoutEnd(null);

        String email = googleUser.getEmail();
        String baseUsername = email.substring(0, email.indexOf('@'));
        String uniqueUsername = userService.generateUniqueUsername(baseUsername);
        user.setUsername(uniqueUsername);
        user.setNormalizedUserName(uniqueUsername.toUpperCase());
        user.setNormalizedEmail(email.toLowerCase());

        return user;
    }

    public User mapFacebookUserToUser(FacebookUser facebookUser, UserService userService) {
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
        user.setGender(null);
        user.setUserDOB(null);
        user.setLockoutEnd(null);

        String email = facebookUser.getEmail();
        String baseUsername = email.substring(0, email.indexOf('@'));
        String uniqueUsername = userService.generateUniqueUsername(baseUsername);
        user.setUsername(uniqueUsername);
        user.setNormalizedUserName(uniqueUsername.toUpperCase());
        user.setNormalizedEmail(email.toLowerCase());

        return user;
    }

    public UserLogins mapFacebookUserToUserLogins(FacebookUser facebookUser, User user) {
        UserLogins login = new UserLogins("facebook", facebookUser.getFacebookId(), "Facebook", user.getUserId());
        
        String fullName = facebookUser.getFullName();
        String displayName = (fullName != null && !fullName.trim().isEmpty()) ? fullName.trim() : "Facebook User";
        
        login.setProviderDisplayName(displayName);
        return login;
    }

    public UserLogins mapGoogleUserToUserLogins(GoogleUser googleUser, User user) {
        UserLogins login = new UserLogins("google", googleUser.getGoogleId(), "Google", user.getUserId());
        
        // Handle null firstName and lastName
        String firstName = googleUser.getFirstName() != null ? googleUser.getFirstName().trim() : "";
        String lastName = googleUser.getLastName() != null ? googleUser.getLastName().trim() : "";
        
        String displayName;
        if (!firstName.isEmpty() && !lastName.isEmpty()) {
            displayName = firstName + " " + lastName;
        } else if (!firstName.isEmpty()) {
            displayName = firstName;
        } else if (!lastName.isEmpty()) {
            displayName = lastName;
        } else {
            displayName = "Google User"; 
        }
        
        login.setProviderDisplayName(displayName);
        return login;
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
