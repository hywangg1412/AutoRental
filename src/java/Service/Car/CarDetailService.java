package Service.Car;

import Model.DTO.CarDetailDTO;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarFeature;
import Model.Entity.Car.CarImage;
import Repository.Car.CarImageRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CarDetailService {

    private final CarService carService = new CarService();
    private final CarBrandService brandService = new CarBrandService();
    private final FuelTypeService fuelTypeService = new FuelTypeService();
    private final TransmissionTypeService transmissionService = new TransmissionTypeService();
    private final CarCategoriesService categoryService = new CarCategoriesService();
    private final CarFeatureService featureService = new CarFeatureService();
    private final CarImageRepository imageRepository = new CarImageRepository();

    public CarDetailDTO getCarDetail(UUID carId) throws Exception {
        Car car = carService.findById(carId);
        if (car == null) {
            throw new Exception("Car not found with ID: " + carId);
        }

        CarDetailDTO dto = new CarDetailDTO();
        dto.setCarId(car.getCarId());
        dto.setCarModel(car.getCarModel());
        dto.setDescription(car.getDescription());
        dto.setSeats(car.getSeats());
        dto.setOdometer(car.getOdometer());
        dto.setPricePerDay(car.getPricePerDay());
        dto.setPricePerHour(car.getPricePerHour());
        dto.setPricePerMonth(car.getPricePerMonth());
        dto.setCreatedDate(car.getCreatedDate());

        // Brand
        var brand = brandService.findById(car.getBrandId());
        dto.setBrandName(brand != null ? brand.getBrandName() : "Unknown");

        // Fuel
        var fuel = fuelTypeService.findById(car.getFuelTypeId());
        dto.setFuelName(fuel != null ? fuel.getFuelName() : "Unknown");

        // Transmission
        var transmission = transmissionService.findById(car.getTransmissionTypeId());
        dto.setTransmissionName(transmission != null ? transmission.getTranmissionName() : "Unknown");

        // Category (optional)
        if (car.getCategoryId() != null) {
            var category = categoryService.findById(car.getCategoryId());
            dto.setCategoryName(category != null ? category.getCategoryName() : null);
        }

        // Features
        List<String> featureNames = new ArrayList<>();
        for (CarFeature feature : featureService.findByCarId(car.getCarId())) {
            featureNames.add(feature.getFetureName());
        }
        dto.setFeatureNames(featureNames);

        // Lấy tất cả feature
        List<String> allFeatureNames = featureService.findAll()
                .stream().map(CarFeature::getFetureName).toList();
        dto.setAllFeatureNames(allFeatureNames);

        // Images
        List<String> imageUrls = imageRepository.findAll()
                .stream()
                .filter(img -> img.getCarId().equals(car.getCarId()))
                .map(CarImage::getImageUrl)
                .toList();
        dto.setImageUrls(imageUrls);

        return dto;
    }
}
