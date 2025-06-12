package Model.Entity.Role;

import java.util.UUID;

public class Role {
    private UUID roleId;
    private String roleName;
    private String normalizedName;

    public Role() {
    }

    public Role(UUID roleId, String roleName, String normalizedName) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.normalizedName = normalizedName;
    }

    public UUID getRoleId() {
        return roleId;
    }

    public void setRoleId(UUID roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getNormalizedName() {
        return normalizedName;
    }

    public void setNormalizedName(String normalizedName) {
        this.normalizedName = normalizedName;
    }

    @Override
    public String toString() {
        return "Role{" + "roleId=" + roleId + ", roleName=" + roleName + ", normalizedName=" + normalizedName + '}';
    }
    
}
