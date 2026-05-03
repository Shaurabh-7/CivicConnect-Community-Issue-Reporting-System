<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="civicconnect.model.Categories" %>
<%
    Categories category = (Categories) request.getAttribute("category");
    boolean isEdit = request.getAttribute("isEdit") != null && (boolean) request.getAttribute("isEdit");
    String title = isEdit ? "Edit Category" : "Add New Category";
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
                    <p style="color: var(--text-muted); font-size: 0.9rem;">Define complaint categories for citizens</p>
                </div>
                <div class="header-user">
                    <a href="<%= request.getContextPath() %>/superadmin/categories" class="logout-link" style="color: var(--text-main); border-color: var(--border-color);">
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

                <form action="<%= request.getContextPath() %>/superadmin/categories" method="POST">
                    <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%= category.getId() %>">
                    <% } %>

                    <div class="form-group">
                        <label for="categoryName">Category Name <span class="required">*</span></label>
                        <input type="text" id="categoryName" name="categoryName" 
                               placeholder="e.g. Road Maintenance, Waste Management" 
                               value="<%= isEdit ? category.getName() : "" %>" required>
                        <p class="help-text">Choose a clear, concise name that citizens will understand.</p>
                    </div>

                    <div style="margin-top: 2rem;">
                        <button type="submit" class="btn-primary">
                            <i class="fas <%= isEdit ? "fa-save" : "fa-plus" %>"></i> 
                            <%= isEdit ? "Save Changes" : "Create Category" %>
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
