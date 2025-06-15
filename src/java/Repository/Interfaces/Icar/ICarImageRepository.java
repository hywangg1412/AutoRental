package Repository.Interfaces.Icar;

import Model.Entity.Car.CarImage;
import Repository.Interfaces.Repository;


import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface ICarImageRepository extends Repository<CarImage, UUID> {
    CarImage findMainImageByCarId(UUID carId) throws SQLException;
    List<CarImage> findByCarId(UUID carId) throws SQLException;
}
