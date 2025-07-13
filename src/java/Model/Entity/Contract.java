
package Model.Entity;

import Model.Constants.ContractStatusConstants;
import java.math.BigDecimal;
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
    private LocalDateTime termsAcceptedDate;
    private String termsVersion;
    private String termsFileUrl;
    private String signatureData; 
    private String signatureMethod; 
    private String notes;
    private String cancellationReason;

    public Contract(UUID contractId, String contractCode, UUID userId, UUID bookingId, LocalDateTime createdDate, LocalDateTime signedDate, LocalDateTime completedDate, String status, boolean termsAccepted, LocalDateTime termsAcceptedDate, String termsVersion, String termsFileUrl, String signatureData, String signatureMethod, String notes, String cancellationReason) {
        this.contractId = contractId;
        this.contractCode = contractCode;
        this.userId = userId;
        this.bookingId = bookingId;
        this.createdDate = createdDate;
        this.signedDate = signedDate;
        this.completedDate = completedDate;
        this.status = status;
        this.termsAccepted = termsAccepted;
        this.termsAcceptedDate = termsAcceptedDate;
        this.termsVersion = termsVersion;
        this.termsFileUrl = termsFileUrl;
        this.signatureData = signatureData;
        this.signatureMethod = signatureMethod;
        this.notes = notes;
        this.cancellationReason = cancellationReason;
    }
   
    public Contract() {
    }

    public UUID getContractId() {
        return contractId;
    }

    public void setContractId(UUID contractId) {
        this.contractId = contractId;
    }

    public String getContractCode() {
        return contractCode;
    }

    public void setContractCode(String contractCode) {
        this.contractCode = contractCode;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getBookingId() {
        return bookingId;
    }

    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public LocalDateTime getSignedDate() {
        return signedDate;
    }

    public void setSignedDate(LocalDateTime signedDate) {
        this.signedDate = signedDate;
    }

    public LocalDateTime getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(LocalDateTime completedDate) {
        this.completedDate = completedDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isTermsAccepted() {
        return termsAccepted;
    }

    public void setTermsAccepted(boolean termsAccepted) {
        this.termsAccepted = termsAccepted;
    }

    public LocalDateTime getTermsAcceptedDate() {
        return termsAcceptedDate;
    }

    public void setTermsAcceptedDate(LocalDateTime termsAcceptedDate) {
        this.termsAcceptedDate = termsAcceptedDate;
    }

    public String getTermsVersion() {
        return termsVersion;
    }

    public void setTermsVersion(String termsVersion) {
        this.termsVersion = termsVersion;
    }

    public String getTermsFileUrl() {
        return termsFileUrl;
    }

    public void setTermsFileUrl(String termsFileUrl) {
        this.termsFileUrl = termsFileUrl;
    }

    public String getSignatureData() {
        return signatureData;
    }

    public void setSignatureData(String signatureData) {
        this.signatureData = signatureData;
    }

    public String getSignatureMethod() {
        return signatureMethod;
    }

    public void setSignatureMethod(String signatureMethod) {
        this.signatureMethod = signatureMethod;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public void setCancellationReason(String cancellationReason) {
        this.cancellationReason = cancellationReason;
    }

    public boolean isSigned() {
        return signedDate != null && termsAccepted;
    }

    public boolean isActive() {
        return ContractStatusConstants.ACTIVE.equals(status);
    }

    public boolean isCompleted() {
        return ContractStatusConstants.COMPLETED.equals(status);
    }

    public boolean canBeSigned() {
        return ContractStatusConstants.CREATED.equals(status) || ContractStatusConstants.PENDING.equals(status);
    }

    public void sign(String signatureData, String signatureMethod, String termsVersion, String termsFileUrl) {
        this.signedDate = LocalDateTime.now();
        this.signatureData = signatureData;
        this.signatureMethod = signatureMethod;
        this.termsAccepted = true;
        this.termsAcceptedDate = LocalDateTime.now();
        this.termsVersion = termsVersion;
        this.termsFileUrl = termsFileUrl;
        this.status = ContractStatusConstants.ACTIVE;
    }

    public void complete() {
        this.completedDate = LocalDateTime.now();
        this.status = ContractStatusConstants.COMPLETED;
    }

    public void cancel(String reason) {
        this.cancellationReason = reason;
        this.status = ContractStatusConstants.CANCELLED;
    }

    @Override
    public String toString() {
        return "Contract{" +
                "contractId=" + contractId +
                ", contractCode='" + contractCode + '\'' +
                ", userId=" + userId +
                ", bookingId=" + bookingId +
                ", status='" + status + '\'' +
                ", signedDate=" + signedDate +
                ", completedDate=" + completedDate +
                '}';
    }
}
