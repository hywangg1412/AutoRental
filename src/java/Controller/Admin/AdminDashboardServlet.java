package Controller.Admin;

import Service.User.UserService;
import Service.Car.CarService;
import Service.DiscountService;
import Model.Entity.User.User;
import Model.Entity.Car.Car;
import Model.Entity.Discount;
import Repository.User.UserRepository;
import Repository.Payment.PaymentRepository;
import Model.Entity.Payment.Payment;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.TextStyle;
import java.util.*;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            UserRepository userRepo = new UserRepository();
            UUID userRoleId = UUID.fromString("6BA7B810-9DAD-11D1-80B4-00C04FD430C8");
            UUID staffRoleId = UUID.fromString("6BA7B811-9DAD-11D1-80B4-00C04FD430C8");

            // Lấy toàn bộ user và staff
            List<User> users = userRepo.findByRoleId(userRoleId);
            List<User> staff = userRepo.findByRoleId(staffRoleId);

            // Thống kê user theo trạng thái
            long userActive = users.stream().filter(u -> "ACTIVE".equalsIgnoreCase(u.getStatus())).count();
            long userBanned = users.stream().filter(u -> "BANNED".equalsIgnoreCase(u.getStatus())).count();
            long userDisabled = users.stream().filter(u -> "DISABLED".equalsIgnoreCase(u.getStatus()) || "DELETED".equalsIgnoreCase(u.getStatus())).count();

            // Thống kê staff theo trạng thái
            long staffActive = staff.stream().filter(u -> "ACTIVE".equalsIgnoreCase(u.getStatus())).count();
            long staffBanned = staff.stream().filter(u -> "BANNED".equalsIgnoreCase(u.getStatus())).count();
            long staffDisabled = staff.stream().filter(u -> "DISABLED".equalsIgnoreCase(u.getStatus()) || "DELETED".equalsIgnoreCase(u.getStatus())).count();

            // Lấy tổng số xe
            CarService carService = new CarService();
            List<Car> cars = carService.findAll();

            // Lấy voucher
            DiscountService discountService = new DiscountService();
            List<Discount> vouchers = discountService.getAllDiscounts();
            long voucherActive = vouchers.stream().filter(Discount::isIsActive).count();
            long voucherInactive = vouchers.size() - voucherActive;

            // Lấy toàn bộ payment completed
            PaymentRepository paymentRepo = new PaymentRepository();
            List<Payment> payments = paymentRepo.getAllPayments();
            
            // Thống kê theo tháng (12 tháng gần nhất)
            int months = 12;
            LocalDate now = LocalDate.now();
            
            // Thống kê doanh thu theo tháng (12 tháng gần nhất)
            double[] revenueByMonth = new double[months];
            for (int i = 0; i < months; i++) {
                LocalDateTime monthForRevenue = now.minusMonths(months - 1 - i).atStartOfDay();
                revenueByMonth[i] = payments.stream()
                    .filter(p -> p.getPaymentStatus() != null && p.getPaymentStatus().equalsIgnoreCase("Completed"))
                    .filter(p -> p.getCreatedDate() != null
                        && p.getCreatedDate().getYear() == monthForRevenue.getYear()
                        && p.getCreatedDate().getMonthValue() == monthForRevenue.getMonthValue())
                    .mapToDouble(Payment::getAmount)
                    .sum();
            }

            // Thống kê theo tháng (12 tháng gần nhất)
            List<String> monthLabels = new ArrayList<>();
            int[] userByMonth = new int[months];
            int[] carByMonth = new int[months];
            int[] voucherByMonth = new int[months];

            for (int i = months - 1; i >= 0; i--) {
                LocalDate month = now.minusMonths(i);
                String label = month.getMonth().getDisplayName(TextStyle.SHORT, new Locale("vi")) + " " + month.getYear();
                monthLabels.add(label);
                int idx = months - 1 - i;
                // User
                userByMonth[idx] = (int) users.stream().filter(u -> u.getCreatedDate() != null &&
                        u.getCreatedDate().getYear() == month.getYear() &&
                        u.getCreatedDate().getMonthValue() == month.getMonthValue()).count();
                // Car
                carByMonth[idx] = (int) cars.stream().filter(c -> c.getCreatedDate() != null &&
                        c.getCreatedDate().toInstant().atZone(ZoneId.systemDefault()).getYear() == month.getYear() &&
                        c.getCreatedDate().toInstant().atZone(ZoneId.systemDefault()).getMonthValue() == month.getMonthValue()).count();
                // Voucher
                voucherByMonth[idx] = (int) vouchers.stream().filter(v -> v.getCreatedDate() != null &&
                        v.getCreatedDate().toInstant().atZone(ZoneId.systemDefault()).getYear() == month.getYear() &&
                        v.getCreatedDate().toInstant().atZone(ZoneId.systemDefault()).getMonthValue() == month.getMonthValue()).count();
            }

            // Sau khi tính toán các mảng thống kê tháng
            Gson gson = new Gson();
            request.setAttribute("monthLabelsJson", gson.toJson(monthLabels));
            request.setAttribute("userByMonthJson", gson.toJson(userByMonth));
            request.setAttribute("carByMonthJson", gson.toJson(carByMonth));
            request.setAttribute("voucherByMonthJson", gson.toJson(voucherByMonth));
            request.setAttribute("revenueByMonthJson", gson.toJson(revenueByMonth));

            request.setAttribute("userCount", users.size());
            request.setAttribute("userActive", userActive);
            request.setAttribute("userBanned", userBanned);
            request.setAttribute("userDisabled", userDisabled);

            request.setAttribute("staffCount", staff.size());
            request.setAttribute("staffActive", staffActive);
            request.setAttribute("staffBanned", staffBanned);
            request.setAttribute("staffDisabled", staffDisabled);

            request.setAttribute("carCount", cars.size());

            request.setAttribute("voucherCount", vouchers.size());
            request.setAttribute("voucherActive", voucherActive);
            request.setAttribute("voucherInactive", voucherInactive);

            request.getRequestDispatcher("/pages/admin/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi lấy dữ liệu dashboard: " + e.getMessage());
        }
    }
} 