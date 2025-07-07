package Model.Entity.User;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

public class DriverLicense {
    private UUID licenseId;
    private UUID userId;
    private String licenseNumber;
    private String fullName;
    private LocalDate dob;
    private String licenseImage;
    private LocalDateTime createdDate;

    public DriverLicense() {}

    public DriverLicense(UUID licenseId, UUID userId, String licenseNumber, String fullName, LocalDate dob, String licenseImage, LocalDateTime createdDate) {
        this.licenseId = licenseId;
        this.userId = userId;
        this.licenseNumber = licenseNumber;
        this.fullName = fullName;
        this.dob = dob;
        this.licenseImage = licenseImage;
        this.createdDate = createdDate;
    }

    public UUID getLicenseId() {
        return licenseId;
    }

    public void setLicenseId(UUID licenseId) {
        this.licenseId = licenseId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getLicenseImage() {
        return licenseImage;
    }

    public void setLicenseImage(String licenseImage) {
        this.licenseImage = licenseImage;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "DriverLicense{" +
                "licenseId=" + licenseId +
                ", userId=" + userId +
                ", licenseNumber='" + licenseNumber + '\'' +
                ", fullName='" + fullName + '\'' +
                ", dob=" + dob +
                ", licenseImage='" + licenseImage + '\'' +
                ", createdDate=" + createdDate +
                '}';
    }
}
