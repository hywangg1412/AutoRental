package Service.Contract;

import Model.Entity.Contract.Contract;
import Repository.Contract.ContractRepository;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ContractService {
    private static final Logger LOGGER = Logger.getLogger(ContractService.class.getName());
    private final ContractRepository contractRepository = new ContractRepository();

    public Contract add(Contract contract) {
        try {
            return contractRepository.add(contract);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding contract", e);
            return null;
        }
    }

    public boolean update(Contract contract) {
        try {
            return contractRepository.update(contract);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating contract", e);
            return false;
        }
    }

    public boolean delete(UUID contractId) {
        try {
            return contractRepository.delete(contractId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting contract", e);
            return false;
        }
    }

    public Contract findById(UUID contractId) {
        try {
            return contractRepository.findById(contractId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding contract by id", e);
            return null;
        }
    }

    public String generateUniqueContractCode() {
        // Tạo mã hợp đồng theo logic của bạn, ví dụ: "HD" + timestamp hoặc UUID rút gọn
        return "HD" + System.currentTimeMillis();
    }
}
