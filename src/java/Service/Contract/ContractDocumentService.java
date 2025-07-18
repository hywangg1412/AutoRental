package Service.Contract;

import Model.Entity.Contract.ContractDocument;
import Repository.Contract.ContractDocumentRepository;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ContractDocumentService {
    private static final Logger LOGGER = Logger.getLogger(ContractDocumentService.class.getName());
    private final ContractDocumentRepository contractDocumentRepository = new ContractDocumentRepository();

    public ContractDocument add(ContractDocument document) {
        try {
            return contractDocumentRepository.add(document);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding contract document", e);
            return null;
        }
    }

    public boolean update(ContractDocument document) {
        try {
            return contractDocumentRepository.update(document);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating contract document", e);
            return false;
        }
    }

    public boolean delete(UUID documentId) {
        try {
            return contractDocumentRepository.delete(documentId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting contract document", e);
            return false;
        }
    }

    public ContractDocument findById(UUID documentId) {
        try {
            return contractDocumentRepository.findById(documentId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding contract document by id", e);
            return null;
        }
    }

    public ContractDocument findByContractId(UUID contractId) {
        try {
            return contractDocumentRepository.findByContractId(contractId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding contract document by contractId", e);
            return null;
        }
    }

    public List<ContractDocument> findAll() {
        try {
            return contractDocumentRepository.findAll();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all contract documents", e);
            return null;
        }
    }
}
