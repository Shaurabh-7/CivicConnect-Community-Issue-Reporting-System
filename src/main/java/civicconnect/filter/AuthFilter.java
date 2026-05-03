package civicconnect.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getServletPath();
        String contextPath = req.getContextPath();

        // Allow public resources through without any checks
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;

        // No session → redirect to login
        if (userRole == null) {
            session = req.getSession(true);
            session.setAttribute("errorMessage", "Please log in to access this page.");
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Role vs URL prefix enforcement
        if (path.startsWith("/citizen/") && !"citizen".equals(userRole)) {
            res.sendRedirect(contextPath + "/unauthorized");
            return;
        }

        if (path.startsWith("/admin/") && !"municipality_admin".equals(userRole)) {
            res.sendRedirect(contextPath + "/unauthorized");
            return;
        }

        if (path.startsWith("/superadmin/") && !"super_admin".equals(userRole)) {
            res.sendRedirect(contextPath + "/unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("/")
                || path.equals("/login")
                || path.equals("/register")
                || path.equals("/about")
                || path.equals("/home")
                || path.equals("/unauthorized")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/uploads/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".png")
                || path.endsWith(".jpg")
                || path.endsWith(".ico");
    }

    @Override
    public void destroy() {
    }
}
