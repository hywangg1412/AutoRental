package Model.booking;

import Model.Location;
import java.util.Date;

public class Booking {
    private int bookingId;
    private int userId;
    private int carId;
    private Date startDate;
    private Date endDate;
    private Location location;
    private double totalAmount;
    private String status;

    
    public Location getLocation() {
        return location;
    }

    public void setLocation(Location location) {
        this.location = location;
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
        return "Booking{" + "bookingId=" + bookingId + ", userId=" + userId + ", carId=" + carId + ", startDate=" + startDate + ", endDate=" + endDate + ", location=" + location + ", totalAmount=" + totalAmount + ", status=" + status + '}';
    }

}
