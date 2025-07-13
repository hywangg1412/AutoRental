package Service.Payment;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Config.DBContext;
import Config.PaymentConfig;
import Model.DTO.Deposit.DepositPageDTO;
import Model.DTO.PaymentDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingSurcharges;
import Model.Entity.Payment.Payment;
import Repository.Booking.BookingRepository;
import Repository.Booking.BookingSurchargesRepository;
import Repository.Deposit.DepositRepository;
import Repository.Deposit.TermsRepository;
import Repository.Interfaces.IPayment.IPaymentRepository;
import Repository.Payment.PaymentRepository;
import Service.Deposit.DepositService;
import Service.Interfaces.IPaymentService;
import Utils.VNPayUtils;

public class PaymentService implements IPaymentService {
    private static final Logger LOGGER = Logger.getLogger(PaymentService.class.getName());
    private final IPaymentRepository paymentRepository;
    private final DBContext db;
    private final DepositService depositService;
    private final BookingRepository bookingRepository; // Tái sử dụng method có sẵn

    public PaymentService() {
        this.paymentRepository = new PaymentRepository();
        this.db = new DBContext();
        this.depositService = new DepositService(new DepositRepository(), new TermsRepository());
        this.bookingRepository = new BookingRepository(); // Khởi tạo để tái sử dụng method có sẵn
        LOGGER.info("PaymentService initialized with VNPay integration");
    }

    @Override
    public PaymentDTO createDepositPayment(UUID bookingId, UUID userId) throws SQLException {
        System.out.println("=== createDepositPayment START ===");
        System.out.println("BookingId: " + bookingId);
        System.out.println("UserId: " + userId);
        
        // Debug VNPay configuration
        System.out.println("=== VNPay Configuration ===");
        System.out.println("TMN_CODE: " + PaymentConfig.getTmnCode());
        System.out.println("HASH_SECRET: " + PaymentConfig.getHashSecret().substring(0, 5) + "...");
        System.out.println("PAY_URL: " + PaymentConfig.getPayUrl());
        System.out.println("RETURN_URL: " + PaymentConfig.getReturnUrl());
        System.out.println("CANCEL_URL: " + PaymentConfig.getCancelUrl());
        System.out.println("=========================");

        try {
            // Get deposit data
            var depositDTO = depositService.getDepositPageData(bookingId, userId);
            
            // Lấy chính xác số tiền hiển thị trên JSP (đã format)
            String formattedAmount = depositDTO.getFormattedDepositAmount(); // "2,218,339 VND"
            
            // Parse số tiền từ formatted string để đảm bảo chính xác 100%
            double depositAmount = parseFormattedAmount(formattedAmount);
            
            System.out.println("Deposit Amount (raw from DB): " + depositDTO.getDepositAmount());
            System.out.println("Deposit Amount (formatted): " + formattedAmount);
            System.out.println("Deposit Amount (parsed VND): " + depositAmount);

            // Validate deposit amount - VNPay yêu cầu số tiền tối thiểu
            if (depositAmount < 1000) {
                throw new SQLException("Số tiền thanh toán phải tối thiểu 1,000 VND. Số tiền hiện tại: " + depositAmount);
            }

            // Create payment record
            Payment payment = new Payment();
            payment.setPaymentId(UUID.randomUUID());
            payment.setBookingId(bookingId);
            payment.setUserId(userId);
            payment.setAmount(depositAmount); // Lưu giá trị thực tế (VND)
            payment.setPaymentMethod("VNPay");
            payment.setPaymentStatus("Pending");
            payment.setPaymentType("Deposit");
            payment.setCreatedDate(LocalDateTime.now());

            // Save payment to database
            paymentRepository.createPayment(payment);
            System.out.println("Payment created in database with ID: " + payment.getPaymentId());

            // Generate transaction reference - sử dụng timestamp để đảm bảo unique
            String vnpTxnRef = String.valueOf(System.currentTimeMillis());
            System.out.println("VNP TxnRef: " + vnpTxnRef);

            // Convert to VNPay amount format (VND * 100) - sử dụng chính xác số tiền từ JSP
            long vnpAmount = Math.round(depositAmount * 100);
            if (vnpAmount <= 0) {
                throw new SQLException("Số tiền VNPay không hợp lệ: " + vnpAmount);
            }

            System.out.println("VNPay Request Details:");
            System.out.println("- TxnRef: " + vnpTxnRef);
            System.out.println("- Deposit Amount (VND): " + depositAmount);
            System.out.println("- VNPay Amount (VND * 100): " + vnpAmount);

            // Create VNPay payment URL
            String paymentUrl = createVNPayLink(vnpTxnRef, vnpAmount, bookingId);

            // Update payment record with transaction ID
            payment.setTransactionId(vnpTxnRef);
            paymentRepository.updatePayment(payment);

            // Create PaymentDTO for response
            PaymentDTO dto = new PaymentDTO();
            dto.setPaymentId(payment.getPaymentId());
            dto.setBookingId(payment.getBookingId());
            dto.setAmount(payment.getAmount());
            dto.setPaymentStatus(payment.getPaymentStatus());
            dto.setQrCode(paymentUrl);
            dto.setTransactionId(vnpTxnRef);
            
            System.out.println("PaymentDTO created successfully!");
            System.out.println("Payment URL: " + paymentUrl);
            return dto;
            
        } catch (Exception ex) {
            System.out.println("Exception caught: " + ex.getMessage());
            LOGGER.log(Level.SEVERE, "Error creating deposit payment", ex);
            System.err.println("VNPay error details: " + ex.getMessage());
            ex.printStackTrace();

            String errorDetail = String.format(
                    "Lỗi tạo payment - BookingId: %s, UserId: %s, Error: %s",
                    bookingId, userId, ex.getMessage()
            );
            System.out.println("DEBUG ERROR: " + errorDetail);
            throw new SQLException("Could not create deposit payment: " + ex.getMessage());
        }
    }

    /**
     * Tạo VNPay payment link
     */
    private String createVNPayLink(String txnRef, long amount, UUID bookingId) throws Exception {
        System.out.println("=== CREATING VNPAY PAYMENT LINK ===");
        
        try {
            // Tạo các tham số VNPay
            Map<String, String> vnpParams = new HashMap<>();
            vnpParams.put("vnp_Version", "2.1.0");
            vnpParams.put("vnp_Command", "pay");
            vnpParams.put("vnp_TmnCode", PaymentConfig.getTmnCode());
            vnpParams.put("vnp_Amount", String.valueOf(amount));
            vnpParams.put("vnp_CurrCode", "VND");
            vnpParams.put("vnp_TxnRef", txnRef);
            vnpParams.put("vnp_OrderInfo", "Dat coc booking " + bookingId.toString().substring(0, 8));
            vnpParams.put("vnp_OrderType", "other");
            vnpParams.put("vnp_Locale", "vn");
            vnpParams.put("vnp_ReturnUrl", PaymentConfig.getReturnUrl() + "?bookingId=" + bookingId);
            vnpParams.put("vnp_IpAddr", "127.0.0.1"); // Default IP for development
            vnpParams.put("vnp_CreateDate", VNPayUtils.getCurrentDateTime());
            vnpParams.put("vnp_ExpireDate", VNPayUtils.getExpireDateTime(15)); // 15 phút hết hạn

            System.out.println("VNPay Parameters:");
            for (Map.Entry<String, String> entry : vnpParams.entrySet()) {
                System.out.println("- " + entry.getKey() + ": " + entry.getValue());
            }

            // Tạo URL thanh toán
            String paymentUrl = VNPayUtils.createPaymentUrl(vnpParams, PaymentConfig.getHashSecret(), PaymentConfig.getPayUrl());
            
            System.out.println("✅ VNPay Payment URL created successfully");
            System.out.println("Payment URL: " + paymentUrl);
            System.out.println("=== VNPAY PAYMENT LINK CREATION COMPLETE ===");
            
            return paymentUrl;
            
        } catch (Exception e) {
            System.err.println("❌ VNPay payment link creation failed: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("VNPay payment link creation failed: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean checkPaymentStatus(String txnRef) throws SQLException {
        System.out.println("=== CHECKING VNPAY PAYMENT STATUS ===");
        System.out.println("TxnRef: " + txnRef);
        
        try {
            // VNPay không có API riêng để check status như PayOS
            // Thay vào đó, status sẽ được cập nhật thông qua callback
            // Ở đây chúng ta chỉ kiểm tra trong database
            
            Payment payment = paymentRepository.getPaymentByTransactionId(txnRef);
            if (payment != null) {
                System.out.println("Payment found in database:");
                System.out.println("- PaymentId: " + payment.getPaymentId());
                System.out.println("- Status: " + payment.getPaymentStatus());
                System.out.println("- Amount: " + payment.getAmount());
                
                if ("Completed".equals(payment.getPaymentStatus())) {
                    return updateBookingAfterSuccessfulDeposit(payment.getBookingId());
                }
            } else {
                System.out.println("Payment not found in database for TxnRef: " + txnRef);
            }
            
            return false;
        } catch (Exception e) {
            System.err.println("Error checking payment status: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Could not check payment status: " + e.getMessage());
        }
    }

    @Override
    public PaymentDTO getPaymentStatus(UUID paymentId) throws SQLException {
        try {
            Payment payment = paymentRepository.getPaymentById(paymentId);
            if (payment == null) {
                throw new SQLException("Payment not found with ID: " + paymentId);
            }

            PaymentDTO dto = new PaymentDTO();
            dto.setPaymentId(payment.getPaymentId());
            dto.setBookingId(payment.getBookingId());
            dto.setAmount(payment.getAmount());
            dto.setPaymentStatus(payment.getPaymentStatus());
            dto.setTransactionId(payment.getTransactionId());
            dto.setPaymentDate(payment.getPaymentDate());

            return dto;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting payment status", e);
            throw new SQLException("Could not get payment status: " + e.getMessage());
        }
    }

    @Override
    public boolean processPaymentCallback(String transactionId, String status) throws SQLException {
        System.out.println("=== PROCESSING VNPAY CALLBACK ===");
        System.out.println("TransactionId: " + transactionId);
        System.out.println("Status: " + status);
        
        try {
            // Debug: Kiểm tra tất cả payments trong database
            System.out.println("=== DEBUGGING PAYMENT LOOKUP ===");
            System.out.println("Looking for payment with transactionId: " + transactionId);
            
            Payment payment = paymentRepository.getPaymentByTransactionId(transactionId);
            if (payment == null) {
                System.out.println("❌ Payment not found for transaction ID: " + transactionId);
                
                // Debug: Kiểm tra xem có payment nào trong database không
                System.out.println("=== CHECKING ALL PAYMENTS IN DATABASE ===");
                try {
                    // List tất cả payments để debug
                    java.util.List<Payment> allPayments = paymentRepository.getAllPayments();
                    System.out.println("Total payments in database: " + allPayments.size());
                    
                    for (Payment p : allPayments) {
                        System.out.println("Payment: " + p.getTransactionId() + " - " + p.getPaymentStatus() + " - " + p.getCreatedDate());
                    }
                    
                    // Thử tìm payment với transaction ID tương tự
                    System.out.println("Attempting to find similar transaction IDs...");
                    String similarTxnRef = findSimilarTransactionId(transactionId);
                    if (similarTxnRef != null) {
                        System.out.println("Found similar transaction ID: " + similarTxnRef);
                        payment = paymentRepository.getPaymentByTransactionId(similarTxnRef);
                    }
                    
                } catch (Exception debugEx) {
                    System.out.println("Debug error: " + debugEx.getMessage());
                }
                
                if (payment == null) {
                    System.out.println("❌ Still no payment found. This could mean:");
                    System.out.println("1. Payment was not created in createDepositPayment()");
                    System.out.println("2. Transaction ID mismatch between creation and callback");
                    System.out.println("3. Database connection issue");
                    return false;
                }
            }

            System.out.println("✅ Payment found:");
            System.out.println("- PaymentId: " + payment.getPaymentId());
            System.out.println("- BookingId: " + payment.getBookingId());
            System.out.println("- Amount: " + payment.getAmount());
            System.out.println("- Current Status: " + payment.getPaymentStatus());
            System.out.println("- Transaction ID: " + payment.getTransactionId());

            // Update payment status based on VNPay response
            String newStatus = "00".equals(status) ? "Completed" : "Failed";
            paymentRepository.updatePaymentStatus(payment.getPaymentId(), newStatus, transactionId);
            
            System.out.println("Payment status updated to: " + newStatus);

            // If payment successful, update booking
            if ("Completed".equals(newStatus)) {
                return updateBookingAfterSuccessfulDeposit(payment.getBookingId());
            }

            return true;
        } catch (Exception e) {
            System.err.println("Error processing payment callback: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Could not process payment callback: " + e.getMessage());
        }
    }
    
    /**
     * Parse số tiền từ formatted string (ví dụ: "2,218,339 VND" → 2218339.0)
     */
    private double parseFormattedAmount(String formattedAmount) {
        try {
            // Remove "VND", spaces, and commas, then parse
            String cleanAmount = formattedAmount
                .replace("VND", "")
                .replace(",", "")
                .replace(" ", "")
                .trim();
            
            double amount = Double.parseDouble(cleanAmount);
            System.out.println("Parsed amount: " + cleanAmount + " → " + amount);
            return amount;
        } catch (Exception e) {
            System.err.println("Error parsing formatted amount: " + formattedAmount);
            e.printStackTrace();
            throw new RuntimeException("Cannot parse deposit amount: " + formattedAmount, e);
        }
    }
    
    /**
     * Tìm transaction ID tương tự (để debug)
     */
    private String findSimilarTransactionId(String targetTxnRef) {
        try {
            // Lấy timestamp từ target
            long targetTimestamp = Long.parseLong(targetTxnRef);
            
            // Tìm trong khoảng +/- 5 phút (300000 ms)
            long minTimestamp = targetTimestamp - 300000;
            long maxTimestamp = targetTimestamp + 300000;
            
            System.out.println("Searching for transaction IDs between " + minTimestamp + " and " + maxTimestamp);
            
            // Gọi repository để tìm (cần implement method này)
            return paymentRepository.findTransactionIdInRange(minTimestamp, maxTimestamp);
            
        } catch (Exception e) {
            System.out.println("Error finding similar transaction ID: " + e.getMessage());
            return null;
        }
    }

    private boolean updateBookingAfterSuccessfulDeposit(UUID bookingId) throws SQLException {
        System.out.println("=== UPDATING BOOKING AFTER SUCCESSFUL DEPOSIT ===");
        System.out.println("BookingId: " + bookingId);
        
        try {
            // ========== BƯỚC 1: LẤY THÔNG TIN DEPOSIT ĐÃ TÍNH TOÁN ==========
            System.out.println("--- Bước 1: Lấy thông tin deposit đã tính toán ---");
            
            // Lấy thông tin booking hiện tại
            Booking booking = bookingRepository.findById(bookingId);
            if (booking == null) {
                System.err.println("❌ Không tìm thấy booking với ID: " + bookingId);
                return false;
            }
            
            // Lấy thông tin deposit đã tính toán từ DepositService
            // Sử dụng userId từ booking để lấy deposit data
            DepositPageDTO depositData = depositService.getDepositPageData(bookingId, booking.getUserId());
            
            System.out.println("📊 Thông tin deposit đã tính toán:");
            System.out.println("- Base Amount: " + depositData.getBaseRentalPrice() + " (DB value)");
            System.out.println("- Insurance Amount: " + depositData.getTotalInsuranceAmount() + " (DB value)");
            System.out.println("- VAT Amount: " + depositData.getVatAmount() + " (DB value)");
            System.out.println("- Total Amount: " + depositData.getTotalAmount() + " (DB value)");
            System.out.println("- Deposit Amount: " + depositData.getDepositAmount() + " (DB value)");
            
            // ========== BƯỚC 2: TẠO VAT SURCHARGE RECORD ==========
            System.out.println("--- Bước 2: Tạo VAT surcharge record ---");
            
            double vatAmount = depositData.getVatAmount();
            if (vatAmount > 0) {
                // Tạo VAT surcharge record
                BookingSurcharges vatSurcharge = new BookingSurcharges();
                vatSurcharge.setSurchargeId(UUID.randomUUID());
                vatSurcharge.setBookingId(bookingId);
                vatSurcharge.setSurchargeType("VAT");
                vatSurcharge.setAmount(vatAmount); // Giá trị DB (sẽ hiển thị × 1000 trên giao diện)
                vatSurcharge.setDescription("Thuế VAT 10% áp dụng cho tổng chi phí thuê xe và bảo hiểm");
                vatSurcharge.setCreatedDate(LocalDateTime.now());
                vatSurcharge.setSurchargeCategory("Tax");
                vatSurcharge.setSystemGenerated(true); // Đánh dấu là phí tự động tạo
                
                // Lưu VAT surcharge vào database
                BookingSurchargesRepository surchargeRepo = new BookingSurchargesRepository();
                
                // Xóa VAT cũ nếu có (tránh duplicate)
                surchargeRepo.deleteByBookingIdAndCategory(bookingId, "Tax");
                
                // Thêm VAT mới
                BookingSurcharges savedVatSurcharge = surchargeRepo.add(vatSurcharge);
                
                if (savedVatSurcharge != null) {
                    System.out.println("✅ Đã tạo VAT surcharge thành công:");
                    System.out.println("  - SurchargeId: " + savedVatSurcharge.getSurchargeId());
                    System.out.println("  - Amount: " + savedVatSurcharge.getAmount() + " (DB value)");
                    System.out.println("  - Display Amount: " + String.format("%.0f", savedVatSurcharge.getAmount() * 1000) + " VND");
                    System.out.println("  - Description: " + savedVatSurcharge.getDescription());
                    System.out.println("  - Category: " + savedVatSurcharge.getSurchargeCategory());
                    System.out.println("  - System Generated: " + savedVatSurcharge.isSystemGenerated());
                } else {
                    System.err.println("❌ Không thể tạo VAT surcharge");
                }
            } else {
                System.out.println("⚠️ VAT amount = 0, không tạo surcharge record");
            }
            
            // ========== BƯỚC 3: CẬP NHẬT BOOKING TOTAL AMOUNT ==========
            System.out.println("--- Bước 3: Cập nhật booking totalAmount để đóng băng giá ---");
            
            double finalTotalAmount = depositData.getTotalAmount();
            boolean totalAmountUpdated = bookingRepository.updateBookingTotalAmount(bookingId, finalTotalAmount);
            
            if (totalAmountUpdated) {
                System.out.println("✅ Đã cập nhật booking totalAmount thành công:");
                System.out.println("  - Old Amount: " + booking.getTotalAmount() + " (DB value)");
                System.out.println("  - New Amount: " + finalTotalAmount + " (DB value)");
                System.out.println("  - Display Amount: " + String.format("%.0f", finalTotalAmount * 1000) + " VND");
                System.out.println("💰 Giá tiền booking đã được đóng băng!");
            } else {
                System.err.println("❌ Không thể cập nhật booking totalAmount");
            }
            
            // ========== BƯỚC 4: CẬP NHẬT BOOKING STATUS ==========
            System.out.println("--- Bước 4: Cập nhật booking status ---");
            
            // Cập nhật booking status sử dụng method có sẵn trong BookingRepository
            bookingRepository.updateBookingStatus(bookingId, "DepositPaid");
            System.out.println("✅ Booking status updated to 'DepositPaid' successfully");
            
            // ========== BƯỚC 5: ĐẢM BẢO TERMS AGREEMENT ==========
            System.out.println("--- Bước 5: Đảm bảo terms agreement ---");
            
            // Đảm bảo terms agreement (sử dụng method có sẵn)
            bookingRepository.updateTermsAgreement(bookingId, true, "v1.0");
            System.out.println("✅ Terms agreement ensured (if not already agreed)");
            
            // ========== KẾT QUẢ CUỐI CÙNG ==========
            System.out.println("=== KẾT QUẢ CUỐI CÙNG ===");
            System.out.println("✅ Booking is now ready for contract signing");
            System.out.println("✅ VAT surcharge đã được thêm vào bảng BookingSurcharges");
            System.out.println("✅ Booking totalAmount đã được cập nhật và đóng băng giá");
            System.out.println("✅ Các chi phí khác (penalty, service) sẽ được thêm khi return xe");
            
            return true;
            
        } catch (Exception e) {
            System.err.println("❌ Error updating booking after successful deposit: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Could not update booking after successful deposit: " + e.getMessage());
        }
    }
}


