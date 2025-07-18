
package Repository.Interfaces.IContract;

import Model.Entity.Contract.Contract;
import Repository.Interfaces.Repository;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface IContractRepository extends Repository<Contract, UUID>{
    
    List<Contract> getByUserId(UUID userId) throws SQLException;
    List<Contract> getByStatus(String status) throws SQLException;
    Contract getByContractCode(String contractCode) throws SQLException;
    boolean isContractCodeExists(String contractCode) throws SQLException;
}
