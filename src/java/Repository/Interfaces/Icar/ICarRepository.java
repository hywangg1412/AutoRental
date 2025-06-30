package Repository.Interfaces.ICar;

import Model.Entity.Car.Car;
import Repository.Interfaces.Repository;
import java.util.List;
import java.sql.SQLException;

public interface ICarRepository extends Repository<Car, Integer> {
    List<Car> searchByKeyword(String keyword, int offset, int limit) throws SQLException;
    int countByKeyword(String keyword) throws SQLException;
    List<Car> filterCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String sort, String keyword,
        Integer minPricePerHour, Integer maxPricePerHour,
        Integer minSeats, Integer maxSeats,
        Integer minYear, Integer maxYear,
        Integer minOdometer, Integer maxOdometer,
        Integer minDistance, Integer maxDistance,
        int offset, int limit
    ) throws SQLException;
    int countFilteredCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String keyword,
        Integer minPricePerHour, Integer maxPricePerHour,
        Integer minSeats, Integer maxSeats,
        Integer minYear, Integer maxYear,
        Integer minOdometer, Integer maxOdometer,
        Integer minDistance, Integer maxDistance
    ) throws SQLException;
}
