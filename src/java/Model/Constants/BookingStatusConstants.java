package Model.Constants;

/**
 * Constants for Booking status
 */
public class BookingStatusConstants {
    public static final String PENDING = "Pending";
    public static final String CONFIRMED = "Confirmed";
    public static final String CANCELLED = "Cancelled";
    public static final String COMPLETED = "Completed";
    
    // Additional statuses for deposit workflow
    public static final String AWAITING_PAYMENT = "AwaitingPayment";
    public static final String DEPOSIT_PAID = "DepositPaid";
    public static final String CONTRACT_SIGNED = "ContractSigned";
    public static final String FULLY_PAID = "FullyPaid";
    public static final String IN_PROGRESS = "InProgress";
    public static final String REJECTED = "Rejected";
    public static final String WAITING_RETURN_CONFIRM = "WAITING_RETURN_CONFIRM";
    public static final String RETURN_REJECTED = "RETURN_REJECTED";
    public static final String PENDING_INSPECTION = "PendingInspection"; // Trạng thái chờ kiểm tra xe
    public static final String INSPECTION_COMPLETED = "InspectionCompleted";
}