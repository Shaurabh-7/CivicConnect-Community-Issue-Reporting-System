<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Complaint Details - CivicConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/stylesheet.css">
    <style>
        .detail-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; }
        .admin-box { background: #f8f9fa; border: 1px solid #ddd; padding: 1.5rem; border-radius: 8px; }
        .admin-box h3 { margin-top: 0; color: #333; border-bottom: 1px solid #ccc; padding-bottom: 0.5rem; }
        .detail-item { margin-bottom: 1rem; }
        .detail-item strong { display: block; color: #555; font-size: 0.9em; text-transform: uppercase; }
        .detail-image img { max-width: 100%; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .btn-danger { background-color: #dc3545; color: white; border: none; }
        .btn-danger:hover { background-color: #c82333; }
        .status-form { margin-top: 1rem; display: flex; gap: 1rem; align-items: center; }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="container">
        
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
                        <img src="${pageContext.request.contextPath}/${complaint.imagePath}" alt="Complaint Photo">
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
                        <fmt:formatDate value="${complaint.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                    </div>
                </div>

                <div class="admin-box">
                    <h3>Admin Actions</h3>
                    
                    <form action="${pageContext.request.contextPath}/admin/complaint-detail" method="POST">
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

                    <form action="${pageContext.request.contextPath}/admin/complaint-detail" method="POST" onsubmit="return confirm('Are you sure you want to delete this complaint? This action cannot be undone.');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${complaint.id}">
                        <button type="submit" class="btn btn-danger" style="width: 100%;">Delete Complaint</button>
                    </form>
                </div>
            </aside>
        </div>
    </main>
</body>
</html>
