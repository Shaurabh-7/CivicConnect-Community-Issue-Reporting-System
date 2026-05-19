<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String currentUri = request.getRequestURI();
    String userName = (String) session.getAttribute("userName");
    String munName = (String) session.getAttribute("municipalityName");
    if (munName == null) munName = "CivicConnect";
%>
<nav class="navbar citizen-nav">
    <div class="nav-container">
        <div class="nav-left-group">
            <a href="<%= request.getContextPath() %>/citizen/dashboard" class="nav-logo">
                <div class="logo-box">CC</div>
                <span>CivicConnect</span>
            </a>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/citizen/browse" class="<%= currentUri.contains("browse") ? "active" : "" %>">BROWSE</a>
                <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="<%= currentUri.contains("submit") ? "active" : "" %>">SUBMIT COMPLAINT</a>
                <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="<%= currentUri.contains("my-complaints") ? "active" : "" %>">MY COMPLAINTS</a>
                <a href="<%= request.getContextPath() %>/citizen/profile" class="<%= currentUri.contains("profile") ? "active" : "" %>">PROFILE</a>
            </div>
        </div>

        <div class="nav-right-group">
            <div class="user-profile-section">
                <div class="user-avatar-circle">
                    <%= userName != null ? userName.substring(0, 1).toUpperCase() : "U" %>
                </div>
                <div class="user-full-info">
                    <%= userName %> • <%= munName %>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn-logout-outline">Logout</a>
            </div>
        </div>
    </div>
</nav>
