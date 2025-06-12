package Model.Entity.Role;

import java.util.UUID;

public class UserRole {
    private UUID userId;
    private UUID roleId;

    public UserRole() {
    }

    public UserRole(UUID userId, UUID roleId) {
        this.userId = userId;
        this.roleId = roleId;
    }
 
    
    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getRoleId() {
        return roleId;
    }

    public void setRoleId(UUID roleId) {
        this.roleId = roleId;
    }

    @Override
    public String toString() {
        return "UserRole{" + "userId=" + userId + ", roleId=" + roleId + '}';
    }
    
}
