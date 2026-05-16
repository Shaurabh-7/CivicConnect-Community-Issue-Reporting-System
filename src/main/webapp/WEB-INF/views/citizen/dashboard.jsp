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
        <header class="welcome-header">
            <h1>Welcome back, <%= user != null ? user.getFullName().split(" ")[0] : "Citizen" %>! 👋</h1>
            <p>
                <%= munName %> • Ward <%= user != null ? user.getWardNumber() : "N/A" %> • 
                Citizen since <%= user != null && user.getCreatedAt() != null ? user.getCreatedAt().format(memberSinceFormatter) : "Recently" %>
            </p>
        </header>

        <!-- Stats Section -->
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon icon-blue">
                    <i class="fas fa-file-alt"></i>
                </div>
                <div class="stat-info">
                    <h3>Total Submitted</h3>
                    <div class="stat-value"><%= request.getAttribute("totalSubmitted") %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-orange">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-info">
                    <h3>Pending</h3>
                    <div class="stat-value"><%= request.getAttribute("pendingCount") %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-purple">
                    <i class="fas fa-spinner"></i>
                </div>
                <div class="stat-info">
                    <h3>In Progress</h3>
                    <div class="stat-value"><%= request.getAttribute("inProgressCount") %></div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-green">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>Resolved</h3>
                    <div class="stat-value"><%= request.getAttribute("resolvedCount") %></div>
                </div>
            </div>
        </section>

        <!-- Quick Actions -->
        <section class="quick-actions">
            <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-plus-circle"></i>
                </div>
                <h4>Submit New Complaint</h4>
                <p>Report a new civic issue in your area</p>
            </a>
            <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-list-ul"></i>
                </div>
                <h4>View All My Complaints</h4>
                <p>Track and manage your submissions</p>
            </a>
            <a href="<%= request.getContextPath() %>/citizen/browse" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-globe"></i>
                </div>
                <h4>Browse Public Issues</h4>
                <p>See all complaints across municipalities</p>
            </a>
            <a href="<%= request.getContextPath() %>/citizen/profile" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-user-edit"></i>
                </div>
                <h4>Edit Profile</h4>
                <p>Update your personal information</p>
            </a>
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
                            <th>Title</th>
                            <th>Category</th>
                            <th>Ward</th>
                            <th>Status</th>
                            <th>Supports</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentComplaints != null && !recentComplaints.isEmpty()) { 
                            for (ComplaintDTO complaint : recentComplaints) { %>
                            <tr>
                                <td style="font-weight: 600;"><%= complaint.getTitle() %></td>
                                <td><span class="admin-badge"><%= complaint.getCategoryName() != null ? complaint.getCategoryName().toUpperCase() : "N/A" %></span></td>
                                <td><%= complaint.getWardNumber() %></td>
                                <td>
                                    <span class="status-badge status-<%= complaint.getStatus().toLowerCase().replace(" ", "-") %>">
                                        <%= complaint.getStatus().toUpperCase() %>
                                    </span>
                                </td>
                                <td style="font-weight: 700;"><%= complaint.getVoteCount() %></td>
                                <td><%= complaint.getCreatedAt().format(formatter) %></td>
                                <td>
                                    <% if ("pending".equalsIgnoreCase(complaint.getStatus())) { %>
                                        <a href="<%= request.getContextPath() %>/citizen/edit-complaint?id=<%= complaint.getId() %>" class="btn-icon" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/citizen/delete-complaint?id=<%= complaint.getId() %>" class="btn-icon btn-icon-danger" title="Delete" onclick="return confirm('Are you sure you want to delete this complaint?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    <% } else { %>
                                        <span class="text-muted" style="font-size: 0.8rem; font-style: italic;">Locked</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 3rem; color: var(--text-muted);">
                                    <i class="fas fa-info-circle" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                                    You haven't submitted any complaints yet.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <div class="alert alert-info" style="margin-top: 2rem; display: flex; align-items: center; gap: 15px;">
            <i class="fas fa-info-circle"></i>
            <p>You can edit or delete complaints only while they are in <strong>Pending</strong> status. Once an admin starts processing, actions are locked.</p>
        </div>
    </main>

    <footer class="dashboard-footer">
        <div class="footer-content">
            <p>&copy; 2026 CivicConnect • Municipality-Level Civic Issue Reporting • Nepal</p>
            <div class="footer-links">
                <a href="<%= request.getContextPath() %>/about" style="color: rgba(255, 255, 255, 0.7); text-decoration: none;">About</a>
            </div>
        </div>
    </footer>
</body>
</html>
