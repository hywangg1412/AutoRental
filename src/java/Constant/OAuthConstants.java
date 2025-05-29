package Constant;

public class OAuthConstants {
// Google OAuth


    // Google OAuth Endpoints
    public static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/auth";
    public static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v1/userinfo";

    public static final String GOOGLE_CLIENT_ID = "669490144407-kiueqs7v7sv1drt65s709fgs3l29rts6.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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";
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/autorental/googleLogin";
    public static final String GOOGLE_EMAIL_SCOPE = "https://www.googleapis.com/auth/userinfo.email";
    public static final String GOOGLE_PROFILE_SCOPE = "https://www.googleapis.com/auth/userinfo.profile";

    // Facebook OAuth
    public static final String FACEBOOK_CLIENT_ID = System.getenv("FACEBOOK_CLIENT_ID");
    public static final String FACEBOOK_CLIENT_SECRET = System.getenv("FACEBOOK_CLIENT_SECRET");
    public static final String FACEBOOK_REDIRECT_URI = System.getenv("FACEBOOK_REDIRECT_URI");
    public static final String FACEBOOK_GRANT_TYPE = System.getenv("FACEBOOK_GRANT_TYPE");
    public static final String FACEBOOK_LINK_GET_TOKEN = System.getenv("FACEBOOK_LINK_GET_TOKEN");
    public static final String FACEBOOK_LINK_GET_USER_INFO = System.getenv("FACEBOOK_LINK_GET_USER_INFO");
}
