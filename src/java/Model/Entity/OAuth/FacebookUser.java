package Model.Entity.OAuth;

public class FacebookUser {
    private String facebookId;
    private String email;
    private String fullName;
    private String avatarUrl;

    public FacebookUser() {}

    public FacebookUser(String facebookId, String email, String fullName, String avatarUrl) {
        this.facebookId = facebookId;
        this.email = email;
        this.fullName = fullName;
        this.avatarUrl = avatarUrl;
    }

    public String getFacebookId() {
        return facebookId;
    }

    public void setFacebookId(String facebookId) {
        this.facebookId = facebookId;
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

    @Override
    public String toString() {
        return "FacebookUser{" + "facebookId=" + facebookId + ", email=" + email + ", fullName=" + fullName + ", avatarUrl=" + avatarUrl + '}';
    }
} 