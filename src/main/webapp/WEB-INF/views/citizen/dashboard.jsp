<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="civicconnect.dto.complaint.ComplaintDTO" %>
<%@ page import="civicconnect.model.Complaint" %>
<%@ page import="civicconnect.model.Users" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Users user = (Users) request.getAttribute("user");
    String munName = (String) request.getAttribute("municipalityName");
    ArrayList<ComplaintDTO> recentComplaints = (ArrayList<ComplaintDTO>) request.getAttribute("recentComplaints");
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    DateTimeFormatter memberSinceFormatter = DateTimeFormatter.ofPattern("MMMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="citizen-dashboard">
        <div class="top-header" style="margin-bottom: 2rem;">
            <div class="header-info">
                <h2>Welcome back, <%= user != null ? user.getFullName().split(" ")[0] : "Citizen" %>! 👋</h2>
                <p style="color: var(--text-muted); font-size: 0.9rem;">
                    <%= munName %> • Ward <%= user != null ? user.getWardNumber() : "N/A" %> • 
                    Citizen since <%= user != null && user.getCreatedAt() != null ? user.getCreatedAt().format(memberSinceFormatter) : "Recently" %>
                </p>
            </div>
        </div>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon icon-blue">
                    <i class="fas fa-file-alt"></i>
                </div>
                <div class="stat-info">
                    <h3>TOTAL SUBMITTED</h3>
                    <div class="stat-value"><%= request.getAttribute("totalSubmitted") %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-orange">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-info">
                    <h3>PENDING</h3>
                    <div class="stat-value"><%= request.getAttribute("pendingCount") %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-purple">
                    <i class="fas fa-spinner"></i>
                </div>
                <div class="stat-info">
                    <h3>IN PROGRESS</h3>
                    <div class="stat-value"><%= request.getAttribute("inProgressCount") %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-green">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>RESOLVED</h3>
                    <div class="stat-value"><%= request.getAttribute("resolvedCount") %></div>
                </div>
            </div>
        </section>

        <!-- Recent Complaints Table -->
        <section class="content-card">
            <div class="card-header">
                <h3>My Recent Complaints</h3>
                <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="btn-manage-all">View All</a>
            </div>
            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>TITLE</th>
                            <th>CATEGORY</th>
                            <th>WARD</th>
                            <th>STATUS</th>
                            <th>SUPPORTS</th>
                            <th>DATE</th>
                            <th>ACTIONS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentComplaints != null && !recentComplaints.isEmpty()) { 
                            for (ComplaintDTO complaint : recentComplaints) { %>
                            <tr>
                                <td><strong><%= complaint.getTitle() %></strong></td>
                                <td>
                                    <span class="admin-badge">
                                        <%= complaint.getCategoryName() != null ? complaint.getCategoryName().toUpperCase() : "N/A" %>
                                    </span>
                                </td>
                                <td><%= complaint.getWardNumber() %></td>
                                <td>
                                    <span class="status-badge status-<%= complaint.getStatus().toLowerCase().replace(" ", "-") %>">
                                        <%= complaint.getStatus().toUpperCase() %>
                                    </span>
                                </td>
                                <td><%= complaint.getVoteCount() %></td>
                                <td><%= complaint.getCreatedAt().format(formatter) %></td>
                                <td>
                                    <div style="display: flex; gap: 5px;">
                                        <a href="<%= request.getContextPath() %>/citizen/view-complaint?id=<%= complaint.getId() %>" class="btn-icon" title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <% if ("pending".equalsIgnoreCase(complaint.getStatus())) { %>
                                            <a href="<%= request.getContextPath() %>/citizen/edit-complaint?id=<%= complaint.getId() %>" class="btn-icon" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="<%= request.getContextPath() %>/citizen/delete-complaint?id=<%= complaint.getId() %>" 
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
                                <td colspan="7" style="text-align: center; padding: 3rem; color: #64748b;">
                                    You haven't submitted any complaints yet.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <div class="alert alert-info" style="margin-top: 2rem; background-color: #dbeafe; color: #1e40af; border: none; border-radius: 8px; padding: 12px 20px; display: flex; align-items: center; gap: 10px; font-size: 0.85rem;">
            <i class="fas fa-info-circle"></i>
            <p>You can edit or delete complaints only while they are in <strong>Pending</strong> status. Once an admin starts processing, actions are locked.</p>
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
