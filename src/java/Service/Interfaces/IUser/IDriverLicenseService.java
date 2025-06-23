package Service.Interfaces.IUser;

import Model.Entity.User.DriverLicense;
import Service.Interfaces.Service;
import Exception.EventException;
import java.util.UUID;

public interface IDriverLicenseService extends Service<DriverLicense>{
    /**
     * Creates a default driver license for a new user
     * @param userId The user ID
     * @return The created driver license
     * @throws EventException If creation fails
     */
    DriverLicense createDefaultForUser(UUID userId) throws EventException;
}
