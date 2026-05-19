package civicconnect.dao;

import civicconnect.daoInterface.userInterface;
import civicconnect.model.Users;
import civicconnect.dto.user.UserDTO;
import civicconnect.utils.DBConnection;
import civicconnect.utils.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;

/**
 * Handles all database operations for users.
 * Allows user registration, profile updates, status changes, and fetching user lists.
 */
public class UserDAO implements userInterface {

    /**
     * Registers a new user (citizen, admin, or super admin) in the database.
     *
     * @param user The user object containing registration details.
     * @return True if the registration was successful, false otherwise.
     */
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

    /**
     * Finds a single user by their email address.
     * Used mainly during login.
     *
     * @param email The email address to look for.
     * @return The found Users object, or null if no user matches that email.
     */
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

    /**
     * Finds a single user by their unique user ID.
     *
     * @param id The unique ID of the user.
     * @return The found Users object, or null if no user matches that ID.
     */
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

    /**
     * Updates profile details for an existing user (such as full name, phone number, ward, and municipality).
     *
     * @param user The user object containing the new profile details.
     * @return True if the profile was updated successfully, false otherwise.
     */
    @Override
    public boolean updateUserProfile(Users user) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, ward_number = ?, municipality_id = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());

            if (user.getWardNumber() != null) {
                ps.setInt(3, user.getWardNumber());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            if (user.getMunicipalityId() != null) {
                ps.setInt(4, user.getMunicipalityId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            ps.setInt(5, user.getId());

            int row = ps.executeUpdate();
            return row > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates the password hash of a specific user.
     *
     * @param userId The unique ID of the user.
     * @param newPasswordHash The new pre-hashed password.
     * @return True if the password was changed successfully, false otherwise.
     */
    @Override
    public boolean changePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);

            int row = ps.executeUpdate();
            return row > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Gets a list of all registered users on the platform, ordered from newest to oldest.
     *
     * @return A list of all users, or an empty list if none are registered.
     */
    @Override
    public ArrayList<Users> getAllUsers() {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Gets all users that hold a specific platform role (such as "citizen" or "municipality_admin").
     *
     * @param role The role name to filter by.
     * @return A list of users holding that role.
     */
    @Override
    public ArrayList<Users> getUsersByRole(String role) {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Updates the status (active or inactive) of a specific user.
     * Used by municipality admins to deactivate offending users.
     *
     * @param userId The unique ID of the user.
     * @param status The new status value ("active" or "inactive").
     * @return True if successful, false otherwise.
     */
    @Override
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, userId);

            int row = ps.executeUpdate();
            return row > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Gets all registered citizens belonging to a specific municipality.
     *
     * @param municipalityId The unique ID of the municipality.
     * @return A list of citizens belonging to that municipality.
     */
    @Override
    public ArrayList<Users> getUsersByMunicipality(int municipalityId) {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE municipality_id = ? AND role = 'citizen' ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, municipalityId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Searches for registered citizens within a municipality by their name, email, or phone.
     *
     * @param municipalityId The unique ID of the municipality.
     * @param query The search text query.
     * @return A list of citizens matching the search filters.
     */
    @Override
    public ArrayList<Users> searchUsers(int municipalityId, String query) {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE municipality_id = ? AND role = 'citizen' " +
                "AND (full_name LIKE ? OR email LIKE ? OR phone LIKE ?) ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, municipalityId);
            String searchPattern = "%" + query + "%";
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Counts the total number of active municipality admins on the entire platform.
     *
     * @return The count of active admins, or 0 if none or on database error.
     */
    @Override
    public int getActiveAdminsCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'municipality_admin' AND status = 'active'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Counts the total number of registered citizens on the platform.
     *
     * @return The count of citizens, or 0 if none or on database error.
     */
    @Override
    public int getTotalCitizensCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'citizen'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Gets a list of all municipality admins, joining the municipalities table to display their assigned location.
     *
     * @return A list of admin UserDTOs, ordered from newest to oldest.
     */
    @Override
    public ArrayList<UserDTO> getAllMunicipalityAdmins() {
        ArrayList<UserDTO> users = new ArrayList<>();
        String sql = "SELECT u.*, m.name as municipality_name FROM users u " +
                     "LEFT JOIN municipalities m ON u.municipality_id = m.id " +
                     "WHERE u.role = 'municipality_admin' ORDER BY u.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                users.add(mapResultSetToUserDTO(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Automatically seeds a default Super Admin account (admin@gmail.com / Admin@123) if none exists.
     * Runs at startup to guarantee access.
     */
    public void seedDefaultAdmin() {
        String checkSql = "SELECT COUNT(*) FROM users WHERE role = 'super_admin'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next() && rs.getInt(1) == 0) {
                System.out.println("No Super Admin found. Seeding default admin...");
                String insertSql = "INSERT INTO users (full_name, email, phone, password_hash, role, status, created_at) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, NOW())";
                try (PreparedStatement ips = conn.prepareStatement(insertSql)) {
                    ips.setString(1, "System Administrator");
                    ips.setString(2, "admin@gmail.com");
                    ips.setString(3, "9800000000");
                    ips.setString(4, PasswordUtil.hashPassword("Admin@123"));
                    ips.setString(5, "super_admin");
                    ips.setString(6, "active");
                    ips.executeUpdate();
                    System.out.println("Default Super Admin seeded: admin@gmail.com / Admin@123");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Helper method to convert a database row (ResultSet) into a Users model object.
     *
     * @param rs The ResultSet pointer at the current row.
     * @return The fully populated Users object.
     * @throws Exception If there is a database reading issue.
     */
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

    /**
     * Helper method to convert a database row (ResultSet) into a UserDTO object.
     *
     * @param rs The ResultSet pointer at the current row.
     * @return The populated UserDTO object.
     * @throws Exception If there is a database reading issue.
     */
    private UserDTO mapResultSetToUserDTO(ResultSet rs) throws Exception {
        UserDTO dto = new UserDTO();
        dto.setId(rs.getInt("id"));
        dto.setFullName(rs.getString("full_name"));
        dto.setEmail(rs.getString("email"));
        dto.setPhone(rs.getString("phone"));
        dto.setRole(rs.getString("role"));
        dto.setMunicipalityId((Integer) rs.getObject("municipality_id"));
        dto.setMunicipalityName(rs.getString("municipality_name"));
        dto.setWardNumber((Integer) rs.getObject("ward_number"));
        dto.setStatus(rs.getString("status"));
        dto.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return dto;
    }
}
