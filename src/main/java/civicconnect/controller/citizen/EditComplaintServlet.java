package civicconnect.controller.citizen;

import civicconnect.dao.CategoryDAO;
import civicconnect.dao.ComplaintDAO;
import civicconnect.model.Categories;
import civicconnect.model.Complaint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.ArrayList;
import civicconnect.utils.FileUploadUtil;

@WebServlet("/citizen/edit-complaint")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class EditComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/citizen/dashboard");
            return;
        }

        int id = Integer.parseInt(idStr);
        Complaint complaint = complaintDAO.getComplaintById(id);

        // Security Check: Only the owner can edit, and only if it's pending
        if (complaint == null || complaint.getUserId() != userId || !"pending".equalsIgnoreCase(complaint.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?error=Unauthorized+or+Locked");
            return;
        }

        ArrayList<Categories> categories = categoryDAO.getAllCategories();
        request.setAttribute("complaint", complaint);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/WEB-INF/views/citizen/edit-complaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        
        int id = Integer.parseInt(request.getParameter("id"));
        Complaint existingComplaint = complaintDAO.getComplaintById(id);

        // Security Check
        if (existingComplaint == null || existingComplaint.getUserId() != userId || !"pending".equalsIgnoreCase(existingComplaint.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?error=Unauthorized+or+Locked");
            return;
        }

        // Get updated parameters
        String title = request.getParameter("title");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        int wardNumber = Integer.parseInt(request.getParameter("wardNumber"));
        String location = request.getParameter("location");
        String contactEmail = request.getParameter("contactEmail");
        boolean isAnonymous = request.getParameter("isAnonymous") != null;

        // Handle Image Upload (Optional)
        String imagePath = existingComplaint.getImagePath(); // Keep old one by default
        Part filePart = request.getPart("image");
        String newImagePath = FileUploadUtil.saveImage(filePart, getServletContext().getRealPath(""), "uploads/complaints");
        if (newImagePath != null) {
            imagePath = newImagePath;
        }

        // Update object
        existingComplaint.setTitle(title);
        existingComplaint.setCategoryId(categoryId);
        existingComplaint.setDescription(description);
        existingComplaint.setWardNumber(wardNumber);
        existingComplaint.setLocation(location);
        existingComplaint.setImagePath(imagePath);
        existingComplaint.setAnonymous(isAnonymous);
        existingComplaint.setContactEmail(contactEmail);

        if (complaintDAO.updateComplaint(existingComplaint)) {
            response.sendRedirect(request.getContextPath() + "/citizen/my-complaints?success=Complaint+updated+successfully");
        } else {
            request.setAttribute("error", "Failed to update complaint.");
            doGet(request, response);
        }
    }
}
