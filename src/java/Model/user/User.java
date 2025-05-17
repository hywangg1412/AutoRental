package Model.user;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class User {
    private int userId;
    private String username;
    private String password;
    private String email;
    private String phoneNumber;
    private String firstName;
    private String lastName;
    private LocalDate dob;
    private boolean gender;
    private String driverLicenseNumber;
    private String driverLicenseImage;
    private String userAddress;
    private String role;
    private LocalDateTime createdDate;
    private String status;

    public User() {
        this.createdDate = LocalDateTime.now();
    }

    public User(int userId, String driverLicenseNumber, String driverLicenseImage, String userAddress,
            String username, String password, String email, String phoneNumber,
            String firstName, String lastName, LocalDate dob, boolean gender,
            String role, LocalDateTime createdDate, String status) {
        this.userId = userId;
        this.driverLicenseNumber = driverLicenseNumber;
        this.driverLicenseImage = driverLicenseImage;
        this.userAddress = userAddress;

        this.username = username;
        this.password = password;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.firstName = firstName;
        this.lastName = lastName;
        this.dob = dob;
        this.gender = gender;
        this.role = role;
        this.createdDate = createdDate;
        this.status = status;
    }

    public String getFullName() {
        return firstName + " " + lastName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public String getUserAddress() {
        return userAddress;
    }

    public void setUserAddress(String userAddress) {
        this.userAddress = userAddress;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
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
        return "User{"
                + "userId=" + userId
                + ", driverLicenseNumber='" + driverLicenseNumber + '\''
                + ", driverLicenseImage='" + driverLicenseImage + '\''
                + ", userAddress='" + userAddress + '\''
                + ", username='" + username + '\''
                + ", email='" + email + '\''
                + ", phoneNumber='" + phoneNumber + '\''
                + ", fullName='" + getFullName() + '\''
                + ", dob=" + dob
                + ", gender=" + gender
                + ", role='" + role + '\''
                + ", createdDate=" + createdDate
                + ", status='" + status + '\''
                + '}';
    }
}
