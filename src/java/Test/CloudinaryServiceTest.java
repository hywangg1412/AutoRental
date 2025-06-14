package Test;

import Service.CloudinaryService;
import Config.CloudinaryConfig;
import com.cloudinary.Cloudinary;
import java.io.File;
import java.util.Map;

public class CloudinaryServiceTest {
    public static void main(String[] args) {
        try {
            Cloudinary cloudinary = CloudinaryConfig.getInstance();
            
            CloudinaryService cloudinaryService = new CloudinaryService(cloudinary);

            File imageFile = new File("D:/My_shit/ava.jpg");
            Map uploadResult = cloudinaryService.uploadImage(imageFile);
            
            String imageUrl = cloudinaryService.getImageUrlAfterUpload(uploadResult);
            System.out.println("Image URL: " + imageUrl);

            Map folderUploadResult = cloudinaryService.uploadImageToFolder(imageFile, "test_folder");
            String folderImageUrl = cloudinaryService.getImageUrlAfterUpload(folderUploadResult);
            System.out.println("Folder Image URL: " + folderImageUrl);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
} 