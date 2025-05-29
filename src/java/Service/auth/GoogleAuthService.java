package Service.auth;

import Constant.OAuthConstants;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.User;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.oauth2.Oauth2;
import com.google.api.services.oauth2.model.Userinfo;

import java.io.IOException;
import java.util.Arrays;


public class GoogleAuthService extends OAuthConstants{

    private GoogleAuthorizationCodeFlow flow;
    
    public GoogleAuthService(){
        try {
            flow = new GoogleAuthorizationCodeFlow.Builder(
            new NetHttpTransport(),
            GsonFactory.getDefaultInstance(),
                    GOOGLE_CLIENT_ID,
                    GOOGLE_CLIENT_SECRET, 
                    Arrays.asList(OAuthConstants.GOOGLE_EMAIL_SCOPE, OAuthConstants.GOOGLE_PROFILE_SCOPE))
                    .setAccessType("offline")
                    .build();
        } catch (Exception e){
            throw new RuntimeException("Failed to initialize Google Auth Service - " + e.toString());
        }
    }
    
    public String getAuthorizationUrl() {
        return flow.newAuthorizationUrl()
            .setRedirectUri(GOOGLE_REDIRECT_URI)
            .build();
    }
    
    public GoogleUser getUserInfo(String code) throws IOException {
        TokenResponse tokenResponse = flow.newTokenRequest(code)
            .setRedirectUri(OAuthConstants.GOOGLE_REDIRECT_URI)
            .execute();
            
        GoogleCredential credential = new GoogleCredential()
            .setAccessToken(tokenResponse.getAccessToken());
            
        Oauth2 oauth2 = new Oauth2.Builder(
            new NetHttpTransport(),
            GsonFactory.getDefaultInstance(),
            credential)
            .build();
            
        Userinfo userInfo = oauth2.userinfo().get().execute();
        
        return new GoogleUser(
            userInfo.getId(),
            userInfo.getEmail(),
            userInfo.getName(),
            userInfo.getPicture()
        );
    }
}
