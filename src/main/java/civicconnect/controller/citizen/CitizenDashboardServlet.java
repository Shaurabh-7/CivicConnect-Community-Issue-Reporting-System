package civicconnect.controller.citizen;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.MunicipalityDAO;
import civicconnect.dao.UserDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.model.Municipality;
import civicconnect.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/citizen/dashboard")
public class CitizenDashboardServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();
    private final MunicipalityDAO municipalityDAO = new MunicipalityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        Users user = userDAO.getUserById(userId);
        if (user != null && user.getMunicipalityId() != null) {
            Municipality municipality = municipalityDAO.getMunicipalityById(user.getMunicipalityId());
            request.setAttribute("municipalityName", municipality != null ? municipality.getName() : "Unknown");
            request.setAttribute("user", user);
        }

        int totalSubmitted = complaintDAO.getTotalComplaintsCountByUser(userId);
        int pendingCount = complaintDAO.getComplaintsCountByUserAndStatus(userId, "pending");
        int inProgressCount = complaintDAO.getComplaintsCountByUserAndStatus(userId, "in progress");
        int resolvedCount = complaintDAO.getComplaintsCountByUserAndStatus(userId, "resolved");

        request.setAttribute("totalSubmitted", totalSubmitted);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("resolvedCount", resolvedCount);

        ArrayList<ComplaintDTO> recentComplaints = complaintDAO.getRecentComplaintsByUser(userId, 5);
        request.setAttribute("recentComplaints", recentComplaints);

        request.getRequestDispatcher("/WEB-INF/views/citizen/dashboard.jsp").forward(request, response);
    }
}
