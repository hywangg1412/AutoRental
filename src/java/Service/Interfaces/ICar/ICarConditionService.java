package Service.Interfaces.ICar;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.CarConditionLogs;
import Service.Interfaces.Service;

import java.util.List;
import java.util.UUID;

public interface ICarConditionService extends Service<CarConditionLogs> {
    List<CarConditionLogs> findByBookingId(UUID bookingId) throws NotFoundException;
    List<CarConditionLogs> findByCarId(UUID carId) throws NotFoundException;
    List<CarConditionLogs> findRecentInspections(int limit) throws EmptyDataException;
    List<CarConditionLogs> findPendingInspections() throws EmptyDataException;
    boolean updateConditionStatus(UUID logId, String status) throws NotFoundException, InvalidDataException;
    CarConditionLogs createInspection(UUID bookingId, UUID carId, UUID staffId, String checkType, 
                                     Integer odometer, String fuelLevel, String conditionStatus, 
                                     String conditionDescription, String damageImages, String note) 
                                     throws InvalidDataException, EventException;
    boolean acceptReturnCar(UUID bookingId, UUID logId) throws NotFoundException, EventException;
} 