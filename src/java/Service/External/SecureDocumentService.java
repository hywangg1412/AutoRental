package Service.External;

import java.io.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Map;
import java.util.UUID;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;
import java.security.SecureRandom;

public class SecureDocumentService {
    private final CloudinaryService cloudinaryService;
    private static final String HASH_ALGORITHM = "SHA-256";
    private static final String ENCRYPTION_ALGORITHM = "AES/CBC/PKCS5Padding";
    private static final String SECRET_KEY = "YourSecretKey123"; // 16, 24, or 32 bytes
    private static final String IV = "YourIVKey1234567"; // 16 bytes
    
    public SecureDocumentService() {
        this.cloudinaryService = new CloudinaryService();
    }
    
    /**
     * Upload bằng lái xe hoặc CCCD với bảo mật cao
     */
    public DocumentUploadResult uploadSecureDocument(byte[] fileBytes, String documentType, String userId) throws Exception {
        // 1. Validate file
        validateDocument(fileBytes, documentType);
        
        // 2. Generate unique filename
        String originalFileName = generateSecureFileName(documentType, userId);
        
        // 3. Calculate file hash BEFORE upload
        String fileHash = calculateFileHash(fileBytes);
        
        // 4. Encrypt file content (optional - for extra security)
        byte[] encryptedBytes = encryptFile(fileBytes);
        
        // 5. Upload to Cloudinary
        String folderName = getSecureFolderName(documentType);
        Map uploadResult = cloudinaryService.uploadFileToFolder(encryptedBytes, folderName, originalFileName);
        
        // 6. Get URL and metadata
        String documentUrl = (String) uploadResult.get("url");
        String publicId = (String) uploadResult.get("public_id");
        
        // 7. Create result object
        DocumentUploadResult result = new DocumentUploadResult();
        result.setDocumentUrl(documentUrl);
        result.setPublicId(publicId);
        result.setFileHash(fileHash);
        result.setFileName(originalFileName);
        result.setUploadDate(LocalDateTime.now());
        result.setDocumentType(documentType);
        result.setUserId(userId);
        result.setFileSize(fileBytes.length);
        
        return result;
    }
    
    /**
     * Validate document trước khi upload
     */
    private void validateDocument(byte[] fileBytes, String documentType) throws Exception {
        // Kiểm tra kích thước file (max 5MB cho CCCD, 10MB cho bằng lái)
        int maxSize = "CCCD".equals(documentType) ? 5 * 1024 * 1024 : 10 * 1024 * 1024;
        if (fileBytes.length > maxSize) {
            throw new IllegalArgumentException("File size exceeds maximum allowed size for " + documentType);
        }
        
        // Kiểm tra file signature (magic bytes) để đảm bảo là file ảnh hợp lệ
        if (!isValidImageFile(fileBytes)) {
            throw new IllegalArgumentException("Invalid image file format");
        }
    }
    
    /**
     * Kiểm tra file có phải là ảnh hợp lệ không
     */
    private boolean isValidImageFile(byte[] fileBytes) {
        if (fileBytes.length < 4) return false;
        
        // JPEG signature
        if (fileBytes[0] == (byte) 0xFF && fileBytes[1] == (byte) 0xD8 && fileBytes[2] == (byte) 0xFF) {
            return true;
        }
        
        // PNG signature
        if (fileBytes[0] == (byte) 0x89 && fileBytes[1] == (byte) 0x50 && 
            fileBytes[2] == (byte) 0x4E && fileBytes[3] == (byte) 0x47) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Tạo tên file bảo mật
     */
    private String generateSecureFileName(String documentType, String userId) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String randomId = UUID.randomUUID().toString().substring(0, 8);
        return String.format("%s_%s_%s_%s", documentType, userId, timestamp, randomId);
    }
    
    /**
     * Tính hash của file
     */
    private String calculateFileHash(byte[] fileBytes) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance(HASH_ALGORITHM);
        byte[] hashBytes = digest.digest(fileBytes);
        return Base64.getEncoder().encodeToString(hashBytes);
    }
    
    /**
     * Mã hóa file (optional)
     */
    private byte[] encryptFile(byte[] fileBytes) throws Exception {
        SecretKeySpec secretKey = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
        IvParameterSpec iv = new IvParameterSpec(IV.getBytes());
        
        Cipher cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, iv);
        
        return cipher.doFinal(fileBytes);
    }
    
    /**
     * Giải mã file (khi cần thiết)
     */
    public byte[] decryptFile(byte[] encryptedBytes) throws Exception {
        SecretKeySpec secretKey = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
        IvParameterSpec iv = new IvParameterSpec(IV.getBytes());
        
        Cipher cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, iv);
        
        return cipher.doFinal(encryptedBytes);
    }
    
    /**
     * Lấy tên folder bảo mật
     */
    private String getSecureFolderName(String documentType) {
        return "secure_documents/" + documentType.toLowerCase();
    }
    
    /**
     * Verify file integrity bằng cách so sánh hash
     */
    public boolean verifyFileIntegrity(byte[] fileBytes, String expectedHash) throws Exception {
        String actualHash = calculateFileHash(fileBytes);
        return actualHash.equals(expectedHash);
    }
    
    /**
     * Xóa document bảo mật
     */
    public boolean deleteSecureDocument(String publicId) throws Exception {
        return cloudinaryService.deleteImage(publicId) != null;
    }
    
    /**
     * Class để lưu kết quả upload
     */
    public static class DocumentUploadResult {
        private String documentUrl;
        private String publicId;
        private String fileHash;
        private String fileName;
        private LocalDateTime uploadDate;
        private String documentType;
        private String userId;
        private long fileSize;
        
        // Getters and Setters
        public String getDocumentUrl() { return documentUrl; }
        public void setDocumentUrl(String documentUrl) { this.documentUrl = documentUrl; }
        
        public String getPublicId() { return publicId; }
        public void setPublicId(String publicId) { this.publicId = publicId; }
        
        public String getFileHash() { return fileHash; }
        public void setFileHash(String fileHash) { this.fileHash = fileHash; }
        
        public String getFileName() { return fileName; }
        public void setFileName(String fileName) { this.fileName = fileName; }
        
        public LocalDateTime getUploadDate() { return uploadDate; }
        public void setUploadDate(LocalDateTime uploadDate) { this.uploadDate = uploadDate; }
        
        public String getDocumentType() { return documentType; }
        public void setDocumentType(String documentType) { this.documentType = documentType; }
        
        public String getUserId() { return userId; }
        public void setUserId(String userId) { this.userId = userId; }
        
        public long getFileSize() { return fileSize; }
        public void setFileSize(long fileSize) { this.fileSize = fileSize; }
    }
} 