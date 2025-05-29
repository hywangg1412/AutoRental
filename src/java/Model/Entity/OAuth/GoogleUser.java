package Model.Entity.OAuth;

public class GoogleUser {

    private String googleId;
    
    private String email;
    
//    private boolean emailVerified;
    
    // Tên đầy đủ của user
    private String fullName;
    
    // Tên đầu tiên
//    private String givenName;
//    
//    // Tên cuối
//    private String familyName;
    
    // Link ảnh đại diện
    private String avatarUrl;
    
    // Link profile Google
//    private String profileLink;
//    
//    // Locale của user (ví dụ: vi, en-US)
//    private String locale;
//    
//    // Thời gian token hết hạn
//    private Long tokenExpiresIn;
//    
//    // Loại token
//    private String tokenType;
//    
//    // Access token
//    private String accessToken;
//    
//    // Refresh token (nếu có)
//    private String refreshToken;
//    
//    // Scope của token
//    private String tokenScope;
//    
//    // Thời gian token được tạo
//    private Long tokenCreatedAt;

    public GoogleUser() {
    }

    public GoogleUser(String googleId, String email, String fullName, String avatarUrl) {
        this.googleId = googleId;
        this.email = email;
        this.fullName = fullName;
        this.avatarUrl = avatarUrl;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }
    
}
