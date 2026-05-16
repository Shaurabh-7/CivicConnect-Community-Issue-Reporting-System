<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="civicconnect.model.Categories" %>
<%@ page import="civicconnect.model.Complaint" %>
<%
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    ArrayList<Categories> categories = (ArrayList<Categories>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Complaint - CivicConnect</title>
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
            <a href="<%= request.getContextPath() %>/citizen/my-complaints" style="color: #3b82f6; text-decoration: none;">My Complaints</a>
            <span style="margin: 0 0.5rem;">›</span>
            <span>Edit Complaint</span>
        </nav>

        <!-- Alert Notice -->
        <div class="alert alert-warning" style="margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px; background-color: #fffbeb; color: #b45309; border: 1px solid #fde68a;">
            <i class="fas fa-edit"></i>
            <p>You are editing a <strong>Pending</strong> complaint. Once an admin begins processing it, editing will be locked.</p>
        </div>

        <div class="content-card" style="padding: 2.5rem; max-width: 900px; margin: 0 auto;">
            <div style="margin-bottom: 2rem;">
                <h2 style="font-size: 1.75rem; color: #1e293b; margin-bottom: 0.5rem;">Edit Complaint</h2>
                <p style="color: #64748b; font-size: 0.95rem;">Update the details below. All fields are pre-filled with your current submission.</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error" style="margin-bottom: 1.5rem;">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/citizen/edit-complaint" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="id" value="<%= complaint.getId() %>">

                <!-- Complaint Title -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Complaint Title <span style="color: #ef4444;">*</span></label>
                    <input type="text" name="title" required value="<%= complaint.getTitle() %>"
                           style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;"><%= complaint.getTitle().length() %> / 200 characters</span>
                </div>

                <!-- Category -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Category <span style="color: #ef4444;">*</span></label>
                    <select name="categoryId" required style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px; background: white;">
                        <% if (categories != null) { 
                            for (Categories cat : categories) { %>
                            <option value="<%= cat.getId() %>" <%= cat.getId() == complaint.getCategoryId() ? "selected" : "" %>><%= cat.getName() %></option>
                        <% } } %>
                    </select>
                </div>

                <!-- Ward and Location -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Ward Number <span style="color: #ef4444;">*</span></label>
                        <input type="number" name="wardNumber" required value="<%= complaint.getWardNumber() %>"
                               style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    </div>
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Location Description <span style="color: #ef4444;">*</span></label>
                        <input type="text" name="location" required value="<%= complaint.getLocation() %>"
                               style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                    </div>
                </div>

                <!-- Full Description -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Full Description <span style="color: #ef4444;">*</span></label>
                    <textarea name="description" rows="8" required
                              style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px; resize: vertical;"><%= complaint.getDescription() %></textarea>
                    <span style="font-size: 0.75rem; color: #94a3b8; display: block; margin-top: 0.4rem;"><%= complaint.getDescription().length() %> / 5000 characters</span>
                </div>

                <!-- Photo Evidence -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Photo Evidence</label>
                    <% if (complaint.getImagePath() != null && !complaint.getImagePath().isEmpty()) { %>
                        <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1rem; display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                            <div style="width: 60px; height: 60px; background-color: #e2e8f0; border-radius: 4px; display: flex; align-items: center; justify-content: center; overflow: hidden;">
                                <img src="<%= request.getContextPath() %>/<%= complaint.getImagePath() %>" alt="Evidence" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                            <div style="flex: 1;">
                                <p style="margin: 0; font-size: 0.9rem; font-weight: 600; color: #334155;"><%= complaint.getImagePath().substring(complaint.getImagePath().lastIndexOf("/") + 1) %></p>
                                <p style="margin: 0; font-size: 0.75rem; color: #64748b;">Current photo</p>
                            </div>
                            <div style="display: flex; gap: 0.5rem;">
                                <button type="button" class="btn-outline" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;" onclick="document.getElementById('imageInput').click();">Replace</button>
                                <button type="button" class="btn-outline btn-outline-danger" style="padding: 0.4rem 0.8rem; font-size: 0.8rem; color: #ef4444; border-color: #fee2e2;">Remove</button>
                            </div>
                        </div>
                    <% } %>
                    <input type="file" name="image" id="imageInput" accept="image/*" style="<%= (complaint.getImagePath() != null) ? "display: none;" : "width: 100%; padding: 0.6rem; border: 1px solid #e2e8f0; border-radius: 8px;" %>">
                </div>

                <!-- Contact Email -->
                <div class="form-group" style="margin-bottom: 1.5rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #334155;">Contact Email <span style="color: #94a3b8; font-weight: normal;">(optional)</span></label>
                    <input type="email" name="contactEmail" value="<%= complaint.getContactEmail() != null ? complaint.getContactEmail() : "" %>"
                           style="width: 100%; padding: 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                </div>

                <!-- Anonymous Toggle -->
                <div class="form-group" style="margin-bottom: 2rem; display: flex; align-items: center; gap: 10px;">
                    <input type="checkbox" name="isAnonymous" id="isAnonymous" <%= complaint.isAnonymous() ? "checked" : "" %> style="width: 18px; height: 18px; cursor: pointer;">
                    <label for="isAnonymous" style="font-size: 0.9rem; color: #475569; cursor: pointer;">
                        Submit Anonymously — Your name will be hidden from the public.
                    </label>
                </div>

                <!-- Actions -->
                <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #f1f5f9; padding-top: 2rem;">
                    <div style="display: flex; gap: 1rem;">
                        <button type="submit" class="btn-primary" style="width: auto; padding: 0.85rem 2.5rem; font-weight: 600; text-decoration: none;">Save Changes</button>
                        <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="btn-outline" 
                           style="width: auto; padding: 0.85rem 2.5rem; text-decoration: none; text-align: center; font-weight: 600; color: #3b82f6; border: 1px solid #dbeafe;">Cancel</a>
                    </div>
                    <a href="<%= request.getContextPath() %>/citizen/delete-complaint?id=<%= complaint.getId() %>" 
                       class="btn-danger" style="width: auto; padding: 0.85rem 1.5rem; background-color: #ef4444; color: white; text-decoration: none; border-radius: 8px; font-weight: 600;"
                       onclick="return confirm('Are you sure you want to delete this complaint permanently?')">
                        Delete This Complaint
                    </a>
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
