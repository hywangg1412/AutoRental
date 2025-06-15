package Service.Car;

import Model.DTO.CarListItemDTO;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarImage;
import Repository.Car.CarImageRepository;
import Service.Interfaces.ICar.ICarBrandService;
import Service.Interfaces.ICar.ICarService;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CarListService {

    private final ICarService carService = new CarService();
    private final ICarBrandService brandService = new CarBrandService();
    private final CarImageRepository imageRepository = new CarImageRepository();

    public List<CarListItemDTO> getAll() {
        List<CarListItemDTO> result = new ArrayList<>();
        try {
            List<Car> cars = carService.findAll();

            for (Car car : cars) {
                CarListItemDTO dto = new CarListItemDTO();
                dto.setCarId(car.getCarId());
                dto.setCarModel(car.getCarModel());
                dto.setPricePerDay(car.getPricePerDay());

                try {
                    dto.setBrandName(brandService.findById(car.getBrandId()).getBrandName());
                } catch (Exception e) {
                    dto.setBrandName("N/A");
                }

                try {
                    CarImage image = imageRepository.findMainImageByCarId(car.getCarId());
                    if (image != null && image.getImageUrl() != null && !image.getImageUrl().isBlank()) {
                        dto.setMainImageUrl(image.getImageUrl());
                    } else {
                        dto.setMainImageUrl("/images/car-default.jpg");
                    }
                } catch (Exception e) {
                    dto.setMainImageUrl("/images/car-default.jpg");
                }

                result.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}
