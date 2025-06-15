package Service.Interfaces.ICar;

import Model.Entity.Car.Car;
import Service.Interfaces.Service;
import java.sql.SQLException;
import java.util.List;

public interface ICarService extends Service<Car>{
    List<Car> findAll() throws SQLException;
}
