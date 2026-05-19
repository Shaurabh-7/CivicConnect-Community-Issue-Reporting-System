<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="civicconnect.dto.complaint.ComplaintDTO" %>
<%@ page import="civicconnect.model.Categories" %>
<%@ page import="civicconnect.dto.municipality.MunicipalityDTO" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Set" %>
<%
    ArrayList<ComplaintDTO> complaints = (ArrayList<ComplaintDTO>) request.getAttribute("complaints");
    ArrayList<Categories> categories = (ArrayList<Categories>) request.getAttribute("categories");
    ArrayList<MunicipalityDTO> municipalities = (ArrayList<MunicipalityDTO>) request.getAttribute("municipalities");
    ArrayList<ComplaintDTO> topComplaints = (ArrayList<ComplaintDTO>) request.getAttribute("topComplaints");
    Set<Integer> votedIds = (Set<Integer>) request.getAttribute("votedIds");
    
    int totalComplaints = (int) request.getAttribute("totalComplaints");
    int resolvedComplaints = (int) request.getAttribute("resolvedComplaints");
    int totalCitizens = (int) request.getAttribute("totalCitizens");
    int activeMun = (int) request.getAttribute("activeMun");

    String currentStatus = (String) request.getAttribute("currentStatus");
    String currentCategory = (String) request.getAttribute("currentCategory");
    String currentSearch = (String) request.getAttribute("currentSearch");
    int currentMunId = (int) request.getAttribute("currentMunId");
    String currentTab = (String) request.getAttribute("currentTab");
    
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Issues - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero-section {
            padding: 3rem 0;
            border-left: 4px solid #ef4444;
            margin-bottom: 2rem;
        }
        .hero-title {
            font-size: 2.25rem;
            font-weight: 800;
            color: #1e293b;
            line-height: 1.2;
            margin-bottom: 1rem;
            max-width: 600px;
        }
        .hero-subtitle {
            color: #64748b;
            font-size: 1rem;
            max-width: 500px;
            line-height: 1.6;
        }
        
        .browse-layout {
            display: grid;
            grid-template-columns: minmax(0, 2fr) 350px;
            gap: 3rem;
            align-items: start;
        }

        .sidebar {
            position: sticky;
            top: 2rem;
            background: transparent; 
        }

        .tab-menu {
            display: flex;
            gap: 2rem;
            border-bottom: 1px solid #e2e8f0;
            margin-bottom: 1.5rem;
        }
        .tab-link {
            padding-bottom: 0.75rem;
            font-size: 0.85rem;
            font-weight: 700;
            color: #94a3b8;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-bottom: 2px solid transparent;
            cursor: pointer;
        }
        .tab-link.active {
            color: #2563eb;
            border-bottom-color: #2563eb;
        }

        .feed-item {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            gap: 1.5rem;
            transition: border-color 0.2s;
        }
        .feed-item:hover {
            border-color: #cbd5e1;
        }
        .vote-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
            min-width: 50px;
        }
        .vote-btn {
            background: #f1f5f9;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 8px;
            color: #64748b;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }
        .vote-count {
            font-weight: 800;
            color: #1e293b;
            font-size: 1.1rem;
        }

        .feed-content {
            flex-grow: 1;
        }
        .feed-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.5rem;
            display: block;
            text-decoration: none;
        }
        .feed-desc {
            font-size: 0.9rem;
            color: #64748b;
            margin-bottom: 1rem;
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .feed-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
            font-size: 0.75rem;
            color: #94a3b8;
            font-weight: 600;
            text-transform: uppercase;
        }

        .sidebar-title {
            font-size: 0.8rem;
            font-weight: 800;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.07em;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 8px;
            /* Fix: Ensure it doesn't float or hover unexpectedly */
            position: relative;
            z-index: 1;
        }
        .sidebar-title::after {
            content: "";
            height: 1px;
            background: #e2e8f0;
            flex-grow: 1;
        }

        .agenda-item {
            margin-bottom: 1rem;
            display: flex;
            gap: 12px;
        }
        .agenda-rank {
            font-size: 0.8rem;
            font-weight: 800;
            color: #cbd5e1;
            margin-top: 2px;
        }
        .agenda-link {
            font-size: 0.85rem;
            font-weight: 700;
            color: #334155;
            text-decoration: none;
            line-height: 1.4;
            display: block;
            margin-bottom: 2px;
        }
        .agenda-stats {
            font-size: 0.7rem;
            font-weight: 700;
            color: #94a3b8;
        }

        .stat-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.85rem;
        }
        .stat-label { color: #64748b; }
        .stat-value { font-weight: 700; color: #1e293b; }
        .vote-btn.voted {
            background: #2563eb;
            color: white;
        }
    </style>
</head>
<body class="dashboard-body">
    <jsp:include page="navbar.jsp" />

    <!-- JavaScript for Voting -->
    <script>
        function toggleVote(complaintId, btnElement) {
            const formData = new URLSearchParams();
            formData.append('complaintId', complaintId);

            fetch('<%= request.getContextPath() %>/citizen/vote', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => response.text())
            .then(status => {
                const countElement = document.getElementById('vote-count-' + complaintId);
                let currentCount = parseInt(countElement.innerText);
                
                if (status === 'voted') {
                    btnElement.classList.add('voted');
                    countElement.innerText = currentCount + 1;
                } else if (status === 'unvoted') {
                    btnElement.classList.remove('voted');
                    countElement.innerText = currentCount - 1;
                }
            })
            .catch(error => console.error('Error voting:', error));
        }
    </script>

    <main class="citizen-dashboard">
        <!-- Hero -->
        <div class="hero-section">
            <h1 class="hero-title">Citizen Voice for Better Governance in Your Municipality.</h1>
            <p class="hero-subtitle">A structured digital channel for citizens to report local problems directly to their municipality — roads, water, sanitation, electricity, and more.</p>
        </div>

        <!-- Search & Filter Bar -->
        <form action="<%= request.getContextPath() %>/citizen/browse" method="GET" class="content-card" style="padding: 1rem; margin-bottom: 2.5rem; display: flex; gap: 1rem;">
            <input type="hidden" name="tab" value="<%= currentTab %>">
            <div style="flex-grow: 1; position: relative;">
                <i class="fas fa-search" style="position: absolute; left: 1.25rem; top: 50%; transform: translateY(-50%); color: #2563eb;"></i>
                <input type="text" name="search" placeholder="Search complaints by title or description..." value="<%= currentSearch %>"
                       style="width: 100%; padding: 1rem 1rem 1rem 3rem; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 0.95rem;">
            </div>
            <select name="municipalityId" onchange="this.form.submit()" style="padding: 0 1.5rem; border: 1px solid #e2e8f0; border-radius: 8px; background: white; font-weight: 600; color: #334155;">
                <option value="0">All Municipalities</option>
                <% if (municipalities != null) { 
                    for (MunicipalityDTO m : municipalities) { %>
                    <option value="<%= m.getId() %>" <%= currentMunId == m.getId() ? "selected" : "" %>><%= m.getName() %></option>
                <% } } %>
            </select>
            <button type="submit" class="btn-primary" style="width: auto; padding: 0 1.5rem;">Search</button>
        </form>

        <div class="browse-layout">
            <!-- Left Column: Feed -->
            <div class="main-feed">
                <div class="tab-menu">
                    <a href="<%= request.getContextPath() %>/citizen/browse?tab=latest&search=<%= currentSearch %>&municipalityId=<%= currentMunId %>" 
                       class="tab-link <%= "latest".equals(currentTab) ? "active" : "" %>">Latest Submissions</a>
                    <a href="<%= request.getContextPath() %>/citizen/browse?tab=trending&search=<%= currentSearch %>&municipalityId=<%= currentMunId %>" 
                       class="tab-link <%= "trending".equals(currentTab) ? "active" : "" %>">Trending</a>
                </div>

                <% if (complaints != null && !complaints.isEmpty()) { 
                    for (ComplaintDTO c : complaints) { %>
                    <div class="feed-item">
                        <div class="vote-section">
                            <button class="vote-btn <%= (votedIds != null && votedIds.contains(c.getId())) ? "voted" : "" %>" 
                                    onclick="toggleVote(<%= c.getId() %>, this)">
                                <i class="fas fa-caret-up"></i>
                            </button>
                            <div class="vote-count" id="vote-count-<%= c.getId() %>"><%= c.getVoteCount() %></div>
                        </div>
                        <div class="feed-content">
                            <a href="<%= request.getContextPath() %>/citizen/view-complaint?id=<%= c.getId() %>" class="feed-title"><%= c.getTitle() %></a>
                            <p class="feed-desc"><%= c.getDescription() %></p>
                            <div class="feed-meta">
                                <span><%= c.isAnonymous() ? "Anonymous" : (c.getUserName() != null ? c.getUserName() : "Citizen") %></span>
                                <span class="admin-badge" style="background: #f1f5f9; color: #475569; font-size: 0.65rem;"><%= c.getCategoryName() %></span>
                                <span><%= c.getMunicipalityName() %></span>
                                <span>Ward <%= c.getWardNumber() %></span>
                                <span class="status-badge status-<%= c.getStatus().toLowerCase().replace(" ", "-") %>" style="padding: 2px 8px; font-size: 0.65rem;">
                                    <%= c.getStatus().toUpperCase() %>
                                </span>
                                <span>Posted <%= c.getCreatedAt().format(formatter) %></span>
                            </div>
                        </div>
                        <div style="display: flex; align-items: center;">
                            <a href="<%= request.getContextPath() %>/citizen/view-complaint?id=<%= c.getId() %>" class="btn-primary" 
                               style="width: auto; padding: 0.6rem 1rem; font-size: 0.8rem; text-decoration: none; border-radius: 6px;">View</a>
                        </div>
                    </div>
                <% } } else { %>
                    <div class="content-card" style="text-align: center; padding: 4rem; color: #94a3b8;">
                        <i class="fas fa-search" style="font-size: 3rem; margin-bottom: 1rem;"></i>
                        <p>No issues found matching your criteria.</p>
                    </div>
                <% } %>
            </div>

            <!-- Right Column: Sidebar -->
            <div class="sidebar">
                <!-- Most Supported -->
                <div class="content-card" style="padding: 1.5rem; margin-bottom: 2rem;">
                    <div class="sidebar-title">Public Agenda — Most Supported</div>
                    <% if (topComplaints != null && !topComplaints.isEmpty()) { 
                        int rank = 1;
                        for (ComplaintDTO top : topComplaints) { %>
                        <div class="agenda-item">
                            <div class="agenda-rank">0<%= rank++ %></div>
                            <div>
                                <a href="<%= request.getContextPath() %>/citizen/view-complaint?id=<%= top.getId() %>" class="agenda-link"><%= top.getTitle() %></a>
                                <div class="agenda-stats"><%= top.getVoteCount() %> SUPPORTS</div>
                            </div>
                        </div>
                    <% } } %>
                    <a href="#" style="display: block; margin-top: 1.5rem; font-size: 0.75rem; font-weight: 800; color: #2563eb; text-decoration: none; text-transform: uppercase; letter-spacing: 0.05em;">
                        View Full Agenda Record →
                    </a>
                </div>

                <!-- Quick Stats -->
                <div class="content-card" style="padding: 1.5rem; margin-bottom: 2rem;">
                    <div class="sidebar-title">Quick Stats</div>
                    <div class="stat-row">
                        <span class="stat-label">Active Municipalities</span>
                        <span class="stat-value"><%= activeMun %></span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">Total Complaints</span>
                        <span class="stat-value"><%= String.format("%,d", totalComplaints) %></span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">Resolved Issues</span>
                        <span class="stat-value" style="color: #10b981;"><%= String.format("%,d", resolvedComplaints) %></span>
                    </div>
                    <div class="stat-row" style="border-bottom: none;">
                        <span class="stat-label">Registered Citizens</span>
                        <span class="stat-value"><%= String.format("%,d", totalCitizens) %></span>
                    </div>
                </div>

                <!-- Have an Issue? -->
                <div class="content-card" style="padding: 1.5rem; background: white; border-style: dashed;">
                    <div class="sidebar-title">Have an Issue?</div>
                    <p style="font-size: 0.85rem; color: #64748b; margin-bottom: 1.5rem; line-height: 1.5;">
                        Report a civic problem directly to your municipality admin. Your voice matters.
                    </p>
                    <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="btn-primary" style="text-decoration: none; text-align: center; display: block;">Report Now</a>
                </div>
            </div>
        </div>
    </main>

    <footer class="dashboard-footer" style="margin-left: 0;">
        <div class="footer-content">
            <p>&copy; 2026 CivicConnect. All rights reserved.</p>
            <div class="footer-links">
                <a href="#">About</a>
                <span class="separator">•</span>
                <a href="#">Privacy</a>
                <span class="separator">•</span>
                <a href="#">Contact</a>
            </div>
        </div>
    </footer>
</body>
</html>
