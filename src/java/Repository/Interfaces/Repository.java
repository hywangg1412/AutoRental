package Repository.Interfaces;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface Repository<T, C>{
    
    T add(T entity) throws SQLException;
    T findById(UUID Id) throws SQLException;
    boolean update(T entity) throws SQLException;
    boolean delete(UUID Id) throws SQLException;
    List<T> findAll() throws SQLException;
}
