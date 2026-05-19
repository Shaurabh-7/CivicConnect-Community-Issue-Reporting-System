package civicconnect.controller.citizen;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/citizen/view-complaint")
public class ViewComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/citizen/dashboard");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            ComplaintDTO complaint = complaintDAO.getComplaintDTOById(id);

            if (complaint == null) {
                response.sendRedirect(request.getContextPath() + "/citizen/dashboard?error=Complaint+not+found");
                return;
            }

            // Check if the current citizen has voted/supported this complaint
            boolean hasVoted = false;
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("userId") != null) {
                int currentUserId = (int) session.getAttribute("userId");
                civicconnect.dao.VoteDAO voteDAO = new civicconnect.dao.VoteDAO();
                hasVoted = voteDAO.hasUserVoted(currentUserId, id);
            }

            request.setAttribute("complaint", complaint);
            request.setAttribute("hasVoted", hasVoted);
            request.getRequestDispatcher("/WEB-INF/views/citizen/view-complaint.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/citizen/dashboard?error=Internal+Server+Error");
        }
    }
}
