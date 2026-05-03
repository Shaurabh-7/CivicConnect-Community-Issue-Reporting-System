<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String currentPath = request.getServletPath(); %>
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="logo-box">CC</div>
        <span>SuperAdmin</span>
    </div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/superadmin/dashboard" class="<%= currentPath.contains("dashboard") ? "active" : "" %>">
            <i class="fas fa-chart-line"></i> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/superadmin/municipalities" class="<%= currentPath.contains("municipalities") ? "active" : "" %>">
            <i class="fas fa-city"></i> Municipalities
        </a>
        <a href="<%= request.getContextPath() %>/superadmin/admins" class="<%= currentPath.contains("admins") ? "active" : "" %>">
            <i class="fas fa-users-cog"></i> Municipality Admins
        </a>
        <a href="<%= request.getContextPath() %>/superadmin/categories" class="<%= currentPath.contains("categories") ? "active" : "" %>">
            <i class="fas fa-tags"></i> Categories
        </a>
    </nav>
    <div class="sidebar-status">
        <p>Logged in as <strong>Super Admin</strong></p>
        <p class="access-text">Platform-wide access</p>
    </div>
</aside>