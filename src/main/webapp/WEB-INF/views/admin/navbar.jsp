<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="logo">CivicConnect Admin</a>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/manage-complaints">Manage Complaints</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/manage-users">Manage Users</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
        </ul>
        <div class="user-menu">
            <span class="user-name">Admin: <c:out value="${sessionScope.userName}" /> | <c:out value="${sessionScope.municipalityName}" /></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </div>
</nav>
