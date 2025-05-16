package Model.user;

import java.util.Date;

public class User extends Person{
    private int userId;
    private String driverLicense;

    public User() {
    }

    public User(int userId, String driverLicense, String username, String password, String email, String phoneNumber, String firstName, String lastName, Date dob, boolean gender) {
        super(username, password, email, phoneNumber, firstName, lastName, dob, gender);
        this.userId = userId;
        this.driverLicense = driverLicense;
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

    @Override
    public String toString() {
        return super.toString() + "userId=" + userId + ", driverLicense=" + driverLicense + '}';
    }
}
