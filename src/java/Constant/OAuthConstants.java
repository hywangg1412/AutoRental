package Constant;

import io.github.cdimascio.dotenv.Dotenv;

public class OAuthConstants {
    
    private static final Dotenv dotenv = Dotenv.load();
    public static final String GOOGLE_AUTH_URL = getenv("GOOGLE_AUTH_URL", "https://accounts.google.com/o/oauth2/auth");
    public static final String GOOGLE_TOKEN_URL = getenv("GOOGLE_TOKEN_URL", "https://oauth2.googleapis.com/token");
    public static final String GOOGLE_USER_INFO_URL = getenv("GOOGLE_USER_INFO_URL", "https://www.googleapis.com/oauth2/v1/userinfo");

    public static final String GOOGLE_CLIENT_ID = getenv("GOOGLE_CLIENT_ID", "");
    public static final String GOOGLE_CLIENT_SECRET = getenv("GOOGLE_CLIENT_SECRET", "");
    public static final String GOOGLE_REDIRECT_URI = getenv("GOOGLE_REDIRECT_URI", "");
    public static final String GOOGLE_EMAIL_SCOPE = getenv("GOOGLE_EMAIL_SCOPE", "https://www.googleapis.com/auth/userinfo.email");
    public static final String GOOGLE_PROFILE_SCOPE = getenv("GOOGLE_PROFILE_SCOPE", "https://www.googleapis.com/auth/userinfo.profile");

    // Facebook OAuth
    public static final String FACEBOOK_CLIENT_ID = getenv("FACEBOOK_CLIENT_ID", "");
    public static final String FACEBOOK_CLIENT_SECRET = getenv("FACEBOOK_CLIENT_SECRET", "");
    public static final String FACEBOOK_REDIRECT_URI = getenv("FACEBOOK_REDIRECT_URI", "");
    public static final String FACEBOOK_GRANT_TYPE = getenv("FACEBOOK_GRANT_TYPE", "");
    public static final String FACEBOOK_LINK_GET_TOKEN = getenv("FACEBOOK_LINK_GET_TOKEN", "");
    public static final String FACEBOOK_LINK_GET_USER_INFO = getenv("FACEBOOK_LINK_GET_USER_INFO", "");

    private static String getenv(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value != null && !value.isEmpty()) return value;
        value = dotenv.get(key);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }
}
