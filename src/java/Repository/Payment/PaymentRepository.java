package Repository.Payment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Config.DBContext;
import Model.Entity.Payment.Payment;
import Repository.Interfaces.IPayment.IPaymentRepository;

public class PaymentRepository implements IPaymentRepository {
    private static final Logger LOGGER = Logger.getLogger(PaymentRepository.class.getName());
    private final DBContext db;

    public PaymentRepository() {
        this.db = new DBContext();
    }

    @Override
    public Payment createPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO Payment (PaymentId, BookingId, ContractId, Amount, " +
                    "PaymentMethod, PaymentStatus, PaymentType, TransactionId, PaymentDate, " +
                    "UserId, Notes, CreatedDate) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, payment.getPaymentId());
            ps.setObject(2, payment.getBookingId());
            ps.setObject(3, payment.getContractId());
            ps.setDouble(4, payment.getAmount());
            ps.setString(5, payment.getPaymentMethod());
            ps.setString(6, payment.getPaymentStatus());
            ps.setString(7, payment.getPaymentType());
            ps.setString(8, payment.getTransactionId());
            ps.setTimestamp(9, payment.getPaymentDate() != null ? 
                Timestamp.valueOf(payment.getPaymentDate()) : null);
            ps.setObject(10, payment.getUserId());
            ps.setString(11, payment.getNotes());
            ps.setTimestamp(12, Timestamp.valueOf(payment.getCreatedDate()));
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                return payment;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating payment", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    @Override
    public Payment getPaymentById(UUID paymentId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE PaymentId = ?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payment by ID", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    @Override
    public Payment getPaymentByBookingId(UUID bookingId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE BookingId = ? ORDER BY CreatedDate DESC";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payment by booking ID", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    @Override
    public List<Payment> getPaymentsByUserId(UUID userId) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE UserId = ? ORDER BY CreatedDate DESC";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payments by user ID", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
        return payments;
    }

    @Override
    public boolean updatePaymentStatus(UUID paymentId, String status, String transactionId) throws SQLException {
        String sql = "UPDATE Payment SET PaymentStatus = ?, TransactionId = ?, PaymentDate = ? WHERE PaymentId = ?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, transactionId);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setObject(4, paymentId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean updatePayment(Payment payment) throws SQLException {
        String sql = "UPDATE Payment SET PaymentStatus = ?, TransactionId = ?, PaymentDate = ?, " +
                    "Notes = ? WHERE PaymentId = ?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, payment.getPaymentStatus());
            ps.setString(2, payment.getTransactionId());
            ps.setTimestamp(3, payment.getPaymentDate() != null ? 
                Timestamp.valueOf(payment.getPaymentDate()) : null);
            ps.setString(4, payment.getNotes());
            ps.setObject(5, payment.getPaymentId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean hasSuccessfulDeposit(UUID bookingId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Payment " +
                    "WHERE BookingId = ? AND PaymentType = 'Deposit' AND PaymentStatus = 'Completed'";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking successful deposit", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
        return false;
    }

    @Override
    public boolean updateBookingAndCarAfterDeposit(UUID bookingId) throws SQLException {
        try (Connection conn = db.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Update booking status
                String updateBookingSql = 
                    "UPDATE Booking SET Status = 'DepositPaid', " +
                    "TermsAgreed = 1, TermsAgreedAt = ? " +
                    "WHERE BookingId = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateBookingSql)) {
                    ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
                    ps.setObject(2, bookingId);
                    ps.executeUpdate();
                }

                // 2. Get car ID from booking
                String getCarSql = "SELECT CarId FROM Booking WHERE BookingId = ?";
                UUID carId;
                try (PreparedStatement ps = conn.prepareStatement(getCarSql)) {
                    ps.setObject(1, bookingId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("Booking not found");
                        }
                        carId = UUID.fromString(rs.getString("CarId"));
                    }
                }

                // 3. Update car status to Reserved
                String updateCarSql = "UPDATE Car SET Status = 'Reserved' WHERE CarId = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateCarSql)) {
                    ps.setObject(1, carId);
                    ps.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Error updating booking and car after deposit", e);
                e.printStackTrace();
                System.out.println("DEBUG ERROR: " + e.getMessage());
                throw e;
            }
        }
    }

    @Override
    public Payment getPaymentByTransactionId(String transactionId) throws SQLException {
        String sql = "SELECT * FROM Payment WHERE TransactionId = ?";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, transactionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payment by transaction ID", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }

    @Override
    public String findTransactionIdInRange(long minTimestamp, long maxTimestamp) throws SQLException {
        String sql = "SELECT TransactionId FROM Payment " +
                    "WHERE TransactionId BETWEEN ? AND ? " +
                    "ORDER BY CreatedDate DESC";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, String.valueOf(minTimestamp));
            ps.setString(2, String.valueOf(maxTimestamp));
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("TransactionId");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding transaction ID in range", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
        return null;
    }
    
    @Override
    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM Payment ORDER BY CreatedDate DESC";
        
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                    
                    // Debug log
                    System.out.println("Found payment: " + 
                        rs.getString("PaymentId") + " - TxnId: " + 
                        rs.getString("TransactionId") + " - Status: " + 
                        rs.getString("PaymentStatus"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all payments", e);
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            throw e;
        }
        return payments;
    }

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(UUID.fromString(rs.getString("PaymentId")));
        payment.setBookingId(UUID.fromString(rs.getString("BookingId")));
        
        String contractId = rs.getString("ContractId");
        if (contractId != null) {
            payment.setContractId(UUID.fromString(contractId));
        }
        
        payment.setAmount(rs.getDouble("Amount"));
        payment.setPaymentMethod(rs.getString("PaymentMethod"));
        payment.setPaymentStatus(rs.getString("PaymentStatus"));
        payment.setPaymentType(rs.getString("PaymentType"));
        payment.setTransactionId(rs.getString("TransactionId"));
        
        Timestamp paymentDate = rs.getTimestamp("PaymentDate");
        if (paymentDate != null) {
            payment.setPaymentDate(paymentDate.toLocalDateTime());
        }
        
        String userId = rs.getString("UserId");
        if (userId != null) {
            payment.setUserId(UUID.fromString(userId));
        }
        
        payment.setNotes(rs.getString("Notes"));
        payment.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        
        return payment;
    }
} 