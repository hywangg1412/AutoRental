package Model.Entity.OAuth;

import java.util.UUID;

public class UserLogins {
    private String loginProvider;
    private String providerKey;
    private String providerDisplayName;
    private UUID userId;

    public UserLogins() {
    }

    public UserLogins(String loginProvider, String providerKey, String providerDisplayName, UUID userId) {
        this.loginProvider = loginProvider;
        this.providerKey = providerKey;
        this.providerDisplayName = providerDisplayName;
        this.userId = userId;
    }

    public String getLoginProvider() {
        return loginProvider;
    }

    public void setLoginProvider(String loginProvider) {
        this.loginProvider = loginProvider;
    }

    public String getProviderKey() {
        return providerKey;
    }

    public void setProviderKey(String providerKey) {
        this.providerKey = providerKey;
    }

    public String getProviderDisplayName() {
        return providerDisplayName;
    }

    public void setProviderDisplayName(String providerDisplayName) {
        this.providerDisplayName = providerDisplayName;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "UserLogins{" +
                "loginProvider='" + loginProvider + '\'' +
                ", providerKey='" + providerKey + '\'' +
                ", providerDisplayName='" + providerDisplayName + '\'' +
                ", userId=" + userId +
                '}';
    }
}
