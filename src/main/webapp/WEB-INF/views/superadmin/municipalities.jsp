<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="civicconnect.dto.municipality.MunicipalityDTO" %>
<%@ page import="java.util.ArrayList" %>
<%
    ArrayList<MunicipalityDTO> municipalities = (ArrayList<MunicipalityDTO>) request.getAttribute("municipalities");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Municipalities - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <div class="top-header">
                <div class="header-info">
                    <h2>Municipalities</h2>
                </div>
                <div class="header-user">
                    <form action="<%= request.getContextPath() %>/logout" method="POST" style="margin: 0;">
                        <button type="submit" class="logout-link" style="background: none; cursor: pointer; border: 1px solid rgba(239, 68, 68, 0.2);">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </button>
                    </form>
                </div>
            </div>

            <div class="content-card">
                <div class="card-header">
                    <h3>All Municipalities</h3>
                    <a href="<%= request.getContextPath() %>/superadmin/municipalities?action=add" class="btn-primary" style="width: auto; padding: 8px 16px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                        <i class="fas fa-plus"></i> Add Municipality
                    </a>
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
                            <% if (municipalities != null) { 
                                for (MunicipalityDTO m : municipalities) { %>
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
                                            <a href="<%= request.getContextPath() %>/superadmin/municipalities?action=toggleStatus&id=<%= m.getId() %>&status=<%= m.getStatus() %>" 
                                               class="btn-icon <%= m.getStatus().equalsIgnoreCase("active") ? "btn-icon-danger" : "" %>" 
                                               title="<%= m.getStatus().equalsIgnoreCase("active") ? "Deactivate" : "Activate" %>">
                                                <i class="fas <%= m.getStatus().equalsIgnoreCase("active") ? "fa-user-slash" : "fa-user-check" %>"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 2rem; color: var(--text-muted);">
                                        No municipalities found.
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