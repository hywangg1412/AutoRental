package Mapper;

import Model.DTO.User.UserProfileDTO;
import Model.Entity.User.User;
import Model.Entity.OAuth.UserLogins;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class UserProfileMapper {
    public static UserProfileDTO mapUserToProfileDTO(User user, List<UserLogins> userLogins) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        UserProfileDTO profile = new UserProfileDTO();
        profile.setUsername(user.getUsername());
        profile.setUserDOB(user.getUserDOB());
        if (user.getUserDOB() != null) {
            profile.setUserDOBFormatted(user.getUserDOB().format(formatter));
        }
        profile.setGender(user.getGender());
        profile.setPhoneNumber(user.getPhoneNumber());
        profile.setEmail(user.getEmail());
        profile.setEmailVerified(user.isEmailVerifed());
        profile.setAvatarUrl(user.getAvatarUrl());
        profile.setCreatedAt(user.getCreatedDate().format(formatter));
        Set<String> providers = new HashSet<>();
        for (UserLogins login : userLogins) {
            String provider = login.getLoginProvider().toLowerCase();
            providers.add(provider);
            if ("facebook".equals(provider)) {
                profile.setHasFacebookLogin(true);
                profile.setFacebookAccountName(login.getProviderDisplayName());
            } else if ("google".equals(provider)) {
                profile.setHasGoogleLogin(true);
                profile.setGoogleAccountName(login.getProviderDisplayName());
            }
        }
        return profile;
    }
}