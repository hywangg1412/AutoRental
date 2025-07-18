
package Repository.User;

import Config.DBContext;
import Model.Entity.User.CitizenIdCard;
import Repository.Interfaces.IUser.ICitizendIdCardRepository;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

public class CitizenIdCardRepository implements ICitizendIdCardRepository {
    private final DBContext dbContext = new DBContext();

    @Override
    public CitizenIdCard add(CitizenIdCard entity) throws SQLException {
        String sql = "INSERT INTO CitizenIdCards (Id, UserId, CitizenIdNumber, FullName, DOB, CitizenIdImageUrl, CitizenIdBackImageUrl, CitizenIdIssuedDate, CitizenIdIssuedPlace, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            UUID id = entity.getId() != null ? entity.getId() : UUID.randomUUID();
            ps.setString(1, id.toString());
            ps.setString(2, entity.getUserId().toString());
            ps.setString(3, entity.getCitizenIdNumber());
            ps.setString(4, entity.getFullName());
            ps.setDate(5, entity.getDob() != null ? java.sql.Date.valueOf(entity.getDob()) : null);
            ps.setString(6, entity.getCitizenIdImageUrl());
            ps.setString(7, entity.getCitizenIdBackImageUrl());
            ps.setDate(8, entity.getCitizenIdIssuedDate() != null ? java.sql.Date.valueOf(entity.getCitizenIdIssuedDate()) : null);
            ps.setString(9, entity.getCitizenIdIssuedPlace());
            ps.setTimestamp(10, entity.getCreatedDate() != null ? Timestamp.valueOf(entity.getCreatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            ps.executeUpdate();
            entity.setId(id);
            return entity;
        }
    }

    @Override
    public CitizenIdCard findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM CitizenIdCards WHERE Id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id.toString());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean update(CitizenIdCard entity) throws SQLException {
        String sql = "UPDATE CitizenIdCards SET CitizenIdNumber=?, FullName=?, DOB=?, CitizenIdImageUrl=?, CitizenIdBackImageUrl=?, CitizenIdIssuedDate=?, CitizenIdIssuedPlace=? WHERE Id=?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getCitizenIdNumber());
            ps.setString(2, entity.getFullName());
            ps.setDate(3, entity.getDob() != null ? java.sql.Date.valueOf(entity.getDob()) : null);
            ps.setString(4, entity.getCitizenIdImageUrl());
            ps.setString(5, entity.getCitizenIdBackImageUrl());
            ps.setDate(6, entity.getCitizenIdIssuedDate() != null ? java.sql.Date.valueOf(entity.getCitizenIdIssuedDate()) : null);
            ps.setString(7, entity.getCitizenIdIssuedPlace());
            ps.setString(8, entity.getId().toString());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM CitizenIdCards WHERE Id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id.toString());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<CitizenIdCard> findAll() throws SQLException {
        List<CitizenIdCard> list = new ArrayList<>();
        String sql = "SELECT * FROM CitizenIdCards";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public CitizenIdCard findByUserId(UUID userId) throws SQLException {
        String sql = "SELECT * FROM CitizenIdCards WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId.toString());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    private CitizenIdCard mapRow(ResultSet rs) throws SQLException {
        CitizenIdCard card = new CitizenIdCard();
        card.setId(UUID.fromString(rs.getString("Id")));
        card.setUserId(UUID.fromString(rs.getString("UserId")));
        card.setCitizenIdNumber(rs.getString("CitizenIdNumber"));
        card.setFullName(rs.getString("FullName"));
        card.setDob(rs.getDate("DOB").toLocalDate());
        card.setCitizenIdImageUrl(rs.getString("CitizenIdImageUrl"));
        card.setCitizenIdBackImageUrl(rs.getString("CitizenIdBackImageUrl"));
        card.setCitizenIdIssuedDate(rs.getDate("CitizenIdIssuedDate").toLocalDate());
        card.setCitizenIdIssuedPlace(rs.getString("CitizenIdIssuedPlace"));
        card.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        return card;
    }
}
