package Utils;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.google.auth.oauth2.GoogleCredentials;
import java.io.FileInputStream;
import java.io.IOException;

public class FirebaseUtil {
    private static boolean initialized = false;

    public static void initFirebase() throws IOException {
        if (!initialized) {
            FileInputStream serviceAccount = new FileInputStream("/path/to/serviceAccountKey.json"); // TODO: chỉnh lại path
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();
            FirebaseApp.initializeApp(options);
            initialized = true;
        }
    }

    public static FirebaseToken verifyIdToken(String idToken) throws Exception {
        initFirebase();
        return FirebaseAuth.getInstance().verifyIdToken(idToken);
    }
} 