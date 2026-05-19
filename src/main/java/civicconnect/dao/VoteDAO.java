package civicconnect.dao;

import civicconnect.daoInterface.voteInterface;
import civicconnect.model.Votes;
import civicconnect.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Handles all database operations for voting on complaints.
 * Allows adding votes, removing votes, checking if a user voted, and counting votes.
 */
public class VoteDAO implements voteInterface {

    /**
     * Adds an upvote from a citizen to a complaint.
     *
     * @param vote The Votes object containing the userId and complaintId.
     * @return True if the vote was successfully saved, false otherwise.
     */
    @Override
    public boolean addVote(Votes vote) {
        String sql = "INSERT INTO votes (user_id, complaint_id, created_at) VALUES (?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vote.getUserId());
            ps.setInt(2, vote.getComplaintId());

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Removes an upvote from a citizen for a specific complaint (downvotes / cancels vote).
     *
     * @param userId The unique ID of the citizen.
     * @param complaintId The unique ID of the complaint.
     * @return True if the vote was successfully deleted, false otherwise.
     */
    @Override
    public boolean removeVote(int userId, int complaintId) {
        String sql = "DELETE FROM votes WHERE user_id = ? AND complaint_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, complaintId);

            int row = ps.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks if a citizen has already voted on a specific complaint.
     * Prevents citizens from upvoting the same complaint twice.
     *
     * @param userId The unique ID of the citizen.
     * @param complaintId The unique ID of the complaint.
     * @return True if the citizen has already voted, false otherwise.
     */
    @Override
    public boolean hasUserVoted(int userId, int complaintId) {
        String sql = "SELECT 1 FROM votes WHERE user_id = ? AND complaint_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, complaintId);
            ResultSet rs = ps.executeQuery();

            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Counts the total number of upvotes a specific complaint has received.
     *
     * @param complaintId The unique ID of the complaint.
     * @return The total vote count, or 0 if none or on database error.
     */
    @Override
    public int getVoteCountByComplaint(int complaintId) {
        String sql = "SELECT COUNT(*) FROM votes WHERE complaint_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, complaintId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
