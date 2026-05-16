package civicconnect.daoInterface;

import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.model.Complaint;
import java.util.ArrayList;

public interface complaintInterface {
    boolean submitComplaint(Complaint complaint);

    boolean updateComplaint(Complaint complaint);

    boolean deleteComplaint(int id);

    Complaint getComplaintById(int id);

    ArrayList<Complaint> getAllComplaints();

    ArrayList<Complaint> getComplaintsByUser(int userId);

    ArrayList<Complaint> getComplaintsByMunicipality(int municipalityId);

    ArrayList<Complaint> getComplaintsByStatus(String status);

    boolean updateComplaintStatus(int id, String status);

    boolean updateVoteCount(int id, int increment);

    int getTotalComplaintsCount();

    int getTotalComplaintsCountByUser(int userId);

    ArrayList<ComplaintDTO> getRecentComplaintsByUser(int userId, int limit);

    int getComplaintsCountByUserAndStatus(int userId, String status);
    
    ArrayList<ComplaintDTO> getFilteredComplaintsByUser(int userId, String status, Integer categoryId, String searchQuery);
    
    ComplaintDTO getComplaintDTOById(int id);
}
