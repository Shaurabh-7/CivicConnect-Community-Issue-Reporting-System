package civicconnect.dao;

import civicconnect.daoInterface.userInterface;
import civicconnect.model.Users;
import civicconnect.dto.user.UserDTO;
import civicconnect.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;

public class UserDAO implements userInterface {

    @Override
    public boolean registerUser(Users user) {
        if (user.getFullName() == null || user.getFullName().trim().isEmpty() ||
                user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return false;
        }

        String sql = "INSERT INTO users (full_name, email, phone, password_hash, role, municipality_id, ward_number, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, user.getRole());

            if (user.getMunicipalityId() != null) {
                ps.setInt(6, user.getMunicipalityId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            if (user.getWardNumber() != null) {
                ps.setInt(7, user.getWardNumber());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.setString(8, user.getStatus() != null ? user.getStatus() : "active");

            int row = ps.executeUpdate();
            return row > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Users getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Users getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Users mapResultSetToUser(ResultSet rs) throws Exception {
        return new Users(
                rs.getInt("id"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getString("password_hash"),
                rs.getString("role"),
                (Integer) rs.getObject("municipality_id"),
                (Integer) rs.getObject("ward_number"),
                rs.getString("status"),
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null
        );
    }
}
