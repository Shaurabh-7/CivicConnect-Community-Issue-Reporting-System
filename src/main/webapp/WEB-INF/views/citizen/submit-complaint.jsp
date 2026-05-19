<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="civicconnect.model.Categories" %>
<%@ page import="civicconnect.model.Users" %>
<%
    ArrayList<Categories> categories = (ArrayList<Categories>) request.getAttribute("categories");
    Users user = (Users) session.getAttribute("user"); // We might need to get user from session or fetch in servlet
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint - CivicConnect</title>
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
            <span>Submit Complaint</span>
        </nav>

        <div class="content-card" style="padding: 2.5rem; max-width: 900px; margin: 0 auto;">
            <div style="margin-bottom: 2rem;">
                <h2 style="font-size: 1.75rem; color: #1e293b; margin-bottom: 0.5rem;">Submit a New Complaint</h2>
                <p style="color: #64748b; font-size: 0.95rem;">Your complaint will be publicly visible immediately and sent to your municipality admin. Fill in as much detail as possible.</p>
            </div>

            <!-- Info Box -->
            <div style="background-color: #dbeafe; border-radius: 8px; padding: 1rem 1.5rem; display: flex; align-items: center; gap: 12px; margin-bottom: 2rem; color: #1e40af;">
                <i class="fas fa-info-circle"></i>
                <p style="margin: 0; font-size: 0.9rem; font-weight: 500;">
                    Submitting for: <%= session.getAttribute("municipalityName") != null ? session.getAttribute("municipalityName") : "Your Municipality" %> • Ward <%= session.getAttribute("wardNumber") != null ? session.getAttribute("wardNumber") : "N/A" %>
                </p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error" style="margin-bottom: 1.5rem;">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/citizen/submit-complaint" method="POST" enctype="multipart/form-data">
                <!-- Complaint Title -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Complaint Title <span style="color: #ef4444;">*</span></label>
                    <input type="text" name="title" required placeholder="Brief, specific title (10-200 characters)"
                           style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;">0 / 200 characters</span>
                </div>

                <!-- Category -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Category <span style="color: #ef4444;">*</span></label>
                    <select name="categoryId" required style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px; background: white;">
                        <option value="">Select a category...</option>
                        <% if (categories != null) { 
                            for (Categories cat : categories) { %>
                            <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                        <% } } %>
                    </select>
                </div>

                <!-- Ward and Location -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Ward Number <span style="color: #ef4444;">*</span></label>
                        <input type="number" name="wardNumber" required value="<%= session.getAttribute("wardNumber") != null ? session.getAttribute("wardNumber") : "" %>"
                               style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                        <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;">Pre-filled from your profile. You may change it.</span>
                    </div>
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Location Description <span style="color: #ef4444;">*</span></label>
                        <input type="text" name="location" required placeholder="e.g., Near Bhanu Chowk, Ward 5"
                               style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                        <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;">Describe the location — not GPS coordinates</span>
                    </div>
                </div>

                <!-- Full Description -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Full Description <span style="color: #ef4444;">*</span></label>
                    <textarea name="description" rows="5" required placeholder="Describe the issue in detail. Include when it started, who is affected, what has been tried so far, and any other relevant context. (Min 30 characters)"
                              style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px; resize: vertical;"></textarea>
                    <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;">0 / 5000 characters</span>
                </div>

                <!-- Photo Evidence -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Photo Evidence <span style="color: #94a3b8; font-weight: normal;">(optional)</span></label>
                    <div style="border: 2px dashed #e2e8f0; border-radius: 8px; padding: 2rem; text-align: center; position: relative;">
                        <input type="file" name="image" accept="image/*" style="opacity: 0; position: absolute; top: 0; left: 0; width: 100%; height: 100%; cursor: pointer;">
                        <i class="fas fa-camera" style="font-size: 1.5rem; color: #cbd5e1; margin-bottom: 1rem;"></i>
                        <p style="margin: 0; font-size: 0.9rem; color: #64748b;">Click to upload or drag & drop</p>
                        <p style="margin: 0; font-size: 0.75rem; color: #94a3b8; margin-top: 0.5rem;">JPG or PNG only • Max 5 MB • Single file</p>
                    </div>
                </div>

                <!-- Contact Email -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Contact Email <span style="color: #94a3b8; font-weight: normal;">(optional)</span></label>
                    <input type="email" name="contactEmail" value="<%= user != null ? user.getEmail() : "" %>"
                           style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;">The admin may use this to follow up. Leave blank to use no contact email.</span>
                </div>

                <!-- Anonymous Toggle -->
                <div class="form-group" style="margin-bottom: 2rem; display: flex; align-items: center; gap: 10px;">
                    <input type="checkbox" name="isAnonymous" id="isAnonymous" style="width: 18px; height: 18px; cursor: pointer;">
                    <label for="isAnonymous" style="font-size: 0.9rem; color: #475569; cursor: pointer;">
                        <strong>Submit Anonymously</strong> — Your name will be hidden from the public. The municipality admin can still see your identity.
                    </label>
                </div>

                <!-- Actions -->
                <div style="display: flex; gap: 1rem;">
                    <button type="submit" class="btn-primary" style="width: auto; padding: 0.85rem 2.5rem; font-weight: 600;">Submit Complaint</button>
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="btn-outline" 
                       style="width: auto; padding: 0.85rem 2.5rem; text-decoration: none; text-align: center; font-weight: 600; color: #3b82f6; border: 1px solid #dbeafe;">Cancel</a>
                </div>
            </form>
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
