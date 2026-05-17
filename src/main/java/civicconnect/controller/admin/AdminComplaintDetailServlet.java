package civicconnect.controller.admin;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.UserDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;

@WebServlet("/admin/complaint-detail")
public class AdminComplaintDetailServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int adminUserId = (int) session.getAttribute("userId");
        Users adminUser = userDAO.getUserById(adminUserId);
        Integer municipalityId = adminUser.getMunicipalityId();

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing complaint ID.");
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid complaint ID.");
            return;
        }

        ComplaintDTO complaint = complaintDAO.getComplaintDTOById(complaintId);
        if (complaint == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found.");
            return;
        }

        // Security check: Ensure complaint belongs to admin's municipality
        if (complaint.getMunicipalityId() != municipalityId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have access to this complaint.");
            return;
        }

        // Fetch submitter info for the admin view
        Users submitter = userDAO.getUserById(complaint.getUserId());
        request.setAttribute("submitter", submitter);
        request.setAttribute("complaint", complaint);

        request.getRequestDispatcher("/WEB-INF/views/admin/complaint-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int adminUserId = (int) session.getAttribute("userId");
        Users adminUser = userDAO.getUserById(adminUserId);
        Integer municipalityId = adminUser.getMunicipalityId();

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.isEmpty() || action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-complaints?error=Invalid+request");
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-complaints?error=Invalid+complaint+ID");
            return;
        }

        ComplaintDTO complaint = complaintDAO.getComplaintDTOById(complaintId);
        if (complaint == null || complaint.getMunicipalityId() != municipalityId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Action not allowed.");
            return;
        }

        if ("updateStatus".equals(action)) {
            String newStatus = request.getParameter("status");
            
            // Validate forward-only status update
            boolean valid = false;
            String currentStatus = complaint.getStatus();
            if ("pending".equals(currentStatus) && ("in_progress".equals(newStatus) || "resolved".equals(newStatus))) {
                valid = true;
            } else if ("in_progress".equals(currentStatus) && "resolved".equals(newStatus)) {
                valid = true;
            }

            if (!valid) {
                response.sendRedirect(request.getContextPath() + "/admin/complaint-detail?id=" + complaintId + "&error=Invalid+status+transition.");
                return;
            }

            boolean updated = complaintDAO.updateComplaintStatus(complaintId, newStatus);
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/complaint-detail?id=" + complaintId + "&success=Complaint+status+updated.");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/complaint-detail?id=" + complaintId + "&error=Failed+to+update+status.");
            }

        } else if ("delete".equals(action)) {
            
            String imagePath = complaint.getImagePath();
            boolean deleted = complaintDAO.deleteComplaint(complaintId);
            
            if (deleted) {
                // Delete image from disk if it exists
                if (imagePath != null && !imagePath.isEmpty()) {
                    String fullPath = getServletContext().getRealPath("") + File.separator + imagePath;
                    File imgFile = new File(fullPath);
                    if (imgFile.exists()) {
                        imgFile.delete();
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin/manage-complaints?success=Complaint+deleted+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/complaint-detail?id=" + complaintId + "&error=Failed+to+delete+complaint.");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-complaints?error=Unknown+action");
        }
    }
}
