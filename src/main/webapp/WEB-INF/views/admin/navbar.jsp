<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%
    String currentURI = request.getRequestURI();
%>

<!-- Top Sticky Navbar -->
<nav class="admin-navbar">
    <div class="admin-nav-container">
        <a href="<%= request.getContextPath() %>/admin/dashboard" class="admin-logo-link">
            <span class="logo-box">CC</span>
            <span class="logo-text">CivicConnect</span>
        </a>
        
        <ul class="admin-nav-links">
            <li><a href="<%= request.getContextPath() %>/admin/dashboard" class="<%= currentURI.contains("dashboard") ? "active" : "" %>">DASHBOARD</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/manage-complaints" class="<%= currentURI.contains("manage-complaints") ? "active" : "" %>">MANAGE COMPLAINTS</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/manage-users" class="<%= currentURI.contains("manage-users") ? "active" : "" %>">MANAGE USERS</a></li>
            <li><a href="<%= request.getContextPath() %>/admin/reports" class="<%= currentURI.contains("reports") ? "active" : "" %>">REPORTS</a></li>
        </ul>
        
        <div class="admin-user-menu">
            <div class="admin-avatar-circle">
                <c:set var="nameParts" value="${fn:split(sessionScope.userName, ' ')}" />
                <c:choose>
                    <c:when test="${fn:length(nameParts) >= 2}">
                        <c:out value="${fn:toUpperCase(fn:substring(nameParts[0], 0, 1))}${fn:toUpperCase(fn:substring(nameParts[1], 0, 1))}" />
                    </c:when>
                    <c:otherwise>
                        <c:out value="${fn:toUpperCase(fn:substring(sessionScope.userName, 0, 2))}" />
                    </c:otherwise>
                </c:choose>
            </div>
            <span class="admin-user-info">
                <strong><c:out value="${sessionScope.userName}" /></strong> • <c:out value="${sessionScope.municipalityName}" />
            </span>
            <a href="<%= request.getContextPath() %>/logout" class="admin-btn-logout">Logout</a>
        </div>
    </div>
</nav>

<!-- Left Sidebar -->
<aside class="admin-sidebar">
    <div class="sidebar-section-title">MUNICIPALITY ADMIN</div>
    <nav class="sidebar-menu">
        <a href="<%= request.getContextPath() %>/admin/dashboard" class="<%= currentURI.contains("dashboard") ? "active" : "" %>">
            <i class="fas fa-th-large"></i> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/admin/manage-complaints" class="<%= currentURI.contains("manage-complaints") ? "active" : "" %>">
            <i class="fas fa-tasks"></i> Manage Complaints
        </a>
        <a href="<%= request.getContextPath() %>/admin/manage-users" class="<%= currentURI.contains("manage-users") ? "active" : "" %>">
            <i class="fas fa-users"></i> Manage Users
        </a>
        <a href="<%= request.getContextPath() %>/admin/reports" class="<%= currentURI.contains("reports") ? "active" : "" %>">
            <i class="fas fa-chart-bar"></i> Reports
        </a>
    </nav>
    
    <div class="admin-sidebar-footer">
        <div class="footer-label">Logged in as</div>
        <div class="footer-username"><c:out value="${sessionScope.userName}" /></div>
        <div class="footer-role">Municipality Admin</div>
    </div>
</aside>
