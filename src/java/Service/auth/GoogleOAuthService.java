package Service.auth;

import Constant.OAuthConstants;
import Model.Entity.OAuth.GoogleUser;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.ClientProtocolException;

public class GoogleOAuthService extends OAuthConstants{

    public String getToken(String code) throws ClientProtocolException, IOException {
        String response = Request.Post(OAuthConstants.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(
                        Form.form()
                                .add("client_id", OAuthConstants.GOOGLE_CLIENT_ID)
                                .add("client_secret", OAuthConstants.GOOGLE_CLIENT_SECRET)
                                .add("redirect_uri", OAuthConstants.GOOGLE_REDIRECT_URI)
                                .add("code", code)
                                .add("grant_type", OAuthConstants.GOOGLE_GRANT_TYPE)
                                .build()
                )
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }
    
    public GoogleUser getUserInfo(final String accessToken) throws ClientProtocolException, IOException {

        String link = OAuthConstants.GOOGLE_LINK_GET_USER_INFO + accessToken;

        String response = Request.Get(link).execute().returnContent().asString();

        GoogleUser googlePojo = new Gson().fromJson(response, GoogleUser.class);

        return googlePojo;

    }


}
