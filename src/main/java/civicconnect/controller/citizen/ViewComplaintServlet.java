package civicconnect.controller.citizen;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

        int id = Integer.parseInt(idStr);
        ComplaintDTO complaint = complaintDAO.getComplaintDTOById(id);

        if (complaint == null) {
            response.sendRedirect(request.getContextPath() + "/citizen/dashboard?error=Complaint+not+found");
            return;
        }

        // Security check: If anonymous, we might still show it if it's in the same municipality
        // For now, let's allow viewing if it exists.
        
        request.setAttribute("complaint", complaint);
        request.getRequestDispatcher("/WEB-INF/views/citizen/view-complaint.jsp").forward(request, response);
    }
}
