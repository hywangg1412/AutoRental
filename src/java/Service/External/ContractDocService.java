package Service.External;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletResponseWrapper;
import org.xhtmlrenderer.pdf.ITextRenderer;
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
import com.lowagie.text.pdf.BaseFont;

public class ContractDocService {
    private final CloudinaryService cloudinaryService;
    private static final String HASH_ALGORITHM = "SHA-256";
    private static final String ENCRYPTION_ALGORITHM = "AES/CBC/PKCS5Padding";
    private static final String SECRET_KEY = "YourSecretKey123"; // 16, 24, or 32 bytes
    private static final String IV = "YourIVKey1234567"; // 16 bytes

    public ContractDocService() {
        this.cloudinaryService = new CloudinaryService();
    }

    // --- Render JSP -> HTML ---
    public String renderContractJspToHtml(HttpServletRequest request, HttpServletResponse response, String bookingId) throws Exception {
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("isPdfExport", true); // Đảm bảo luôn set true khi render cho PDF
        StringWriter stringWriter = new StringWriter();
        HttpServletResponseWrapper responseWrapper = new HttpServletResponseWrapper(response) {
            private PrintWriter writer = new PrintWriter(stringWriter);
            @Override
            public PrintWriter getWriter() { return writer; }
        };
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/contract/contract-template.jsp");
        dispatcher.include(request, responseWrapper);
        return stringWriter.toString();
    }

    // --- HTML -> PDF ---
    public byte[] htmlToPdf(String html, String fontAbsolutePath) throws Exception {
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        ITextRenderer renderer = new ITextRenderer();
        // Ưu tiên nhúng font BeVietnam Pro nếu có
        String beVietnamFontPath = new java.io.File("web/assets/fonts/be_vietnam/BeVietnamPro-Regular.ttf").getAbsolutePath();
        java.io.File beVietnamFontFile = new java.io.File(beVietnamFontPath);
        if (beVietnamFontFile.exists()) {
            renderer.getFontResolver().addFont(beVietnamFontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        } else if (fontAbsolutePath != null && !fontAbsolutePath.isEmpty()) {
            renderer.getFontResolver().addFont(fontAbsolutePath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        }
        renderer.setDocumentFromString(html);
        renderer.layout();
        renderer.createPDF(os);
        return os.toByteArray();
    }

    public DocumentUploadResult uploadSecureDocument(byte[] fileBytes, String documentType, String userId) throws Exception {
        validateDocument(fileBytes, documentType);
        String originalFileName = generateSecureFileName(documentType, userId) + ".pdf";
        String fileHash = calculateFileHash(fileBytes);
        String folderName = getSecureFolderName(documentType);
        Map uploadResult = cloudinaryService.uploadFileToFolder(fileBytes, folderName, originalFileName);
        String documentUrl = (String) uploadResult.get("url");
        String publicId = (String) uploadResult.get("public_id");
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

    // --- Validate file ---
    private void validateDocument(byte[] fileBytes, String documentType) throws Exception {
        int maxSize = "CCCD".equals(documentType) ? 5 * 1024 * 1024 : 10 * 1024 * 1024;
        if (fileBytes.length > maxSize) {
            throw new IllegalArgumentException("File size exceeds maximum allowed size for " + documentType);
        }
        if (!isValidImageFile(fileBytes) && !"CONTRACT_PDF".equals(documentType)) {
            throw new IllegalArgumentException("Invalid image file format");
        }
    }

    private boolean isValidImageFile(byte[] fileBytes) {
        if (fileBytes.length < 4) return false;
        if (fileBytes[0] == (byte) 0xFF && fileBytes[1] == (byte) 0xD8 && fileBytes[2] == (byte) 0xFF) return true;
        if (fileBytes[0] == (byte) 0x89 && fileBytes[1] == (byte) 0x50 && fileBytes[2] == (byte) 0x4E && fileBytes[3] == (byte) 0x47) return true;
        return false;
    }

    private String generateSecureFileName(String documentType, String userId) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String randomId = UUID.randomUUID().toString().substring(0, 8);
        return String.format("%s_%s_%s_%s", documentType, userId, timestamp, randomId);
    }

    private String calculateFileHash(byte[] fileBytes) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance(HASH_ALGORITHM);
        byte[] hashBytes = digest.digest(fileBytes);
        return Base64.getEncoder().encodeToString(hashBytes);
    }

    private byte[] encryptFile(byte[] fileBytes) throws Exception {
        SecretKeySpec secretKey = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
        IvParameterSpec iv = new IvParameterSpec(IV.getBytes());
        Cipher cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, iv);
        return cipher.doFinal(fileBytes);
    }

    public byte[] decryptFile(byte[] encryptedBytes) throws Exception {
        SecretKeySpec secretKey = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
        IvParameterSpec iv = new IvParameterSpec(IV.getBytes());
        Cipher cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, iv);
        return cipher.doFinal(encryptedBytes);
    }

    private String getSecureFolderName(String documentType) {
        return "secure_documents/" + documentType.toLowerCase();
    }

    public boolean verifyFileIntegrity(byte[] fileBytes, String expectedHash) throws Exception {
        String actualHash = calculateFileHash(fileBytes);
        return actualHash.equals(expectedHash);
    }

    public boolean deleteSecureDocument(String publicId) throws Exception {
        return cloudinaryService.deleteImage(publicId) != null;
    }

    public static class DocumentUploadResult {
        private String documentUrl;
        private String publicId;
        private String fileHash;
        private String fileName;
        private LocalDateTime uploadDate;
        private String documentType;
        private String userId;
        private long fileSize;
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