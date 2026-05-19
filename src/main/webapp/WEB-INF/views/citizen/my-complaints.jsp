<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="civicconnect.dto.complaint.ComplaintDTO" %>
<%@ page import="civicconnect.model.Categories" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    ArrayList<ComplaintDTO> complaints = (ArrayList<ComplaintDTO>) request.getAttribute("complaints");
    ArrayList<Categories> categories = (ArrayList<Categories>) request.getAttribute("categories");
    String currentStatus = (String) request.getAttribute("currentStatus");
    String currentCategory = (String) request.getAttribute("currentCategory");
    String currentSearch = (String) request.getAttribute("currentSearch");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Complaints - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="dashboard-body">
    <jsp:include page="navbar.jsp" />

    <main class="citizen-dashboard">
        <!-- Breadcrumbs -->
        <nav class="breadcrumb" style="margin-bottom: 1rem; font-size: 0.85rem; color: #64748b;">
            <a href="<%= request.getContextPath() %>/citizen/dashboard" style="color: #3b82f6; text-decoration: none;">Dashboard</a>
            <span style="margin: 0 0.5rem;">›</span>
            <span>My Complaints</span>
        </nav>

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <h2 style="font-size: 1.5rem; color: #1e293b; font-weight: 700;">My Complaints</h2>
            <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="btn-primary" style="width: auto; padding: 0.6rem 1.2rem; text-decoration: none;">
                <i class="fas fa-plus"></i> Submit New Complaint
            </a>
        </div>

        <!-- Filters Section -->
        <div class="content-card" style="padding: 1rem; margin-bottom: 1.5rem;">
            <form action="<%= request.getContextPath() %>/citizen/my-complaints" method="GET" style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: center;">
                <div style="flex: 1; min-width: 150px;">
                    <select name="status" onchange="this.form.submit()" style="width: 100%; padding: 0.6rem; border: 1px solid #e2e8f0; border-radius: 6px; background: white;">
                        <option value="all" <%= "all".equals(currentStatus) ? "selected" : "" %>>All Status</option>
                        <option value="pending" <%= "pending".equals(currentStatus) ? "selected" : "" %>>Pending</option>
                        <option value="in_progress" <%= "in_progress".equals(currentStatus) ? "selected" : "" %>>In Progress</option>
                        <option value="resolved" <%= "resolved".equals(currentStatus) ? "selected" : "" %>>Resolved</option>
                    </select>
                </div>
                <div style="flex: 1; min-width: 150px;">
                    <select name="category" onchange="this.form.submit()" style="width: 100%; padding: 0.6rem; border: 1px solid #e2e8f0; border-radius: 6px; background: white;">
                        <option value="all" <%= "all".equals(currentCategory) ? "selected" : "" %>>All Categories</option>
                        <% if (categories != null) { 
                            for (Categories cat : categories) { %>
                            <option value="<%= cat.getId() %>" <%= String.valueOf(cat.getId()).equals(currentCategory) ? "selected" : "" %>><%= cat.getName() %></option>
                        <% } } %>
                    </select>
                </div>
                <div style="flex: 3; min-width: 300px; position: relative;">
                    <i class="fas fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #94a3b8;"></i>
                    <input type="text" name="search" value="<%= currentSearch %>" placeholder="Search my complaints..."
                           style="width: 100%; padding: 0.6rem 0.6rem 0.6rem 2.5rem; border: 1px solid #e2e8f0; border-radius: 6px;">
                </div>
                <button type="submit" style="display: none;">Search</button>
            </form>
        </div>

        <!-- Table Section -->
        <section class="content-card">
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width: 60px;">#</th>
                            <th>TITLE</th>
                            <th>CATEGORY</th>
                            <th>WARD</th>
                            <th>STATUS</th>
                            <th>SUPPORTS</th>
                            <th>SUBMITTED</th>
                            <th style="text-align: right;">ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (complaints != null && !complaints.isEmpty()) { 
                            int i = 1;
                            for (ComplaintDTO c : complaints) { %>
                            <tr>
                                <td style="color: #94a3b8; font-size: 0.8rem; font-weight: 500;"><%= String.format("%03d", i++) %></td>
                                <td style="max-width: 400px;">
                                    <strong><%= c.getTitle() %></strong>
                                </td>
                                <td>
                                    <span class="admin-badge">
                                        <%= c.getCategoryName() != null ? c.getCategoryName().toUpperCase() : "N/A" %>
                                    </span>
                                </td>
                                <td><%= c.getWardNumber() %></td>
                                <td>
                                    <span class="status-badge status-<%= c.getStatus().toLowerCase().replace(" ", "-") %>">
                                        <%= c.getStatus().toUpperCase() %>
                                    </span>
                                </td>
                                <td style="font-weight: 600;"><%= c.getVoteCount() %></td>
                                <td style="color: #64748b;">
                                    <%= c.getCreatedAt() != null ? c.getCreatedAt().format(formatter) : "N/A" %>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 5px; justify-content: flex-end;">
                                        <a href="<%= request.getContextPath() %>/citizen/view-complaint?id=<%= c.getId() %>" class="btn-icon" title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <% if ("pending".equalsIgnoreCase(c.getStatus())) { %>
                                            <a href="<%= request.getContextPath() %>/citizen/edit-complaint?id=<%= c.getId() %>" class="btn-icon" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="<%= request.getContextPath() %>/citizen/delete-complaint?id=<%= c.getId() %>" 
                                               class="btn-icon btn-icon-danger" title="Delete"
                                               onclick="return confirm('Are you sure you want to delete this complaint?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 4rem; color: #64748b;">
                                    <div style="margin-bottom: 1rem;">
                                        <i class="fas fa-folder-open" style="font-size: 3rem; color: #e2e8f0;"></i>
                                    </div>
                                    <p>No complaints found matching your filters.</p>
                                    <a href="<%= request.getContextPath() %>/citizen/submit-complaint" style="color: #3b82f6; text-decoration: none; font-weight: 600;">Submit your first complaint</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Footer Notice -->
        <div class="alert alert-info" style="margin-top: 2rem; background-color: #f8fafc; color: #64748b; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px 20px; display: flex; align-items: center; gap: 10px; font-size: 0.85rem;">
            <i class="fas fa-info-circle" style="color: #3b82f6;"></i>
            <p>Complaints in <strong>Pending</strong> status can be edited or deleted. Once an admin begins processing, actions are locked.</p>
        </div>
    </main>

    <footer class="dashboard-footer" style="margin-left: 0;">
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
