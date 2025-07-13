package Repository.Interfaces.IDeposit;

import Model.Entity.Deposit.Terms;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

/**
 * Interface cho TermsRepository
 * Xử lý các thao tác database liên quan đến điều khoản
 * KHÔNG kế thừa Repository generic để tránh conflict
 */
public interface ITermsRepository {
    
    /**
     * Tìm điều khoản đang active
     * @return Terms object hoặc null
     */
    Terms findActiveTerms() throws SQLException;
    
    /**
     * Tìm điều khoản theo version
     * @param version Phiên bản điều khoản
     * @return Terms object hoặc null
     */
    Terms findByVersion(String version) throws SQLException;
    
    /**
     * Lấy tất cả điều khoản
     * @return List các Terms
     */
    List<Terms> findAll() throws SQLException;
    
    /**
     * Lấy version mới nhất
     * @return String version
     */
    String getLatestVersion() throws SQLException;
    
    // ========== BASIC CRUD METHODS ==========
    
    /**
     * Thêm điều khoản mới
     */
    Terms add(Terms entity) throws SQLException;
    
    /**
     * Tìm điều khoản theo ID
     */
    Terms findById(UUID id) throws SQLException;
    
    /**
     * Cập nhật điều khoản
     */
    boolean update(Terms entity) throws SQLException;
    
    /**
     * Xóa điều khoản
     */
    boolean delete(UUID id) throws SQLException;
}
