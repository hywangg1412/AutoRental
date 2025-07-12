package Model.Entity.User;

import Model.Constants.UserStatusConstants;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

public class User {
    private UUID userId;
    private String username;
    private LocalDate userDOB;
    private String phoneNumber;
    private String avatarUrl;
    private String gender;
    private String firstName;
    private String lastName;
    private String status;
    private UUID roleId;
    private LocalDateTime createdDate;
    private String normalizedUserName;
    private String email;
    private String normalizedEmail;
    private boolean emailVerifed;
    private String passwordHash;
    private String securityStamp;
    private String concurrencyStamp;
    private boolean twoFactorEnabled;
    private LocalDateTime lockoutEnd;
    private boolean lockoutEnabled;
    private int accessFailedCount;

    public User() {
    }

    public User(UUID userId, String username, LocalDate userDOB, String phoneNumber,
             String avatarUrl, String gender,
            String firstName, String lastName, String status, UUID roleId, LocalDateTime createdDate,
            String normalizedUserName, String email, String normalizedEmail, boolean emailVerifed,
            String passwordHash, String securityStamp, String concurrencyStamp,
            boolean twoFactorEnabled, LocalDateTime lockoutEnd, boolean lockoutEnabled,
            int accessFailedCount) {
        this.userId = userId;
        this.username = username;
        this.userDOB = userDOB;
        this.phoneNumber = phoneNumber;
        this.avatarUrl = avatarUrl;
        this.gender = gender;
        this.firstName = firstName;
        this.lastName = lastName;
        this.status = status;
        this.roleId = roleId;
        this.createdDate = createdDate;
        this.normalizedUserName = normalizedUserName;
        this.email = email;
        this.normalizedEmail = normalizedEmail;
        this.emailVerifed = emailVerifed;
        this.passwordHash = passwordHash;
        this.securityStamp = securityStamp;
        this.concurrencyStamp = concurrencyStamp;
        this.twoFactorEnabled = twoFactorEnabled;
        this.lockoutEnd = lockoutEnd;
        this.lockoutEnabled = lockoutEnabled;
        this.accessFailedCount = accessFailedCount;
    }

    public String getFullName() {
        return firstName + " " + lastName;
    }

    // Getters and Setters
    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isBanned() {
        return UserStatusConstants.BANNED.equalsIgnoreCase(status);
    }

    public boolean isActive() {
        return UserStatusConstants.ACTIVE.equalsIgnoreCase(status);
    }

    public boolean isDeleted() {
        return UserStatusConstants.DELETED.equalsIgnoreCase(status);
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public String getNormalizedUserName() {
        return normalizedUserName;
    }

    public void setNormalizedUserName(String normalizedUserName) {
        this.normalizedUserName = normalizedUserName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNormalizedEmail() {
        return normalizedEmail;
    }

    public void setNormalizedEmail(String normalizedEmail) {
        this.normalizedEmail = normalizedEmail;
    }

    public boolean isEmailVerifed() {
        return emailVerifed;
    }

    public void setEmailVerifed(boolean emailVerifed) {
        this.emailVerifed = emailVerifed;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getSecurityStamp() {
        return securityStamp;
    }

    public void setSecurityStamp(String securityStamp) {
        this.securityStamp = securityStamp;
    }

    public String getConcurrencyStamp() {
        return concurrencyStamp;
    }

    public void setConcurrencyStamp(String concurrencyStamp) {
        this.concurrencyStamp = concurrencyStamp;
    }

    public boolean isTwoFactorEnabled() {
        return twoFactorEnabled;
    }

    public void setTwoFactorEnabled(boolean twoFactorEnabled) {
        this.twoFactorEnabled = twoFactorEnabled;
    }

    public LocalDateTime getLockoutEnd() {
        return lockoutEnd;
    }

    public void setLockoutEnd(LocalDateTime lockoutEnd) {
        this.lockoutEnd = lockoutEnd;
    }

    public boolean isLockoutEnabled() {
        return lockoutEnabled;
    }

    public void setLockoutEnabled(boolean lockoutEnabled) {
        this.lockoutEnabled = lockoutEnabled;
    }

    public int getAccessFailedCount() {
        return accessFailedCount;
    }

    public void setAccessFailedCount(int accessFailedCount) {
        this.accessFailedCount = accessFailedCount;
    }

    public UUID getRoleId() {
        return roleId;
    }

    public void setRoleId(UUID roleId) {
        this.roleId = roleId;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", fullName='" + getFullName() + '\'' +
                ", userDOB=" + userDOB +
                ", gender='" + gender + '\'' +
                ", createdDate=" + createdDate +
                ", status='" + status + '\'' +
                '}';
    }
}