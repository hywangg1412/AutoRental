package Model.user;

import java.util.Date;

public class Admin extends Person {

    public Admin() {
    }

    public Admin(String username, String password, String email, String phoneNumber, String firstName, String lastName, Date dob, boolean gender) {
        super(username, password, email, phoneNumber, firstName, lastName, dob, gender);
    }

    @Override
    public String toString() {
        return super.toString();
    }

}
