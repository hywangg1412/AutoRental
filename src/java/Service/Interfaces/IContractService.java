package Service.Interfaces;

import Model.Entity.Contract;
import java.util.List;
import java.util.UUID;

public interface IContractService extends Service<Contract> {
    List<Contract> getContractsByUser(UUID userId) throws Exception;
    List<Contract> getContractsByStatus(String status) throws Exception;
    Contract getContractByCode(String contractCode) throws Exception;
    boolean signContract(UUID contractId, String signatureData, String signatureImageUrl) throws Exception;
    String generateUniqueContractCode();
}
