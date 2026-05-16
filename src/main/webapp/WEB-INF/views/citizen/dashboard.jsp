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
            <div class="stat-card icon-blue">
                <div class="stat-info">
                    <h3>TOTAL SUBMITTED</h3>
                    <div class="stat-value"><%= request.getAttribute("totalSubmitted") %></div>
                    <p class="stat-subtext">All time complaints</p>
                </div>
            </div>
            <div class="stat-card icon-orange">
                <div class="stat-info">
                    <h3>PENDING</h3>
                    <div class="stat-value"><%= request.getAttribute("pendingCount") %></div>
                    <p class="stat-subtext">Awaiting review</p>
                </div>
            </div>
            <div class="stat-card icon-purple">
                <div class="stat-info">
                    <h3>IN PROGRESS</h3>
                    <div class="stat-value"><%= request.getAttribute("inProgressCount") %></div>
                    <p class="stat-subtext">Being addressed</p>
                </div>
            </div>
            <div class="stat-card icon-green">
                <div class="stat-info">
                    <h3>RESOLVED</h3>
                    <div class="stat-value"><%= request.getAttribute("resolvedCount") %></div>
                    <p class="stat-subtext">Issues closed</p>
                </div>
            </div>
        </section>

        <!-- Quick Actions -->
        <section class="quick-actions">
            <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="action-card">
                <div class="action-icon">
                    <img src="https://cdn-icons-png.flaticon.com/512/3602/3602145.png" width="24" alt="Submit">
                </div>
                <h4>Submit New Complaint</h4>
                <p>Report a new civic issue in your area</p>
            </a>
            <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="action-card">
                <div class="action-icon">
                    <img src="https://cdn-icons-png.flaticon.com/512/2991/2991108.png" width="24" alt="Complaints">
                </div>
                <h4>View All My Complaints</h4>
                <p>Track and manage your submissions</p>
            </a>
            <a href="<%= request.getContextPath() %>/citizen/browse" class="action-card">
                <div class="action-icon">
                    <img src="https://cdn-icons-png.flaticon.com/512/854/854866.png" width="24" alt="Browse">
                </div>
                <h4>Browse Public Issues</h4>
                <p>See all complaints across municipalities</p>
            </a>
            <a href="<%= request.getContextPath() %>/citizen/profile" class="action-card">
                <div class="action-icon">
                    <img src="https://cdn-icons-png.flaticon.com/512/1144/1144760.png" width="24" alt="Profile">
                </div>
                <h4>Edit Profile</h4>
                <p>Update your personal information</p>
            </a>
        </section>

        <!-- Recent Complaints Table -->
        <section class="content-card">
            <div class="card-header">
                <h3>My Recent Complaints</h3>
                <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="btn-manage-all" style="background: white; border: 1px solid #e2e8f0; color: #3b82f6 !important; font-weight: 500;">View All</a>
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
                                <td style="font-weight: 500; font-size: 0.9rem; color: #1e293b;"><%= complaint.getTitle() %></td>
                                <td>
                                    <span class="status-badge" style="background-color: #dbeafe; color: #1e40af; border-radius: 4px; padding: 2px 8px; font-size: 0.75rem;">
                                        <%= complaint.getCategoryName() != null ? complaint.getCategoryName().toUpperCase() : "N/A" %>
                                    </span>
                                </td>
                                <td style="color: #64748b;"><%= complaint.getWardNumber() %></td>
                                <td>
                                    <span class="status-badge status-<%= complaint.getStatus().toLowerCase().replace(" ", "-") %>" style="border-radius: 12px; padding: 2px 10px; font-size: 0.75rem;">
                                        <%= complaint.getStatus().toUpperCase() %>
                                    </span>
                                </td>
                                <td style="font-weight: 600; color: #1e293b;"><%= complaint.getVoteCount() %></td>
                                <td style="color: #64748b;"><%= complaint.getCreatedAt().format(formatter) %></td>
                                <td>
                                    <% if ("pending".equalsIgnoreCase(complaint.getStatus())) { %>
                                        <div style="display: flex; gap: 8px;">
                                            <a href="<%= request.getContextPath() %>/citizen/edit-complaint?id=<%= complaint.getId() %>" 
                                               style="border: 1px solid #3b82f6; color: #3b82f6; text-decoration: none; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: 500;">Edit</a>
                                            <a href="<%= request.getContextPath() %>/citizen/delete-complaint?id=<%= complaint.getId() %>" 
                                               style="background-color: #ef4444; color: white; text-decoration: none; padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: 500;"
                                               onclick="return confirm('Are you sure you want to delete this complaint?')">Delete</a>
                                        </div>
                                    <% } else { %>
                                        <span style="color: #94a3b8; font-size: 0.8rem;">Locked</span>
                                    <% } %>
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
            <div style="display: flex; align-items: center; gap: 10px;">
                <span style="font-weight: 700; color: white;">CivicConnect</span>
                <span style="color: rgba(255,255,255,0.4)">•</span>
                <span>Municipality-Level Civic Issue Reporting • Nepal</span>
            </div>
            <div class="footer-links">
                <a href="<%= request.getContextPath() %>/about" style="color: rgba(255,255,255,0.6); text-decoration: none;">About</a>
            </div>
        </div>
    </footer>
</body>
</html>
