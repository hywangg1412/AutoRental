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
                dto.setPricePerHour(car.getPricePerHour());
                dto.setStatusDisplay(car.getStatus().getDisplayValue());
                dto.setStatusCssClass(car.getStatus().getCssClass());

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

    public List<CarListItemDTO> getByPage(int offset, int limit) {
        List<CarListItemDTO> result = new ArrayList<>();
        try {
            List<Car> cars = carService.findByPage(offset, limit);

            for (Car car : cars) {
                CarListItemDTO dto = new CarListItemDTO();
                dto.setCarId(car.getCarId());
                dto.setCarModel(car.getCarModel());
                dto.setPricePerDay(car.getPricePerDay());
                dto.setPricePerHour(car.getPricePerHour());
                dto.setStatusDisplay(car.getStatus().getDisplayValue());
                dto.setStatusCssClass(car.getStatus().getCssClass());

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

    public int countAll() {
        try {
            return carService.countAll();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    public List<CarListItemDTO> searchByKeyword(String keyword, int offset, int limit) {
        List<CarListItemDTO> result = new ArrayList<>();
        try {
            List<Car> cars = carService.searchByKeyword(keyword, offset, limit);
            for (Car car : cars) {
                CarListItemDTO dto = new CarListItemDTO();
                dto.setCarId(car.getCarId());
                dto.setCarModel(car.getCarModel());
                dto.setPricePerDay(car.getPricePerDay());
                dto.setPricePerHour(car.getPricePerHour());
                dto.setStatusDisplay(car.getStatus().getDisplayValue());
                dto.setStatusCssClass(car.getStatus().getCssClass());
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
    
    public int countByKeyword(String keyword) {
        try {
            return carService.countByKeyword(keyword);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<CarListItemDTO> filterCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String sort, String keyword, int offset, int limit
    ) {
        List<CarListItemDTO> result = new ArrayList<>();
        try {
            List<Car> cars = carService.filterCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, sort, keyword, offset, limit);
            for (Car car : cars) {
                CarListItemDTO dto = new CarListItemDTO();
                dto.setCarId(car.getCarId());
                dto.setCarModel(car.getCarModel());
                dto.setPricePerDay(car.getPricePerDay());
                dto.setPricePerHour(car.getPricePerHour());
                dto.setStatusDisplay(car.getStatus().getDisplayValue());
                dto.setStatusCssClass(car.getStatus().getCssClass());
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
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    public int countFilteredCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String keyword
    ) {
        try {
            return carService.countFilteredCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, keyword);
        } catch (Exception e) { e.printStackTrace(); return 0; }
    }
}
