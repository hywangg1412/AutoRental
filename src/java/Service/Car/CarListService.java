package Service.Car;

import Model.DTO.CarListItemDTO;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarImage;
import Repository.Car.CarImageRepository;
import Repository.Car.CarRepository;
import Service.Interfaces.ICar.ICarBrandService;
import Service.Interfaces.ICar.ICarService;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.Map;

public class CarListService {

    private final ICarService carService = new CarService();
    private final ICarBrandService brandService = new CarBrandService();
    private final CarImageRepository imageRepository = new CarImageRepository();

    /**
     * CẢNH BÁO: Hàm này lấy toàn bộ xe từ DB, có thể gây tải lớn nếu số lượng xe nhiều.
     * KHÔNG dùng cho hiển thị danh sách lớn. Chỉ dùng cho mục đích đặc biệt (admin, xuất excel, ...).
     * Nên dùng getByPage, filterCars, searchByKeyword để phân trang.
     */
    public List<CarListItemDTO> getAll() {
        List<CarListItemDTO> result = new ArrayList<>();
        try {
            List<Car> cars = carService.findAll();
            List<UUID> brandIds = new ArrayList<>();
            List<UUID> carIds = new ArrayList<>();
            for (Car car : cars) {
                if (car.getBrandId() != null) brandIds.add(car.getBrandId());
                carIds.add(car.getCarId());
            }
            Map<UUID, Model.Entity.Car.CarBrand> brandMap = brandService.findByIds(brandIds);
            Map<UUID, Model.Entity.Car.CarImage> imageMap = imageRepository.findMainImagesByCarIds(carIds);
            for (Car car : cars) {
                CarListItemDTO dto = new CarListItemDTO();
                dto.setCarId(car.getCarId());
                dto.setCarModel(car.getCarModel());
                dto.setPricePerDay(car.getPricePerDay());
                dto.setPricePerHour(car.getPricePerHour());
                dto.setStatusDisplay(car.getStatus().getDisplayValue());
                dto.setStatusCssClass(car.getStatus().getCssClass());
                Model.Entity.Car.CarBrand brand = brandMap.get(car.getBrandId());
                dto.setBrandName(brand != null ? brand.getBrandName() : "N/A");
                Model.Entity.Car.CarImage image = imageMap.get(car.getCarId());
                if (image != null && image.getImageUrl() != null && !image.getImageUrl().isBlank()) {
                    dto.setMainImageUrl(image.getImageUrl());
                } else {
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
            List<UUID> brandIds = new ArrayList<>();
            List<UUID> carIds = new ArrayList<>();
            for (Car car : cars) {
                if (car.getBrandId() != null) brandIds.add(car.getBrandId());
                carIds.add(car.getCarId());
            }
            Map<UUID, Model.Entity.Car.CarBrand> brandMap = brandService.findByIds(brandIds);
            Map<UUID, Model.Entity.Car.CarImage> imageMap = imageRepository.findMainImagesByCarIds(carIds);
            for (Car car : cars) {
                CarListItemDTO dto = new CarListItemDTO();
                dto.setCarId(car.getCarId());
                dto.setCarModel(car.getCarModel());
                dto.setPricePerDay(car.getPricePerDay());
                dto.setPricePerHour(car.getPricePerHour());
                dto.setStatusDisplay(car.getStatus().getDisplayValue());
                dto.setStatusCssClass(car.getStatus().getCssClass());
                Model.Entity.Car.CarBrand brand = brandMap.get(car.getBrandId());
                dto.setBrandName(brand != null ? brand.getBrandName() : "N/A");
                Model.Entity.Car.CarImage image = imageMap.get(car.getCarId());
                if (image != null && image.getImageUrl() != null && !image.getImageUrl().isBlank()) {
                    dto.setMainImageUrl(image.getImageUrl());
                } else {
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
            List<UUID> brandIds = new ArrayList<>();
            List<UUID> carIds = new ArrayList<>();
            for (Car car : cars) {
                if (car.getBrandId() != null) brandIds.add(car.getBrandId());
                carIds.add(car.getCarId());
            }
            Map<UUID, Model.Entity.Car.CarBrand> brandMap = brandService.findByIds(brandIds);
            Map<UUID, Model.Entity.Car.CarImage> imageMap = imageRepository.findMainImagesByCarIds(carIds);
            for (Car car : cars) {
                CarListItemDTO dto = new CarListItemDTO();
                dto.setCarId(car.getCarId());
                dto.setCarModel(car.getCarModel());
                dto.setPricePerDay(car.getPricePerDay());
                dto.setPricePerHour(car.getPricePerHour());
                dto.setStatusDisplay(car.getStatus().getDisplayValue());
                dto.setStatusCssClass(car.getStatus().getCssClass());
                Model.Entity.Car.CarBrand brand = brandMap.get(car.getBrandId());
                dto.setBrandName(brand != null ? brand.getBrandName() : "N/A");
                Model.Entity.Car.CarImage image = imageMap.get(car.getCarId());
                if (image != null && image.getImageUrl() != null && !image.getImageUrl().isBlank()) {
                    dto.setMainImageUrl(image.getImageUrl());
                } else {
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
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String sort, String keyword,
        Integer minPricePerHour, Integer maxPricePerHour,
        Integer minSeats, Integer maxSeats,
        Integer minYear, Integer maxYear,
        Integer minOdometer, Integer maxOdometer,
        Integer minDistance, Integer maxDistance,
        int offset, int limit
    ) {
        List<CarListItemDTO> result = new ArrayList<>();
        try {
            List<Car> cars = carService.filterCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, sort, keyword, minPricePerHour, maxPricePerHour, minSeats, maxSeats, minYear, maxYear, minOdometer, maxOdometer, minDistance, maxDistance, offset, limit);
            List<UUID> brandIdList = new ArrayList<>();
            List<UUID> carIdList = new ArrayList<>();
            for (Car car : cars) {
                if (car.getBrandId() != null) brandIdList.add(car.getBrandId());
                carIdList.add(car.getCarId());
            }
            Map<UUID, Model.Entity.Car.CarBrand> brandMap = brandService.findByIds(brandIdList);
            Map<UUID, Model.Entity.Car.CarImage> imageMap = imageRepository.findMainImagesByCarIds(carIdList);
            for (Car car : cars) {
                CarListItemDTO dto = new CarListItemDTO();
                dto.setCarId(car.getCarId());
                dto.setCarModel(car.getCarModel());
                dto.setPricePerDay(car.getPricePerDay());
                dto.setPricePerHour(car.getPricePerHour());
                dto.setStatusDisplay(car.getStatus().getDisplayValue());
                dto.setStatusCssClass(car.getStatus().getCssClass());
                Model.Entity.Car.CarBrand brand = brandMap.get(car.getBrandId());
                dto.setBrandName(brand != null ? brand.getBrandName() : "N/A");
                Model.Entity.Car.CarImage image = imageMap.get(car.getCarId());
                if (image != null && image.getImageUrl() != null && !image.getImageUrl().isBlank()) {
                    dto.setMainImageUrl(image.getImageUrl());
                } else {
                    dto.setMainImageUrl("/images/car-default.jpg");
                }
                result.add(dto);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return result;
    }

    public int countFilteredCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String keyword,
        Integer minPricePerHour, Integer maxPricePerHour,
        Integer minSeats, Integer maxSeats,
        Integer minYear, Integer maxYear,
        Integer minOdometer, Integer maxOdometer,
        Integer minDistance, Integer maxDistance
    ) {
        try {
            return carService.countFilteredCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, keyword, minPricePerHour, maxPricePerHour, minSeats, maxSeats, minYear, maxYear, minOdometer, maxOdometer, minDistance, maxDistance);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Lấy danh sách xe tối ưu cho trang chủ (JOIN đủ bảng, có limit)
    public List<CarListItemDTO> getForHomePage(int limit) {
        try {
            CarRepository repo = new CarRepository();
            return repo.findAllForHomePage(limit);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
