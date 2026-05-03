<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="civicconnect.dto.user.UserDTO" %>
<%@ page import="java.util.ArrayList" %>
<%
    ArrayList<UserDTO> admins = (ArrayList<UserDTO>) request.getAttribute("admins");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Admins - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <div class="top-header">
                <div class="header-info">
                    <h2>Municipality Admins</h2>
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
                    <h3>All Admins</h3>
                    <a href="<%= request.getContextPath() %>/superadmin/admins?action=add" class="btn-primary" style="width: auto; padding: 8px 16px; text-decoration: none; display: inline-flex; align-items: center; gap: 8px;">
                        <i class="fas fa-plus"></i> Add Admin
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Municipality</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (admins != null) { 
                                for (UserDTO u : admins) { %>
                                <tr>
                                    <td><strong><%= u.getFullName() %></strong></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><%= u.getPhone() %></td>
                                    <td><span class="admin-badge"><%= u.getMunicipalityName() != null ? u.getMunicipalityName() : "Unassigned" %></span></td>
                                    <td>
                                        <span class="status-badge status-<%= u.getStatus().toLowerCase() %>">
                                            <%= u.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 5px;">
                                            <a href="<%= request.getContextPath() %>/superadmin/admins?action=edit&id=<%= u.getId() %>" class="btn-icon" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="<%= request.getContextPath() %>/superadmin/admins?action=toggleStatus&id=<%= u.getId() %>&status=<%= u.getStatus() %>" 
                                               class="btn-icon <%= u.getStatus().equalsIgnoreCase("active") ? "btn-icon-danger" : "" %>" 
                                               title="<%= u.getStatus().equalsIgnoreCase("active") ? "Deactivate" : "Activate" %>">
                                                <i class="fas <%= u.getStatus().equalsIgnoreCase("active") ? "fa-user-slash" : "fa-user-check" %>"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <%  } 
                               } %>
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