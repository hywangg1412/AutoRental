package Model.user;

import java.util.Date;

public class User extends Person{
    private int userId;
    private String driverLicense;
    private Role role;

    public User() {
         this.role.setRoleName("CUSTOMER");
    }

    public User(int userId, String driverLicense, Role role) {
        this.userId = userId;
        this.driverLicense = driverLicense;
        this.role = role;
    }

    public User(int userId, String driverLicense, Role role, String username, String password, String email, String phoneNumber, String firstName, String lastName, Date dob, boolean gender) {
        super(username, password, email, phoneNumber, firstName, lastName, dob, gender);
        this.userId = userId;
        this.driverLicense = driverLicense;
        this.role = role;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getDriverLicense() {
        return driverLicense;
    }

    public void setDriverLicense(String driverLicense) {
        this.driverLicense = driverLicense;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return super.toString() + "userId=" + userId + ", driverLicense=" + driverLicense + ", role=" + role + '}';
    }
}
