package Controller.Booking;

import Model.DTO.BookingInfoDTO;
import Model.DTO.CarDetailDTO;
import Model.DTO.Deposit.InsuranceDetailDTO;
import Model.Entity.Deposit.Insurance;
import Model.Entity.User.DriverLicense;
import Model.Entity.User.User;
import Repository.Deposit.InsuranceRepository;
import Service.Booking.BookingInsuranceService;
import Service.Car.CarDetailService;
import Service.User.DriverLicenseService;
import Utils.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/booking/form/details")
public class BookingFormDetailsServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookingFormDetailsServlet.class.getName());
    private final CarDetailService carDetailService = new CarDetailService();
    private final DriverLicenseService driverLicenseService = new DriverLicenseService();
    private final InsuranceRepository insuranceRepository = new InsuranceRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Kiểm tra đăng nhập
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }

            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/car.jsp");
                return;
            }

            UUID carId = UUID.fromString(idParam);
            CarDetailDTO carDto = carDetailService.getCarDetail(carId);

            // Kiểm tra bằng lái xe
            DriverLicense driverLicense = null;
            boolean hasDriverLicense = false;
            try {
                driverLicense = driverLicenseService.findByUserId(user.getUserId());
                hasDriverLicense = (driverLicense != null && driverLicense.getLicenseImage() != null);
            } catch (Exception e) {
                // Người dùng chưa có bằng lái
                hasDriverLicense = false;
            }

            // Tạo BookingInfoDTO từ CarDetailDTO
            BookingInfoDTO bookingInfoDTO = new BookingInfoDTO();
            bookingInfoDTO.setCarModel(carDto.getCarModel());
            // CarDetailDTO không có getLicensePlate(), chỉ lưu carModel
            bookingInfoDTO.setCarLicensePlate("");
            bookingInfoDTO.setPricePerHour(carDto.getPricePerHour());
            bookingInfoDTO.setPricePerDay(carDto.getPricePerDay());
            bookingInfoDTO.setPricePerMonth(carDto.getPricePerMonth());
            
            // Lấy thông tin bảo hiểm từ database
            List<InsuranceDetailDTO> insuranceDetails = getInsuranceDetails(carDto.getSeats());
            bookingInfoDTO.setInsuranceDetails(insuranceDetails);
            
            // Tính phí bảo hiểm cơ bản (bảo hiểm vật chất)
            double basicInsuranceFee = calculateVehicleInsurance(carDto.getPricePerDay().doubleValue());
            bookingInfoDTO.setBasicInsuranceFee(basicInsuranceFee);
            
            // Tính phí bảo hiểm bổ sung (bảo hiểm tai nạn)
            double additionalInsuranceFee = calculateAccidentInsurance(carDto.getSeats());
            bookingInfoDTO.setAdditionalInsuranceFee(additionalInsuranceFee);
            
            // Đặt thuộc tính cho JSP
            request.setAttribute("bookingInfo", bookingInfoDTO);
            request.setAttribute("car", carDto);
            request.setAttribute("hasDriverLicense", hasDriverLicense);
            request.setAttribute("driverLicense", driverLicense);
            
            request.getRequestDispatcher("/pages/booking-form/booking-form-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            
            // Cải thiện thông báo lỗi để hiển thị chi tiết hơn
            String errorMessage = "Không tìm thấy xe hoặc xảy ra lỗi: " + e.getMessage();
            
            // Thêm thông tin chi tiết về loại lỗi
            if (e instanceof IllegalArgumentException) {
                errorMessage = "Dữ liệu không hợp lệ: " + e.getMessage();
            } else if (e instanceof java.sql.SQLException) {
                errorMessage = "Lỗi cơ sở dữ liệu: " + e.getMessage();
            } else if (e instanceof java.util.NoSuchElementException) {
                errorMessage = "Không tìm thấy dữ liệu yêu cầu: " + e.getMessage();
            }
            
            // Ghi log lỗi
            LOGGER.log(Level.SEVERE, "Error in BookingFormDetailsServlet: ", e);
            
            // Đặt thông báo lỗi chi tiết vào request attribute
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("exception", e);
            
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Lấy danh sách bảo hiểm từ database
     * 
     * @param carSeats Số chỗ ngồi của xe
     * @return Danh sách InsuranceDetailDTO
     */
    private List<InsuranceDetailDTO> getInsuranceDetails(int carSeats) {
        List<InsuranceDetailDTO> result = new ArrayList<>();
        
        try {
            // 1. Lấy bảo hiểm vật chất
            List<Insurance> vehicleInsurances = insuranceRepository.findByType("VatChat");
            if (!vehicleInsurances.isEmpty()) {
                Insurance vehicleInsurance = vehicleInsurances.get(0);
                InsuranceDetailDTO dto = new InsuranceDetailDTO();
                dto.setInsuranceName(vehicleInsurance.getInsuranceName());
                dto.setInsuranceType(vehicleInsurance.getInsuranceType());
                dto.setDescription(vehicleInsurance.getDescription());
                dto.setPremiumAmount(0); // Sẽ được tính sau
                result.add(dto);
            }
            
            // 2. Lấy bảo hiểm tai nạn phù hợp với số chỗ ngồi
            List<Insurance> accidentInsurances = insuranceRepository.findByType("TaiNan");
            for (Insurance insurance : accidentInsurances) {
                if (isApplicableSeatRange(carSeats, insurance.getApplicableCarSeats())) {
                    InsuranceDetailDTO dto = new InsuranceDetailDTO();
                    dto.setInsuranceName(insurance.getInsuranceName());
                    dto.setInsuranceType(insurance.getInsuranceType());
                    dto.setDescription(insurance.getDescription());
                    dto.setPremiumAmount(insurance.getBaseRatePerDay() / 1000); // Chuyển đổi sang đơn vị DB
                    result.add(dto);
                    break;
                }
            }
        } catch (Exception e) {
            LOGGER.warning("Lỗi khi lấy thông tin bảo hiểm: " + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * Tính phí bảo hiểm vật chất
     * 
     * @param dailyRate Giá thuê theo ngày
     * @return Phí bảo hiểm vật chất
     */
    private double calculateVehicleInsurance(double dailyRate) {
        try {
            // Lấy bảo hiểm vật chất từ database
            List<Insurance> vehicleInsurances = insuranceRepository.findByType("VatChat");
            if (!vehicleInsurances.isEmpty()) {
                Insurance vehicleInsurance = vehicleInsurances.get(0);
                
                // Tính giá trị xe dựa trên giá thuê theo ngày
                double yearCoefficient = getYearCoefficient(dailyRate * 1000); // Chuyển sang VND
                double estimatedCarValue = dailyRate * 1000 * 365 * yearCoefficient;
                
                // Tính phí bảo hiểm vật chất theo ngày
                double premiumPerDay = estimatedCarValue * vehicleInsurance.getPercentageRate() / 100 / 365;
                
                // Giảm 50% phí bảo hiểm vật chất theo yêu cầu
                premiumPerDay = premiumPerDay * 0.5;
                
                LOGGER.info("Tính phí bảo hiểm vật chất: Giá thuê=" + dailyRate + ", Hệ số năm=" + yearCoefficient 
                        + ", Giá trị xe=" + estimatedCarValue + ", Tỷ lệ BH=" + vehicleInsurance.getPercentageRate() 
                        + "%, Phí BH/ngày (sau giảm 50%)=" + premiumPerDay);
                
                return premiumPerDay; // Trả về đơn vị VND
            }
        } catch (Exception e) {
            LOGGER.warning("Lỗi khi tính phí bảo hiểm vật chất: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Tính phí bảo hiểm tai nạn
     * 
     * @param carSeats Số chỗ ngồi của xe
     * @return Phí bảo hiểm tai nạn
     */
    private double calculateAccidentInsurance(int carSeats) {
        try {
            // Lấy bảo hiểm tai nạn phù hợp với số chỗ ngồi
            List<Insurance> accidentInsurances = insuranceRepository.findByType("TaiNan");
            for (Insurance insurance : accidentInsurances) {
                if (isApplicableSeatRange(carSeats, insurance.getApplicableCarSeats())) {
                    return insurance.getBaseRatePerDay(); // Trả về đơn vị VND
                }
            }
        } catch (Exception e) {
            LOGGER.warning("Lỗi khi tính phí bảo hiểm tai nạn: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Kiểm tra xem số chỗ ngồi có phù hợp với range của bảo hiểm không
     */
    private boolean isApplicableSeatRange(int seats, String seatRange) {
        if (seatRange == null) return true;
        
        if (seatRange.equals("1-5")) return seats <= 5;
        if (seatRange.equals("6-11")) return seats >= 6 && seats <= 11;
        if (seatRange.equals("12+")) return seats >= 12;
        
        return true;
    }
    
    /**
     * Xác định hệ số năm sử dụng theo giá thuê/ngày
     */
    private double getYearCoefficient(double dailyRate) {
        if (dailyRate <= 500000) {
            return 5; // Hệ số thấp
        } else if (dailyRate <= 800000) {
            return 7; // Hệ số trung bình
        } else if (dailyRate <= 1200000) {
            return 10; // Hệ số cao
        } else {
            return 15; // Hệ số cao cấp
        }
    }
}