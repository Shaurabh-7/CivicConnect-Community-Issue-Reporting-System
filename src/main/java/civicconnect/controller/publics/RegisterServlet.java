package civicconnect.controller.publics;

import civicconnect.dao.UserDAO;
import civicconnect.dao.MunicipalityDAO;
import civicconnect.model.Users;
import civicconnect.model.Municipality;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import civicconnect.utils.PasswordUtil;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final MunicipalityDAO municipalityDAO = new MunicipalityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load active municipalities for the dropdown
        ArrayList<Municipality> municipalities = municipalityDAO.getActiveMunicipalities();
        request.setAttribute("municipalities", municipalities);

        request.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String municipalityIdStr = request.getParameter("municipalityId");
        String wardNumberStr = request.getParameter("wardNumber");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean hasError = false;

        // Validations
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

        if (!hasError) {
            if (userDAO.getUserByEmail(email.trim()) != null) {
                request.setAttribute("errorEmail", "An account with this email already exists.");
                hasError = true;
            }
        }

        if (hasError) {
            request.setAttribute("retainFullName", fullName);
            request.setAttribute("retainEmail", email);
            request.setAttribute("retainPhone", phone);
            request.setAttribute("retainWard", wardNumberStr);

            // Reload municipalities for re-render
            request.setAttribute("municipalities", municipalityDAO.getActiveMunicipalities());
            request.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(request, response);
            return;
        }

        // Success flow
        int municipalityId = Integer.parseInt(municipalityIdStr);
        String passwordHash = PasswordUtil.hashPassword(password);

        Users newUser = new Users();
        newUser.setFullName(fullName.trim());
        newUser.setEmail(email.trim());
        newUser.setPhone(phone.trim());
        newUser.setPasswordHash(passwordHash);
        newUser.setRole("citizen");
        newUser.setMunicipalityId(municipalityId);
        newUser.setWardNumber(wardNumber);
        newUser.setStatus("active");

        if (userDAO.registerUser(newUser)) {
            response.sendRedirect(request.getContextPath() + "/login?success=Registration+successful.+Please+log+in.");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.setAttribute("municipalities", municipalityDAO.getActiveMunicipalities());
            request.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(request, response);
        }
    }
}
