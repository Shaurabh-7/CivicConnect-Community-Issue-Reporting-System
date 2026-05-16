package civicconnect.dao;

import civicconnect.daoInterface.complaintInterface;
import civicconnect.model.Complaint;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ComplaintDAO implements complaintInterface {

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
