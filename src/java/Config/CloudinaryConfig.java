package Config;

import com.cloudinary.Cloudinary;
import com.google.common.collect.HashBiMap;
import io.github.cdimascio.dotenv.Dotenv;
import io.github.cdimascio.dotenv.DotenvException;
import java.util.HashMap;
import java.util.Map;

public class CloudinaryConfig {

    private static Cloudinary cloudinary;
    private static Dotenv dotenv;

    static {
        try {
            dotenv = Dotenv.load();
        } catch (DotenvException e) {
            System.err.println("Error while loading .env file - " + e.getMessage());
            throw new RuntimeException("Failed to load .env file");
        }
    }

    public static Cloudinary getInstance() {
        if (cloudinary == null) {
            try {
                Map<String, String> config = new HashMap<>();
                String cloudName = dotenv.get("CLOUDINARY_CLOUD_NAME");
                String apiKey = dotenv.get("CLOUDINARY_API_KEY");
                String apiSecret = dotenv.get("CLOUDINARY_API_SECRET");

                if (cloudName == null || apiKey == null || apiSecret == null) {
                    throw new RuntimeException("Missing cloudinary component in .env file");
                }
                config.put("cloud_name", cloudName);
                config.put("api_key", apiKey);
                config.put("api_secret", apiSecret);
                cloudinary = new Cloudinary(config);
            } catch (Exception e) {
                System.err.println("Error initializing Cloudinary - " + e.getMessage());
                throw new RuntimeException("Failed to initialize Cloudinary");
            }
        }
        return cloudinary;
    }
}
