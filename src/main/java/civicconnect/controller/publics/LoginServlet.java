package civicconnect.controller.publics;

import civicconnect.dao.UserDAO;
import civicconnect.model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("rememberMe");

        // Basic empty check
        if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
            return;
        }

        // Look up user by email
        Users user = userDAO.getUserByEmail(email.trim());

        // Generic error if not found OR wrong password
        if (user == null || !BCrypt.checkpw(password, user.getPasswordHash())) {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.setAttribute("retainEmail", email);
            request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
            return;
        }

        // Check account status
        if ("inactive".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("errorMessage",
                    "Your account has been deactivated. Please contact your municipality admin.");
            request.setAttribute("retainEmail", email);
            request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
            return;
        }

        // Create session
        HttpSession session = request.getSession();
        session.invalidate(); // regenerate to prevent session fixation
        session = request.getSession(true);
        session.setMaxInactiveInterval(60 * 60); // 60 minutes

        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("municipalityId", user.getMunicipalityId());
        session.setAttribute("wardNumber", user.getWardNumber());

        // Remember Me cookie (email only, 7 days)
        if ("on".equals(remember)) {
            Cookie emailCookie = new Cookie("rememberedEmail", user.getEmail());
            emailCookie.setMaxAge(7 * 24 * 60 * 60);
            emailCookie.setHttpOnly(true);
            emailCookie.setPath(request.getContextPath() + "/");
            response.addCookie(emailCookie);
        }

        // Role-based redirect
        switch (user.getRole()) {
            case "super_admin" -> response.sendRedirect(request.getContextPath() + "/superadmin/dashboard");
            case "municipality_admin" -> response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            default -> response.sendRedirect(request.getContextPath() + "/citizen/dashboard");
        }
    }
}
