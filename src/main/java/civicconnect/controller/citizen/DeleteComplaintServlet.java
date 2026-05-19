package civicconnect.controller.citizen;

import civicconnect.dao.ComplaintDAO;
import civicconnect.model.Complaint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/citizen/delete-complaint")
public class DeleteComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Complaint complaint = complaintDAO.getComplaintById(id);

            // Security Check: Only the owner can delete, and only if it's pending
            if (complaint != null && complaint.getUserId() == userId && "pending".equalsIgnoreCase(complaint.getStatus())) {
                if (complaintDAO.deleteComplaint(id)) {
                    response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?success=Complaint+deleted+successfully");
                    return;
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?error=Could+not+delete+complaint");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
