<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="civicconnect.dto.municipality.MunicipalityDTO" %>
<%@ page import="java.util.ArrayList" %>
<%
    Integer totalMunicipalities = (Integer) request.getAttribute("totalMunicipalities");
    Integer activeAdmins = (Integer) request.getAttribute("activeAdmins");
    Integer totalCitizens = (Integer) request.getAttribute("totalCitizens");
    Integer totalComplaints = (Integer) request.getAttribute("totalComplaints");
    ArrayList<MunicipalityDTO> recentMunicipalities = (ArrayList<MunicipalityDTO>) request.getAttribute("recentMunicipalities");
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super-Admin Dashboard - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="dashboard-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <div class="top-header">
                <div class="header-info">
                    <h2>Dashboard Overview</h2>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Welcome back, System Administrator</p>
                </div>
                <div class="header-user">
                    <form action="<%= request.getContextPath() %>/logout" method="POST" style="margin: 0;">
                        <button type="submit" class="logout-link" style="background: none; cursor: pointer; border: 1px solid rgba(239, 68, 68, 0.2);">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </button>
                    </form>
                </div>
            </div>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-blue">
                        <i class="fas fa-city"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Municipalities</h3>
                        <div class="stat-value"><%= totalMunicipalities != null ? totalMunicipalities : 0 %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-green">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Active Admins</h3>
                        <div class="stat-value"><%= activeAdmins != null ? activeAdmins : 0 %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-orange">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Citizens</h3>
                        <div class="stat-value"><%= totalCitizens != null ? totalCitizens : 0 %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-purple">
                        <i class="fas fa-file-invoice"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Total Complaints</h3>
                        <div class="stat-value"><%= totalComplaints != null ? totalComplaints : 0 %></div>
                    </div>
                </div>
            </div>

            <!-- Recent Municipalities Table -->
            <div class="content-card">
                <div class="card-header">
                    <h3>Recently Added Municipalities</h3>
                    <a href="<%= request.getContextPath() %>/superadmin/municipalities" class="btn-manage-all">Manage All</a>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Municipality</th>
                                <th>District</th>
                                <th>Province</th>
                                <th>Assigned Admin</th>
                                <th>Citizens</th>
                                <th>Complaints</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (recentMunicipalities != null && !recentMunicipalities.isEmpty()) { 
                                for (MunicipalityDTO m : recentMunicipalities) { %>
                                <tr>
                                    <td><strong><%= m.getName() %></strong></td>
                                    <td><%= m.getDistrict() %></td>
                                    <td><%= m.getProvince() %></td>
                                    <td><span class="admin-badge"><%= m.getAdminName() != null ? m.getAdminName() : "Not Assigned" %></span></td>
                                    <td><%= m.getCitizenCount() %></td>
                                    <td><%= m.getComplaintCount() %></td>
                                    <td>
                                        <span class="status-badge status-<%= m.getStatus().toLowerCase() %>">
                                            <%= m.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 5px;">
                                            <a href="<%= request.getContextPath() %>/superadmin/municipalities?action=edit&id=<%= m.getId() %>" class="btn-icon" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button class="btn-icon <%= m.getStatus().equalsIgnoreCase("active") ? "btn-icon-danger" : "" %>" 
                                                    title="<%= m.getStatus().equalsIgnoreCase("active") ? "Deactivate" : "Activate" %>">
                                                <i class="fas <%= m.getStatus().equalsIgnoreCase("active") ? "fa-user-slash" : "fa-user-check" %>"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 2rem; color: var(--text-muted);">
                                        No municipalities found. <a href="<%= request.getContextPath() %>/superadmin/municipalities">Add your first one!</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Footer -->
    <footer class="dashboard-footer">
        <div class="footer-content">
            <p>&copy; 2026 CivicConnect. All rights reserved.</p>
            <div class="footer-links">
                <span>Version 1.0.0</span>
                <span class="separator">|</span>
                <span>System Status: <span class="status-online">Online</span></span>
            </div>
        </div>
    </footer>
</body>
</html>