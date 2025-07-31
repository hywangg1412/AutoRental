package Service.Deposit;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Model.DTO.Deposit.DepositPageDTO;
import Model.DTO.Deposit.InsuranceDetailDTO;
import Model.DTO.DurationResult;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingInsurance;
import Model.Entity.Deposit.Insurance;
import Model.Entity.Deposit.Terms;
import Model.Entity.Discount;
import Model.DTO.Deposit.DiscountDTO;
import Repository.Interfaces.IDeposit.IDepositRepository;
import Repository.Interfaces.IDeposit.ITermsRepository;
import Service.Interfaces.IDeposit.IDepositService;

/**
 * Service handling deposit logic - STYLE FOR STUDENTS TO UNDERSTAND EASILY
 * Simple logic: Get data from database → Calculate → Return DTO
 * REUSE duration logic from BookingService
 */
public class DepositService implements IDepositService {

    private static final Logger LOGGER = Logger.getLogger(DepositService.class.getName());
    
    // ========== CALCULATION CONSTANTS - EASY TO UNDERSTAND ==========
    private static final double DEPOSIT_PERCENTAGE = 0.30;    // 30% deposit
    private static final double VAT_PERCENTAGE = 0.10;        // 10% VAT
    private static final double VEHICLE_INSURANCE_RATE = 0.02; // 2% vehicle insurance/year
    
    // Coefficient to estimate vehicle value based on rental price/day
    private static final double COEFFICIENT_LOW = 5;     // ≤ 500k/day
    private static final double COEFFICIENT_MEDIUM = 7;  // ≤ 800k/day
    private static final double COEFFICIENT_HIGH = 10;   // ≤ 1,200k/day
    private static final double COEFFICIENT_LUXURY = 15; // > 1,200k/day

    // ========== DURATION CONSTANTS - REUSED FROM BOOKINGSERVICE ==========
    private static final double MIN_HOURLY_DURATION = 4.0; // Minimum 4 hours rental
    private static final double MIN_DAILY_DURATION = 0.5;  // Minimum 0.5 day rental (12 hours)
    private static final double MIN_MONTHLY_DURATION = 0.5; // Minimum 0.5 month rental (15 days)
    private static final int DAYS_PER_MONTH = 30; // Convention: 1 month = 30 days

    private final IDepositRepository depositRepository;
    private final ITermsRepository termsRepository;

    public DepositService(IDepositRepository depositRepository, ITermsRepository termsRepository) {
        this.depositRepository = depositRepository;
        this.termsRepository = termsRepository;
    }

    // ========== MAIN METHOD - GET DEPOSIT DATA ==========

    @Override
    public DepositPageDTO getDepositPageData(UUID bookingId, UUID userId) throws Exception {
        // Step 1: Check booking ownership
        if (!depositRepository.isBookingOwnedByUser(bookingId, userId)) {
            throw new SecurityException("Booking does not belong to this user");
        }

        // Step 2: Get booking information
        Booking booking = depositRepository.getBookingForDeposit(bookingId);
        if (booking == null) {
            throw new IllegalArgumentException("Booking not found");
        }

        // Step 3: Check booking status
        if (!"Confirmed".equals(booking.getStatus()) && !"Pending".equals(booking.getStatus())) {
            throw new IllegalStateException("Booking must be in Confirmed or Pending status");
        }

        // Step 4: Get vehicle information
        Repository.Deposit.DepositRepository.CarInfoForDeposit carInfo = 
            ((Repository.Deposit.DepositRepository) depositRepository).getCarInfoByBookingId(bookingId);

        // Step 5: Create DTO and fill data
        DepositPageDTO dto = new DepositPageDTO();

        // Map basic information
        mapBookingInfoToDTO(booking, dto);
        
        // Map vehicle information
        if (carInfo != null) {
            mapCarInfoToDTO(carInfo, dto);
        }
        
        // Calculate duration using DurationResult
        calculateDurationUsingDurationResult(booking, dto);
        
        // Get insurance list
        List<InsuranceDetailDTO> insuranceList = getInsuranceList(bookingId);
        dto.setInsuranceDetails(insuranceList);
        
        // Get applied discount information (if any)
        if (booking.getDiscountId() != null) {
            try {
                Discount appliedDiscount = depositRepository.getDiscountById(booking.getDiscountId());
                if (appliedDiscount != null) {
                    DiscountDTO discountDTO = new DiscountDTO();
                    discountDTO.setVoucherCode(appliedDiscount.getVoucherCode());
                    discountDTO.setName(appliedDiscount.getDiscountName());
                    discountDTO.setDiscountType(appliedDiscount.getDiscountType());
                    discountDTO.setDiscountValue(appliedDiscount.getDiscountValue().doubleValue());
                    discountDTO.setMinOrderAmount(appliedDiscount.getMinOrderAmount() != null ? 
                        appliedDiscount.getMinOrderAmount().doubleValue() : 0.0);
                    discountDTO.setDescription(appliedDiscount.getDescription());
                    
                    dto.setAppliedDiscount(discountDTO);
                    LOGGER.info("Applied discount: " + appliedDiscount.getDiscountName() + " (" + appliedDiscount.getVoucherCode() + ")");
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error getting applied discount information", e);
            }
        }
        
        // Calculate pricing
        calculateAllPricing(booking, dto);

        return dto;
    }

    // ========== OTHER METHODS ==========

    @Override
    public boolean applyVoucher(UUID bookingId, String voucherCode, UUID userId) throws Exception {
        LOGGER.info("=== APPLYING VOUCHER ===");
        LOGGER.info("Booking ID: " + bookingId);
        LOGGER.info("Voucher Code: " + voucherCode);
        LOGGER.info("User ID: " + userId);
        
        try {
            // Step 1: Check booking ownership
            if (!depositRepository.isBookingOwnedByUser(bookingId, userId)) {
                LOGGER.warning("User does not have permission for this booking");
                throw new SecurityException("Booking does not belong to this user");
            }
            
            // Step 2: Validate voucher code
            if (voucherCode == null || voucherCode.trim().isEmpty()) {
                LOGGER.warning("Voucher code cannot be empty");
                throw new IllegalArgumentException("Voucher code cannot be empty");
            }
            
            // Step 3: Check if voucher is valid
            LOGGER.info("Calling depositRepository.validateVoucher('" + voucherCode.trim() + "')");
            Discount discount = depositRepository.validateVoucher(voucherCode.trim());
            if (discount == null) {
                LOGGER.warning("Invalid or non-existent voucher: " + voucherCode);
                throw new IllegalArgumentException("Invalid or non-existent voucher");
            }
            
            LOGGER.info("Valid voucher: " + discount.getDiscountName() + " (ID: " + discount.getDiscountId() + ")");
            
            // Step 4: Check if user has used this voucher before
            if (depositRepository.hasUserUsedVoucher(userId, discount.getDiscountId())) {
                LOGGER.warning("User has used this voucher before");
                throw new IllegalArgumentException("You have used this voucher before");
            }
            
            // Step 5: Check if booking meets conditions
            double minOrderAmount = discount.getMinOrderAmount() != null ? 
                discount.getMinOrderAmount().doubleValue() : 0.0;
            
            if (!depositRepository.isBookingEligibleForVoucher(bookingId, minOrderAmount)) {
                LOGGER.warning("Booking does not meet voucher conditions");
                throw new IllegalArgumentException("Order does not meet conditions for this voucher");
            }
            
            // Step 6: Update discount for booking
            boolean updateSuccess = depositRepository.updateBookingDiscount(bookingId, discount.getDiscountId());
            if (!updateSuccess) {
                LOGGER.severe("Cannot update discount for booking");
                throw new Exception("Cannot apply voucher to booking");
            }
            
            // Step 7: Record voucher usage
            boolean recordSuccess = depositRepository.recordVoucherUsage(userId, discount.getDiscountId());
            if (!recordSuccess) {
                LOGGER.warning("Cannot record voucher usage, but voucher has been applied");
                // Don't throw exception because voucher was applied successfully
            }
            
            LOGGER.info("Voucher applied successfully: " + discount.getDiscountName());
            LOGGER.info("=== END APPLYING VOUCHER ===");
            
            return true;
            
        } catch (SecurityException | IllegalArgumentException e) {
            LOGGER.warning("Voucher validation failed: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error applying voucher", e);
            throw new Exception("An error occurred while applying voucher: " + e.getMessage());
        }
    }

    @Override
    public boolean removeVoucher(UUID bookingId, UUID userId) throws Exception {
        LOGGER.info("=== REMOVING VOUCHER ===");
        LOGGER.info("Booking ID: " + bookingId);
        LOGGER.info("User ID: " + userId);
        
        try {
            // Step 1: Check booking ownership
            if (!depositRepository.isBookingOwnedByUser(bookingId, userId)) {
                LOGGER.warning("User does not have permission for this booking");
                throw new SecurityException("Booking does not belong to this user");
            }
            
            // Step 2: Get current booking information
            Booking booking = depositRepository.getBookingForDeposit(bookingId);
            if (booking == null) {
                LOGGER.warning("Booking not found");
                throw new IllegalArgumentException("Booking not found");
            }
            
            // Step 3: Check if booking has voucher
            if (booking.getDiscountId() == null) {
                LOGGER.info("Booking has no voucher to remove");
                return true; // No voucher = successful removal
            }
            
            // Step 4: Remove voucher from booking
            boolean updateSuccess = depositRepository.updateBookingDiscount(bookingId, null);
            if (!updateSuccess) {
                LOGGER.severe("Cannot remove discount from booking");
                throw new Exception("Cannot remove voucher from booking");
            }
            
            LOGGER.info("Voucher removed from booking successfully");
            LOGGER.info("=== END REMOVING VOUCHER ===");
            
            return true;
            
        } catch (SecurityException | IllegalArgumentException e) {
            LOGGER.warning("Voucher removal validation failed: " + e.getMessage());
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error removing voucher", e);
            throw new Exception("An error occurred while removing voucher: " + e.getMessage());
        }
    }

    @Override
    public boolean agreeToTerms(UUID bookingId, UUID userId, String termsVersion) throws Exception {
        // Check permission
        if (!depositRepository.isBookingOwnedByUser(bookingId, userId)) {
            throw new SecurityException("No permission for this booking");
        }

        // Update terms agreement
        return depositRepository.updateTermsAgreement(bookingId, true, termsVersion);
    }

    @Override
    public DepositPageDTO recalculateCost(UUID bookingId) throws Exception {
        // Get booking again and calculate
        Booking booking = depositRepository.getBookingForDeposit(bookingId);
        if (booking == null) {
            throw new IllegalArgumentException("Booking not found");
        }
        
        // Get car info
        Repository.Deposit.DepositRepository.CarInfoForDeposit carInfo = 
            ((Repository.Deposit.DepositRepository) depositRepository).getCarInfoByBookingId(bookingId);
        
        DepositPageDTO dto = new DepositPageDTO();
        mapBookingInfoToDTO(booking, dto);
        
        if (carInfo != null) {
            mapCarInfoToDTO(carInfo, dto);
        }
        
        calculateDurationUsingDurationResult(booking, dto);
        
        List<InsuranceDetailDTO> insuranceList = getInsuranceList(bookingId);
        dto.setInsuranceDetails(insuranceList);
        
        calculateAllPricing(booking, dto);
        return dto;
    }

    @Override
    public boolean isBookingOwnedByUser(UUID bookingId, UUID userId) throws Exception {
        return depositRepository.isBookingOwnedByUser(bookingId, userId);
    }

    // ========== HELPER METHODS - SIMPLE AND EASY TO UNDERSTAND ==========
    
    /**
     * Copy information from Booking entity to DTO
     */
    private void mapBookingInfoToDTO(Booking booking, DepositPageDTO dto) {
        dto.setBookingId(booking.getBookingId());
        dto.setBookingCode(booking.getBookingCode());
        dto.setCustomerName(booking.getCustomerName());
        dto.setCustomerPhone(booking.getCustomerPhone());
        dto.setCustomerEmail(booking.getCustomerEmail());
        dto.setPickupDateTime(booking.getPickupDateTime());
        dto.setReturnDateTime(booking.getReturnDateTime());
        dto.setRentalType(booking.getRentalType()); // ADD THIS LINE
        dto.setTermsAgreed(booking.isTermsAgreed());
        dto.setTermsAgreedAt(booking.getTermsAgreedAt());
        
        // Get terms from DB by version
        try {
            Terms terms = termsRepository.findByVersion(booking.getTermsVersion());
            if (terms != null) {
                dto.setTermsVersion(terms.getVersion());
                dto.setTermsTitle(terms.getTitle());
                dto.setTermsShortContent(terms.getShortContent());
                dto.setTermsFullContent(terms.getFullContent());
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting terms from DB", e);
        }
    }

    /**
     * Map vehicle information - NEWLY ADDED
     */
    private void mapCarInfoToDTO(Repository.Deposit.DepositRepository.CarInfoForDeposit carInfo, DepositPageDTO dto) {
        dto.setCarModel(carInfo.getCarModel());
        dto.setCarBrand(carInfo.getCarBrand());
        dto.setLicensePlate(carInfo.getLicensePlate());
        dto.setCarSeats(carInfo.getCarSeats());
    }

    /**
     * Calculate duration using DurationResult - REUSED FROM BOOKINGSERVICE
     */
    private void calculateDurationUsingDurationResult(Booking booking, DepositPageDTO dto) {
        if (booking.getPickupDateTime() != null && booking.getReturnDateTime() != null) {
            String rentalType = booking.getRentalType() != null ? booking.getRentalType() : "daily";
            
            LOGGER.info("=== DURATION CALCULATION DEBUG ===");
            LOGGER.info("Booking ID: " + booking.getBookingId());
            LOGGER.info("Rental Type: " + rentalType);
            LOGGER.info("Pickup: " + booking.getPickupDateTime());
            LOGGER.info("Return: " + booking.getReturnDateTime());
            
            // Use logic from BookingService
            DurationResult durationResult = calculateDuration(
                booking.getPickupDateTime(), 
                booking.getReturnDateTime(), 
                rentalType
            );
            
            // Set duration from DurationResult
            dto.setDuration(durationResult.getBillingUnitsAsDouble());
            
            LOGGER.info(String.format("Duration calculation result: %s %s %s", 
                durationResult.getBillingUnits(), 
                durationResult.getUnitType(),
                durationResult.getNote() != null ? "(" + durationResult.getNote() + ")" : ""
            ));
            LOGGER.info("=== END DURATION CALCULATION ===");
        } else {
            dto.setDuration(1.0); // Default 1 day
            LOGGER.warning("Pickup or Return time is null, using default duration 1.0");
        }
    }

    /**
     * REUSE DURATION LOGIC FROM BOOKINGSERVICE
     * Calculate rental duration by type with minimum rules
     */
    public DurationResult calculateDuration(java.time.LocalDateTime start, java.time.LocalDateTime end, String rentalType) {
        if (start == null || end == null) {
            throw new IllegalArgumentException("Start and end time cannot be null");
        }

        if (end.isBefore(start)) {
            throw new IllegalArgumentException("End time must be after start time");
        }

        Duration duration = Duration.between(start, end);

        switch (rentalType.toLowerCase()) {
            case "hourly":
                return calculateHourlyDuration(duration);
            case "daily":
                return calculateDailyDuration(duration);
            case "monthly":
                return calculateMonthlyDuration(duration);
            default:
                return calculateDailyDuration(duration); // Default is daily
        }
    }

    /**
     * Calculate hourly duration - SYNCHRONIZED WITH BOOKINGSERVICE
     * Update: If rental time exceeds 24 hours, recommend switching to daily rental
     */
    private DurationResult calculateHourlyDuration(Duration duration) {
        double actualHours = duration.toMinutes() / 60.0;
        double ceilHours = Math.ceil(actualHours);
        double billingHours = Math.max(ceilHours, MIN_HOURLY_DURATION);
        
        String note = null;
        if (actualHours < MIN_HOURLY_DURATION) {
            note = "Minimum 4 hours applied";
        } else if (actualHours > 24.0) {
            note = "Rental time exceeds 24 hours, recommend switching to daily rental";
        }

        return new DurationResult(
                BigDecimal.valueOf(billingHours).setScale(2, RoundingMode.HALF_UP),
                "hour",
                note
        );
    }

    /**
     * Calculate daily duration - SYNCHRONIZED WITH BOOKINGSERVICE
     * Update: If rental time is under 24 hours, automatically switch to hourly calculation
     * If rental time is 24 hours or more, calculate by day
     */
    private DurationResult calculateDailyDuration(Duration duration) {
        double totalHours = duration.toMinutes() / 60.0;
        
        // If rental time is under 24 hours, automatically switch to hourly calculation
        if (totalHours < 24.0) {
            // Apply hourly calculation rules (minimum 4 hours)
            double ceilHours = Math.ceil(totalHours);
            double billingHours = Math.max(ceilHours, MIN_HOURLY_DURATION);
            
            return new DurationResult(
                BigDecimal.valueOf(billingHours).setScale(2, RoundingMode.HALF_UP),
                "hour", // Unit is hours
                "Rental time under 24 hours, automatically calculated by hour"
            );
        } 
        // If rental time is 24 hours or more, calculate by day
        else {
            // Calculate number of days and round up
            double days = totalHours / 24.0;
            double billingDays = Math.ceil(days);

        return new DurationResult(
                BigDecimal.valueOf(billingDays).setScale(2, RoundingMode.HALF_UP),
                "day",
                null
        );
        }
    }

    /**
     * Calculate monthly duration - SYNCHRONIZED WITH BOOKINGSERVICE
     */
    private DurationResult calculateMonthlyDuration(Duration duration) {
        double totalDays = duration.toHours() / 24.0;
        double actualMonths = totalDays / DAYS_PER_MONTH;
        double billingMonths = Math.max(actualMonths, MIN_MONTHLY_DURATION);
        billingMonths = Math.round(billingMonths * 100.0) / 100.0;

        return new DurationResult(
                BigDecimal.valueOf(billingMonths).setScale(2, RoundingMode.HALF_UP),
                "month",
                actualMonths < MIN_MONTHLY_DURATION ? "Minimum 0.5 month applied" : null
        );
    }

    /**
     * CALCULATE VEHICLE INSURANCE PER DAY USING STUDENT-PROVIDED FORMULA
     * 
     * Formula:
     * 1. Estimate vehicle value = Daily rental price × 365 × Year usage coefficient  
     * 2. Vehicle insurance fee PER DAY = Vehicle value × 2% / 365
     *    = (Daily rental price × 365 × Year coefficient) × 0.02 / 365
     * 
     * NOTE: Database stores divided by 1000, calculate with actual VND then divide by 1000 to return DB value
     * 
     * Return: Vehicle insurance fee PER DAY (DB unit)
     */
    private double calculateVehicleInsurance(Booking booking) {
        try {
            LOGGER.info("=== CALCULATING VEHICLE INSURANCE ===");
            LOGGER.info("Booking ID: " + booking.getBookingId());
            LOGGER.info("Total Amount (DB value): " + booking.getTotalAmount());
            
            // Convert from database value to actual VND
            double actualTotalAmount = booking.getTotalAmount() * 1000;
            LOGGER.info("Actual Total Amount (VND for calculation): " + actualTotalAmount);
            
            // Step 1: Estimate daily rental price (actual VND)
            double dailyRateVND = estimateDailyRateWithActualValue(booking, actualTotalAmount);
            LOGGER.info("Estimated daily rate: " + dailyRateVND + " VND");

            // Step 2: Determine year usage coefficient based on rental price
            double yearCoefficient = getYearCoefficient(dailyRateVND);
            LOGGER.info("Year coefficient: " + yearCoefficient);

            // Step 3: Calculate new vehicle value (actual VND)
            double estimatedCarValue = dailyRateVND * 365 * yearCoefficient;
            LOGGER.info("Estimated car value: " + estimatedCarValue + " VND");
            
            // Step 4: Calculate vehicle insurance fee PER DAY (actual VND)
            double vehicleInsurancePerDayVND = estimatedCarValue * VEHICLE_INSURANCE_RATE / 365;
            LOGGER.info("Vehicle insurance per day (VND): " + vehicleInsurancePerDayVND);
            
            // Convert to DB unit (divide by 1000) to assign to DTO
            double vehicleInsurancePerDayDB = vehicleInsurancePerDayVND / 1000;
            vehicleInsurancePerDayDB = Math.round(vehicleInsurancePerDayDB * 1000.0) / 1000.0;
            
            LOGGER.info("Vehicle insurance per day: " + vehicleInsurancePerDayVND + " VND → " + vehicleInsurancePerDayDB + " (DB value for DTO)");
            LOGGER.info("=== END VEHICLE INSURANCE CALCULATION ===");

            return vehicleInsurancePerDayDB;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error calculating vehicle insurance", e);
            return 0.0;
        }
    }

    /**
     * Check if number of seats is suitable for TNDS insurance range
     */
    private boolean isApplicableSeatRange(int seats, String seatRange) {
        if (seatRange == null) return true;
        
        if (seatRange.equals("1-5")) return seats <= 5;
        if (seatRange.equals("6-11")) return seats >= 6 && seats <= 11;
        if (seatRange.equals("12+")) return seats >= 12;
        
        return true;
    }

    /**
     * Get insurance list for booking, filter TNDS by number of seats
     * Ensure only one vehicle insurance and one accident insurance are displayed if available
     */
    private List<InsuranceDetailDTO> getInsuranceList(UUID bookingId) throws Exception {
        List<InsuranceDetailDTO> insuranceList = new ArrayList<>();
        
        try {
            // Get booking insurance list from database
            List<BookingInsurance> bookingInsurances = depositRepository.getBookingInsurancesByBookingId(bookingId);
            LOGGER.info("Found " + bookingInsurances.size() + " booking insurances from database");

            // Create map to store insurance by type (keep only one insurance for each type)
            java.util.Map<String, InsuranceDetailDTO> insuranceMap = new java.util.HashMap<>();

            // For each booking insurance, get detailed information
            for (BookingInsurance bookingInsurance : bookingInsurances) {
                Insurance insurance = depositRepository.getInsuranceById(bookingInsurance.getInsuranceId());

                if (insurance != null) {
                    LOGGER.info("Processing insurance: " + insurance.getInsuranceName() + 
                            " (Type: " + insurance.getInsuranceType() + ", Premium: " + 
                            bookingInsurance.getPremiumAmount() + ")");
                    
                    // Check if TNDS is suitable for number of seats
                    if ("TaiNan".equals(insurance.getInsuranceType())) {
                        String seatRange = insurance.getApplicableCarSeats();
                        int carSeats = bookingInsurance.getCarSeats();
                        if (!isApplicableSeatRange(carSeats, seatRange)) {
                            LOGGER.info("Skipping insurance - seat range not applicable: " + seatRange + 
                                    " for car with " + carSeats + " seats");
                            continue;
                        }
                    }

                    String insuranceType = insurance.getInsuranceType();
                    
                    // If insurance of this type already exists, only update if premium is higher
                    if (insuranceMap.containsKey(insuranceType)) {
                        InsuranceDetailDTO existingDto = insuranceMap.get(insuranceType);
                        if (bookingInsurance.getPremiumAmount() > existingDto.getPremiumAmount()) {
                            LOGGER.info("Updating existing insurance with higher premium: " + 
                                    bookingInsurance.getPremiumAmount() + " > " + existingDto.getPremiumAmount());
                            existingDto.setPremiumAmount(bookingInsurance.getPremiumAmount());
                            existingDto.setInsuranceName(insurance.getInsuranceName());
                            existingDto.setDescription(insurance.getDescription());
                        }
                    } else {
                        // If not exists, add to map
                        InsuranceDetailDTO dto = new InsuranceDetailDTO();
                        dto.setInsuranceName(insurance.getInsuranceName());
                        dto.setInsuranceType(insuranceType);
                        dto.setPremiumAmount(bookingInsurance.getPremiumAmount());
                        dto.setDescription(insurance.getDescription());
                        
                        insuranceMap.put(insuranceType, dto);
                        LOGGER.info("Added insurance: " + insurance.getInsuranceName() + 
                                " (" + insuranceType + ") = " + bookingInsurance.getPremiumAmount() + " (DB value)");
                    }
                } else {
                    LOGGER.warning("Insurance not found for ID: " + bookingInsurance.getInsuranceId());
                }
            }

            // Convert from map to list
            insuranceList.addAll(insuranceMap.values());
            
            LOGGER.info("Final insurance list contains " + insuranceList.size() + " items:");
            for (InsuranceDetailDTO dto : insuranceList) {
                LOGGER.info("- " + dto.getInsuranceName() + " (" + dto.getInsuranceType() + "): " + 
                        dto.getPremiumAmount() + " (DB value)");
            }

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting insurance information for booking " + bookingId, e);
            // Return empty list instead of throwing exception
        }

        return insuranceList;
    }

    /**
     * Calculate all pricing - SIMPLE LOGIC
     * Logic: Rental price + Insurance - Discount + VAT = Total
     *        Deposit = 300,000 VND (hardcode)
     * NOTE: Keep DB values for calculation, display formatting will handle × 1000
     */
    private void calculateAllPricing(Booking booking, DepositPageDTO dto) throws Exception {
        try {
            LOGGER.info("=== CALCULATING ALL PRICING ===");
            
            // Get insurance information from database
            List<InsuranceDetailDTO> insuranceDetails = dto.getInsuranceDetails();
            
            // Calculate total insurance amount from detail list
            double totalInsuranceAmount = 0.0;
            for (InsuranceDetailDTO insurance : insuranceDetails) {
                totalInsuranceAmount += insurance.getPremiumAmount();
                LOGGER.info("Insurance: " + insurance.getInsuranceName() + " = " + insurance.getPremiumAmount() + " (DB value)");
            }
            LOGGER.info("Total insurance amount from details: " + totalInsuranceAmount + " (DB value)");
            
            // Get total insurance amount from repository to verify
            double repoInsuranceAmount = depositRepository.getTotalInsuranceAmount(booking.getBookingId());
            LOGGER.info("Total insurance amount from repository: " + repoInsuranceAmount + " (DB value)");
            
            // Use total insurance amount from details to ensure accuracy
            double insuranceAmount = totalInsuranceAmount;
            
            // Calculate base rental price = booking.totalAmount - insuranceAmount
            double baseAmount = booking.getTotalAmount() - insuranceAmount;
            LOGGER.info("Base amount calculation: " + booking.getTotalAmount() + " - " + insuranceAmount + " = " + baseAmount + " (DB value)");
            
            // Step 3: Calculate discount from voucher (If any)
            double discountAmount = 0.0;
            if (booking.getDiscountId() != null) {
                try {
                    Discount discount = depositRepository.getDiscountById(booking.getDiscountId());
                    if (discount != null) {
                        discountAmount = calculateDiscountAmount(baseAmount, discount);
                        LOGGER.info("Discount applied: " + discount.getDiscountName() + " = " + discountAmount + " (DB value)");
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error calculating discount", e);
                }
            }
            LOGGER.info("Discount amount: " + discountAmount + " (DB value)");
            
            // Step 4: Calculate subtotal = base + insurance - discount
            double subtotal = baseAmount + insuranceAmount - discountAmount;
            LOGGER.info("Subtotal: " + baseAmount + " + " + insuranceAmount + " - " + discountAmount + " = " + subtotal);
            
            // Step 5: Calculate VAT = subtotal * 10%
            double vatAmount = subtotal * VAT_PERCENTAGE;
            LOGGER.info("VAT (10%): " + subtotal + " × " + VAT_PERCENTAGE + " = " + vatAmount);
            
            // Step 6: Total = subtotal + VAT
            double totalAmount = subtotal + vatAmount;
            LOGGER.info("Total: " + subtotal + " + " + vatAmount + " = " + totalAmount);
            
            // Step 7: Deposit = 300,000 VND (hardcode)
            // Convert from VND to DB unit (divide by 1000)
            double depositAmount = 300.0; // 300,000 VND = 300 DB units
            LOGGER.info("Deposit (hardcode): 300,000 VND = " + depositAmount + " (DB value)");

            // Assign to DTO (DB values, format methods will handle display)
            dto.setBaseRentalPrice(baseAmount);
            dto.setTotalInsuranceAmount(insuranceAmount);
            dto.setDiscountAmount(discountAmount);
            dto.setSubtotal(subtotal);
            dto.setVatAmount(vatAmount);
            dto.setTotalAmount(totalAmount);
            dto.setDepositAmount(depositAmount);
            
            LOGGER.info("=== END PRICING CALCULATION ===");
            LOGGER.info("Final deposit amount: " + depositAmount + " (DB value) - JSP will show with 000 VND suffix");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error calculating pricing for booking " + booking.getBookingId(), e);
            
            // If error, use default values to avoid crash
            double baseAmount = booking.getTotalAmount();
            dto.setBaseRentalPrice(baseAmount);
            dto.setTotalInsuranceAmount(0.0);
            dto.setDiscountAmount(0.0);
            dto.setSubtotal(baseAmount);
            dto.setVatAmount(baseAmount * VAT_PERCENTAGE);
            dto.setTotalAmount(baseAmount * (1 + VAT_PERCENTAGE));
            dto.setDepositAmount(300.0); // 300,000 VND = 300 DB units
        }
    }
    
    /**
     * Calculate discount amount based on discount type
     * @param baseAmount Base amount (DB value)
     * @param discount Discount entity
     * @return Discount amount (DB value)
     */
    private double calculateDiscountAmount(double baseAmount, Discount discount) {
        if (discount == null || discount.getDiscountValue() == null) {
            return 0.0;
        }
        
        double discountValue = discount.getDiscountValue().doubleValue();
        double calculatedDiscount = 0.0;
        
        if ("Percent".equals(discount.getDiscountType()) || "Percentage".equals(discount.getDiscountType())) {
            // Calculate by percentage
            calculatedDiscount = baseAmount * (discountValue / 100.0);
        } else if ("Fixed".equals(discount.getDiscountType())) {
            // Calculate by fixed amount (convert from VND to DB value)
            calculatedDiscount = discountValue / 1000.0;
        }
        
        // Check maximum discount limit
        if (discount.getMaxDiscountAmount() != null) {
            double maxDiscount = discount.getMaxDiscountAmount().doubleValue() / 1000.0; // Convert from VND to DB
            if (calculatedDiscount > maxDiscount) {
                calculatedDiscount = maxDiscount;
            }
        }
        
        // Ensure discount does not exceed base amount
        if (calculatedDiscount > baseAmount) {
            calculatedDiscount = baseAmount;
        }
        
        // Round to 3 decimal places
        calculatedDiscount = Math.round(calculatedDiscount * 1000.0) / 1000.0;
        
        LOGGER.info("Discount calculation: " + discount.getDiscountType() + " " + discountValue + 
                   " = " + calculatedDiscount + " (DB value)");
        
        return calculatedDiscount;
    }

    // getTotalInsuranceAmount method has been removed and used directly from repository
    
    /**
     * Estimate daily rental price from booking.totalAmount
     */
    private double estimateDailyRate(Booking booking) {
        LOGGER.info("--- Estimating daily rate ---");
        
        // Calculate rental days using DurationResult for accuracy
        DurationResult durationResult = calculateDuration(
            booking.getPickupDateTime(), 
            booking.getReturnDateTime(), 
            booking.getRentalType() != null ? booking.getRentalType() : "daily"
        );
        
        double rentalDays = durationResult.getBillingUnitsAsDouble();
        LOGGER.info("Duration result: " + durationResult.getBillingUnits() + " " + durationResult.getUnitType());
        
        // Convert to days
        if ("hour".equals(durationResult.getUnitType())) {
            rentalDays = rentalDays / 24.0;
            LOGGER.info("Converted " + durationResult.getBillingUnits() + " hours to " + rentalDays + " days");
        } else if ("month".equals(durationResult.getUnitType())) {
            rentalDays = rentalDays * 30;
            LOGGER.info("Converted " + durationResult.getBillingUnits() + " months to " + rentalDays + " days");
        }
        
        if (rentalDays <= 0) {
            rentalDays = 1;
            LOGGER.info("Rental days was <= 0, set to 1");
        }

        // Estimate daily price = totalAmount / number of days
        double dailyRate = booking.getTotalAmount() / rentalDays;
        LOGGER.info("Daily rate calculation: " + booking.getTotalAmount() + " / " + rentalDays + " = " + dailyRate);
        
        return dailyRate;
    }

    /**
     * Estimate daily rental price from actual value (multiplied by 1000)
     * Used for vehicle insurance calculation with accurate VND value
     */
    private double estimateDailyRateWithActualValue(Booking booking, double actualTotalAmount) {
        LOGGER.info("--- Estimating daily rate with actual VND value ---");
        
        // Calculate rental days using DurationResult for accuracy
        DurationResult durationResult = calculateDuration(
            booking.getPickupDateTime(), 
            booking.getReturnDateTime(), 
            booking.getRentalType() != null ? booking.getRentalType() : "daily"
        );
        
        double rentalDays = durationResult.getBillingUnitsAsDouble();
        LOGGER.info("Duration result: " + durationResult.getBillingUnits() + " " + durationResult.getUnitType());
        
        // Convert to days
        if ("hour".equals(durationResult.getUnitType())) {
            rentalDays = rentalDays / 24.0;
            LOGGER.info("Converted " + durationResult.getBillingUnits() + " hours to " + rentalDays + " days");
        } else if ("month".equals(durationResult.getUnitType())) {
            rentalDays = rentalDays * 30;
            LOGGER.info("Converted " + durationResult.getBillingUnits() + " months to " + rentalDays + " days");
        }
        
        if (rentalDays <= 0) {
            rentalDays = 1;
            LOGGER.info("Rental days was <= 0, set to 1");
        }

        // Estimate daily price = actualTotalAmount / number of days
        double dailyRate = actualTotalAmount / rentalDays;
        LOGGER.info("Daily rate calculation: " + actualTotalAmount + " VND / " + rentalDays + " days = " + dailyRate + " VND/day");
        
        return dailyRate;
    }

    /**
     * Determine year usage coefficient based on daily rental price
     * 
     * Rules:
     * - ≤ 500k: coefficient = 5
     * - ≤ 800k: coefficient = 7  
     * - ≤ 1,200k: coefficient = 10
     * - > 1,200k: coefficient = 15
     */
    private double getYearCoefficient(double dailyRate) {
        if (dailyRate <= 500000) {
            return COEFFICIENT_LOW;
        } else if (dailyRate <= 800000) {
            return COEFFICIENT_MEDIUM;
        } else if (dailyRate <= 1200000) {
            return COEFFICIENT_HIGH;
        } else {
            return COEFFICIENT_LUXURY;
        }
    }
}
