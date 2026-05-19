<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Details - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="admin-main-content">
        <div class="admin-page-header">
            <h1>Complaint Details</h1>
            <p>Admin Operations Panel · Sunsari District, Province 1</p>
        </div>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success"><c:out value="${param.success}" /></div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error"><c:out value="${param.error}" /></div>
        </c:if>

        <div class="detail-grid">
            <section class="complaint-main">
                <h2><c:out value="${complaint.title}" /></h2>
                
                <div class="badges" style="margin-bottom: 1.5rem;">
                    <span class="badge badge-primary"><c:out value="${complaint.categoryName}" /></span>
                    <span class="badge badge-${fn:toLowerCase(complaint.status)}">
                        <c:choose>
                            <c:when test="${complaint.status == 'pending'}">Pending</c:when>
                            <c:when test="${complaint.status == 'in_progress'}">In Progress</c:when>
                            <c:when test="${complaint.status == 'resolved'}">Resolved</c:when>
                        </c:choose>
                    </span>
                    <span class="badge badge-info">Ward <c:out value="${complaint.wardNumber}" /></span>
                    <span class="badge badge-secondary"><c:out value="${complaint.voteCount}" /> Votes</span>
                </div>

                <div class="detail-item">
                    <strong>Description</strong>
                    <p><c:out value="${complaint.description}" /></p>
                </div>

                <div class="detail-item">
                    <strong>Location Details</strong>
                    <p><c:out value="${complaint.location}" /></p>
                </div>

                <c:if test="${not empty complaint.imagePath}">
                    <div class="detail-item detail-image">
                        <strong>Evidence Photo</strong>
                        <img src="<%= request.getContextPath() %>/${complaint.imagePath}" alt="Complaint Photo">
                    </div>
                </c:if>
            </section>

            <aside class="complaint-sidebar">
                <div class="admin-box" style="margin-bottom: 1.5rem;">
                    <h3>Submitter Info (Admin View)</h3>
                    <div class="detail-item">
                        <strong>Name</strong>
                        <c:out value="${submitter.fullName}" />
                        <c:if test="${complaint.anonymous}">
                            <span class="badge badge-secondary" style="font-size: 0.7em;">Submitted Anonymously</span>
                        </c:if>
                    </div>
                    <div class="detail-item">
                        <strong>Email</strong>
                        <a href="mailto:${submitter.email}"><c:out value="${submitter.email}" /></a>
                    </div>
                    <div class="detail-item">
                        <strong>Phone</strong>
                        <c:out value="${submitter.phone}" />
                    </div>
                    <div class="detail-item">
                        <strong>Contact Email (From Form)</strong>
                        <c:choose>
                            <c:when test="${not empty complaint.contactEmail}">
                                <a href="mailto:${complaint.contactEmail}"><c:out value="${complaint.contactEmail}" /></a>
                            </c:when>
                            <c:otherwise>Not Provided</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="detail-item">
                        <strong>Date Submitted</strong>
                        <c:out value="${complaint.formattedCreatedAtFull}" />
                    </div>
                </div>

                <div class="admin-box">
                    <h3>Admin Actions</h3>
                    
                    <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="id" value="${complaint.id}">
                        <div class="detail-item">
                            <strong>Update Status</strong>
                            <div class="status-form">
                                <select name="status" class="form-control" ${complaint.status == 'resolved' ? 'disabled' : ''}>
                                    <option value="pending" ${complaint.status == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="in_progress" ${complaint.status == 'in_progress' ? 'selected' : ''}>In Progress</option>
                                    <option value="resolved" ${complaint.status == 'resolved' ? 'selected' : ''}>Resolved</option>
                                </select>
                                <button type="submit" class="btn btn-primary" ${complaint.status == 'resolved' ? 'disabled' : ''}>Update</button>
                            </div>
                            <small style="color: #666; margin-top: 5px; display: block;">Status can only move forward.</small>
                        </div>
                    </form>

                    <hr style="margin: 1.5rem 0; border-top: 1px solid #ccc;">

                    <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST" onsubmit="return confirm('Are you sure you want to delete this complaint? This action cannot be undone.');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${complaint.id}">
                        <button type="submit" class="btn btn-danger" style="width: 100%;">Delete Complaint</button>
                    </form>
                </div>
            </aside>
        </div>
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
