package Service.Booking;

import Model.DTO.BookingDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarImage;
import Model.Entity.User.User;
import Repository.Booking.BookingRepository;
import Repository.Car.CarImageRepository;
import Service.Car.CarService;
import Service.User.UserService;

import java.util.UUID;

public class BookingDetailService {

    private final BookingRepository bookingRepository = new BookingRepository();
    private final UserService userService = new UserService();
    private final CarService carService = new CarService();
    private final CarImageRepository carImageRepository = new CarImageRepository();

    public BookingDTO getBookingDetail(UUID bookingId) throws Exception {
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

        BookingDTO dto = new BookingDTO();

        dto.setBookingId(booking.getBookingId());
        dto.setBookingCode(booking.getBookingCode());
        dto.setCreatedDate(booking.getCreatedDate());
        dto.setStatus(booking.getStatus());
        dto.setPickupDateTime(booking.getPickupDateTime());
        dto.setReturnDateTime(booking.getReturnDateTime());
        dto.setTotalAmount(booking.getTotalAmount());
        dto.setCancelReason(booking.getCancelReason());
        
        // User Info
        dto.setFullName(user.getFirstName() + " " + user.getLastName());
        dto.setEmail(user.getEmail());
        dto.setPhoneNumber(user.getPhoneNumber());

        // Car Info
        dto.setCarModel(car.getCarModel());
        dto.setLicensePlate(car.getLicensePlate());
        dto.setCarImage(mainImage);
        dto.setPricePerDay(car.getPricePerDay());

        return dto;
    }
}
