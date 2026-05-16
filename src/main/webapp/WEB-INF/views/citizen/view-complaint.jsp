<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="civicconnect.dto.complaint.ComplaintDTO" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    ComplaintDTO complaint = (ComplaintDTO) request.getAttribute("complaint");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy 'at' hh:mm a");
    int userId = (session.getAttribute("userId") != null) ? (int) session.getAttribute("userId") : -1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Details - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .complaint-detail-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }
        .evidence-container {
            width: 100%;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 2rem;
            background-color: #f1f5f9;
            border: 1px solid #e2e8f0;
        }
        .evidence-image {
            width: 100%;
            display: block;
            object-fit: contain;
            max-height: 500px;
        }
        .detail-item {
            margin-bottom: 1.5rem;
        }
        .detail-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }
        .detail-value {
            font-size: 1rem;
            color: #1e293b;
            line-height: 1.6;
        }
    </style>
</head>
<body class="dashboard-body">
    <jsp:include page="navbar.jsp" />

    <main class="citizen-dashboard">
        <!-- Breadcrumbs -->
        <nav class="breadcrumb" style="margin-bottom: 1.5rem; font-size: 0.85rem; color: #64748b;">
            <a href="<%= request.getContextPath() %>/citizen/dashboard" style="color: #3b82f6; text-decoration: none;">Dashboard</a>
            <span style="margin: 0 0.5rem;">›</span>
            <% if (complaint.getUserId() == userId) { %>
                <a href="<%= request.getContextPath() %>/citizen/my-complaints" style="color: #3b82f6; text-decoration: none;">My Complaints</a>
                <span style="margin: 0 0.5rem;">›</span>
            <% } %>
            <span>Complaint Details</span>
        </nav>

        <div class="complaint-detail-grid">
            <!-- Left Column: Image and Description -->
            <div class="left-section">
                <div class="content-card" style="padding: 2rem;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1.5rem;">
                        <div>
                            <span class="status-badge status-<%= complaint.getStatus().toLowerCase().replace(" ", "-") %>" style="margin-bottom: 1rem;">
                                <%= complaint.getStatus().toUpperCase() %>
                            </span>
                            <h1 style="font-size: 1.75rem; color: #1e293b; font-weight: 700; margin-top: 0.5rem;"><%= complaint.getTitle() %></h1>
                            <p style="color: #64748b; margin-top: 0.25rem;">Submitted on <%= complaint.getCreatedAt().format(formatter) %></p>
                        </div>
                        <div style="text-align: right;">
                            <div style="font-size: 1.5rem; font-weight: 700; color: #2563eb;"><%= complaint.getVoteCount() %></div>
                            <div style="font-size: 0.7rem; color: #94a3b8; font-weight: 600;">SUPPORTS</div>
                        </div>
                    </div>

                    <div class="evidence-container">
                        <% if (complaint.getImagePath() != null && !complaint.getImagePath().isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/<%= complaint.getImagePath() %>" alt="Evidence" class="evidence-image">
                        <% } else { %>
                            <div style="padding: 4rem; text-align: center; color: #94a3b8;">
                                <i class="fas fa-image" style="font-size: 3rem; margin-bottom: 1rem;"></i>
                                <p>No photo evidence provided for this complaint.</p>
                            </div>
                        <% } %>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Full Description</div>
                        <div class="detail-value" style="background: #f8fafc; padding: 1.5rem; border-radius: 8px; border-left: 4px solid #e2e8f0;">
                            <%= complaint.getDescription() %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Meta Info -->
            <div class="right-section">
                <div class="content-card" style="padding: 2rem; margin-bottom: 1.5rem;">
                    <h3 style="font-size: 1.1rem; color: #1e293b; margin-bottom: 1.5rem; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem;">Location & Category</h3>
                    
                    <div class="detail-item">
                        <div class="detail-label">Municipality</div>
                        <div class="detail-value"><%= session.getAttribute("municipalityName") %></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Ward Number</div>
                        <div class="detail-value">Ward No. <%= complaint.getWardNumber() %></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Exact Location</div>
                        <div class="detail-value"><%= complaint.getLocation() %></div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Category</div>
                        <div class="detail-value">
                            <span class="admin-badge"><%= complaint.getCategoryName().toUpperCase() %></span>
                        </div>
                    </div>
                </div>

                <div class="content-card" style="padding: 2rem; margin-bottom: 1.5rem;">
                    <h3 style="font-size: 1.1rem; color: #1e293b; margin-bottom: 1.5rem; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem;">Reporter Information</h3>
                    
                    <div class="detail-item">
                        <div class="detail-label">Submitted By</div>
                        <div class="detail-value">
                            <% if (complaint.isAnonymous()) { %>
                                <i class="fas fa-user-secret" style="margin-right: 5px;"></i> Anonymous Citizen
                            <% } else { %>
                                <i class="fas fa-user" style="margin-right: 5px;"></i> <%= complaint.getUserName() != null ? complaint.getUserName() : "Citizen" %>
                            <% } %>
                        </div>
                    </div>

                    <div class="detail-item">
                        <div class="detail-label">Contact Email</div>
                        <div class="detail-value"><%= (complaint.getContactEmail() != null && !complaint.getContactEmail().isEmpty()) ? complaint.getContactEmail() : "Not provided" %></div>
                    </div>
                </div>

                <!-- Action Button -->
                <% if (complaint.getUserId() == userId && "pending".equalsIgnoreCase(complaint.getStatus())) { %>
                    <a href="<%= request.getContextPath() %>/citizen/edit-complaint?id=<%= complaint.getId() %>" class="btn-primary" style="width: 100%; padding: 1rem; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 10px;">
                        <i class="fas fa-edit"></i> Edit This Complaint
                    </a>
                <% } else { %>
                    <button class="btn-primary" style="width: 100%; padding: 1rem; display: flex; align-items: center; justify-content: center; gap: 10px;">
                        <i class="fas fa-thumbs-up"></i> Support This Issue
                    </button>
                <% } %>
            </div>
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
