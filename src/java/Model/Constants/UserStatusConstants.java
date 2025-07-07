package Model.Constants;

public class UserStatusConstants {
    // User status constants
    public static final String ACTIVE = "Active";
    public static final String BANNED = "Banned";
    public static final String DELETED = "Deleted";
    public static final String INACTIVE = "Inactive";
    
    // Helper methods
    public static boolean isValidStatus(String status) {
        return ACTIVE.equals(status) || 
               BANNED.equals(status) || 
               DELETED.equals(status) ||
               INACTIVE.equals(status);
    }
} 