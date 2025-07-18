package Repository.Contract;

import Model.Entity.Contract.ContractDocument;
import Repository.Interfaces.IContract.IContractDocumentRepository;
import Config.DBContext;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class ContractDocumentRepository implements IContractDocumentRepository {
    private final DBContext dbContext;

    public ContractDocumentRepository() {
        this.dbContext = new DBContext();
    }

    @Override
    public ContractDocument add(ContractDocument entity) throws SQLException {
        String sql = "INSERT INTO ContractDocuments (DocumentId, ContractId, DriverLicenseImageUrl, DriverLicenseNumber, CitizenIdFrontImageUrl, CitizenIdBackImageUrl, CitizenIdNumber, CitizenIdIssuedDate, CitizenIdIssuedPlace, DriverLicenseImageHash, CitizenIdFrontImageHash, CitizenIdBackImageHash) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getDocumentId());
            ps.setObject(2, entity.getContractId());
            ps.setString(3, entity.getDriverLicenseImageUrl());
            ps.setString(4, entity.getDriverLicenseNumber());
            ps.setString(5, entity.getCitizenIdFrontImageUrl());
            ps.setString(6, entity.getCitizenIdBackImageUrl());
            ps.setString(7, entity.getCitizenIdNumber());
            if (entity.getCitizenIdIssuedDate() != null) {
                ps.setDate(8, java.sql.Date.valueOf(entity.getCitizenIdIssuedDate()));
            } else {
                ps.setNull(8, Types.DATE);
            }
            ps.setString(9, entity.getCitizenIdIssuedPlace());
            ps.setString(10, entity.getDriverLicenseImageHash());
            ps.setString(11, entity.getCitizenIdFrontImageHash());
            ps.setString(12, entity.getCitizenIdBackImageHash());
            int affected = ps.executeUpdate();
            return affected > 0 ? entity : null;
        }
    }

    @Override
    public ContractDocument findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM ContractDocuments WHERE DocumentId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEntity(rs);
                }
            }
        }
        return null;
    }

    public ContractDocument findByContractId(UUID contractId) throws SQLException {
        String sql = "SELECT * FROM ContractDocuments WHERE ContractId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEntity(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean update(ContractDocument entity) throws SQLException {
        String sql = "UPDATE ContractDocuments SET ContractId=?, DriverLicenseImageUrl=?, DriverLicenseNumber=?, CitizenIdFrontImageUrl=?, CitizenIdBackImageUrl=?, CitizenIdNumber=?, CitizenIdIssuedDate=?, CitizenIdIssuedPlace=?, DriverLicenseImageHash=?, CitizenIdFrontImageHash=?, CitizenIdBackImageHash=? WHERE DocumentId=?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getContractId());
            ps.setString(2, entity.getDriverLicenseImageUrl());
            ps.setString(3, entity.getDriverLicenseNumber());
            ps.setString(4, entity.getCitizenIdFrontImageUrl());
            ps.setString(5, entity.getCitizenIdBackImageUrl());
            ps.setString(6, entity.getCitizenIdNumber());
            // Sửa lỗi Date: chuyển LocalDate -> java.sql.Date
            if (entity.getCitizenIdIssuedDate() != null) {
                ps.setDate(7, java.sql.Date.valueOf(entity.getCitizenIdIssuedDate()));
            } else {
                ps.setNull(7, Types.DATE);
            }
            ps.setString(8, entity.getCitizenIdIssuedPlace());
            ps.setString(9, entity.getDriverLicenseImageHash());
            ps.setString(10, entity.getCitizenIdFrontImageHash());
            ps.setString(11, entity.getCitizenIdBackImageHash());
            ps.setObject(12, entity.getDocumentId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM ContractDocuments WHERE DocumentId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<ContractDocument> findAll() throws SQLException {
        String sql = "SELECT * FROM ContractDocuments";
        List<ContractDocument> list = new ArrayList<>();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        }
        return list;
    }

    private ContractDocument mapResultSetToEntity(ResultSet rs) throws SQLException {
        ContractDocument doc = new ContractDocument();
        doc.setDocumentId(UUID.fromString(rs.getString("DocumentId")));
        doc.setContractId(UUID.fromString(rs.getString("ContractId")));
        doc.setDriverLicenseImageUrl(rs.getString("DriverLicenseImageUrl"));
        doc.setDriverLicenseNumber(rs.getString("DriverLicenseNumber"));
        doc.setCitizenIdFrontImageUrl(rs.getString("CitizenIdFrontImageUrl"));
        doc.setCitizenIdBackImageUrl(rs.getString("CitizenIdBackImageUrl"));
        doc.setCitizenIdNumber(rs.getString("CitizenIdNumber"));
        // Sửa lỗi Date: dùng getDate và toLocalDate
        java.sql.Date issuedDate = rs.getDate("CitizenIdIssuedDate");
        if (issuedDate != null) doc.setCitizenIdIssuedDate(issuedDate.toLocalDate());
        doc.setCitizenIdIssuedPlace(rs.getString("CitizenIdIssuedPlace"));
        doc.setDriverLicenseImageHash(rs.getString("DriverLicenseImageHash"));
        doc.setCitizenIdFrontImageHash(rs.getString("CitizenIdFrontImageHash"));
        doc.setCitizenIdBackImageHash(rs.getString("CitizenIdBackImageHash"));
        return doc;
    }
}
