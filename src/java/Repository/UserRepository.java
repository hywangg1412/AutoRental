package Repository;

import Config.DBContext;
import Model.Entity.User;
import Repository.Interfaces.IUserRepository;
import java.util.List;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserRepository implements IUserRepository {

    private DBContext dbContext = new DBContext();

    public UserRepository() {
    }

    @Override
    public void add(User entity) throws SQLException {
        String sql = "INSERT INTO Users WHERE (UserId, Username, PasswordHash, Email, Phonenumber, FirstName, LastName, DOB, Gender) ";
    }

    @Override
    public User findById(int Id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(User entity) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(int Id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<User> findAll() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public User findByUsernameAndPassword(String username, String password) {
        String sql = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, username);
            st.setString(2, password);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error While Finding Username and Password - " + ex.getMessage());
        }
        return null;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User u = new User();
//        u.setUserId(rs.getInt("UserId"));
//        u.setUsername(rs.getString("Username"));
//        u.setPassword(rs.getString("Password"));
        return u;
    }

}
