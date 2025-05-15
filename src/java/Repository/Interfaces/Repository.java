package Repository.Interfaces;

import java.sql.SQLException;
import java.util.List;

public interface Repository<T, C>{
    
    void add(T entity) throws SQLException;
    T findById(int Id) throws SQLException;
    void update(T entity) throws SQLException;
    void delete(int Id) throws SQLException;
    List<T> findAll() throws SQLException;
}
