const GOOGLE_CONFIG = {
    clientId: '669490144407-kiueqs7v7sv1drt65s709fgs3l29rts6.apps.googleusercontent.com',
    clientSecret: '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',
    redirectUri: 'http://localhost:8080/autorental/googleLogin',
    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile',
    responseType: 'code',
    approvalPrompt: 'force',
    authEndpoint: 'https://accounts.google.com/o/oauth2/v2/auth',
    tokenEndpoint: 'https://oauth2.googleapis.com/token',
    userInfoEndpoint: 'https://www.googleapis.com/oauth2/v1/userinfo'
};

const FACEBOOK_CONFIG = {
    clientId: '1895974034498063',
    clientSecret: '9877a0693e89b9e5052f7fc85c526395',
    redirectUri: 'http://localhost:8080/autorental/facebookLogin',
    scope: 'email,public_profile',
    responseType: 'code',
    state: 'some_random_string',
    authEndpoint: 'https://www.facebook.com/v23.0/dialog/oauth'
};

const GOOGLE_REGISTER_CONFIG = {
    redirectUri: 'http://localhost:8080/autorental/googleRegister'
};

const FACEBOOK_REGISTER_CONFIG = {
    redirectUri: 'http://localhost:8080/autorental/facebookRegister'
};