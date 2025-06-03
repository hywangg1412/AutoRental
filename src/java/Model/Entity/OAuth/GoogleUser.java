package Model.Entity.OAuth;

public class GoogleUser {

    private String googleId;              
    private String email;          
    private String firstName;       
    private String lastName;       
    private String avatarUrl;         
    private boolean emailVerified;  

    public GoogleUser() {
    }

    public GoogleUser(String googleId, String email, String firstName, String lastName,
            String avatarUrl, boolean emailVerified) {
        this.googleId = googleId;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.avatarUrl = avatarUrl;
        this.emailVerified = emailVerified;
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

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    public void setEmailVerified(boolean emailVerified) {
        this.emailVerified = emailVerified;
    }

    @Override
    public String toString() {
        return "GoogleUser{" + "googleId=" + googleId + ", email=" + email + ", firstName=" + firstName + ", lastName=" + lastName + ", avatarUrl=" + avatarUrl + ", emailVerified=" + emailVerified + '}';
    }

    
}