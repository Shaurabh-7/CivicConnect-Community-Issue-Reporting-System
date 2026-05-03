package civicconnect.controller.superAdmin;

import civicconnect.dao.CategoryDAO;
import civicconnect.model.Categories;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/superadmin/categories")
public class CategoryManagementServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/superadmin/category-form.jsp").forward(request, response);
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Categories category = categoryDAO.getCategoryById(id);
            request.setAttribute("category", category);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/WEB-INF/views/superadmin/category-form.jsp").forward(request, response);
            return;
        }

        // Default: List all categories
        ArrayList<Categories> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/superadmin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String name = request.getParameter("categoryName");

        if ("add".equals(action)) {
            Categories category = new Categories(0, name, null);
            boolean success = categoryDAO.addCategory(category);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/superadmin/categories?success=Category+added");
            } else {
                request.setAttribute("errorMessage", "Failed to add category.");
                request.getRequestDispatcher("/WEB-INF/views/superadmin/category-form.jsp").forward(request, response);
            }
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Categories category = new Categories(id, name, null);
            boolean success = categoryDAO.updateCategory(category);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/superadmin/categories?success=Category+updated");
            } else {
                request.setAttribute("category", category);
                request.setAttribute("isEdit", true);
                request.setAttribute("errorMessage", "Failed to update category.");
                request.getRequestDispatcher("/WEB-INF/views/superadmin/category-form.jsp").forward(request, response);
            }
        }
    }
}
