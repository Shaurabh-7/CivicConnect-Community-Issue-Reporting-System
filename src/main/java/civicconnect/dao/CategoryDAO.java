package civicconnect.dao;

import civicconnect.daoInterface.categoryInterface;
import civicconnect.model.Categories;
import civicconnect.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 * Handles all database operations for complaint categories.
 * Allows adding, updating, deleting, and fetching categories.
 */
public class CategoryDAO implements categoryInterface {

    /**
     * Adds a new complaint category to the database.
     *
     * @param category The category object containing the name to add.
     * @return True if the category was successfully added, false otherwise.
     */
    @Override
    public boolean addCategory(Categories category) {
        String sql = "INSERT INTO categories (name, created_at) VALUES (?, NOW())";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getName());

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates the name of an existing category in the database.
     *
     * @param category The category object containing the new name and its ID.
     * @return True if the update was successful, false otherwise.
     */
    @Override
    public boolean updateCategory(Categories category) {
        String sql = "UPDATE categories SET name = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getName());
            ps.setInt(2, category.getId());

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Permanently deletes a category from the database by its ID.
     *
     * @param id The unique ID of the category to delete.
     * @return True if the category was deleted, false otherwise.
     */
    @Override
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";
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
     * Finds a single category by its unique ID.
     *
     * @param id The unique ID of the category to look for.
     * @return The found Categories object, or null if no category matches the ID.
     */
    @Override
    public Categories getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Gets a list of all registered complaint categories, sorted alphabetically by name.
     *
     * @return An ArrayList containing all the categories, or an empty list if none are found.
     */
    @Override
    public ArrayList<Categories> getAllCategories() {
        ArrayList<Categories> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToCategory(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Counts the total number of categories saved in the system.
     * This count is displayed on the super admin dashboard.
     *
     * @return The total count of categories, or 0 if a database error happens.
     */
    @Override
    public int getTotalCategoriesCount() {
        String sql = "SELECT COUNT(*) FROM categories";
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
     * A helper method to convert a database row (ResultSet) into a Categories object.
     *
     * @param rs The ResultSet pointer at the current row.
     * @return The fully populated Categories object.
     * @throws Exception If there is an issue reading database columns.
     */
    private Categories mapResultSetToCategory(ResultSet rs) throws Exception {
        return new Categories(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
    }
}
