/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.Entity.Booking;

/**
 *
 * @author admin
 */
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Model BookingInsurance - liên kết booking với bảo hiểm Mỗi booking sẽ có 3
 * records: TNDS, VatChat, TaiNan Sử dụng double để khớp với Booking model
 */
public class BookingInsurance {

    private UUID bookingInsuranceId;
    private UUID bookingId;
    private UUID insuranceId;
    private double premiumAmount;        // Phí bảo hiểm đã tính (VND) - DÙNG DOUBLE
    private double rentalDays;           // Số ngày thuê - DÙNG DOUBLE
    private int carSeats;                // Số chỗ ngồi xe
    private double estimatedCarValue;    // Giá trị ước tính xe - DÙNG DOUBLE
    private LocalDateTime createdAt;

    // Constructors
    public BookingInsurance() {
    }

    public BookingInsurance(UUID bookingInsuranceId, UUID bookingId, UUID insuranceId,
            double premiumAmount, double rentalDays, int carSeats,
            double estimatedCarValue, LocalDateTime createdAt) {
        this.bookingInsuranceId = bookingInsuranceId;
        this.bookingId = bookingId;
        this.insuranceId = insuranceId;
        this.premiumAmount = premiumAmount;
        this.rentalDays = rentalDays;
        this.carSeats = carSeats;
        this.estimatedCarValue = estimatedCarValue;
        this.createdAt = createdAt;
    }

    // ========== GETTERS VÀ SETTERS ==========
    public UUID getBookingInsuranceId() {
        return bookingInsuranceId;
    }

    public void setBookingInsuranceId(UUID bookingInsuranceId) {
        this.bookingInsuranceId = bookingInsuranceId;
    }

    public UUID getBookingId() {
        return bookingId;
    }

    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
    }

    public UUID getInsuranceId() {
        return insuranceId;
    }

    public void setInsuranceId(UUID insuranceId) {
        this.insuranceId = insuranceId;
    }

    /**
     * Phí bảo hiểm đã tính cho booking này - chỉ lưu trữ kết quả từ Service
     */
    public double getPremiumAmount() {
        return premiumAmount;
    }

    public void setPremiumAmount(double premiumAmount) {
        this.premiumAmount = premiumAmount;
    }

    /**
     * Số ngày thuê (dùng để tính phí) - chỉ lưu trữ
     */
    public double getRentalDays() {
        return rentalDays;
    }

    public void setRentalDays(double rentalDays) {
        this.rentalDays = rentalDays;
    }

    public int getCarSeats() {
        return carSeats;
    }

    public void setCarSeats(int carSeats) {
        this.carSeats = carSeats;
    }

    /**
     * Giá trị ước tính xe (dùng để tính bảo hiểm vật chất) - chỉ lưu trữ
     */
    public double getEstimatedCarValue() {
        return estimatedCarValue;
    }

    public void setEstimatedCarValue(double estimatedCarValue) {
        this.estimatedCarValue = estimatedCarValue;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "BookingInsurance{"
                + "bookingInsuranceId=" + bookingInsuranceId
                + ", bookingId=" + bookingId
                + ", insuranceId=" + insuranceId
                + ", premiumAmount=" + premiumAmount
                + ", rentalDays=" + rentalDays
                + ", carSeats=" + carSeats
                + ", estimatedCarValue=" + estimatedCarValue
                + ", createdAt=" + createdAt
                + '}';
    }
}
