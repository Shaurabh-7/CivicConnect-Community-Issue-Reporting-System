package civicconnect.dao;

import civicconnect.daoInterface.complaintInterface;
import civicconnect.model.Complaint;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 * Handles all database operations for civic complaints.
 * Allows citizens to submit and edit complaints, and allows admins to update status.
 */
public class ComplaintDAO implements complaintInterface {

    /**
     * Submits a new citizen complaint to the database.
     * Sets the initial status to "pending" if no status is given.
     *
     * @param complaint The complaint object containing the issue details.
     * @return True if the complaint was successfully submitted, false otherwise.
     */
    @Override
    public boolean submitComplaint(Complaint complaint) {
        String sql = "INSERT INTO complaints (user_id, municipality_id, category_id, title, description, ward_number, location, image_path, is_anonymous, status, vote_count, contact_email, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, complaint.getUserId());
            ps.setInt(2, complaint.getMunicipalityId());
            ps.setInt(3, complaint.getCategoryId());
            ps.setString(4, complaint.getTitle());
            ps.setString(5, complaint.getDescription());
            ps.setInt(6, complaint.getWardNumber());
            ps.setString(7, complaint.getLocation());
            ps.setString(8, complaint.getImagePath());
            ps.setBoolean(9, complaint.isAnonymous());
            ps.setString(10, complaint.getStatus() != null ? complaint.getStatus() : "pending");
            ps.setInt(11, complaint.getVoteCount());
            ps.setString(12, complaint.getContactEmail());

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing complaint with new details (like title, description, or location).
     *
     * @param complaint The complaint object containing the updated details.
     * @return True if the complaint was successfully updated, false otherwise.
     */
    @Override
    public boolean updateComplaint(Complaint complaint) {
        String sql = "UPDATE complaints SET category_id = ?, title = ?, description = ?, ward_number = ?, location = ?, image_path = ?, is_anonymous = ?, contact_email = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, complaint.getCategoryId());
            ps.setString(2, complaint.getTitle());
            ps.setString(3, complaint.getDescription());
            ps.setInt(4, complaint.getWardNumber());
            ps.setString(5, complaint.getLocation());
            ps.setString(6, complaint.getImagePath());
            ps.setBoolean(7, complaint.isAnonymous());
            ps.setString(8, complaint.getContactEmail());
            ps.setInt(9, complaint.getId());

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Permanently deletes a complaint from the database.
     *
     * @param id The unique ID of the complaint to delete.
     * @return True if the complaint was successfully deleted, false otherwise.
     */
    @Override
    public boolean deleteComplaint(int id) {
        String sql = "DELETE FROM complaints WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Finds a single complaint by its unique ID.
     *
     * @param id The unique ID of the complaint to search for.
     * @return The found Complaint object, or null if no complaint matches the ID.
     */
    @Override
    public Complaint getComplaintById(int id) {
        String sql = "SELECT * FROM complaints WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToComplaint(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Gets a list of all complaints submitted in the platform, ordered from newest to oldest.
     *
     * @return A list containing all complaints, or an empty list if none exist.
     */
    @Override
    public ArrayList<Complaint> getAllComplaints() {
        ArrayList<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM complaints ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Gets a list of all complaints submitted by a specific citizen.
     *
     * @param userId The unique ID of the citizen.
     * @return A list of complaints submitted by the citizen, or an empty list if none.
     */
    @Override
    public ArrayList<Complaint> getComplaintsByUser(int userId) {
        ArrayList<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Gets a list of all complaints submitted within a specific municipality.
     *
     * @param municipalityId The unique ID of the municipality.
     * @return A list of complaints from that municipality, or an empty list if none.
     */
    @Override
    public ArrayList<Complaint> getComplaintsByMunicipality(int municipalityId) {
        ArrayList<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE municipality_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, municipalityId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Gets all complaints that match a specific status (like "pending", "in_progress", or "resolved").
     *
     * @param status The status name to filter by.
     * @return A list of complaints matching the status.
     */
    @Override
    public ArrayList<Complaint> getComplaintsByStatus(String status) {
        ArrayList<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE status = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Updates the status of a specific complaint.
     *
     * @param id The unique ID of the complaint.
     * @param status The new status value (such as "in_progress" or "resolved").
     * @return True if the status was successfully updated, false otherwise.
     */
    @Override
    public boolean updateComplaintStatus(int id, String status) {
        String sql = "UPDATE complaints SET status = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates the vote count (upvotes) of a specific complaint by a set amount.
     *
     * @param id The unique ID of the complaint.
     * @param increment The number of votes to add or subtract (usually 1 or -1).
     * @return True if the vote count was successfully updated, false otherwise.
     */
    @Override
    public boolean updateVoteCount(int id, int increment) {
        String sql = "UPDATE complaints SET vote_count = vote_count + ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, increment);
            ps.setInt(2, id);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gets a list of recent complaints submitted by a citizen, limited to a maximum number.
     * This method joins categories to retrieve the category name directly.
     *
     * @param userId The unique ID of the citizen.
     * @param limit The maximum number of complaints to return.
     * @return A list of recent complaint DTOs, or an empty list if none.
     */
    @Override
    public ArrayList<ComplaintDTO> getRecentComplaintsByUser(int userId, int limit) {
        ArrayList<ComplaintDTO> list = new ArrayList<>();
        String sql = "SELECT c.*, cat.name as category_name FROM complaints c " +
                     "LEFT JOIN categories cat ON c.category_id = cat.id " +
                     "WHERE c.user_id = ? ORDER BY c.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToComplaintDTO(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Counts how many complaints a user has submitted that match a specific status.
     *
     * @param userId The unique ID of the citizen.
     * @param status The status name to check.
     * @return The count of complaints matching the criteria, or 0 if none or on error.
     */
    @Override
    public int getComplaintsCountByUserAndStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM complaints WHERE user_id = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Counts all fully resolved complaints on the platform.
     *
     * @return The count of resolved complaints, or 0 if none or on database error.
     */
    @Override
    public int getResolvedComplaintsCount() {
        String sql = "SELECT COUNT(*) FROM complaints WHERE status = 'resolved'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Counts all complaints that are currently in progress on the platform.
     *
     * @return The count of in-progress complaints, or 0 if none or on database error.
     */
    @Override
    public int getInProgressComplaintsCount() {
        String sql = "SELECT COUNT(*) FROM complaints WHERE status = 'in_progress'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Counts the total number of complaints submitted on the entire platform.
     *
     * @return The total number of complaints, or 0 if none or on database error.
     */
    @Override
    public int getTotalComplaintsCount() {
        String sql = "SELECT COUNT(*) FROM complaints";
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
     * Counts the total number of complaints submitted by a single citizen.
     *
     * @param userId The unique ID of the citizen.
     * @return The total count of complaints, or 0 if none or on database error.
     */
    @Override
    public int getTotalComplaintsCountByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM complaints WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Gets a list of complaints submitted by a citizen, matching custom filters like status, category, and search text.
     *
     * @param userId The unique ID of the citizen.
     * @param status The status filter (or "all").
     * @param categoryId The category ID filter (or 0 for all).
     * @param searchQuery The search text query (checks title and description).
     * @return A list of matching complaint DTOs, or an empty list if none.
     */
    @Override
    public ArrayList<ComplaintDTO> getFilteredComplaintsByUser(int userId, String status, Integer categoryId, String searchQuery) {
        ArrayList<ComplaintDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT c.*, cat.name as category_name FROM complaints c ");
        sql.append("LEFT JOIN categories cat ON c.category_id = cat.id ");
        sql.append("WHERE c.user_id = ? ");

        if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND c.status = ? ");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND c.category_id = ? ");
        }
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (c.title LIKE ? OR c.description LIKE ?) ");
        }

        sql.append("ORDER BY c.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIdx = 1;
            ps.setInt(paramIdx++, userId);

            if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
                ps.setString(paramIdx++, status);
            }
            if (categoryId != null && categoryId > 0) {
                ps.setInt(paramIdx++, categoryId);
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String lk = "%" + searchQuery.trim() + "%";
                ps.setString(paramIdx++, lk);
                ps.setString(paramIdx++, lk);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaintDTO(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Gets a single complaint details by its ID, joining categories and users to fetch names.
     *
     * @param id The unique ID of the complaint.
     * @return The fully populated ComplaintDTO object, or null if not found.
     */
    @Override
    public ComplaintDTO getComplaintDTOById(int id) {
        String sql = "SELECT c.*, cat.name as category_name, u.full_name as user_name FROM complaints c " +
                     "LEFT JOIN categories cat ON c.category_id = cat.id " +
                     "LEFT JOIN users u ON c.user_id = u.id " +
                     "WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ComplaintDTO dto = mapResultSetToComplaintDTO(rs);
                try {
                    dto.setUserName(rs.getString("user_name"));
                } catch (Exception ignored) {}
                return dto;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Gets a list of complaints in a municipality matching filters, with custom sorting (newest first, or by votes).
     * Used mainly to power the public homepage feed.
     *
     * @param municipalityId The ID of the municipality, or 0 to get all complaints.
     * @param status The status filter (or "all").
     * @param categoryId The category ID filter (or 0 for all).
     * @param searchQuery The search text query.
     * @param sortBy The sorting mode ("trending" or "latest").
     * @return A list of matching complaint DTOs, or an empty list if none.
     */
    @Override
    public ArrayList<ComplaintDTO> getPublicComplaintsByMunicipality(int municipalityId, String status, Integer categoryId, String searchQuery, String sortBy) {
        ArrayList<ComplaintDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT c.*, cat.name as category_name, u.full_name as user_name, m.name as municipality_name FROM complaints c ");
        sql.append("LEFT JOIN categories cat ON c.category_id = cat.id ");
        sql.append("LEFT JOIN users u ON c.user_id = u.id ");
        sql.append("LEFT JOIN municipalities m ON c.municipality_id = m.id ");
        sql.append("WHERE 1=1 ");

        if (municipalityId > 0) {
            sql.append("AND c.municipality_id = ? ");
        }

        if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND c.status = ? ");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append("AND c.category_id = ? ");
        }
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (c.title LIKE ? OR c.description LIKE ?) ");
        }

        if ("trending".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY c.vote_count DESC, c.created_at DESC");
        } else {
            sql.append("ORDER BY c.created_at DESC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIdx = 1;
            if (municipalityId > 0) {
                ps.setInt(paramIdx++, municipalityId);
            }

            if (status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status)) {
                ps.setString(paramIdx++, status);
            }
            if (categoryId != null && categoryId > 0) {
                ps.setInt(paramIdx++, categoryId);
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String lk = "%" + searchQuery.trim() + "%";
                ps.setString(paramIdx++, lk);
                ps.setString(paramIdx++, lk);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ComplaintDTO dto = mapResultSetToComplaintDTO(rs);
                dto.setUserName(rs.getString("user_name"));
                dto.setMunicipalityName(rs.getString("municipality_name"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Gets a list of complaints in a municipality that have the highest number of upvotes.
     * Used to show top-supported items in dashboards.
     *
     * @param municipalityId The unique ID of the municipality.
     * @param limit The maximum number of items to return.
     * @return A list of top supported complaints, or an empty list if none.
     */
    @Override
    public ArrayList<ComplaintDTO> getTopSupportedComplaints(int municipalityId, int limit) {
        ArrayList<ComplaintDTO> list = new ArrayList<>();
        String sql = "SELECT c.*, cat.name as category_name FROM complaints c " +
                     "LEFT JOIN categories cat ON c.category_id = cat.id " +
                     "WHERE c.municipality_id = ? " +
                     "ORDER BY c.vote_count DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, municipalityId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaintDTO(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Helper method to convert a database row (ResultSet) into a Complaint model object.
     *
     * @param rs The ResultSet pointer at the current row.
     * @return The fully populated Complaint object.
     * @throws Exception If there is a database reading issue.
     */
    private Complaint mapResultSetToComplaint(ResultSet rs) throws Exception {
        return new Complaint(
                rs.getInt("id"),
                rs.getInt("user_id"),
                rs.getInt("municipality_id"),
                rs.getInt("category_id"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getInt("ward_number"),
                rs.getString("location"),
                rs.getString("image_path"),
                rs.getBoolean("is_anonymous"),
                rs.getString("status"),
                rs.getInt("vote_count"),
                rs.getString("contact_email"),
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null,
                rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null
        );
    }

    /**
     * Helper method to convert a database row (ResultSet) into a ComplaintDTO object.
     *
     * @param rs The ResultSet pointer at the current row.
     * @return The populated ComplaintDTO object.
     * @throws Exception If there is a database reading issue.
     */
    private ComplaintDTO mapResultSetToComplaintDTO(ResultSet rs) throws Exception {
        ComplaintDTO dto = new ComplaintDTO();
        dto.setId(rs.getInt("id"));
        dto.setUserId(rs.getInt("user_id"));
        dto.setMunicipalityId(rs.getInt("municipality_id"));
        dto.setCategoryId(rs.getInt("category_id"));
        dto.setTitle(rs.getString("title"));
        dto.setDescription(rs.getString("description"));
        dto.setWardNumber(rs.getInt("ward_number"));
        dto.setLocation(rs.getString("location"));
        dto.setImagePath(rs.getString("image_path"));
        dto.setAnonymous(rs.getBoolean("is_anonymous"));
        dto.setStatus(rs.getString("status"));
        dto.setVoteCount(rs.getInt("vote_count"));
        dto.setContactEmail(rs.getString("contact_email"));
        dto.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        dto.setUpdatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
        
        try {
            dto.setCategoryName(rs.getString("category_name"));
        } catch (Exception ignored) {}
        
        return dto;
    }
}
