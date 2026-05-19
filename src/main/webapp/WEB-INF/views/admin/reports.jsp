<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="admin-main-content">
        <div class="admin-page-header">
            <h1>Analytics & Reports</h1>
            <p>Performance Stats · Sunsari District, Province 1</p>
        </div>
        
        <p>This page provides a statistical overview of the civic issues reported in your municipality.</p>

        <div class="grid-2-col">
            <section class="report-section">
                <h3>Complaints by Status</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Status</th>
                            <th>Count</th>
                            <th>Percentage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Pending</td>
                            <td><c:out value="${pendingCount}" /></td>
                            <td><fmt:formatNumber value="${pendingPct}" maxFractionDigits="1" />%</td>
                        </tr>
                        <tr>
                            <td>In Progress</td>
                            <td><c:out value="${inProgressCount}" /></td>
                            <td><fmt:formatNumber value="${inProgressPct}" maxFractionDigits="1" />%</td>
                        </tr>
                        <tr>
                            <td>Resolved</td>
                            <td><c:out value="${resolvedCount}" /></td>
                            <td><fmt:formatNumber value="${resolvedPct}" maxFractionDigits="1" />%</td>
                        </tr>
                        <tr style="font-weight: bold; background: #f8f9fa;">
                            <td>Total</td>
                            <td><c:out value="${totalComplaints}" /></td>
                            <td>100%</td>
                        </tr>
                    </tbody>
                </table>
            </section>

            <section class="report-section">
                <h3>Recent Activity (7 & 30 Days)</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Metric</th>
                            <th>Last 7 Days</th>
                            <th>Last 30 Days</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>New Complaints Filed</td>
                            <td><c:out value="${newLast7Days}" /></td>
                            <td><c:out value="${newLast30Days}" /></td>
                        </tr>
                        <tr>
                            <td>Complaints Resolved</td>
                            <td><c:out value="${resolvedLast7Days}" /></td>
                            <td><c:out value="${resolvedLast30Days}" /></td>
                        </tr>
                    </tbody>
                </table>
            </section>
        </div>

        <div class="grid-2-col">
            <section class="report-section">
                <h3>Complaints by Category</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Category Name</th>
                            <th>Number of Complaints</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${categoryCounts}">
                            <tr>
                                <td><c:out value="${entry.key}" /></td>
                                <td><c:out value="${entry.value}" /></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty categoryCounts}">
                            <tr><td colspan="2">No data available.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </section>

            <section class="report-section">
                <h3>Most Reported Wards</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Ward Number</th>
                            <th>Total Complaints</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${wardCounts}">
                            <tr>
                                <td>Ward <c:out value="${entry.key}" /></td>
                                <td><c:out value="${entry.value}" /></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty wardCounts}">
                            <tr><td colspan="2">No data available.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </section>
        </div>

        <section class="report-section">
            <h3>Top 10 Most Supported Issues</h3>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Votes</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="complaint" items="${topSupported}" varStatus="status">
                        <tr>
                            <td>#<c:out value="${status.index + 1}" /></td>
                            <td><a href="<%= request.getContextPath() %>/admin/complaint-detail?id=${complaint.id}"><c:out value="${complaint.title}" /></a></td>
                            <td><c:out value="${complaint.categoryName}" /></td>
                            <td><c:out value="${complaint.status}" /></td>
                            <td><strong><c:out value="${complaint.voteCount}" /></strong></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty topSupported}">
                        <tr><td colspan="5">No data available.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </section>

    </main>

    <footer class="dashboard-footer" style="margin-left: 240px; background-color: #1e3a8a; color: rgba(255, 255, 255, 0.6); border-top: 1px solid rgba(255, 255, 255, 0.1); padding: 2rem 2.5rem;">
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
