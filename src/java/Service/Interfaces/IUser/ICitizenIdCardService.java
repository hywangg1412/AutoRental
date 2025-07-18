package Service.Interfaces.IUser;

import Exception.NotFoundException;
import Model.Entity.User.CitizenIdCard;
import Service.Interfaces.Service;

public interface ICitizenIdCardService extends Service<CitizenIdCard>{
    CitizenIdCard findByUserId(java.util.UUID userId) throws NotFoundException;
}
