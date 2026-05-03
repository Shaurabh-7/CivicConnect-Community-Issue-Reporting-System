package civicconnect.controller.superAdmin;

import civicconnect.dao.MunicipalityDAO;
import civicconnect.dto.municipality.MunicipalityDTO;
import civicconnect.model.Municipality;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/superadmin/municipalities")
public class MunicipalityManagementServlet extends HttpServlet {

    private final MunicipalityDAO municipalityDAO = new MunicipalityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/superadmin/municipality-form.jsp").forward(request, response);
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Municipality m = municipalityDAO.getMunicipalityById(id);
            request.setAttribute("municipality", m);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/WEB-INF/views/superadmin/municipality-form.jsp").forward(request, response);
            return;
        } else if ("toggleStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String currentStatus = request.getParameter("status");
            String newStatus = currentStatus.equalsIgnoreCase("active") ? "deactivated" : "active";
            municipalityDAO.updateMunicipalityStatus(id, newStatus);
            response.sendRedirect(request.getContextPath() + "/superadmin/municipalities");
            return;
        }

        ArrayList<MunicipalityDTO> municipalities = municipalityDAO.getAllMunicipalities();
        request.setAttribute("municipalities", municipalities);
        request.getRequestDispatcher("/WEB-INF/views/superadmin/municipalities.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String district = request.getParameter("district");
        String province = request.getParameter("province");

        if ("add".equals(action)) {
            Municipality m = new Municipality(0, name, district, province, "active", null);
            boolean success = municipalityDAO.addMunicipality(m);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/superadmin/municipalities?success=Municipality+added");
            } else {
                request.setAttribute("errorMessage", "Failed to add municipality.");
                request.getRequestDispatcher("/WEB-INF/views/superadmin/municipality-form.jsp").forward(request, response);
            }
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Municipality m = new Municipality(id, name, district, province, null, null);
            boolean success = municipalityDAO.updateMunicipality(m);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/superadmin/municipalities?success=Municipality+updated");
            } else {
                request.setAttribute("municipality", m);
                request.setAttribute("isEdit", true);
                request.setAttribute("errorMessage", "Failed to update municipality.");
                request.getRequestDispatcher("/WEB-INF/views/superadmin/municipality-form.jsp").forward(request, response);
            }
        }
    }
}
