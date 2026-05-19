package civicconnect.controller.publics;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.MunicipalityDAO;
import civicconnect.dao.UserDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.model.Municipality;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = { "/home", "" })
public class HomeServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final MunicipalityDAO municipalityDAO = new MunicipalityDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filter params
        String searchQuery = request.getParameter("search");
        String munIdStr = request.getParameter("municipalityId");
        String tab = request.getParameter("tab"); // "latest" or "trending"
        if (tab == null || tab.isEmpty()) {
            tab = "latest";
        }

        int filterMunicipalityId = 0;
        if (munIdStr != null && !munIdStr.isEmpty()) {
            try {
                filterMunicipalityId = Integer.parseInt(munIdStr);
            } catch (NumberFormatException ignored) {}
        }

        // Fetch active municipalities for filter dropdown
        ArrayList<Municipality> municipalities = municipalityDAO.getActiveMunicipalities();

        // Fetch public complaints matching search/filter criteria
        ArrayList<ComplaintDTO> allComplaints = complaintDAO.getPublicComplaintsByMunicipality(
                filterMunicipalityId, null, null, searchQuery, tab
        );

        // Calculate global statistics across all complaints
        ArrayList<ComplaintDTO> statsComplaints = complaintDAO.getPublicComplaintsByMunicipality(0, null, null, null, "latest");
        int totalComplaintsCount = statsComplaints.size();
        int resolvedCount = 0;
        for (ComplaintDTO c : statsComplaints) {
            if ("resolved".equalsIgnoreCase(c.getStatus())) {
                resolvedCount++;
            }
        }
        int activeMunicipalitiesCount = municipalities.size();
        int totalCitizens = userDAO.getTotalCitizensCount();

        // Top 5 most supported issues globally (highest vote count)
        List<ComplaintDTO> topSupported = new ArrayList<>(statsComplaints);
        topSupported.sort((c1, c2) -> Integer.compare(c2.getVoteCount(), c1.getVoteCount()));
        if (topSupported.size() > 5) {
            topSupported = topSupported.subList(0, 5);
        }

        // Pass attributes to View
        request.setAttribute("municipalities", municipalities);
        request.setAttribute("complaints", allComplaints);
        request.setAttribute("topSupported", topSupported);
        
        request.setAttribute("totalComplaintsCount", totalComplaintsCount);
        request.setAttribute("resolvedCount", resolvedCount);
        request.setAttribute("activeMunicipalitiesCount", activeMunicipalitiesCount);
        request.setAttribute("totalCitizens", totalCitizens);

        request.setAttribute("paramSearch", searchQuery);
        request.setAttribute("paramMunicipalityId", filterMunicipalityId);
        request.setAttribute("activeTab", tab);

        request.getRequestDispatcher("/WEB-INF/views/public/home.jsp").forward(request, response);
    }
}
