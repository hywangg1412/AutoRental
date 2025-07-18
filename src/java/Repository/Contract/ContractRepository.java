package Repository.Contract;

import Config.DBContext;
import Model.Entity.Contract.Contract;
import Repository.Interfaces.IContract.IContractRepository;
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
        String sql = "INSERT INTO Contract (ContractId, ContractCode, UserId, BookingId, CreatedDate, SignedDate, CompletedDate, Status, TermsAccepted, SignatureData, SignatureMethod, ContractPdfUrl, ContractFileType, Notes, CancellationReason) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getContractId());
            ps.setString(2, entity.getContractCode());
            ps.setObject(3, entity.getUserId());
            ps.setObject(4, entity.getBookingId());
            ps.setObject(5, entity.getCreatedDate());
            ps.setObject(6, entity.getSignedDate());
            ps.setObject(7, entity.getCompletedDate());
            ps.setString(8, entity.getStatus());
            ps.setBoolean(9, entity.isTermsAccepted());
            ps.setString(10, entity.getSignatureData());
            ps.setString(11, entity.getSignatureMethod());
            ps.setString(12, entity.getContractPdfUrl());
            ps.setString(13, entity.getContractFileType());
            ps.setString(14, entity.getNotes());
            ps.setString(15, entity.getCancellationReason());
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
        String sql = "UPDATE Contract SET ContractCode = ?, UserId = ?, BookingId = ?, CreatedDate = ?, SignedDate = ?, CompletedDate = ?, Status = ?, TermsAccepted = ?, SignatureData = ?, SignatureMethod = ?, ContractPdfUrl = ?, ContractFileType = ?, Notes = ?, CancellationReason = ? WHERE ContractId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getContractCode());
            ps.setObject(2, entity.getUserId());
            ps.setObject(3, entity.getBookingId());
            ps.setObject(4, entity.getCreatedDate());
            ps.setObject(5, entity.getSignedDate());
            ps.setObject(6, entity.getCompletedDate());
            ps.setString(7, entity.getStatus());
            ps.setBoolean(8, entity.isTermsAccepted());
            ps.setString(9, entity.getSignatureData());
            ps.setString(10, entity.getSignatureMethod());
            ps.setString(11, entity.getContractPdfUrl());
            ps.setString(12, entity.getContractFileType());
            ps.setString(13, entity.getNotes());
            ps.setString(14, entity.getCancellationReason());
            ps.setObject(15, entity.getContractId());
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

    // Thêm các method còn thiếu
    public List<Contract> findAll() throws SQLException {
        String sql = "SELECT * FROM Contract";
        List<Contract> list = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToContract(rs));
            }
        }
        return list;
    }

    public List<Contract> findByUserId(UUID userId) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE UserId = ?";
        List<Contract> list = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToContract(rs));
                }
            }
        }
        return list;
    }

    public List<Contract> findByBookingId(UUID bookingId) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE BookingId = ?";
        List<Contract> list = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToContract(rs));
                }
            }
        }
        return list;
    }

    public List<Contract> findByStatus(String status) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE Status = ?";
        List<Contract> list = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToContract(rs));
                }
            }
        }
        return list;
    }

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
        }
        return null;
    }

    private Contract mapResultSetToContract(ResultSet rs) throws SQLException {
        Contract contract = new Contract();
        contract.setContractId(UUID.fromString(rs.getString("ContractId")));
        contract.setContractCode(rs.getString("ContractCode"));
        contract.setUserId(UUID.fromString(rs.getString("UserId")));
        contract.setBookingId(UUID.fromString(rs.getString("BookingId")));
        contract.setCreatedDate(rs.getObject("CreatedDate", LocalDateTime.class));
        contract.setSignedDate(rs.getObject("SignedDate", LocalDateTime.class));
        contract.setCompletedDate(rs.getObject("CompletedDate", LocalDateTime.class));
        contract.setStatus(rs.getString("Status"));
        contract.setTermsAccepted(rs.getBoolean("TermsAccepted"));
        contract.setSignatureData(rs.getString("SignatureData"));
        contract.setSignatureMethod(rs.getString("SignatureMethod"));
        contract.setContractPdfUrl(rs.getString("ContractPdfUrl"));
        contract.setContractFileType(rs.getString("ContractFileType"));
        contract.setNotes(rs.getString("Notes"));
        contract.setCancellationReason(rs.getString("CancellationReason"));
        return contract;
    }

    @Override
    public List<Contract> getByUserId(UUID userId) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE UserId = ?";
        List<Contract> list = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToContract(rs));
                }
            }
        }
        return list;
    }

    @Override
    public List<Contract> getByStatus(String status) throws SQLException {
        String sql = "SELECT * FROM Contract WHERE Status = ?";
        List<Contract> list = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToContract(rs));
                }
            }
        }
        return list;
    }

    @Override
    public boolean isContractCodeExists(String contractCode) throws SQLException {
        String sql = "SELECT 1 FROM Contract WHERE ContractCode = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, contractCode);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
} 