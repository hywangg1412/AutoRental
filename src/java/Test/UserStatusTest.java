package Test;

import Model.Constants.UserStatusConstants;
import Model.Entity.User.User;

public class UserStatusTest {
    
    public static void main(String[] args) {
        System.out.println("Testing UserStatusConstants:");
        System.out.println("ACTIVE: " + UserStatusConstants.ACTIVE);
        System.out.println("BANNED: " + UserStatusConstants.BANNED);
        System.out.println("DELETED: " + UserStatusConstants.DELETED);
        
        System.out.println("\nTesting validation:");
        System.out.println("'Active' is valid: " + UserStatusConstants.isValidStatus("Active"));
        System.out.println("'Deactivated' is valid: " + UserStatusConstants.isValidStatus("Deactivated"));
        System.out.println("'Invalid' is valid: " + UserStatusConstants.isValidStatus("Invalid"));
        
        System.out.println("\nTesting User entity status methods:");
        User user = new User();
        
        user.setStatus(UserStatusConstants.ACTIVE);
        System.out.println("User is Active: " + user.isActive());
        System.out.println("User is Banned: " + user.isBanned());
        System.out.println("User is Deleted: " + user.isDeleted());
        
        System.out.println("\nAfter setting to Deactivated:");
        System.out.println("User is Active: " + user.isActive());
        System.out.println("User is Banned: " + user.isBanned());
        System.out.println("User is Deleted: " + user.isDeleted());
    }
} 