package Model.Entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

public class User {
    private UUID userId;
    private String username;
    private String passwordHash;
    private String email;
    private String phoneNumber;
    private String firstName;
    private String lastName;
    private LocalDate dob;
    private String gender;
    private String role;
    private String userAddress;
    private String driverLicenseNumber;
    private String driverLicenseImage;
    private LocalDateTime createdDate;
    private String status;

    public User() {
        // this.userId = UUID.randomUUID();
        // this.createdDate = LocalDateTime.now();
        // this.role = "User";
        // this.status = "Active";
    }

    public User(UUID userId, String username, String passwordHash, String email, String phoneNumber,
            String firstName, String lastName, LocalDate dob, String gender, String role,
            String userAddress, String driverLicenseNumber, String driverLicenseImage,
            LocalDateTime createdDate, String status) {
        this.userId = userId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.firstName = firstName;
        this.lastName = lastName;
        this.dob = dob;
        this.gender = gender;
        this.role = role;
        this.userAddress = userAddress;
        this.driverLicenseNumber = driverLicenseNumber;
        this.driverLicenseImage = driverLicenseImage;
        this.createdDate = createdDate;
        this.status = status;
    }

    public String getFullName() {
        return firstName + " " + lastName;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getUserAddress() {
        return userAddress;
    }

    public void setUserAddress(String userAddress) {
        this.userAddress = userAddress;
    }

    public String getDriverLicenseNumber() {
        return driverLicenseNumber;
    }

    public void setDriverLicenseNumber(String driverLicenseNumber) {
        this.driverLicenseNumber = driverLicenseNumber;
    }

    public String getDriverLicenseImage() {
        return driverLicenseImage;
    }

    public void setDriverLicenseImage(String driverLicenseImage) {
        this.driverLicenseImage = driverLicenseImage;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", fullName='" + getFullName() + '\'' +
                ", dob=" + dob +
                ", gender='" + gender + '\'' +
                ", role='" + role + '\'' +
                ", userAddress='" + userAddress + '\'' +
                ", driverLicenseNumber='" + driverLicenseNumber + '\'' +
                ", createdDate=" + createdDate +
                ", status='" + status + '\'' +
                '}';
    }
}
