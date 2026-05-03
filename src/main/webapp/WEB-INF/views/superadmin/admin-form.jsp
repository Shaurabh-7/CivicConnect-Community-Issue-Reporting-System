<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="civicconnect.model.Users" %>
<%@ page import="civicconnect.model.Municipality" %>
<%@ page import="java.util.ArrayList" %>
<%
    Users admin = (Users) request.getAttribute("admin");
    ArrayList<Municipality> municipalities = (ArrayList<Municipality>) request.getAttribute("municipalities");
    boolean isEdit = request.getAttribute("isEdit") != null && (boolean) request.getAttribute("isEdit");
    String title = isEdit ? "Edit Admin" : "Add New Admin";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= title %> - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <div class="top-header">
                <div class="header-info">
                    <h2><%= title %></h2>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Assign administrators to municipalities</p>
                </div>
                <div class="header-user">
                    <a href="<%= request.getContextPath() %>/superadmin/admins" class="logout-link" style="color: var(--text-main); border-color: var(--border-color);">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>

            <div class="auth-card" style="max-width: 600px; margin: 0 auto; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/superadmin/admins" method="POST">
                    <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%= admin.getId() %>">
                    <% } %>

                    <div class="form-group">
                        <label for="fullName">Full Name <span class="required">*</span></label>
                        <input type="text" id="fullName" name="fullName" 
                               placeholder="e.g. John Doe" 
                               value="<%= isEdit ? admin.getFullName() : "" %>" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email Address <span class="required">*</span></label>
                            <input type="email" id="email" name="email" 
                                   placeholder="e.g. john@municipality.gov" 
                                   value="<%= isEdit ? admin.getEmail() : "" %>" 
                                   <%= isEdit ? "readonly style='background-color: #f8fafc;'" : "required" %>>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number <span class="required">*</span></label>
                            <input type="text" id="phone" name="phone" 
                                   placeholder="e.g. 9841234567" 
                                   value="<%= isEdit ? admin.getPhone() : "" %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="municipalityId">Assign Municipality <span class="required">*</span></label>
                        <select id="municipalityId" name="municipalityId" required>
                            <option value="">Select Municipality</option>
                            <% if (municipalities != null) {
                               for (Municipality m : municipalities) { %>
                                <option value="<%= m.getId() %>" <%= (isEdit && admin.getMunicipalityId() != null && admin.getMunicipalityId() == m.getId()) ? "selected" : "" %>><%= m.getName() %></option>
                            <% } 
                               } %>
                        </select>
                    </div>

                    <% if (!isEdit) { %>
                        <div class="form-group">
                            <label for="password">Login Password <span class="required">*</span></label>
                            <input type="password" id="password" name="password" placeholder="Minimum 8 characters" required>
                            <p class="help-text">Admins can change their password after their first login.</p>
                        </div>
                    <% } %>

                    <div style="margin-top: 2rem;">
                        <button type="submit" class="btn-primary">
                            <i class="fas <%= isEdit ? "fa-save" : "fa-plus" %>"></i> 
                            <%= isEdit ? "Update Admin" : "Create Admin Account" %>
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>

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
