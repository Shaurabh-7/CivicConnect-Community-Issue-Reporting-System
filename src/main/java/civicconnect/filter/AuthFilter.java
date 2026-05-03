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
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String path = httpRequest.getServletPath();
        String contextPath = httpRequest.getContextPath();

        // 1. Define Public Routes (Anyone can access)
        boolean isPublicResource = path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/");
        boolean isPublicPage = path.equals("/login") || path.equals("/register") ||
                               path.equals("/home") || path.equals("/about") ||
                               path.equals("/") || path.isEmpty();

        if (isPublicResource || isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Check if user is logged in
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;

        if (userRole == null) {
            // Not logged in -> Redirect to login
            httpResponse.sendRedirect(contextPath + "/login?message=Please+log+in+to+continue.");
            return;
        }

        // 3. Role-Based Authorization
        boolean isAuthorized = false;

        if (path.startsWith("/superadmin/")) {
            if ("super_admin".equals(userRole)) {
                isAuthorized = true;
            }
        } else if (path.startsWith("/admin/")) {
            if ("municipality_admin".equals(userRole)) {
                isAuthorized = true;
            }
        } else if (path.startsWith("/citizen/")) {
            if ("citizen".equals(userRole)) {
                isAuthorized = true;
            }
        } else {
            // Any other internal route (e.g. root level protected actions)
            isAuthorized = true;
        }

        if (isAuthorized) {
            chain.doFilter(request, response);
        } else {
            // Logged in but wrong role -> Send 403 Forbidden
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
