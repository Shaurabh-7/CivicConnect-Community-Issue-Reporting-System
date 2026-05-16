package civicconnect.controller.citizen;

import civicconnect.dao.CategoryDAO;
import civicconnect.dao.ComplaintDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.model.Categories;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/citizen/browse")
public class BrowseIssuesServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("municipalityId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get filters
        String status = request.getParameter("status");
        String categoryIdStr = request.getParameter("category");
        String searchQuery = request.getParameter("search");
        String munIdStr = request.getParameter("municipalityId");
        String tab = request.getParameter("tab"); // latest or trending

        int municipalityId = 0; 
        if (munIdStr != null && !munIdStr.isEmpty()) {
            try {
                municipalityId = Integer.parseInt(munIdStr);
            } catch (NumberFormatException ignored) {}
        } else {
            // Default to user's municipality if no filter is applied
            if (session.getAttribute("municipalityId") != null) {
                municipalityId = (int) session.getAttribute("municipalityId");
            }
        }
        
        String sortBy = (tab != null && tab.equals("trending")) ? "trending" : "latest";

        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty() && !"all".equalsIgnoreCase(categoryIdStr)) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException ignored) {}
        }

        // Fetch data
        ArrayList<ComplaintDTO> complaints = complaintDAO.getPublicComplaintsByMunicipality(municipalityId, status, categoryId, searchQuery, sortBy);
        ArrayList<Categories> categories = categoryDAO.getAllCategories();
        ArrayList<ComplaintDTO> topComplaints = complaintDAO.getTopSupportedComplaints(municipalityId, 5);
        
        // Find which ones user has already voted for
        java.util.Set<Integer> votedIds = new java.util.HashSet<>();
        civicconnect.dao.VoteDAO voteDAO = new civicconnect.dao.VoteDAO();
        int userId = (int) session.getAttribute("userId");
        for (ComplaintDTO c : complaints) {
            if (voteDAO.hasUserVoted(userId, c.getId())) {
                votedIds.add(c.getId());
            }
        }
        request.setAttribute("votedIds", votedIds);
        civicconnect.dao.MunicipalityDAO munDAO = new civicconnect.dao.MunicipalityDAO();
        ArrayList<civicconnect.dto.municipality.MunicipalityDTO> municipalities = munDAO.getAllMunicipalities();

        // Fetch Quick Stats
        int totalComplaints = complaintDAO.getTotalComplaintsCount();
        int resolvedComplaints = complaintDAO.getResolvedComplaintsCount();
        civicconnect.dao.UserDAO userDAO = new civicconnect.dao.UserDAO();
        int totalCitizens = userDAO.getTotalCitizensCount();
        int activeMun = municipalities.size();

        request.setAttribute("complaints", complaints);
        request.setAttribute("categories", categories);
        request.setAttribute("municipalities", municipalities);
        request.setAttribute("topComplaints", topComplaints);
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("resolvedComplaints", resolvedComplaints);
        request.setAttribute("totalCitizens", totalCitizens);
        request.setAttribute("activeMun", activeMun);
        
        request.setAttribute("currentStatus", status != null ? status : "all");
        request.setAttribute("currentCategory", categoryIdStr != null ? categoryIdStr : "all");
        request.setAttribute("currentSearch", searchQuery != null ? searchQuery : "");
        request.setAttribute("currentMunId", municipalityId);
        request.setAttribute("currentTab", sortBy);

        request.getRequestDispatcher("/WEB-INF/views/citizen/browse.jsp").forward(request, response);
    }
}
