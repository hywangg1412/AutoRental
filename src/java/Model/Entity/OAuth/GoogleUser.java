package Model.Entity.OAuth;

public class GoogleUser {

    private String googleId;
    
    private String email;
    
    private boolean emailVerified;
    
    // Tên đầy đủ của user
    private String fullName;
    
    // Tên đầu tiên
    private String givenName;
    
    // Tên cuối
    private String familyName;
    
    // Link ảnh đại diện
    private String avatarUrl;
    
    // Link profile Google
    private String profileLink;
    
    // Locale của user (ví dụ: vi, en-US)
    private String locale;
    
    // Thời gian token hết hạn
    private Long tokenExpiresIn;
    
    // Loại token
    private String tokenType;
    
    // Access token
    private String accessToken;
    
    // Refresh token (nếu có)
    private String refreshToken;
    
    // Scope của token
    private String tokenScope;
    
    // Thời gian token được tạo
    private Long tokenCreatedAt;

    public GoogleUser() {
    }

    public GoogleUser(String googleId, String email, boolean emailVerified, String fullName, String givenName, String familyName, String avatarUrl, String profileLink, String locale, Long tokenExpiresIn, String tokenType, String accessToken, String refreshToken, String tokenScope, Long tokenCreatedAt) {
        this.googleId = googleId;
        this.email = email;
        this.emailVerified = emailVerified;
        this.fullName = fullName;
        this.givenName = givenName;
        this.familyName = familyName;
        this.avatarUrl = avatarUrl;
        this.profileLink = profileLink;
        this.locale = locale;
        this.tokenExpiresIn = tokenExpiresIn;
        this.tokenType = tokenType;
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.tokenScope = tokenScope;
        this.tokenCreatedAt = tokenCreatedAt;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGivenName() {
        return givenName;
    }

    public void setGivenName(String givenName) {
        this.givenName = givenName;
    }

    public String getFamilyName() {
        return familyName;
    }

    public void setFamilyName(String familyName) {
        this.familyName = familyName;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getProfileLink() {
        return profileLink;
    }

    public void setProfileLink(String profileLink) {
        this.profileLink = profileLink;
    }

    public String getLocale() {
        return locale;
    }

    public void setLocale(String locale) {
        this.locale = locale;
    }

    public Long getTokenExpiresIn() {
        return tokenExpiresIn;
    }

    public void setTokenExpiresIn(Long tokenExpiresIn) {
        this.tokenExpiresIn = tokenExpiresIn;
    }

    public String getTokenType() {
        return tokenType;
    }

    public void setTokenType(String tokenType) {
        this.tokenType = tokenType;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public String getTokenScope() {
        return tokenScope;
    }

    public void setTokenScope(String tokenScope) {
        this.tokenScope = tokenScope;
    }

    public Long getTokenCreatedAt() {
        return tokenCreatedAt;
    }

    public void setTokenCreatedAt(Long tokenCreatedAt) {
        this.tokenCreatedAt = tokenCreatedAt;
    }

}
