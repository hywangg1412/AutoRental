
package Model.Entity;

import java.util.Date;

public class Contract {
    private int contractId;
    private int userId;
    private int bookingId;
    private int carId;
    private double depositAmount;
    private String contractContent;
    private Date startDate;
    private Date endDate;
    private double estimatedPrice;
    private String companyRepresentative;

    public Contract() {
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public double getDepositAmount() {
        return depositAmount;
    }

    public void setDepositAmount(double depositAmount) {
        this.depositAmount = depositAmount;
    }

    public String getContractContent() {
        return contractContent;
    }

    public void setContractContent(String contractContent) {
        this.contractContent = contractContent;
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

    public double getEstimatedPrice() {
        return estimatedPrice;
    }

    public void setEstimatedPrice(double estimatedPrice) {
        this.estimatedPrice = estimatedPrice;
    }

    public String getCompanyRepresentative() {
        return companyRepresentative;
    }

    public void setCompanyRepresentative(String companyRepresentative) {
        this.companyRepresentative = companyRepresentative;
    }

    @Override
    public String toString() {
        return "Contract{" + "contractId=" + contractId + ", userId=" + userId + ", bookingId=" + bookingId + ", carId=" + carId + ", depositAmount=" + depositAmount + ", contractContent=" + contractContent + ", startDate=" + startDate + ", endDate=" + endDate + ", estimatedPrice=" + estimatedPrice + ", companyRepresentative=" + companyRepresentative + '}';
    }
    
}
