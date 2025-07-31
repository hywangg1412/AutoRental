package Repository.Interfaces.IPayment;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import Model.Entity.Payment.Payment;

public interface IPaymentRepository {
    Payment createPayment(Payment payment) throws SQLException;
    Payment getPaymentById(UUID paymentId) throws SQLException;
    Payment getPaymentByBookingId(UUID bookingId) throws SQLException;
    List<Payment> getPaymentsByUserId(UUID userId) throws SQLException;
    boolean updatePaymentStatus(UUID paymentId, String status, String transactionId) throws SQLException;
    boolean updatePayment(Payment payment) throws SQLException;
    boolean hasSuccessfulDeposit(UUID bookingId) throws SQLException;
    boolean updateBookingAndCarAfterDeposit(UUID bookingId) throws SQLException;
    Payment getPaymentByTransactionId(String transactionId) throws SQLException;
    
    // Debug method để tìm transaction ID tương tự
    String findTransactionIdInRange(long minTimestamp, long maxTimestamp) throws SQLException;
    List<Payment> getAllPayments() throws SQLException;
    Payment findByTxnRef(String txnRef) throws SQLException;
} 