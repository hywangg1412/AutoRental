package Controller.Booking;

import Model.DTO.BookingRequestDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingApproval;
import Model.Entity.Car.Car;
import Model.Entity.User.User;
import Service.Booking.BookingApprovalService;
import Service.Booking.BookingService;
import Service.Car.CarService;
import Service.User.UserService;
import Utils.FormatUtils;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.time.LocalDateTime;
import Utils.SessionUtil;

// /staff/booking-approval-list
public class BookingApprovalListServlet extends HttpServlet {

    private BookingApprovalService BAService;
    private BookingService bookingService;
    private UserService userService;
    private CarService carService;

    @Override
    public void init() {
        BAService = new BookingApprovalService();
        bookingService = new BookingService();
        userService = new UserService();
        carService = new CarService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Booking> pendingBookings = bookingService.findByStatus("Pending");
            List<BookingRequestDTO> dtoList = new ArrayList<>();

            for (Booking booking : pendingBookings) {
                BookingApproval approval = BAService.findByBookingId(booking.getBookingId());
                User staff = (User) SessionUtil.getSessionAttribute(request, "user");
                if (staff == null) {
                    response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                    return;
                }
                UUID staffId = staff.getUserId();
                
                if (approval == null) {
                    approval = new BookingApproval();
                    approval.setApprovalId(UUID.randomUUID());
                    approval.setBookingId(booking.getBookingId());
                    approval.setStaffId(staffId);
                    approval.setApprovalStatus("Pending");
                    approval.setApprovalDate(LocalDateTime.now());
                    BAService.add(approval);
                }
                User customer = userService.findById(booking.getUserId());
                Car car = carService.findById(booking.getCarId());
                
                BookingRequestDTO dto = new BookingRequestDTO();
                dto.setApprovalId(approval.getApprovalId());
                dto.setApprovalStatus(approval.getApprovalStatus());
                dto.setApprovalDate(approval.getApprovalDate());
                dto.setNote(approval.getNote());
                dto.setRejectionReason(approval.getRejectionReason());

                dto.setBookingId(booking.getBookingId());
                dto.setPickupDateTime(FormatUtils.format(booking.getPickupDateTime()));
                dto.setReturnDateTime(FormatUtils.format(booking.getReturnDateTime()));
                dto.setTotalAmount(booking.getTotalAmount());

                dto.setCustomerName(customer.getFirstName() + " " + customer.getLastName());
                dto.setCustomerEmail(customer.getEmail());
                dto.setCarModel(car.getCarModel());
                dto.setLicensePlate(car.getLicensePlate());

                dtoList.add(dto);
            }
            System.out.println("DTO list size: " + dtoList.size());
            for (BookingRequestDTO dto : dtoList) {
                System.out.println("BookingId: " + dto.getBookingId() + ", Customer: " + dto.getCustomerName());
            }
            request.setAttribute("pendingBookings", dtoList);
        } catch (Exception e) {
            request.setAttribute("error", "Can't initialize booking list : " + e.getMessage());
        }
        request.getRequestDispatcher("/pages/staff/staff-booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list");
    }
}
