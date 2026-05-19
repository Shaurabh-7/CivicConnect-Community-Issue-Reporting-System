package civicconnect.controller.admin;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.UserDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.model.Complaint;
import civicconnect.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        Users adminUser = userDAO.getUserById(userId);
        Integer municipalityId = adminUser.getMunicipalityId();

        if (municipalityId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No municipality assigned.");
            return;
        }

        // Defensive check: ensure municipality details are loaded in session
        if (session.getAttribute("municipalityDistrict") == null) {
            civicconnect.dao.MunicipalityDAO munDAO = new civicconnect.dao.MunicipalityDAO();
            civicconnect.model.Municipality mun = munDAO.getMunicipalityById(municipalityId);
            if (mun != null) {
                session.setAttribute("municipalityName", mun.getName());
                session.setAttribute("municipalityDistrict", mun.getDistrict());
                session.setAttribute("municipalityProvince", mun.getProvince());
            }
        }

        // Fetch all complaints for the admin's municipality
        ArrayList<Complaint> allComplaints = complaintDAO.getComplaintsByMunicipality(municipalityId);
        
        // Calculate counts
        long pendingCount = allComplaints.stream().filter(c -> "pending".equalsIgnoreCase(c.getStatus())).count();
        long inProgressCount = allComplaints.stream().filter(c -> "in_progress".equalsIgnoreCase(c.getStatus())).count();
        long resolvedCount = allComplaints.stream().filter(c -> "resolved".equalsIgnoreCase(c.getStatus())).count();
        int totalComplaints = allComplaints.size();

        // Calculate total citizens
        ArrayList<Users> citizens = userDAO.getUsersByMunicipality(municipalityId);
        int totalCitizens = citizens.size();

        // Total votes
        long totalVotes = allComplaints.stream().mapToInt(Complaint::getVoteCount).sum();

        // Latest 10 complaints (using ComplaintDTO for better UI presentation)
        // getPublicComplaintsByMunicipality handles DTO mapping which includes category and municipality names
        ArrayList<ComplaintDTO> recentComplaintsDTO = complaintDAO.getPublicComplaintsByMunicipality(
                municipalityId, null, null, null, "latest"
        );
        List<ComplaintDTO> latest10 = recentComplaintsDTO.stream().limit(10).collect(Collectors.toList());

        // Top 5 most supported complaints
        ArrayList<ComplaintDTO> topSupported = complaintDAO.getTopSupportedComplaints(municipalityId, 5);

        // Set attributes for JSP
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("resolvedCount", resolvedCount);
        request.setAttribute("totalCitizens", totalCitizens);
        request.setAttribute("totalVotes", totalVotes);
        
        request.setAttribute("latestComplaints", latest10);
        request.setAttribute("topSupported", topSupported);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
