<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="civicconnect.model.Users" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Users user = (Users) request.getAttribute("user");
    int complaintCount = (int) request.getAttribute("complaintCount");
    String munName = (String) session.getAttribute("municipalityName");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="dashboard-body">
    <jsp:include page="navbar.jsp" />

    <main class="citizen-dashboard">
        <!-- Breadcrumbs -->
        <nav class="breadcrumb" style="margin-bottom: 1.5rem; font-size: 0.85rem; color: #64748b;">
            <a href="<%= request.getContextPath() %>/citizen/dashboard" style="color: #3b82f6; text-decoration: none;">Dashboard</a>
            <span style="margin: 0 0.5rem;">›</span>
            <span>My Profile</span>
        </nav>

        <!-- Profile Header Card -->
        <div class="profile-header-card" style="background: linear-gradient(135deg, #2563eb, #1d4ed8); border-radius: 12px; padding: 2.5rem; color: white; display: flex; align-items: center; justify-content: space-between; margin-bottom: 2rem;">
            <div style="display: flex; align-items: center; gap: 2rem;">
                <div style="width: 100px; height: 100px; background: rgba(255,255,255,0.2); border: 4px solid rgba(255,255,255,0.3); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: 700;">
                    <%= user.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <div>
                    <h1 style="margin: 0; font-size: 2rem; font-weight: 700;"><%= user.getFullName() %></h1>
                    <p style="margin: 0.5rem 0 0; opacity: 0.9; font-size: 1rem;">
                        Citizen • <%= munName %> • Ward <%= user.getWardNumber() %>
                    </p>
                    <p style="margin: 0.25rem 0 0; opacity: 0.7; font-size: 0.85rem;">
                        Member since <%= user.getCreatedAt().format(formatter) %>
                    </p>
                </div>
            </div>
            <div style="text-align: right;">
                <div style="font-size: 3rem; font-weight: 800; line-height: 1;"><%= complaintCount %></div>
                <div style="font-size: 0.8rem; opacity: 0.8; letter-spacing: 0.05em; font-weight: 600;">COMPLAINTS SUBMITTED</div>
            </div>
        </div>

        <!-- Read-only Quick Info -->
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; margin-bottom: 2.5rem;">
            <div class="content-card" style="padding: 1.25rem;">
                <label style="display: block; font-size: 0.75rem; color: #94a3b8; font-weight: 700; text-transform: uppercase; margin-bottom: 0.5rem;">Email</label>
                <div style="font-weight: 600; color: #334155;"><%= user.getEmail() %></div>
                <span style="font-size: 0.7rem; color: #cbd5e1;">Read-only</span>
            </div>
            <div class="content-card" style="padding: 1.25rem;">
                <label style="display: block; font-size: 0.75rem; color: #94a3b8; font-weight: 700; text-transform: uppercase; margin-bottom: 0.5rem;">Municipality</label>
                <div style="font-weight: 600; color: #334155;"><%= munName %></div>
                <span style="font-size: 0.7rem; color: #cbd5e1;">Read-only</span>
            </div>
            <div class="content-card" style="padding: 1.25rem;">
                <label style="display: block; font-size: 0.75rem; color: #94a3b8; font-weight: 700; text-transform: uppercase; margin-bottom: 0.5rem;">Account Status</label>
                <div>
                    <span style="background: #dcfce7; color: #166534; padding: 0.25rem 0.75rem; border-radius: 999px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase;">
                        <%= user.getStatus() %>
                    </span>
                </div>
            </div>
        </div>

        <!-- Main Forms Section -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
            <!-- Update Profile Column -->
            <div class="content-card" style="padding: 2rem;">
                <div style="margin-bottom: 1.5rem;">
                    <h3 style="margin: 0; font-size: 1.25rem; color: #1e293b;">Update Profile</h3>
                    <p style="margin: 0.25rem 0 0; color: #64748b; font-size: 0.9rem;">Edit your name, phone, and ward number.</p>
                </div>

                <% if (request.getParameter("success") != null && request.getParameter("success").contains("Profile")) { %>
                    <div class="alert alert-success" style="margin-bottom: 1.5rem;">
                        <i class="fas fa-check-circle"></i> Profile updated successfully!
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/citizen/profile" method="POST">
                    <input type="hidden" name="action" value="updateProfile">
                    
                    <div class="form-group" style="margin-bottom: 1.25rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #475569;">Full Name <span style="color: #ef4444;">*</span></label>
                        <input type="text" name="fullName" required value="<%= user.getFullName() %>"
                               style="width: 100%; padding: 0.8rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 1.25rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #475569;">Phone Number <span style="color: #ef4444;">*</span></label>
                        <input type="text" name="phone" required value="<%= user.getPhone() %>"
                               style="width: 100%; padding: 0.8rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 1.25rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #475569;">Ward Number <span style="color: #ef4444;">*</span></label>
                        <input type="number" name="wardNumber" required value="<%= user.getWardNumber() %>"
                               style="width: 100%; padding: 0.8rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 1.5rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #475569;">Email Address</label>
                        <input type="email" disabled value="<%= user.getEmail() %>"
                               style="width: 100%; padding: 0.8rem; border: 1px solid #f1f5f9; border-radius: 8px; background-color: #f8fafc; color: #94a3b8; cursor: not-allowed;">
                        <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;">Email cannot be changed.</span>
                    </div>

                    <button type="submit" class="btn-primary" style="width: 100%; padding: 0.85rem; font-weight: 600;">Save Changes</button>
                </form>
            </div>

            <!-- Change Password Column -->
            <div class="content-card" style="padding: 2rem;">
                <div style="margin-bottom: 1.5rem;">
                    <h3 style="margin: 0; font-size: 1.25rem; color: #1e293b;">Change Password</h3>
                    <p style="margin: 0.25rem 0 0; color: #64748b; font-size: 0.9rem;">Update your account password securely.</p>
                </div>

                <% if (request.getParameter("success") != null && request.getParameter("success").contains("Password")) { %>
                    <div class="alert alert-success" style="margin-bottom: 1.5rem;">
                        <i class="fas fa-check-circle"></i> Password changed successfully!
                    </div>
                <% } %>
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error" style="margin-bottom: 1.5rem;">
                        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/citizen/profile" method="POST">
                    <input type="hidden" name="action" value="changePassword">

                    <div class="form-group" style="margin-bottom: 1.25rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #475569;">Current Password <span style="color: #ef4444;">*</span></label>
                        <input type="password" name="currentPassword" required placeholder="Enter current password"
                               style="width: 100%; padding: 0.8rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 1.25rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #475569;">New Password <span style="color: #ef4444;">*</span></label>
                        <input type="password" name="newPassword" required placeholder="Min 8 characters"
                               style="width: 100%; padding: 0.8rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                        <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;">Min 8 chars, 1 uppercase, 1 lowercase, 1 number</span>
                    </div>

                    <div class="form-group" style="margin-bottom: 2rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #475569;">Confirm New Password <span style="color: #ef4444;">*</span></label>
                        <input type="password" name="confirmPassword" required placeholder="Repeat new password"
                               style="width: 100%; padding: 0.8rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    </div>

                    <button type="submit" class="btn-primary" style="width: 100%; padding: 0.85rem; font-weight: 600;">Change Password</button>
                </form>
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
