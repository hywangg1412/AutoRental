
package Model.Entity.Contract;

import java.time.LocalDateTime;
import java.util.UUID;

public class Contract {
    private UUID contractId;
    private String contractCode;
    private UUID userId;
    private UUID bookingId;
    private LocalDateTime createdDate;
    private LocalDateTime signedDate;
    private LocalDateTime completedDate;
    private String status;
    private boolean termsAccepted;
    private String signatureData;
    private String signatureMethod;
    private String contractPdfUrl;
    private String contractFileType;
    private String notes;
    private String cancellationReason;

    public Contract() {}

    public UUID getContractId() { return contractId; }
    public void setContractId(UUID contractId) { this.contractId = contractId; }

    public String getContractCode() { return contractCode; }
    public void setContractCode(String contractCode) { this.contractCode = contractCode; }

    public UUID getUserId() { return userId; }
    public void setUserId(UUID userId) { this.userId = userId; }

    public UUID getBookingId() { return bookingId; }
    public void setBookingId(UUID bookingId) { this.bookingId = bookingId; }

    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }

    public LocalDateTime getSignedDate() { return signedDate; }
    public void setSignedDate(LocalDateTime signedDate) { this.signedDate = signedDate; }

    public LocalDateTime getCompletedDate() { return completedDate; }
    public void setCompletedDate(LocalDateTime completedDate) { this.completedDate = completedDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isTermsAccepted() { return termsAccepted; }
    public void setTermsAccepted(boolean termsAccepted) { this.termsAccepted = termsAccepted; }

    public String getSignatureData() { return signatureData; }
    public void setSignatureData(String signatureData) { this.signatureData = signatureData; }

    public String getSignatureMethod() { return signatureMethod; }
    public void setSignatureMethod(String signatureMethod) { this.signatureMethod = signatureMethod; }

    public String getContractPdfUrl() { return contractPdfUrl; }
    public void setContractPdfUrl(String contractPdfUrl) { this.contractPdfUrl = contractPdfUrl; }

    public String getContractFileType() { return contractFileType; }
    public void setContractFileType(String contractFileType) { this.contractFileType = contractFileType; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getCancellationReason() { return cancellationReason; }
    public void setCancellationReason(String cancellationReason) { this.cancellationReason = cancellationReason; }
}
