package Repository.Interfaces.IUser;

import Model.Entity.User.CitizenIdCard;
import Repository.Interfaces.Repository;
import java.util.UUID;

public interface ICitizendIdCardRepository extends Repository<CitizenIdCard, UUID>{
    Model.Entity.User.CitizenIdCard findByUserId(java.util.UUID userId) throws java.sql.SQLException;
}
