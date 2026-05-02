package civicconnect.controller;

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

@WebServlet(urlPatterns = { "/user-auth", "/login", "/register", "/home", "" })
public class UserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if (path.equals("/login")) {
            request.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(request, response);
        } else if (path.equals("/register")) {
            request.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(request, response);
        } else if (path.equals("/home") || path.equals("/") || path.isEmpty()) {
            request.getRequestDispatcher("/WEB-INF/views/public/home.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        switch (action) {
            case "register" -> handleRegister(request, response);
            case "login" -> handleLogin(request, response);
            case "logout" -> handleLogout(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String municipalityIdStr = request.getParameter("municipalityId");
        String wardNumberStr = request.getParameter("wardNumber");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean hasError = false;

        if (fullName == null || !fullName.trim().matches("^[a-zA-Z\\s]{2,}$")) {
            request.setAttribute("errorFullName", "Full name must contain only letters and spaces.");
            hasError = true;
        }

        if (email == null || !email.trim().matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("errorEmail", "Please enter a valid email address.");
            hasError = true;
        }

        if (phone == null || !phone.trim().matches("^(97|98)\\d{8}$")) {
            request.setAttribute("errorPhone", "Phone must be 10 digits starting with 97 or 98.");
            hasError = true;
        }

        if (municipalityIdStr == null || municipalityIdStr.isEmpty()) {
            request.setAttribute("errorMunicipality", "Please select your municipality.");
            hasError = true;
        }

        int wardNumber = 0;
        if (wardNumberStr == null || wardNumberStr.isEmpty()) {
            request.setAttribute("errorWard", "Please enter a valid ward number.");
            hasError = true;
        } else {
            try {
                wardNumber = Integer.parseInt(wardNumberStr);
                if (wardNumber < 1 || wardNumber > 33) {
                    request.setAttribute("errorWard", "Ward number must be between 1 and 33.");
                    hasError = true;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorWard", "Please enter a valid ward number.");
                hasError = true;
            }
        }

        if (password == null || !password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$")) {
            request.setAttribute("errorPassword",
                    "Password must be at least 8 characters with one uppercase letter, one lowercase letter, and one number.");
            hasError = true;
        }

        if (confirmPassword == null || !confirmPassword.equals(password)) {
            request.setAttribute("errorConfirmPassword", "Passwords do not match.");
            hasError = true;
        }

        // --- Duplicate email check ---
        if (!hasError) {
            if (userDAO.getUserByEmail(email.trim()) != null) {
                request.setAttribute("errorEmail", "An account with this email already exists.");
                hasError = true;
            }
        }

        // --- If any error, re-render register page ---
        if (hasError) {
            // Retain entered values (except passwords)
            request.setAttribute("retainFullName", fullName);
            request.setAttribute("retainEmail", email);
            request.setAttribute("retainPhone", phone);
            request.setAttribute("retainWard", wardNumberStr);
            request.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(request, response);
            return;
        }

        // --- Hash password and save ---
        int municipalityId = Integer.parseInt(municipalityIdStr);
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(12));

        Users newUser = new Users();
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim());
        newUser.setPhone(phone.trim());
        newUser.setPasswordHash(passwordHash);
        newUser.setRole("citizen");
        newUser.setMunicipalityId(municipalityId);
        newUser.setWardNumber(wardNumber);
        newUser.setStatus("active");

        boolean registered = userDAO.registerUser(newUser);

        if (registered) {
            response.sendRedirect(request.getContextPath() + "/login?success=Registration+successful.+Please+log+in.");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("rememberMe"); // "on" if checked

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

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Invalidate session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Clear remember-me cookie
        Cookie emailCookie = new Cookie("rememberedEmail", "");
        emailCookie.setMaxAge(0);
        emailCookie.setHttpOnly(true);
        emailCookie.setPath(request.getContextPath() + "/");
        response.addCookie(emailCookie);

        response.sendRedirect(request.getContextPath() + "/login?message=You+have+been+logged+out+successfully.");
    }
}
