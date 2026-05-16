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

@WebServlet("/citizen/my-complaints")
public class MyComplaintsServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        // Safety check for session
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // Get filter parameters from URL
        String status = request.getParameter("status");
        String categoryIdStr = request.getParameter("category");
        String searchQuery = request.getParameter("search");

        // Parse categoryId safely
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty() && !"all".equalsIgnoreCase(categoryIdStr)) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException ignored) {}
        }

        // Fetch data from DAO
        ArrayList<ComplaintDTO> complaints = complaintDAO.getFilteredComplaintsByUser(userId, status, categoryId, searchQuery);
        ArrayList<Categories> categories = categoryDAO.getAllCategories();

        // Set attributes for JSP
        request.setAttribute("complaints", complaints);
        request.setAttribute("categories", categories);
        request.setAttribute("currentStatus", status != null ? status : "all");
        request.setAttribute("currentCategory", categoryIdStr != null ? categoryIdStr : "all");
        request.setAttribute("currentSearch", searchQuery != null ? searchQuery : "");

        // Forward to the JSP
        request.getRequestDispatcher("/WEB-INF/views/citizen/my-complaints.jsp").forward(request, response);
    }
}
