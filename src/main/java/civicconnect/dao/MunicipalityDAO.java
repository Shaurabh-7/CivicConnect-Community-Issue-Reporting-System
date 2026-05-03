package civicconnect.dao;

import civicconnect.daoInterface.municipalityInterface;
import civicconnect.model.Municipality;
import civicconnect.dto.municipality.MunicipalityDTO;
import civicconnect.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class MunicipalityDAO implements municipalityInterface {

    @Override
    public boolean addMunicipality(Municipality municipality) {
        String sql = "INSERT INTO municipalities (name, district, province, status, created_at) VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, municipality.getName());
            ps.setString(2, municipality.getDistrict());
            ps.setString(3, municipality.getProvince());
            ps.setString(4, municipality.getStatus() != null ? municipality.getStatus() : "active");

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateMunicipality(Municipality municipality) {
        String sql = "UPDATE municipalities SET name = ?, district = ?, province = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, municipality.getName());
            ps.setString(2, municipality.getDistrict());
            ps.setString(3, municipality.getProvince());
            ps.setInt(4, municipality.getId());

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Municipality getMunicipalityById(int id) {
        String sql = "SELECT * FROM municipalities WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToMunicipality(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public ArrayList<MunicipalityDTO> getAllMunicipalities() {
        ArrayList<MunicipalityDTO> list = new ArrayList<>();
        String sql = "SELECT m.*, " +
                "(SELECT full_name FROM users WHERE municipality_id = m.id AND role = 'municipality_admin' LIMIT 1) as admin_name, "
                +
                "(SELECT COUNT(*) FROM users WHERE municipality_id = m.id AND role = 'citizen') as citizen_count, " +
                "(SELECT COUNT(*) FROM complaints WHERE municipality_id = m.id) as complaint_count " +
                "FROM municipalities m ORDER BY m.name ASC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToMunicipalityDTO(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ArrayList<Municipality> getActiveMunicipalities() {
        ArrayList<Municipality> list = new ArrayList<>();
        String sql = "SELECT * FROM municipalities WHERE status = 'active' ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToMunicipality(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateMunicipalityStatus(int id, String status) {
        String sql = "UPDATE municipalities SET status = ? WHERE id = ?";
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
    public int getTotalMunicipalitiesCount() {
        String sql = "SELECT COUNT(*) FROM municipalities";
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
    public ArrayList<MunicipalityDTO> getRecentMunicipalities(int limit) {
        ArrayList<MunicipalityDTO> list = new ArrayList<>();
        String sql = "SELECT m.*, " +
                "(SELECT full_name FROM users WHERE municipality_id = m.id AND role = 'municipality_admin' LIMIT 1) as admin_name, "
                +
                "(SELECT COUNT(*) FROM users WHERE municipality_id = m.id AND role = 'citizen') as citizen_count, " +
                "(SELECT COUNT(*) FROM complaints WHERE municipality_id = m.id) as complaint_count " +
                "FROM municipalities m ORDER BY m.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToMunicipalityDTO(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Municipality mapResultSetToMunicipality(ResultSet rs) throws Exception {
        return new Municipality(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("district"),
                rs.getString("province"),
                rs.getString("status"),
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
    }

    private MunicipalityDTO mapResultSetToMunicipalityDTO(ResultSet rs) throws Exception {
        MunicipalityDTO dto = new MunicipalityDTO();
        dto.setId(rs.getInt("id"));
        dto.setName(rs.getString("name"));
        dto.setDistrict(rs.getString("district"));
        dto.setProvince(rs.getString("province"));
        dto.setStatus(rs.getString("status"));
        dto.setCreatedAt(
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);

        // Map extra fields from JOINs/Subqueries
        try {
            dto.setAdminName(rs.getString("admin_name"));
        } catch (Exception ignored) {
        }
        try {
            dto.setCitizenCount(rs.getInt("citizen_count"));
        } catch (Exception ignored) {
        }
        try {
            dto.setComplaintCount(rs.getInt("complaint_count"));
        } catch (Exception ignored) {
        }

        return dto;
    }
}
