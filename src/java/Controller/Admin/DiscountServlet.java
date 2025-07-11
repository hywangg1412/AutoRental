package Controller.Admin;

import Model.Entity.Discount;
import Service.DiscountService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/discount")
public class DiscountServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DiscountServlet.class.getName());
    private DiscountService discountService;

    @Override
    public void init() throws ServletException {
        discountService = new DiscountService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // lay Discount ha
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if ("check".equals(action)) {
            String checkId = request.getParameter("id");
            response.setContentType("application/json");
            try (PrintWriter out = response.getWriter()) {
                if (checkId == null || checkId.trim().isEmpty()) {
                    out.println("{\"exists\":false, \"error\":\"ID voucher không được để trống!\"}");
                } else {
                    try {
                        UUID checkUuid = UUID.fromString(checkId.trim());
                        Discount discount = discountService.findById(checkUuid);
                        out.println("{\"exists\":" + (discount != null) + "}");
                    } catch (IllegalArgumentException e) {
                        out.println("{\"exists\":false, \"error\":\"ID voucher không hợp lệ!\"}");
                    } catch (SQLException ex) {
                        Logger.getLogger(DiscountServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
            return;
        }
        
        LOGGER.info("=== DISCOUNT SERVLET DEBUG ===");
        LOGGER.info("Request URI: " + request.getRequestURI());
        LOGGER.info("Request URL: " + request.getRequestURL());
        
        try {
            LOGGER.info("Calling discountService.getAllDiscounts()...");
            List<Discount> discounts = discountService.getAllDiscounts();
            LOGGER.info("Retrieved " + discounts.size() + " discounts");
            
           
            for (int i = 0; i < discounts.size(); i++) {
                Discount d = discounts.get(i);
                LOGGER.info("Discount " + i + ": ID=" + d.getDiscountId() + ", Name=" + d.getDiscountName());
            }
            
            request.setAttribute("discounts", discounts);
            LOGGER.info("Set discounts attribute to request");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to fetch discounts", e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        }
        
        LOGGER.info("Forwarding to JSP...");
        request.getRequestDispatcher("/pages/admin/manage-vouchers.jsp").forward(request, response);
        LOGGER.info("=== END DEBUG ===");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        String message = null;
        String error = null;

        try {
            if (action == null || action.trim().isEmpty()) {
                throw new IllegalArgumentException("Hành động không được để trống");
            }

            switch (action) {
                case "add":
                    Discount newDiscount = createDiscountFromRequest(request);
                    newDiscount.setDiscountId(UUID.randomUUID());
                    discountService.addDiscount(newDiscount);
                    message = "Thêm voucher thành công!";
                    LOGGER.info("Added discount ID: " + newDiscount.getDiscountId());
                    break;

                case "edit":
                    String editId = request.getParameter("discountId");
                    if (editId == null || editId.trim().isEmpty()) {
                        throw new IllegalArgumentException("ID voucher không được để trống");
                    }
                    UUID editUuid = UUID.fromString(editId.trim());
                    Discount updatedDiscount = createDiscountFromRequest(request);
                    updatedDiscount.setDiscountId(editUuid);
                    discountService.updateDiscount(updatedDiscount);
                    message = "Cập nhật voucher thành công!";
                    LOGGER.info("Updated discount ID: " + editUuid);
                    break;

                case "delete":
                    String deleteId = request.getParameter("id");
                    LOGGER.info("Delete request with ID: " + deleteId);
                    if (deleteId == null || deleteId.trim().isEmpty()) {
                        error = "Không tìm thấy Discount ID";
                        LOGGER.warning(error);
                        String accept = request.getHeader("Accept");
                        if (accept != null && accept.contains("application/json")) {
                            response.setContentType("application/json");
                            response.getWriter().write("{\"success\":false, \"error\":\"Không tìm thấy Discount ID\"}");
                            return;
                        }
                        break;
                    }
                    try {
                        discountService.deleteDiscount(deleteId.trim());
                        message = "Xóa voucher thành công!";
                        LOGGER.info("Deleted discount ID: " + deleteId);
                    } catch (IllegalArgumentException e) {
                        error = e.getMessage();
                        LOGGER.warning(error);
                    } catch (SQLException e) {
                        error = "Lỗi cơ sở dữ liệu: " + e.getMessage();
                        LOGGER.log(Level.SEVERE, "Database error during delete", e);
                    }
                    break;

                case "check":
                    String checkId = request.getParameter("id");
                    LOGGER.info("Check request with ID: " + checkId);
                    response.setContentType("application/json");
                    try (PrintWriter out = response.getWriter()) {
                        if (checkId == null || checkId.trim().isEmpty()) {
                            out.println("{\"exists\":false, \"error\":\"ID voucher không được để trống!\"}");
                            LOGGER.warning("Check failed: ID is null or empty");
                        } else {
                            try {
                                UUID checkUuid = UUID.fromString(checkId.trim());
                                Discount discount = discountService.findById(checkUuid);
                                out.println("{\"exists\":" + (discount != null) + "}");
                                LOGGER.info("Check ID " + checkUuid + ": " + (discount != null));
                            } catch (IllegalArgumentException e) {
                                out.println("{\"exists\":false, \"error\":\"ID voucher không hợp lệ!\"}");
                                LOGGER.warning("Check failed: Invalid UUID format: " + checkId);
                            }
                        }
                    }
                    return;

                default:
                    throw new IllegalArgumentException("Hành động không hợp lệ: " + action);
            }
        } catch (IllegalArgumentException e) {
            error = e.getMessage();
            LOGGER.warning("Validation error: " + error);
        } catch (SQLException e) {
            error = "Lỗi cơ sở dữ liệu: " + e.getMessage();
            LOGGER.log(Level.SEVERE, "Database error during action: " + action, e);
        } catch (ParseException e) {
            error = "Lỗi định dạng ngày: " + e.getMessage();
            LOGGER.log(Level.SEVERE, "Date parsing error during action: " + action, e);
        }

        // reload lai discount cái 
        try {
            List<Discount> discounts = discountService.getAllDiscounts();
            request.setAttribute("discounts", discounts);
        } catch (SQLException e) {
            error = "Lỗi cơ sở dữ liệu khi tải danh sách voucher: " + e.getMessage();
            LOGGER.log(Level.SEVERE, "Failed to reload discounts", e);
        }

        if (message != null) {
            request.setAttribute("message", message);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }
        if (!"check".equals(action)) {
            request.getRequestDispatcher("/pages/admin/manage-vouchers.jsp").forward(request, response);
        }
    }

    private Discount createDiscountFromRequest(HttpServletRequest request) throws ParseException {
        Discount discount = new Discount();
        discount.setDiscountName(request.getParameter("discountName"));
        discount.setDescription(request.getParameter("description"));
        discount.setDiscountType(request.getParameter("discountType"));
        discount.setDiscountValue(new BigDecimal(request.getParameter("discountValue")));
        discount.setStartDate(parseDate(request.getParameter("startDate")));
        discount.setEndDate(parseDate(request.getParameter("endDate")));
        discount.setIsActive("on".equals(request.getParameter("isActive")));
        discount.setCreatedDate(new Date());
        discount.setVoucherCode(request.getParameter("voucherCode"));
        discount.setMinOrderAmount(new BigDecimal(request.getParameter("minOrderAmount")));
        String maxDiscountAmount = request.getParameter("maxDiscountAmount");
        discount.setMaxDiscountAmount(maxDiscountAmount != null && !maxDiscountAmount.isEmpty() ? new BigDecimal(maxDiscountAmount) : null);
        String usageLimit = request.getParameter("usageLimit");
        discount.setUsageLimit(usageLimit != null && !usageLimit.isEmpty() ? Integer.parseInt(usageLimit) : null);
        String usedCount = request.getParameter("usedCount");
        discount.setUsedCount(usedCount != null && !usedCount.isEmpty() ? Integer.parseInt(usedCount) : 0);
        discount.setDiscountCategory(request.getParameter("discountCategory"));
        return discount;
    }

    private Date parseDate(String dateStr) throws ParseException {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.parse(dateStr);
    }
}