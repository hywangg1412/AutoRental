package Repository;

import Config.DBContext;
import Model.Entity.Contract;
import Repository.Interfaces.IContractRepository;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ContractRepository implements IContractRepository {
    private static final Logger LOGGER = Logger.getLogger(ContractRepository.class.getName());
    private final DBContext dbContext;
    
    public ContractRepository() {
        this.dbContext = new DBContext();
    }

    @Override
    public Contract add(Contract entity) throws SQLException {
        String sql = "INSERT INTO Contract (ContractId, ContractCode, UserId, BookingId, StaffId, " +
                    "CreatedDate, SignedDate, CompletedDate, Status, TermsAccepted, TermsAcceptedDate, " +
                    "ContractPDFUrl, SignatureData, SignatureImageUrl, SignatureMethod, Notes, CancellationReason) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, entity.getContractId());
            ps.setString(2, entity.getContractCode());
            ps.setObject(3, entity.getUserId());
            ps.setObject(4, entity.getBookingId());
            ps.setObject(5, entity.getStaffId());
            ps.setObject(6, entity.getCreatedDate());
            ps.setObject(7, entity.getSignedDate());
            ps.setObject(8, entity.getCompletedDate());
            ps.setString(9, entity.getStatus());
            ps.setBoolean(10, entity.isTermsAccepted());
            ps.setObject(11, entity.getTermsAcceptedDate());
            ps.setString(12, entity.getContractPDFUrl());
            ps.setString(13, entity.getSignatureData());
            ps.setString(14, entity.getSignatureImageUrl());
            ps.setString(15, entity.getSignatureMethod());
            ps.setString(16, entity.getNotes());
            ps.setString(17, entity.getCancellationReason());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                return entity;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding contract", e);
            throw e;
        }
        return null;
    }

    @Override
    public Contract findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE ContractId = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToContract(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding contract by ID: " + id, e);
            throw e;
        }
        return null;
    }

    @Override
    public boolean update(Contract entity) throws SQLException {
        String sql = "UPDATE Contract SET ContractCode = ?, UserId = ?, BookingId = ?, StaffId = ?, " +
                    "CreatedDate = ?, SignedDate = ?, CompletedDate = ?, Status = ?, TermsAccepted = ?, " +
                    "TermsAcceptedDate = ?, ContractPDFUrl = ?, SignatureData = ?, SignatureImageUrl = ?, " +
                    "SignatureMethod = ?, Notes = ?, CancellationReason = ? WHERE ContractId = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, entity.getContractCode());
            ps.setObject(2, entity.getUserId());
            ps.setObject(3, entity.getBookingId());
            ps.setObject(4, entity.getStaffId());
            ps.setObject(5, entity.getCreatedDate());
            ps.setObject(6, entity.getSignedDate());
            ps.setObject(7, entity.getCompletedDate());
            ps.setString(8, entity.getStatus());
            ps.setBoolean(9, entity.isTermsAccepted());
            ps.setObject(10, entity.getTermsAcceptedDate());
            ps.setString(11, entity.getContractPDFUrl());
            ps.setString(12, entity.getSignatureData());
            ps.setString(13, entity.getSignatureImageUrl());
            ps.setString(14, entity.getSignatureMethod());
            ps.setString(15, entity.getNotes());
            ps.setString(16, entity.getCancellationReason());
            ps.setObject(17, entity.getContractId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating contract: " + entity.getContractId(), e);
            throw e;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM Contract WHERE ContractId = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, id);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting contract: " + id, e);
            throw e;
        }
    }

    @Override
    public List<Contract> findAll() throws SQLException {
        String sql = "SELECT * FROM Contract ORDER BY CreatedDate DESC";
        List<Contract> contracts = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                contracts.add(mapResultSetToContract(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all contracts", e);
            throw e;
        }
        return contracts;
    }

    @Override
    public List<Contract> getByUserId(UUID userId) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE UserId = ? ORDER BY CreatedDate DESC";
        List<Contract> contracts = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    contracts.add(mapResultSetToContract(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding contracts by user ID: " + userId, e);
            throw e;
        }
        return contracts;
    }

    @Override
    public List<Contract> getByStatus(String status) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE Status = ? ORDER BY CreatedDate DESC";
        List<Contract> contracts = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    contracts.add(mapResultSetToContract(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding contracts by status: " + status, e);
            throw e;
        }
        return contracts;
    }

    @Override
    public Contract getByContractCode(String contractCode) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE ContractCode = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, contractCode);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToContract(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding contract by code: " + contractCode, e);
            throw e;
        }
        return null;
    }

    @Override
    public boolean isContractCodeExists(String contractCode) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Contract WHERE ContractCode = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, contractCode);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking contract code existence: " + contractCode, e);
            throw e;
        }
        return false;
    }

    // Helper method to map ResultSet to Contract object
    private Contract mapResultSetToContract(ResultSet rs) throws SQLException {
        Contract contract = new Contract();
        
        contract.setContractId(UUID.fromString(rs.getString("ContractId")));
        contract.setContractCode(rs.getString("ContractCode"));
        contract.setUserId(UUID.fromString(rs.getString("UserId")));
        contract.setBookingId(UUID.fromString(rs.getString("BookingId")));
        contract.setStaffId(UUID.fromString(rs.getString("StaffId")));
        contract.setCreatedDate(rs.getObject("CreatedDate", LocalDateTime.class));
        contract.setSignedDate(rs.getObject("SignedDate", LocalDateTime.class));
        contract.setCompletedDate(rs.getObject("CompletedDate", LocalDateTime.class));
        contract.setStatus(rs.getString("Status"));
        contract.setTermsAccepted(rs.getBoolean("TermsAccepted"));
        contract.setTermsAcceptedDate(rs.getObject("TermsAcceptedDate", LocalDateTime.class));
        contract.setContractPDFUrl(rs.getString("ContractPDFUrl"));
        contract.setSignatureData(rs.getString("SignatureData"));
        contract.setSignatureImageUrl(rs.getString("SignatureImageUrl"));
        contract.setSignatureMethod(rs.getString("SignatureMethod"));
        contract.setNotes(rs.getString("Notes"));
        contract.setCancellationReason(rs.getString("CancellationReason"));
        
        return contract;
    }
}
