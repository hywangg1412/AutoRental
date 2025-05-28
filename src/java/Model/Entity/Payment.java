package Model.Entity;

import java.util.Date;

public class Payment {
    private int paymentId;
    private double totalAmount;
    private Date paymentDate;
    private Date paymentStatus;
    private String paymentMethod;

    public Payment() {
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public Date getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(Date paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    @Override
    public String toString() {
        return "Payment{" + "paymentId=" + paymentId + ", totalAmount=" + totalAmount + ", paymentDate=" + paymentDate + ", paymentStatus=" + paymentStatus + ", paymentMethod=" + paymentMethod + '}';
    }
    
}
