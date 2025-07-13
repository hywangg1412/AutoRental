
package Service.Interfaces;

import Model.DTO.PaymentDTO;
import java.sql.SQLException;
import java.util.UUID;

public interface IPaymentService {
    PaymentDTO createDepositPayment(UUID bookingId, UUID userId) throws SQLException;
    PaymentDTO getPaymentStatus(UUID paymentId) throws SQLException;
    boolean processPaymentCallback(String transactionId, String status) throws SQLException;
    boolean checkPaymentStatus(String orderCode) throws SQLException;
}
