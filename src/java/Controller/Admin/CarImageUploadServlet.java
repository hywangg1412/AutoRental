package Controller.Admin;

import Model.Entity.Car.CarImage;
import Repository.Car.CarImageRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;


import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.UUID;
import java.util.stream.Collectors;

@WebServlet("/carImageUploadServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 5,       // 5MB per file
    maxRequestSize = 1024 * 1024 * 50    // 50MB total
)
public class CarImageUploadServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CarImageUploadServlet.class);
    private static final String UPLOAD_DIR = "Uploads/car-images";
    private static final int MAX_IMAGE_COUNT = 10;
    private static final CarImageRepository carImageRepository = new CarImageRepository();

    @Override
    public void init() throws ServletException {
        try {
            String realPath = getServletContext().getRealPath("");
            Files.createDirectories(Paths.get(realPath + UPLOAD_DIR));
        } catch (IOException e) {
            throw new ServletException("Failed to initialize upload directory", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized");
            return;
        }

        try {
            String carIdStr = request.getParameter("carId");
            if (carIdStr == null || carIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Car ID is required");
                return;
            }

            UUID carId = UUID.fromString(carIdStr);
            String action = request.getParameter("action");
            
            if ("delete".equals(action)) {
                handleDeleteImages(request, response, carId);
            } else {
                handleUploadImages(request, response, carId);
            }

        } catch (IllegalArgumentException e) {
            logger.error("Invalid car ID format: {}", e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid car ID format");
        } catch (Exception e) {
            logger.error("Error processing image upload: {}", e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing upload: " + e.getMessage());
        }
    }

    private void handleUploadImages(HttpServletRequest request, HttpServletResponse response, UUID carId) 
            throws IOException, SQLException, ServletException {
        
        var imageParts = request.getParts().stream()
            .filter(part -> "carImage".equals(part.getName()) && 
                           part.getContentType() != null && 
                           part.getContentType().startsWith("image/") &&
                           part.getHeader("Content-Disposition") != null && 
                           part.getHeader("Content-Disposition").contains("filename=") &&
                           part.getSize() > 0)
            .collect(Collectors.toList());

        if (imageParts.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No valid images found");
            return;
        }

        // Kiểm tra số lượng file
        if (imageParts.size() > MAX_IMAGE_COUNT) {
            logger.warn("Too many images uploaded: {} (max: {})", imageParts.size(), MAX_IMAGE_COUNT);
            imageParts = imageParts.subList(0, MAX_IMAGE_COUNT);
        }

        // Xóa ảnh cũ nếu có
        var existingImages = carImageRepository.findByCarId(carId);
        for (CarImage image : existingImages) {
            carImageRepository.delete(image.getImageId());
        }

        // Upload ảnh mới
        boolean isFirstImage = true;
        for (Part imagePart : imageParts) {
            String imageUrl = handleImageUpload(request, carId, imagePart);
            if (imageUrl != null) {
                carImageRepository.add(new CarImage(UUID.randomUUID(), carId, imageUrl, isFirstImage));
                isFirstImage = false;
            }
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": true, \"message\": \"Images uploaded successfully\"}");
    }

    private void handleDeleteImages(HttpServletRequest request, HttpServletResponse response, UUID carId) 
            throws SQLException, IOException {
        
        var existingImages = carImageRepository.findByCarId(carId);
        for (CarImage image : existingImages) {
            carImageRepository.delete(image.getImageId());
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": true, \"message\": \"Images deleted successfully\"}");
    }

    private String handleImageUpload(HttpServletRequest request, UUID carId, Part filePart) throws IOException {
        try {
            if (filePart == null || filePart.getSize() == 0) {
                logger.info("File part is null or empty");
                return null;
            }

            String contentDisposition = filePart.getHeader("Content-Disposition");
            if (contentDisposition == null || !contentDisposition.contains("filename=")) {
                logger.info("No filename in content disposition");
                return null;
            }

            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                logger.warn("Invalid content type: {}", contentType);
                return null;
            }

            long fileSize = filePart.getSize();
            if (fileSize > 5 * 1024 * 1024) { // 5MB limit
                logger.warn("File size too large: {} bytes", fileSize);
                return null;
            }

            String fileName = carId.toString() + "_" + System.currentTimeMillis() + "." + getFileExtension(filePart);
            String uploadPath = getServletContext().getRealPath("") + UPLOAD_DIR;
            String filePath = uploadPath + "/" + fileName;

            logger.info("Uploading file: {} to path: {}", fileName, filePath);

            Files.createDirectories(Paths.get(uploadPath));
            filePart.write(filePath);

            logger.info("File uploaded successfully: {}", fileName);
            return UPLOAD_DIR + "/" + fileName;
        } catch (Exception e) {
            logger.error("Error uploading file: {}", e.getMessage());
            throw new IOException("Failed to upload file: " + e.getMessage(), e);
        }
    }

    private String getFileExtension(Part part) {
        String contentDisposition = part.getHeader("Content-Disposition");
        if (contentDisposition != null) {
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                    int lastDotIndex = fileName.lastIndexOf(".");
                    return lastDotIndex > 0 ? fileName.substring(lastDotIndex + 1).toLowerCase() : "jpg";
                }
            }
        }
        return "jpg";
    }

    private boolean isAuthorized(HttpServletRequest request) {
        return request.getSession().getAttribute("user") != null &&
               ("Admin".equals(request.getSession().getAttribute("userRole")) || 
                "Staff".equals(request.getSession().getAttribute("userRole")));
    }
} 