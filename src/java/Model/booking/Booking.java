package Model.booking;

import java.util.Date;

public class Booking {
    private int bookingId;
    private int userId;
    private int carId;
    private Date startDate;
    private Date endDate;
    private String pickuplocation;
    private String returnLocation;
    private double totalAmount;
    private String status;

    public Booking() {
    }

    public Booking(int bookingId, int userId, int carId, Date startDate, Date endDate, String pickuplocation, String returnLocation, double totalAmount, String status) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.carId = carId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.pickuplocation = pickuplocation;
        this.returnLocation = returnLocation;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getPickuplocation() {
        return pickuplocation;
    }

    public void setPickuplocation(String pickuplocation) {
        this.pickuplocation = pickuplocation;
    }

    public String getReturnLocation() {
        return returnLocation;
    }

    public void setReturnLocation(String returnLocation) {
        this.returnLocation = returnLocation;
    }
        
    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Booking{" + "bookingId=" + bookingId + ", userId=" + userId + ", carId=" + carId +
                ", startDate=" + startDate + ", endDate=" + endDate + ", pickuplocation=" + pickuplocation + 
                ", returnLocation=" + returnLocation + ", totalAmount=" + totalAmount + ", status=" + status + '}';
    }

}
