package Constant;

public class OAuthConstants {
    // Google OAuth
    public static final String GOOGLE_CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    public static final String GOOGLE_CLIENT_SECRET = System.getenv("GOOGLE_CLIENT_SECRET");
    public static final String GOOGLE_REDIRECT_URI = System.getenv("GOOGLE_REDIRECT_URI");
    public static final String GOOGLE_GRANT_TYPE = System.getenv("GOOGLE_GRANT_TYPE");
    public static final String GOOGLE_LINK_GET_TOKEN = System.getenv("GOOGLE_LINK_GET_TOKEN");
    public static final String GOOGLE_LINK_GET_USER_INFO = System.getenv("GOOGLE_LINK_GET_USER_INFO");

    // Facebook OAuth
    public static final String FACEBOOK_CLIENT_ID = System.getenv("FACEBOOK_CLIENT_ID");
    public static final String FACEBOOK_CLIENT_SECRET = System.getenv("FACEBOOK_CLIENT_SECRET");
    public static final String FACEBOOK_REDIRECT_URI = System.getenv("FACEBOOK_REDIRECT_URI");
    public static final String FACEBOOK_GRANT_TYPE = System.getenv("FACEBOOK_GRANT_TYPE");
    public static final String FACEBOOK_LINK_GET_TOKEN = System.getenv("FACEBOOK_LINK_GET_TOKEN");
    public static final String FACEBOOK_LINK_GET_USER_INFO = System.getenv("FACEBOOK_LINK_GET_USER_INFO");
}
