package civicconnect.controller.citizen;

import civicconnect.dao.UserDAO;
import civicconnect.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/citizen/profile")
public class CitizenProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        
        Users user = userDAO.getUserById(userId);
        
        // Fetch stats for profile header
        civicconnect.dao.ComplaintDAO complaintDAO = new civicconnect.dao.ComplaintDAO();
        int complaintCount = complaintDAO.getTotalComplaintsCountByUser(userId);
        
        request.setAttribute("user", user);
        request.setAttribute("complaintCount", complaintCount);
        
        request.getRequestDispatcher("/WEB-INF/views/citizen/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            int wardNumber = Integer.parseInt(request.getParameter("wardNumber"));

            Users user = userDAO.getUserById(userId);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setWardNumber(wardNumber);

            if (userDAO.updateUserProfile(user)) {
                session.setAttribute("userName", fullName);
                session.setAttribute("wardNumber", wardNumber);
                response.sendRedirect(request.getContextPath() + "/citizen/profile?success=Profile+updated");
            } else {
                request.setAttribute("error", "Failed to update profile.");
                doGet(request, response);
            }
        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            Users user = userDAO.getUserById(userId);

            if (!BCrypt.checkpw(currentPassword, user.getPasswordHash())) {
                request.setAttribute("error", "Current password is incorrect.");
                doGet(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New passwords do not match.");
                doGet(request, response);
                return;
            }

            String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
            if (userDAO.changePassword(userId, hashed)) {
                response.sendRedirect(request.getContextPath() + "/citizen/profile?success=Password+changed");
            } else {
                request.setAttribute("error", "Failed to change password.");
                doGet(request, response);
            }
        }
    }
}
