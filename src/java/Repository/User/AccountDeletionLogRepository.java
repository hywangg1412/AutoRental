package Repository.User;

import Config.DBContext;
import Model.Entity.User.AccountDeletionLog;
import Repository.Interfaces.IUser.IAccountDeletionLogRepository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class AccountDeletionLogRepository implements IAccountDeletionLogRepository {
    private final DBContext dbContext = new DBContext();

    @Override
    public AccountDeletionLog add(AccountDeletionLog entity) throws SQLException {
        String sql = "INSERT INTO AccountDeletionLogs (LogId, UserId, DeletionReason, AdditionalComments, Timestamp) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getLogId().toString());
            st.setString(2, entity.getUserId().toString());
            st.setString(3, entity.getDeletionReason());
            st.setString(4, entity.getAdditionalComments());
            st.setTimestamp(5, Timestamp.valueOf(entity.getTimestamp()));

            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                return entity;
            }
        }
        return null;
    }

    @Override
    public boolean update(AccountDeletionLog entity) throws SQLException {
        String sql = "UPDATE AccountDeletionLogs SET UserId = ?, DeletionReason = ?, AdditionalComments = ?, Timestamp = ? WHERE LogId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getUserId().toString());
            st.setString(2, entity.getDeletionReason());
            st.setString(3, entity.getAdditionalComments());
            st.setTimestamp(4, Timestamp.valueOf(entity.getTimestamp()));
            st.setString(5, entity.getLogId().toString());

            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM AccountDeletionLogs WHERE LogId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, id.toString());
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public AccountDeletionLog findById(UUID id) throws SQLException {
        String sql = "SELECT LogId, UserId, DeletionReason, AdditionalComments, Timestamp FROM AccountDeletionLogs WHERE LogId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, id.toString());
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEntity(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<AccountDeletionLog> findAll() throws SQLException {
        String sql = "SELECT LogId, UserId, DeletionReason, AdditionalComments, Timestamp FROM AccountDeletionLogs ORDER BY Timestamp DESC";
        List<AccountDeletionLog> logs = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    logs.add(mapResultSetToEntity(rs));
                }
            }
        }
        return logs;
    }

    private AccountDeletionLog mapResultSetToEntity(ResultSet rs) throws SQLException {
        AccountDeletionLog log = new AccountDeletionLog();
        log.setLogId(UUID.fromString(rs.getString("LogId")));
        log.setUserId(UUID.fromString(rs.getString("UserId")));
        log.setDeletionReason(rs.getString("DeletionReason"));
        log.setAdditionalComments(rs.getString("AdditionalComments"));
        log.setTimestamp(rs.getTimestamp("Timestamp").toLocalDateTime());
        return log;
    }
} 