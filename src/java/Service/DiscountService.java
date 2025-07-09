package Service;

import Model.Entity.Discount;
import Repository.DiscountRepository;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class DiscountService {
    private final DiscountRepository discountRepository;

    public DiscountService() {
        this.discountRepository = new DiscountRepository();
    }

    public List<Discount> getAllDiscounts() throws SQLException {
        return discountRepository.findAll();
    }

    public Discount getDiscountById(UUID discountId) throws SQLException {
        return discountRepository.findById(discountId);
    }

    public Discount findById(UUID discountId) throws SQLException {
        if (discountId == null) {
            throw new IllegalArgumentException("Discount ID cannot be null");
        }
        return discountRepository.findById(discountId);
    }

    public void addDiscount(Discount discount) throws SQLException {
        // Basic validation
        if (discount.getDiscountName() == null || discount.getDiscountName().isEmpty()) {
            throw new IllegalArgumentException("Discount name is required");
        }
        if (!"Percent".equals(discount.getDiscountType()) && !"Fixed".equals(discount.getDiscountType())) {
            throw new IllegalArgumentException("Discount type must be Percent or Fixed");
        }
        if (discount.getDiscountValue().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Discount value must be non-negative");
        }
        if (!"General".equals(discount.getDiscountCategory()) && !"Voucher".equals(discount.getDiscountCategory())) {
            throw new IllegalArgumentException("Discount category must be General or Voucher");
        }
        discountRepository.save(discount);
    }

    public void updateDiscount(Discount discount) throws SQLException {
        // Basic validation
        if (discount.getDiscountName() == null || discount.getDiscountName().isEmpty()) {
            throw new IllegalArgumentException("Discount name is required");
        }
        if (!"Percent".equals(discount.getDiscountType()) && !"Fixed".equals(discount.getDiscountType())) {
            throw new IllegalArgumentException("Discount type must be Percent or Fixed");
        }
        if (discount.getDiscountValue().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Discount value must be non-negative");
        }
        if (!"General".equals(discount.getDiscountCategory()) && !"Voucher".equals(discount.getDiscountCategory())) {
            throw new IllegalArgumentException("Discount category must be General or Voucher");
        }
        discountRepository.update(discount);
    }

    public void deleteDiscount(String discountId) throws SQLException {
        if (discountId == null || discountId.trim().isEmpty()) {
            throw new IllegalArgumentException("Không tìm thấy Discount ID");
        }
        int affectedRows = discountRepository.delete(discountId.trim());
        if (affectedRows == 0) {
            throw new IllegalArgumentException("Voucher không tồn tại");
        }
    }
}
