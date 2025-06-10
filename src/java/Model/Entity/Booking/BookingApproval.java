package Model.Entity.Booking;

import java.time.LocalDateTime;
import java.util.UUID;

public class BookingApproval {
    private UUID approvalId;
    private UUID bookingId;
    private UUID staffId;
    private String approvalStatus;
    private LocalDateTime approvalDate;
    private String note;
    private String rejectionReason; 

    public BookingApproval() {
    }

    public BookingApproval(UUID approvalId, UUID bookingId, UUID staffId, String approvalStatus, LocalDateTime approvalDate, String note, String rejectionReason) {
        this.approvalId = approvalId;
        this.bookingId = bookingId;
        this.staffId = staffId;
        this.approvalStatus = approvalStatus;
        this.approvalDate = approvalDate;
        this.note = note;
        this.rejectionReason = rejectionReason;
    }

    public UUID getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(UUID approvalId) {
        this.approvalId = approvalId;
    }

    public UUID getBookingId() {
        return bookingId;
    }

    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
    }

    public UUID getStaffId() {
        return staffId;
    }

    public void setStaffId(UUID staffId) {
        this.staffId = staffId;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public LocalDateTime getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(LocalDateTime approvalDate) {
        this.approvalDate = approvalDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    @Override
    public String toString() {
        return "BookingApproval{" + "approvalId=" + approvalId + ", bookingId=" + bookingId + ", staffId=" + staffId + ", approvalStatus=" + approvalStatus + ", approvalDate=" + approvalDate + ", note=" + note + ", rejectionReason=" + rejectionReason + '}';
    }
    
}
