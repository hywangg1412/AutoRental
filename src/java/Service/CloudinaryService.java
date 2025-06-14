package Service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.Map;

public class CloudinaryService {
    private final Cloudinary cloudinary;
    
    public CloudinaryService(Cloudinary cloudinary) {
        this.cloudinary = cloudinary;
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
}
