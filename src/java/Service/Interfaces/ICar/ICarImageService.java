package Service.Interfaces.ICar;

import Model.Entity.Car.CarImage;
import Service.Interfaces.Service;

public interface ICarImageService extends Service<CarImage>{
    
    String getMainImageUrlByCarId(java.util.UUID carId);
}
