package Model.Constants;

public class RoleConstants {
    // Role names
    public static final String ADMIN = "Admin";
    public static final String STAFF = "Staff";
    public static final String USER = "User";

    // Role paths
    public static final String ADMIN_PATH = "/pages/admin/";
    public static final String STAFF_PATH = "/pages/staff/";
    public static final String API_ADMIN_PATH = "/api/admin/";
    public static final String API_STAFF_PATH = "/api/staff/";

    // Role hierarchy
    public static final String[] ADMIN_PERMISSIONS = {ADMIN, STAFF, USER};
    public static final String[] STAFF_PERMISSIONS = {STAFF, USER};
    public static final String[] USER_PERMISSIONS = {USER};
} 