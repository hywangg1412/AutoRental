package Model.user;

import java.util.Date;

public class Admin extends Person {

    private Role role;

    public Admin() {
        this.role.setRoleName("ADMIN");
    }

    public Admin(String username, String password, String email, String phoneNumber, String firstName, String lastName, Date dob, boolean gender) {
        super(username, password, email, phoneNumber, firstName, lastName, dob, gender);
        this.role = role;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return super.toString() + "role=" + role + '}';
    }

}
