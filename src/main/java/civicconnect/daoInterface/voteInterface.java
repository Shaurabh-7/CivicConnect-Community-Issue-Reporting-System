package civicconnect.daoInterface;

import civicconnect.model.Votes;

public interface voteInterface {
    boolean addVote(Votes vote);
    boolean removeVote(int userId, int complaintId);
    boolean hasUserVoted(int userId, int complaintId);
    int getVoteCountByComplaint(int complaintId);
}
