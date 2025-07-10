package Service;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Contract;
import Model.Constants.ContractStatusConstants;
import Repository.ContractRepository;
import Service.Interfaces.IContractService;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ContractService implements IContractService {
    private static final Logger LOGGER = Logger.getLogger(ContractService.class.getName());
    private final ContractRepository contractRepository;
    
    public ContractService() {
        this.contractRepository = new ContractRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<Contract> contracts = contractRepository.findAll();
            if (contracts.isEmpty()) {
                throw new EmptyDataException("No contracts found in the system");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error displaying contracts", e);
            throw new EventException("Error displaying contract list");
        }
    }

    @Override
    public Contract add(Contract entry) throws EventException, InvalidDataException {
        try {
            if (entry.getContractCode() == null || entry.getContractCode().trim().isEmpty()) {
                entry.setContractCode(generateUniqueContractCode());
            }
            
            if (entry.getCreatedDate() == null) {
                entry.setCreatedDate(LocalDateTime.now());
            }
            if (entry.getStatus() == null) {
                entry.setStatus(ContractStatusConstants.PENDING);
            }
            
            Contract addedContract = contractRepository.add(entry);
            if (addedContract == null) {
                throw new EventException("Cannot create contract");
            }
            
            return addedContract;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding contract", e);
            throw new EventException("Error creating contract: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            Contract existingContract = contractRepository.findById(id);
            if (existingContract == null) {
                throw new NotFoundException("Contract not found");
            }
            
            if (ContractStatusConstants.SIGNED.equals(existingContract.getStatus()) || 
                ContractStatusConstants.COMPLETED.equals(existingContract.getStatus())) {
                throw new EventException("Cannot delete signed or completed contract");
            }
            
            return contractRepository.delete(id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting contract: " + id, e);
            throw new EventException("Error deleting contract: " + e.getMessage());
        }
    }

    @Override
    public boolean update(Contract entry) throws EventException, NotFoundException {
        try {
            Contract existingContract = contractRepository.findById(entry.getContractId());
            if (existingContract == null) {
                throw new NotFoundException("Contract not found");
            }
            
            return contractRepository.update(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating contract: " + entry.getContractId(), e);
            throw new EventException("Error updating contract: " + e.getMessage());
        }
    }

    @Override
    public Contract findById(UUID id) throws NotFoundException {
        try {
            Contract contract = contractRepository.findById(id);
            if (contract == null) {
                throw new NotFoundException("Contract not found");
            }
            return contract;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding contract by ID: " + id, e);
            try {
                throw new EventException("Error finding contract: " + e.getMessage());
            } catch (EventException ex) {
                Logger.getLogger(ContractService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return null;
    }

    @Override
    public List<Contract> getContractsByUser(UUID userId) throws Exception {
        try {
            return contractRepository.getByUserId(userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting contracts by user: " + userId, e);
            throw new EventException("Error getting user contracts: " + e.getMessage());
        }
    }

    @Override
    public List<Contract> getContractsByStatus(String status) throws Exception {
        try {
            return contractRepository.getByStatus(status);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting contracts by status: " + status, e);
            throw new EventException("Error getting contracts by status: " + e.getMessage());
        }
    }

    @Override
    public Contract getContractByCode(String contractCode) throws Exception {
        try {
            Contract contract = contractRepository.getByContractCode(contractCode);
            if (contract == null) {
                throw new NotFoundException("Contract with code " + contractCode + " not found");
            }
            return contract;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting contract by code: " + contractCode, e);
            throw new EventException("Error finding contract by code: " + e.getMessage());
        }
    }

    @Override
    public boolean signContract(UUID contractId, String signatureData, String signatureImageUrl) throws Exception {
        try {
            Contract contract = findById(contractId);
            
            if (!ContractStatusConstants.PENDING.equals(contract.getStatus())) {
                throw new EventException("Contract cannot be signed in current status");
            }
            
            contract.setSignedDate(LocalDateTime.now());
            contract.setStatus(ContractStatusConstants.SIGNED);
            contract.setSignatureData(signatureData);
            contract.setSignatureImageUrl(signatureImageUrl);
            contract.setSignatureMethod("CANVAS");
            contract.setTermsAccepted(true);
            contract.setTermsAcceptedDate(LocalDateTime.now());
            
            return update(contract);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error signing contract: " + contractId, e);
            throw new EventException("Error signing contract: " + e.getMessage());
        }
    }

    @Override
    public String generateUniqueContractCode() {
        String prefix = "CTR";
        String timestamp = String.valueOf(System.currentTimeMillis());
        String random = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        String contractCode = prefix + timestamp + random;
        
        try {
            while (contractRepository.isContractCodeExists(contractCode)) {
                random = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                contractCode = prefix + timestamp + random;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error checking contract code uniqueness", e);
        }
        
        return contractCode;
    }


}
