const GOOGLE_CONFIG = {
    clientId: '669490144407-kiueqs7v7sv1drt65s709fgs3l29rts6.apps.googleusercontent.com',
    redirectUri: 'http://localhost:8080/autorental/googleLogin',
    scope: 'email profile openid',
    responseType: 'code',
    approvalPrompt: 'force',
    
    apiVersion: 'v1',
    authEndpoint: 'https://accounts.google.com/o/oauth2/auth'
};