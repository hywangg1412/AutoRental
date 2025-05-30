package Mapper;

import Model.Entity.OAuth.GoogleUser;
import Model.Entity.User;
import java.time.LocalDateTime;
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
        user.setBanned(false); 
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
}
