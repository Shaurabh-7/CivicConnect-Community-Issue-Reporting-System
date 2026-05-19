package civicconnect.controller.admin;

import civicconnect.dao.CategoryDAO;
import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.UserDAO;
import civicconnect.dto.complaint.ComplaintDTO;
import civicconnect.model.Categories;
import civicconnect.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/manage-complaints")
public class ManageComplaintsServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        Users adminUser = userDAO.getUserById(userId);
        Integer municipalityId = adminUser.getMunicipalityId();

        if (municipalityId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No municipality assigned.");
            return;
        }

        // Defensive check: ensure municipality details are loaded in session
        if (session.getAttribute("municipalityDistrict") == null) {
            civicconnect.dao.MunicipalityDAO munDAO = new civicconnect.dao.MunicipalityDAO();
            civicconnect.model.Municipality mun = munDAO.getMunicipalityById(municipalityId);
            if (mun != null) {
                session.setAttribute("municipalityName", mun.getName());
                session.setAttribute("municipalityDistrict", mun.getDistrict());
                session.setAttribute("municipalityProvince", mun.getProvince());
            }
        }

        // Fetch categories for filter dropdown
        ArrayList<Categories> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);

        // Get filter parameters
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String categoryIdStr = request.getParameter("categoryId");
        String wardNumberStr = request.getParameter("wardNumber");
        String sortBy = request.getParameter("sortBy");

        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try { categoryId = Integer.parseInt(categoryIdStr); } catch (NumberFormatException ignored) {}
        }

        Integer wardNumber = null;
        if (wardNumberStr != null && !wardNumberStr.trim().isEmpty()) {
            try { wardNumber = Integer.parseInt(wardNumberStr); } catch (NumberFormatException ignored) {}
        }

        // We use "trending" or "latest" mapping
        String sortParam = "latest";
        if ("votes_desc".equals(sortBy)) {
            sortParam = "trending";
        }

        ArrayList<ComplaintDTO> complaints = complaintDAO.getPublicComplaintsByMunicipality(
                municipalityId, status, categoryId, search, sortParam
        );

        // In-memory filter for ward number if provided
        List<ComplaintDTO> filteredList = complaints;
        if (wardNumber != null) {
            final int wNum = wardNumber;
            filteredList = complaints.stream()
                    .filter(c -> c.getWardNumber() == wNum)
                    .collect(Collectors.toList());
        }

        // In-memory filter for oldest if requested (public complaints only supports 'trending' or 'latest')
        if ("date_asc".equals(sortBy)) {
            filteredList = new ArrayList<>(filteredList);
            java.util.Collections.reverse(filteredList);
        } else if ("votes_asc".equals(sortBy)) {
            filteredList = new ArrayList<>(filteredList);
            filteredList.sort(java.util.Comparator.comparingInt(ComplaintDTO::getVoteCount));
        }

        request.setAttribute("complaints", filteredList);

        // Retain filter parameters
        request.setAttribute("paramSearch", search);
        request.setAttribute("paramStatus", status);
        request.setAttribute("paramCategoryId", categoryIdStr);
        request.setAttribute("paramWard", wardNumberStr);
        request.setAttribute("paramSortBy", sortBy);

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-complaints.jsp").forward(request, response);
    }
}
