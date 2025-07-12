package Service.Interfaces.ICar;

import Model.Entity.Car.CarBrand;
import Service.Interfaces.Service;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface ICarBrandService extends Service<CarBrand> {
    Map<UUID, CarBrand> findByIds(List<UUID> ids);
}
