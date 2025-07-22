package Service.Interfaces.IContract;

import Model.Entity.Contract.Contract;
import Service.Interfaces.Service;
import java.util.List;
import java.util.UUID;

public interface IContractService extends Service<Contract> {
    List<Contract> getContractsByUser(UUID userId) throws Exception;
    List<Contract> getContractsByStatus(String status) throws Exception;
    Contract getContractByCode(String contractCode) throws Exception;
    boolean signContract(UUID contractId, String signatureData, String termsVersion, String termsFileUrl) throws Exception;
    boolean completeContract(UUID contractId) throws Exception;
    boolean cancelContract(UUID contractId, String reason) throws Exception;
    String generateUniqueContractCode();
}
