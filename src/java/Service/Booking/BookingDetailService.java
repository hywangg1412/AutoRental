package Service.Booking;

import java.util.UUID;

import Model.DTO.BookingInfoDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarImage;
import Model.Entity.User.User;
import Repository.Booking.BookingRepository;
import Repository.Car.CarImageRepository;
import Service.Car.CarService;
import Service.User.UserService;

public class BookingDetailService {

    private final BookingRepository bookingRepository = new BookingRepository();
    private final UserService userService = new UserService();
    private final CarService carService = new CarService();
    private final CarImageRepository carImageRepository = new CarImageRepository();

    public BookingInfoDTO getBookingDetail(UUID bookingId) throws Exception {
        Booking booking = bookingRepository.findById(bookingId);
        if (booking == null) {
            throw new Exception("Không tìm thấy booking với ID: " + bookingId);
        }

        User user = userService.findById(booking.getUserId());
        Car car = carService.findById(booking.getCarId());
        String mainImage = carImageRepository.findAll()
                .stream()
                .filter(img -> img.getCarId().equals(car.getCarId()) && img.isMain())
                .map(CarImage::getImageUrl)
                .findFirst()
                .orElse("/assets/images/default-car.jpg");

        BookingInfoDTO dto = new BookingInfoDTO();

        dto.setBookingId(booking.getBookingId());
        dto.setBookingCode(booking.getBookingCode());
        dto.setCreatedDate(booking.getCreatedDate());
        dto.setStatus(booking.getStatus());
        dto.setPickupDateTime(booking.getPickupDateTime());
        dto.setReturnDateTime(booking.getReturnDateTime());
        dto.setTotalAmount(booking.getTotalAmount());
        dto.setCustomerName(booking.getCustomerName());
        dto.setCustomerEmail(booking.getCustomerEmail());
        dto.setCustomerPhone(booking.getCustomerPhone());
        dto.setDriverLicenseImageUrl(booking.getDriverLicenseImageUrl());
        
        // Car Info
        dto.setCarModel(car.getCarModel());
        dto.setCarLicensePlate(car.getLicensePlate());
        dto.setCarStatus(car.getStatus() != null ? car.getStatus().getValue() : "");
        dto.setCarImage(mainImage);
        dto.setPricePerDay(car.getPricePerDay());

        return dto;
    }
}
