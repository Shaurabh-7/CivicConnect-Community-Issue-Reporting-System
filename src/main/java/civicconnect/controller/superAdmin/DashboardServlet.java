package civicconnect.controller.superAdmin;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.MunicipalityDAO;
import civicconnect.dao.UserDAO;
import civicconnect.dto.municipality.MunicipalityDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/superadmin/dashboard")
public class DashboardServlet extends HttpServlet {

    private final MunicipalityDAO municipalityDAO = new MunicipalityDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Fetch statistics
            int totalMunicipalities = municipalityDAO.getTotalMunicipalitiesCount();
            int activeAdmins = userDAO.getActiveAdminsCount();
            int totalCitizens = userDAO.getTotalCitizensCount();
            int totalComplaints = complaintDAO.getTotalComplaintsCount();

            // 2. Fetch recent activity (e.g. 5 most recent municipalities)
            ArrayList<MunicipalityDTO> recentMunicipalities = municipalityDAO.getRecentMunicipalities(5);

            // 3. Set attributes for JSP
            request.setAttribute("totalMunicipalities", totalMunicipalities);
            request.setAttribute("activeAdmins", activeAdmins);
            request.setAttribute("totalCitizens", totalCitizens);
            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("recentMunicipalities", recentMunicipalities);

            // 4. Forward to view
            request.getRequestDispatcher("/WEB-INF/views/superadmin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Dashboard Error: " + e.getMessage());
        }
    }
}
