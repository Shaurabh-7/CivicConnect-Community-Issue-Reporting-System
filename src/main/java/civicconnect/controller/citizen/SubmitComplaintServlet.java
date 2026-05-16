package civicconnect.controller.citizen;

import civicconnect.dao.CategoryDAO;
import civicconnect.dao.ComplaintDAO;
import civicconnect.model.Categories;
import civicconnect.model.Complaint;
import civicconnect.model.Users;
import civicconnect.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.UUID;

@WebServlet("/citizen/submit-complaint")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class SubmitComplaintServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ArrayList<Categories> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/WEB-INF/views/citizen/submit-complaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        Users user = userDAO.getUserById(userId);

        // Get parameters
        String title = request.getParameter("title");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        int wardNumber = Integer.parseInt(request.getParameter("wardNumber"));
        String location = request.getParameter("location");
        String contactEmail = request.getParameter("contactEmail");
        boolean isAnonymous = request.getParameter("isAnonymous") != null;

        // Handle Image Upload
        String imagePath = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "complaints";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            filePart.write(uploadPath + File.separator + fileName);
            imagePath = "uploads/complaints/" + fileName;
        }

        // Create Complaint object
        Complaint complaint = new Complaint();
        complaint.setUserId(userId);
        complaint.setMunicipalityId(user.getMunicipalityId());
        complaint.setCategoryId(categoryId);
        complaint.setTitle(title);
        complaint.setDescription(description);
        complaint.setWardNumber(wardNumber);
        complaint.setLocation(location);
        complaint.setImagePath(imagePath);
        complaint.setAnonymous(isAnonymous);
        complaint.setContactEmail(contactEmail);
        complaint.setStatus("pending");
        complaint.setVoteCount(0);

        if (complaintDAO.submitComplaint(complaint)) {
            response.sendRedirect(request.getContextPath() + "/citizen/dashboard?success=Complaint+submitted+successfully");
        } else {
            request.setAttribute("error", "Failed to submit complaint. Please try again.");
            doGet(request, response);
        }
    }
}
