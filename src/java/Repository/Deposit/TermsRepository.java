package Repository.Deposit;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Config.DBContext;
import Model.Entity.Deposit.Terms;
import Repository.Interfaces.IDeposit.ITermsRepository;

/**
 * Repository xử lý các thao tác database cho Terms (điều khoản) Theo pattern
 * của BookingRepository
 */
public class TermsRepository implements ITermsRepository {

    private static final Logger LOGGER = Logger.getLogger(TermsRepository.class.getName());
    private final DBContext dbContext;

    // SQL queries
    private static final String SQL_FIND_ACTIVE
            = "SELECT * FROM Terms WHERE IsActive = 1 ORDER BY CreatedDate DESC";

    private static final String SQL_FIND_BY_VERSION
            = "SELECT * FROM Terms WHERE Version = ?";

    private static final String SQL_FIND_ALL
            = "SELECT * FROM Terms ORDER BY CreatedDate DESC";

    private static final String SQL_GET_LATEST_VERSION
            = "SELECT TOP 1 Version FROM Terms ORDER BY CreatedDate DESC";

    private static final String SQL_INSERT
            = "INSERT INTO Terms (TermsId, Version, Title, ShortContent, FullContent, "
            + "EffectiveDate, IsActive, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_FIND_BY_ID
            = "SELECT * FROM Terms WHERE TermsId = ?";

    private static final String SQL_UPDATE
            = "UPDATE Terms SET Version = ?, Title = ?, ShortContent = ?, FullContent = ?, "
            + "EffectiveDate = ?, IsActive = ? WHERE TermsId = ?";

    private static final String SQL_DELETE
            = "DELETE FROM Terms WHERE TermsId = ?";

    public TermsRepository() {
        this.dbContext = new DBContext();
    }

    @Override
    public Terms findActiveTerms() throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_ACTIVE)) {

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTerms(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding active terms", e);
            throw e;
        }
    }

    @Override
    public Terms findByVersion(String version) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_VERSION)) {

            ps.setString(1, version);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTerms(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding terms by version: " + version, e);
            throw e;
        }
    }

    @Override
    public String getLatestVersion() throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_GET_LATEST_VERSION)) {

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Version");
                }
                return "v1.0"; // Default version
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting latest version", e);
            throw e;
        }
    }

    @Override
    public Terms add(Terms entity) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {

            ps.setObject(1, entity.getTermsId());
            ps.setString(2, entity.getVersion());
            ps.setString(3, entity.getTitle());
            ps.setString(4, entity.getShortContent());
            ps.setString(5, entity.getFullContent());
            ps.setDate(6, Date.valueOf(entity.getEffectiveDate()));
            ps.setBoolean(7, entity.isActive());
            ps.setTimestamp(8, Timestamp.valueOf(entity.getCreatedDate()));

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                return entity;
            }
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding terms", e);
            throw e;
        }
    }

    @Override
    public Terms findById(UUID id) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {

            ps.setObject(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTerms(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding terms by ID: " + id, e);
            throw e;
        }
    }

    @Override
    public boolean update(Terms entity) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {

            ps.setString(1, entity.getVersion());
            ps.setString(2, entity.getTitle());
            ps.setString(3, entity.getShortContent());
            ps.setString(4, entity.getFullContent());
            ps.setDate(5, Date.valueOf(entity.getEffectiveDate()));
            ps.setBoolean(6, entity.isActive());
            ps.setObject(7, entity.getTermsId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating terms", e);
            throw e;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_DELETE)) {

            ps.setObject(1, id);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting terms", e);
            throw e;
        }
    }

    @Override
    public List<Terms> findAll() throws SQLException {
        List<Terms> termsList = new ArrayList<>();

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                termsList.add(mapResultSetToTerms(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all terms", e);
            throw e;
        }

        return termsList;
    }

    // ========== HELPER METHODS ==========
    /**
     * Map ResultSet sang Terms object
     */
    private Terms mapResultSetToTerms(ResultSet rs) throws SQLException {
        Terms terms = new Terms();

        terms.setTermsId(UUID.fromString(rs.getString("TermsId")));
        terms.setVersion(rs.getString("Version"));
        terms.setTitle(rs.getString("Title"));
        terms.setShortContent(rs.getString("ShortContent"));
        terms.setFullContent(rs.getString("FullContent"));
        terms.setEffectiveDate(rs.getDate("EffectiveDate").toLocalDate());
        terms.setActive(rs.getBoolean("IsActive"));
        terms.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());

        return terms;
    }
}
