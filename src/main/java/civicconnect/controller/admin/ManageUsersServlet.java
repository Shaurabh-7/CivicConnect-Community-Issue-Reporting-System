package civicconnect.controller.admin;

import civicconnect.dao.UserDAO;
import civicconnect.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/admin/manage-users")
public class ManageUsersServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int adminUserId = (int) session.getAttribute("userId");
        Users adminUser = userDAO.getUserById(adminUserId);
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

        String search = request.getParameter("search");
        ArrayList<Users> citizens;

        if (search != null && !search.trim().isEmpty()) {
            citizens = userDAO.searchUsers(municipalityId, search.trim());
        } else {
            citizens = userDAO.getUsersByMunicipality(municipalityId);
        }

        request.setAttribute("citizens", citizens);
        request.setAttribute("paramSearch", search);

        request.getRequestDispatcher("/WEB-INF/views/admin/manage-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int adminUserId = (int) session.getAttribute("userId");
        Users adminUser = userDAO.getUserById(adminUserId);
        Integer municipalityId = adminUser.getMunicipalityId();

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.isEmpty() || action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=Invalid+request");
            return;
        }

        int targetUserId;
        try {
            targetUserId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=Invalid+user+ID");
            return;
        }

        Users targetUser = userDAO.getUserById(targetUserId);
        if (targetUser == null || targetUser.getMunicipalityId() != municipalityId || !"citizen".equals(targetUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Action not allowed.");
            return;
        }

        if ("activate".equals(action)) {
            boolean success = userDAO.updateUserStatus(targetUserId, "active");
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-users?success=User+activated+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=Failed+to+activate+user.");
            }
        } else if ("deactivate".equals(action)) {
            boolean success = userDAO.updateUserStatus(targetUserId, "inactive");
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-users?success=User+deactivated+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=Failed+to+deactivate+user.");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-users?error=Unknown+action");
        }
    }
}
