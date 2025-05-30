package Repository.Interfaces;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface Repository<T, C>{
    
    void add(T entity) throws SQLException;
    T findById(UUID Id) throws SQLException;
    void update(T entity) throws SQLException;
    void delete(UUID Id) throws SQLException;
    List<T> findAll() throws SQLException;
}
