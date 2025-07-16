package Service.External;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.Map;
import io.github.cdimascio.dotenv.Dotenv;
import java.util.HashMap;
import Config.CloudinaryConfig;
import java.io.ByteArrayOutputStream;

public class CloudinaryService {
    private final Cloudinary cloudinary;
    
    public CloudinaryService() {
        this.cloudinary = CloudinaryConfig.getInstance();
    }
    
    public String getImageUrlAfterUpload(Map uploadResult) {
        return (String) uploadResult.get("url");
    }

    public Map uploadImage(File file) throws IOException {
        return cloudinary.uploader().upload(file, Collections.emptyMap());
    }
    
    public Map uploadImage(byte[] fileBytes) throws IOException {
        return cloudinary.uploader().upload(fileBytes, Collections.emptyMap());
    }
    
    public Map deleteImage(String publicId) throws IOException {
        return cloudinary.uploader().destroy(publicId, Collections.emptyMap());
    }
    
    public Map getImageInfo(String publicId) throws IOException, Exception {
        return cloudinary.api().resource(publicId, Collections.emptyMap());
    }
    
    public String getImageUrl(String publicId) {
        return cloudinary.url().generate(publicId);
    }
    
    public Map uploadImageToFolder(File file, String folderName) throws IOException {
        return cloudinary.uploader().upload(file, ObjectUtils.asMap("folder", folderName));
    }
    
    public Map uploadImageToFolder(byte[] fileBytes, String folderName) throws IOException {
        return cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap("folder", folderName));
    }

    public String uploadAndGetUrl(InputStream inputStream, String publicId) throws IOException {
        byte[] bytes = toByteArray(inputStream);
        Map uploadResult = cloudinary.uploader().upload(bytes, ObjectUtils.asMap("public_id", publicId));
        return getImageUrlAfterUpload(uploadResult);
    }

    public String uploadAndGetUrlToFolder(InputStream inputStream, String folderName, String publicId) throws IOException {
        byte[] bytes = toByteArray(inputStream);
        Map uploadResult = cloudinary.uploader().upload(bytes, ObjectUtils.asMap("folder", folderName, "public_id", publicId));
        return getImageUrlAfterUpload(uploadResult);
    }

    public Map uploadFileToFolder(byte[] fileBytes, String folderName, String fileName) throws IOException {
        Map options = ObjectUtils.asMap(
            "folder", folderName,
            "resource_type", "raw",
            "public_id", fileName
        );
        return cloudinary.uploader().upload(fileBytes, options);
    }

    private static byte[] toByteArray(InputStream in) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[16384];
        while ((nRead = in.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        buffer.flush();
        return buffer.toByteArray();
    }
}
