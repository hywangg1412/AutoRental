package Service.Auth;

import Model.Constants.OAuthConstants;
import Model.Entity.OAuth.FacebookUser;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import org.json.JSONObject;

public class FacebookAuthService extends OAuthConstants {

    public String getAuthorizationUrl() {
        try {
            String url = FACEBOOK_AUTH_URL
                    + "?client_id=" + URLEncoder.encode(FACEBOOK_CLIENT_ID, "UTF-8")
                    + "&redirect_uri=" + URLEncoder.encode(FACEBOOK_REDIRECT_URI, "UTF-8")
                    + "&scope=" + URLEncoder.encode(FACEBOOK_SCOPE, "UTF-8")
                    + "&response_type=code"
                    + "&state=" + URLEncoder.encode(FACEBOOK_STATE, "UTF-8");
            return url;
        } catch (Exception e) {
            throw new RuntimeException("Failed to build Facebook authorization URL", e);
        }
    }

    public FacebookUser getUserInfo(String code) throws IOException {
        String tokenUrl = FACEBOOK_TOKEN_URL
                + "?client_id=" + URLEncoder.encode(FACEBOOK_CLIENT_ID, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(FACEBOOK_REDIRECT_URI, "UTF-8")
                + "&client_secret=" + URLEncoder.encode(FACEBOOK_CLIENT_SECRET, "UTF-8")
                + "&code=" + URLEncoder.encode(code, "UTF-8")
                + "&grant_type=" + URLEncoder.encode(FACEBOOK_GRANT_TYPE, "UTF-8");

        JSONObject tokenResponse = getJsonFromUrl(tokenUrl);
        String accessToken = tokenResponse.getString("access_token");

        String userInfoUrl = FACEBOOK_USER_INFO_URL
                + "&access_token=" + URLEncoder.encode(accessToken, "UTF-8");
        JSONObject userInfo = getJsonFromUrl(userInfoUrl);

        String id = userInfo.optString("id", null);
        String email = userInfo.optString("email", null);
        String name = userInfo.optString("name", null);
        String avatarUrl = null;
        if (userInfo.has("picture")) {
            JSONObject picture = userInfo.getJSONObject("picture");
            if (picture.has("data")) {
                avatarUrl = picture.getJSONObject("data").optString("url", null);
            }
        }
        return new FacebookUser(id, email, name, avatarUrl);
    }

    private JSONObject getJsonFromUrl(String urlString) throws IOException {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setDoOutput(true);
        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            throw new IOException("Failed to call URL: " + urlString + ", response code: " + responseCode);
        }
        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String inputLine;
        StringBuilder response = new StringBuilder();
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
        return new JSONObject(response.toString());
    }

    public String getAuthorizationRegisterUrl() {
        try {
            String url = FACEBOOK_AUTH_URL
                    + "?client_id=" + URLEncoder.encode(FACEBOOK_CLIENT_ID, "UTF-8")
                    + "&redirect_uri=" + URLEncoder.encode(FACEBOOK_REDIRECT_URI_REGISTER, "UTF-8")
                    + "&scope=" + URLEncoder.encode(FACEBOOK_SCOPE, "UTF-8")
                    + "&response_type=code"
                    + "&state=" + URLEncoder.encode(FACEBOOK_STATE, "UTF-8");
            return url;
        } catch (Exception e) {
            throw new RuntimeException("Failed to build Facebook authorization URL", e);
        }
    }

    public FacebookUser getRegisterUserInfo(String code) throws IOException {
        String tokenUrl = FACEBOOK_TOKEN_URL
                + "?client_id=" + URLEncoder.encode(FACEBOOK_CLIENT_ID, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(FACEBOOK_REDIRECT_URI_REGISTER, "UTF-8")
                + "&client_secret=" + URLEncoder.encode(FACEBOOK_CLIENT_SECRET, "UTF-8")
                + "&code=" + URLEncoder.encode(code, "UTF-8")
                + "&grant_type=" + URLEncoder.encode(FACEBOOK_GRANT_TYPE, "UTF-8");

        JSONObject tokenResponse = getJsonFromUrl(tokenUrl);
        String accessToken = tokenResponse.getString("access_token");

        String userInfoUrl = FACEBOOK_USER_INFO_URL
                + "&access_token=" + URLEncoder.encode(accessToken, "UTF-8");
        JSONObject userInfo = getJsonFromUrl(userInfoUrl);

        String id = userInfo.optString("id", null);
        String email = userInfo.optString("email", null);
        String name = userInfo.optString("name", null);
        String avatarUrl = null;
        if (userInfo.has("picture")) {
            JSONObject picture = userInfo.getJSONObject("picture");
            if (picture.has("data")) {
                avatarUrl = picture.getJSONObject("data").optString("url", null);
            }
        }
        return new FacebookUser(id, email, name, avatarUrl);
    }

    public String getAuthorizationLinkUrl() {
        try {
            String url = FACEBOOK_AUTH_URL
                    + "?client_id=" + URLEncoder.encode(FACEBOOK_CLIENT_ID, "UTF-8")
                    + "&redirect_uri=" + URLEncoder.encode(FACEBOOK_REDIRECT_URI_LINK, "UTF-8")
                    + "&scope=" + URLEncoder.encode(FACEBOOK_SCOPE, "UTF-8")
                    + "&response_type=code"
                    + "&state=" + URLEncoder.encode(FACEBOOK_STATE, "UTF-8");
            return url;
        } catch (Exception e) {
            throw new RuntimeException("Failed to build Facebook authorization URL for link", e);
        }
    }

    public FacebookUser getLinkUserInfo(String code) throws IOException {
        String tokenUrl = FACEBOOK_TOKEN_URL
                + "?client_id=" + URLEncoder.encode(FACEBOOK_CLIENT_ID, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(FACEBOOK_REDIRECT_URI_LINK, "UTF-8")
                + "&client_secret=" + URLEncoder.encode(FACEBOOK_CLIENT_SECRET, "UTF-8")
                + "&code=" + URLEncoder.encode(code, "UTF-8")
                + "&grant_type=" + URLEncoder.encode(FACEBOOK_GRANT_TYPE, "UTF-8");

        JSONObject tokenResponse = getJsonFromUrl(tokenUrl);
        String accessToken = tokenResponse.getString("access_token");

        String userInfoUrl = FACEBOOK_USER_INFO_URL
                + "&access_token=" + URLEncoder.encode(accessToken, "UTF-8");
        JSONObject userInfo = getJsonFromUrl(userInfoUrl);

        String id = userInfo.optString("id", null);
        String email = userInfo.optString("email", null);
        String name = userInfo.optString("name", null);
        String avatarUrl = null;
        if (userInfo.has("picture")) {
            JSONObject picture = userInfo.getJSONObject("picture");
            if (picture.has("data")) {
                avatarUrl = picture.getJSONObject("data").optString("url", null);
            }
        }
        return new FacebookUser(id, email, name, avatarUrl);
    }

}
