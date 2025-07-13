package Model.DTO.Payment;

import java.time.LocalDateTime;
import java.util.UUID;

public class PaymentDTO {
    private UUID paymentId;
    private UUID bookingId;
    private double amount;
    private String paymentStatus;
    private String paymentType;
    private String qrCode;
    private String transactionId;
    private LocalDateTime paymentDate;
    private String formattedAmount;
    private String formattedDate;
    
    public PaymentDTO() {}
    
    // Getters and Setters
    public UUID getPaymentId() { return paymentId; }
    public void setPaymentId(UUID paymentId) { this.paymentId = paymentId; }
    
    public UUID getBookingId() { return bookingId; }
    public void setBookingId(UUID bookingId) { this.bookingId = bookingId; }
    
    public double getAmount() { return amount; }
    public void setAmount(double amount) { 
        this.amount = amount;
        this.formattedAmount = String.format("%,.0f VND", amount);
    }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public String getPaymentType() { return paymentType; }
    public void setPaymentType(String paymentType) { this.paymentType = paymentType; }
    
    public String getQrCode() { return qrCode; }
    public void setQrCode(String qrCode) { this.qrCode = qrCode; }
    
    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
    
    public LocalDateTime getPaymentDate() { return paymentDate; }
    public void setPaymentDate(LocalDateTime paymentDate) { 
        this.paymentDate = paymentDate;
        if (paymentDate != null) {
            this.formattedDate = paymentDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
        }
    }
    
    public String getFormattedAmount() { return formattedAmount; }
    public String getFormattedDate() { return formattedDate; }
} 