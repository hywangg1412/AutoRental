package Model.DTO.User;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class UserProfileDTO {

    private String username;
    private LocalDate userDOB;
    private String userDOBFormatted; // Thêm field để lưu ngày tháng đã format
    private String gender;
    private String phoneNumber;
    private String email;
    private String avatarUrl;
    private String createdAt;
    private boolean emailVerified;
    private boolean hasFacebookLogin;
    private boolean hasGoogleLogin;
    private String facebookAccountName;
    private String googleAccountName;

    public String getFacebookAccountName() {
        return facebookAccountName;
    }

    public void setFacebookAccountName(String facebookAccountName) {
        this.facebookAccountName = facebookAccountName;
    }

    public String getGoogleAccountName() {
        return googleAccountName;
    }

    public void setGoogleAccountName(String googleAccountName) {
        this.googleAccountName = googleAccountName;
    }

    public boolean isHasFacebookLogin() {
        return hasFacebookLogin;
    }

    public void setHasFacebookLogin(boolean hasFacebookLogin) {
        this.hasFacebookLogin = hasFacebookLogin;
    }

    public boolean isHasGoogleLogin() {
        return hasGoogleLogin;
    }

    public void setHasGoogleLogin(boolean hasGoogleLogin) {
        this.hasGoogleLogin = hasGoogleLogin;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public LocalDate getUserDOB() {
        return userDOB;
    }

    public void setUserDOB(LocalDate userDOB) {
        this.userDOB = userDOB;
    }

    public String getUserDOBFormatted() {
        return userDOBFormatted;
    }

    public void setUserDOBFormatted(String userDOBFormatted) {
        this.userDOBFormatted = userDOBFormatted;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(boolean emailVerifed) {
        this.emailVerified = emailVerifed;
    }

    @Override
    public String toString() {
        return "UserProfileDTO{" + "username=" + username + ", userDOB=" + userDOB + ", gender=" + gender + ", phoneNumber=" + phoneNumber + ", email=" + email + ", avatarUrl=" + avatarUrl + ", createdAt=" + createdAt + ", hasFacebookLogin=" + hasFacebookLogin + ", hasGoogleLogin=" + hasGoogleLogin + ", facebookAccountName=" + facebookAccountName + ", googleAccountName=" + googleAccountName + '}';
    }

}
