package Constant;

import io.github.cdimascio.dotenv.Dotenv;

public class OAuthConstants {

    private static final Dotenv dotenv = Dotenv.configure()
            .directory("L:/Workspace/SWP/AutoRental/.env")
            .ignoreIfMalformed()
            .ignoreIfMissing()
            .load();

    // Google OAuth
    public static final String GOOGLE_AUTH_URL = getenv("GOOGLE_AUTH_URL", "https://accounts.google.com/o/oauth2/auth");
    public static final String GOOGLE_TOKEN_URL = getenv("GOOGLE_TOKEN_URL", "https://oauth2.googleapis.com/token");
    public static final String GOOGLE_USER_INFO_URL = getenv("GOOGLE_USER_INFO_URL", "https://www.googleapis.com/oauth2/v1/userinfo");
    public static final String GOOGLE_CLIENT_ID = getenv("GOOGLE_CLIENT_ID", "");
    public static final String GOOGLE_CLIENT_SECRET = getenv("GOOGLE_CLIENT_SECRET", "");
    public static final String GOOGLE_REDIRECT_URI = getenv("GOOGLE_REDIRECT_URI", "");
    public static final String GOOGLE_REDIRECT_URI_REGISTER = getenv("GOOGLE_REDIRECT_URI_REGISTER", "");
    public static final String GOOGLE_EMAIL_SCOPE = getenv("GOOGLE_EMAIL_SCOPE", "https://www.googleapis.com/auth/userinfo.email");
    public static final String GOOGLE_PROFILE_SCOPE = getenv("GOOGLE_PROFILE_SCOPE", "https://www.googleapis.com/auth/userinfo.profile");

    // Facebook OAuth
    public static final String FACEBOOK_AUTH_URL = getenv("FACEBOOK_AUTH_URL", "https://www.facebook.com/v23.0/dialog/oauth");
    public static final String FACEBOOK_TOKEN_URL = getenv("FACEBOOK_LINK_GET_TOKEN", "https://graph.facebook.com/v23.0/oauth/access_token");
    public static final String FACEBOOK_USER_INFO_URL = getenv("FACEBOOK_LINK_GET_USER_INFO", "https://graph.facebook.com/me?fields=id,name,email,picture");
    public static final String FACEBOOK_CLIENT_ID = getenv("FACEBOOK_CLIENT_ID", "");
    public static final String FACEBOOK_CLIENT_SECRET = getenv("FACEBOOK_CLIENT_SECRET", "");
    public static final String FACEBOOK_REDIRECT_URI = getenv("FACEBOOK_REDIRECT_URI", "");
    public static final String FACEBOOK_REDIRECT_URI_REGISTER = getenv("FACEBOOK_REDIRECT_URI_REGISTER", "");
    public static final String FACEBOOK_GRANT_TYPE = getenv("FACEBOOK_GRANT_TYPE", "authorization_code");
    public static final String FACEBOOK_SCOPE = getenv("FACEBOOK_SCOPE", "email,public_profile");
    public static final String FACEBOOK_STATE = getenv("FACEBOOK_STATE", "some_random_string");

    // Email
    public static final String SENDER_EMAIL= getenv("SENDER_EMAIL", "");
    public static final String SENDER_EMAIL_PASSWORD = getenv("SENDER_EMAIL_PASSWORD", "");

    // Debug info
    static {
        System.out.println("Working dir: " + System.getProperty("user.dir"));
        System.out.println("Env file GOOGLE_CLIENT_ID: " + dotenv.get("GOOGLE_CLIENT_ID"));
        System.out.println("SENDER_EMAIL: " + SENDER_EMAIL);
        System.out.println("SENDER_EMAIL_PASSWORD: " + SENDER_EMAIL_PASSWORD);
    }

    /**
     * Get environment variable or fallback to .env or default value.
     */
    private static String getenv(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value != null && !value.isEmpty()) {
            return value;
        }
        value = dotenv.get(key);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }
}
