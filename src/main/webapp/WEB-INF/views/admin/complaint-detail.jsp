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
            <p>Admin Operations Panel &middot; <c:out value="${sessionScope.municipalityDistrict}" /> District, <c:out value="${sessionScope.municipalityProvince}" /></p>
        </div>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success" style="margin-bottom: 2rem;"><c:out value="${param.success}" /></div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" style="margin-bottom: 2rem;"><c:out value="${param.error}" /></div>
        </c:if>

        <!-- Breadcrumbs Navigation -->
        <div class="breadcrumbs" style="margin-bottom: 2rem; font-size: 0.875rem; color: #64748b;">
            <a href="<%= request.getContextPath() %>/admin/dashboard" style="color: #2563eb; text-decoration: none; font-weight: 600;">Dashboard</a>
            <span style="margin: 0 0.5rem; color: #cbd5e1;">/</span>
            <a href="<%= request.getContextPath() %>/admin/manage-complaints" style="color: #2563eb; text-decoration: none; font-weight: 600;">Complaints</a>
            <span style="margin: 0 0.5rem; color: #cbd5e1;">/</span>
            <span style="color: #334155; font-weight: 700;">#<fmt:formatNumber value="${complaint.id}" minIntegerDigits="2" /></span>
        </div>

        <div class="detail-grid">
            <!-- Left Column (2/3 width) -->
            <section class="complaint-main">
                <h2 style="font-size: 1.8rem; font-weight: 800; color: #0f172a; margin-top: 0; margin-bottom: 1.5rem;"><c:out value="${complaint.title}" /></h2>
                
                <!-- Rounded Evidence Photo Container -->
                <div class="admin-box" style="margin-bottom: 2rem; padding: 0; overflow: hidden; border-radius: 12px; border: 1px solid #e2e8f0; background: #ffffff;">
                    <c:choose>
                        <c:when test="${not empty complaint.imagePath}">
                            <div style="width: 100%; height: 380px; background-color: #f1f5f9; display: flex; align-items: center; justify-content: center; overflow: hidden;">
                                <img src="<%= request.getContextPath() %>/${complaint.imagePath}" alt="Evidence Photo" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="width: 100%; height: 220px; background-color: #f8fafc; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                                <i class="fas fa-image" style="font-size: 3.5rem; color: #cbd5e1; margin-bottom: 0.75rem;"></i>
                                <span style="font-size: 0.9rem; color: #94a3b8; font-weight: 600;">No evidence photo provided</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- FULL DESCRIPTION Card -->
                <div class="admin-box" style="margin-bottom: 2rem; border-radius: 12px;">
                    <h3 style="font-size: 1.1rem; color: #0f172a; margin-bottom: 1.25rem; font-weight: 700; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem; display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-align-left" style="color: #2563eb;"></i> FULL DESCRIPTION
                    </h3>
                    <p style="font-size: 0.95rem; line-height: 1.6; color: #334155; white-space: pre-line; margin: 0;"><c:out value="${complaint.description}" /></p>
                </div>

                <!-- COMPLAINT DETAILS Card -->
                <div class="admin-box" style="margin-bottom: 2rem; border-radius: 12px;">
                    <h3 style="font-size: 1.1rem; color: #0f172a; margin-bottom: 1.25rem; font-weight: 700; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem; display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-info-circle" style="color: #2563eb;"></i> COMPLAINT DETAILS
                    </h3>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                        <div>
                            <div style="margin-bottom: 1.25rem;">
                                <span style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.35rem;">Category</span>
                                <span class="admin-cat-badge cat-${fn:toLowerCase(complaint.categoryName)}">
                                    <c:out value="${complaint.categoryName}" />
                                </span>
                            </div>
                            <div style="margin-bottom: 1.25rem;">
                                <span style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.35rem;">Ward Number</span>
                                <span style="font-size: 0.95rem; font-weight: 700; color: #0f172a;">Ward <c:out value="${complaint.wardNumber}" /></span>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.35rem;">Date Submitted</span>
                                <span style="font-size: 0.95rem; font-weight: 600; color: #334155;"><c:out value="${complaint.formattedCreatedAtFull}" /></span>
                            </div>
                        </div>
                        <div>
                            <div style="margin-bottom: 1.25rem;">
                                <span style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.35rem;">Location Details</span>
                                <span style="font-size: 0.95rem; font-weight: 600; color: #334155; display: flex; align-items: flex-start; gap: 6px;">
                                    <i class="fas fa-map-marker-alt" style="color: #ef4444; margin-top: 3px;"></i>
                                    <c:out value="${complaint.location}" />
                                </span>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.35rem;">Community Support</span>
                                <span style="font-size: 1.35rem; font-weight: 800; color: #2563eb; display: flex; align-items: center; gap: 8px;">
                                    <i class="fas fa-thumbs-up"></i>
                                    <c:out value="${complaint.voteCount}" /> <span style="font-size: 0.875rem; color: #64748b; font-weight: 600;">supports</span>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SUBMITTER DETAILS Card -->
                <div class="admin-box" style="margin-bottom: 2rem; border-radius: 12px; background-color: #fffbeb; border: 1px solid #fde68a;">
                    <h3 style="font-size: 1.1rem; color: #78350f; margin-bottom: 1.25rem; font-weight: 700; border-bottom: 1px solid #fde68a; padding-bottom: 0.75rem; display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-lock" style="color: #d97706;"></i> SUBMITTER DETAILS &middot; SECURE VIEW
                    </h3>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                        <div>
                            <div style="margin-bottom: 1rem;">
                                <span style="font-size: 0.75rem; color: #b45309; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.25rem;">Citizen Name</span>
                                <span style="font-size: 0.95rem; font-weight: 700; color: #78350f; display: flex; align-items: center; gap: 6px;">
                                    <c:out value="${submitter.fullName}" />
                                    <c:if test="${complaint.anonymous}">
                                        <span style="font-size: 0.72rem; background-color: #fef3c7; border: 1px solid #fde68a; color: #b45309; padding: 2px 6px; border-radius: 4px; font-weight: 600;">Anonymous Submitter</span>
                                    </c:if>
                                </span>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: #b45309; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.25rem;">Phone Number</span>
                                <span style="font-size: 0.95rem; font-weight: 600; color: #78350f;"><c:out value="${submitter.phone}" /></span>
                            </div>
                        </div>
                        <div>
                            <div style="margin-bottom: 1rem;">
                                <span style="font-size: 0.75rem; color: #b45309; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.25rem;">Account Email</span>
                                <a href="mailto:${submitter.email}" style="font-size: 0.95rem; font-weight: 600; color: #d97706; text-decoration: none;"><c:out value="${submitter.email}" /></a>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: #b45309; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.25rem;">Contact Email (From Form)</span>
                                <c:choose>
                                    <c:when test="${not empty complaint.contactEmail}">
                                        <a href="mailto:${complaint.contactEmail}" style="font-size: 0.95rem; font-weight: 600; color: #d97706; text-decoration: none;"><c:out value="${complaint.contactEmail}" /></a>
                                    </c:when>
                                    <c:otherwise><span style="font-size: 0.95rem; font-style: italic; color: #b45309;">Not Provided</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer Back Link -->
                <div style="margin-top: 2rem;">
                    <a href="<%= request.getContextPath() %>/admin/manage-complaints" style="display: inline-flex; align-items: center; gap: 8px; color: #2563eb; text-decoration: none; font-weight: 700; font-size: 0.95rem; transition: color 0.2s;">
                        <i class="fas fa-arrow-left"></i> Back to Manage Complaints
                    </a>
                </div>
            </section>

            <!-- Right Column (1/3 width) -->
            <aside class="complaint-sidebar">
                <!-- UPDATE STATUS Card -->
                <div class="admin-box" style="margin-bottom: 2rem; border-radius: 12px;">
                    <h3 style="font-size: 1.1rem; color: #0f172a; margin-bottom: 1.25rem; font-weight: 700; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem; display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-tasks" style="color: #2563eb;"></i> UPDATE STATUS
                    </h3>
                    <div style="margin-bottom: 1.25rem; display: flex; align-items: center; justify-content: space-between;">
                        <span style="font-size: 0.875rem; color: #64748b; font-weight: 600;">Current Status:</span>
                        <span class="admin-status-badge admin-status-${fn:toLowerCase(complaint.status)}">
                            <c:choose>
                                <c:when test="${complaint.status == 'pending'}">PENDING</c:when>
                                <c:when test="${complaint.status == 'in_progress'}">IN PROGRESS</c:when>
                                <c:when test="${complaint.status == 'resolved'}">RESOLVED</c:when>
                                <c:otherwise><c:out value="${fn:toUpperCase(complaint.status)}" /></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="id" value="${complaint.id}">
                        
                        <div style="margin-bottom: 1.25rem;">
                            <label style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: block; margin-bottom: 0.5rem;">Change Status To</label>
                            <select name="status" style="width: 100%; padding: 0.625rem; border-radius: 8px; border: 1px solid #cbd5e1; background-color: #f8fafc; font-size: 0.9rem; color: #1e293b; font-weight: 500; outline: none; transition: border-color 0.2s;" ${complaint.status == 'resolved' ? 'disabled' : ''}>
                                <c:choose>
                                    <c:when test="${complaint.status == 'pending'}">
                                        <option value="pending" selected disabled>Pending</option>
                                        <option value="in_progress">In Progress</option>
                                        <option value="resolved">Resolved</option>
                                    </c:when>
                                    <c:when test="${complaint.status == 'in_progress'}">
                                        <option value="in_progress" selected disabled>In Progress</option>
                                        <option value="resolved">Resolved</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="resolved" selected disabled>Resolved</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </div>
                        
                        <c:choose>
                            <c:when test="${complaint.status != 'resolved'}">
                                <button type="submit" class="btn-action-transition" style="width: 100%; justify-content: center; padding: 10px; border-radius: 8px; font-size: 0.9rem; font-weight: 700;">
                                    Update Status Flow
                                </button>
                            </c:when>
                            <c:otherwise>
                                <div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; color: #166534; padding: 0.75rem; border-radius: 8px; font-size: 0.85rem; font-weight: 600; display: flex; align-items: center; gap: 8px;">
                                    <i class="fas fa-check-circle" style="color: #15803d; font-size: 1.1rem;"></i>
                                    This complaint is fully resolved.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </form>
                    
                    <c:if test="${complaint.status != 'resolved'}">
                        <div style="margin-top: 1rem; background-color: #eff6ff; border: 1px solid #bfdbfe; color: #1e40af; padding: 0.75rem; border-radius: 8px; font-size: 0.8rem; line-height: 1.4; display: flex; align-items: flex-start; gap: 8px;">
                            <i class="fas fa-info-circle" style="margin-top: 2px;"></i>
                            <div>
                                <strong>Transition Notice:</strong> Status flow is forward-only:<br>
                                Pending &rarr; In Progress &rarr; Resolved
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- STATUS TIMELINE Card -->
                <div class="admin-box" style="margin-bottom: 2rem; border-radius: 12px;">
                    <h3 style="font-size: 1.1rem; color: #0f172a; margin-bottom: 1.25rem; font-weight: 700; border-bottom: 1px solid #f1f5f9; padding-bottom: 0.75rem; display: flex; align-items: center; gap: 8px;">
                        <i class="fas fa-history" style="color: #2563eb;"></i> STATUS TIMELINE
                    </h3>
                    <div style="padding-left: 0.5rem; margin-top: 1rem;">
                        <!-- Step 1: Pending -->
                        <div style="position: relative; padding-left: 1.75rem; padding-bottom: 1.5rem; border-left: 2px solid ${complaint.status != 'pending' ? '#2563eb' : '#e2e8f0'};">
                            <div style="position: absolute; left: -7px; top: 0; width: 12px; height: 12px; border-radius: 50%; background-color: #2563eb; border: 2px solid #ffffff; box-shadow: 0 0 0 2px #2563eb;"></div>
                            <span style="font-size: 0.85rem; font-weight: 700; color: #0f172a; display: block;">Pending</span>
                            <span style="font-size: 0.75rem; color: #64748b; font-weight: 500;">Complaint submitted to the system</span>
                        </div>
                        <!-- Step 2: In Progress -->
                        <div style="position: relative; padding-left: 1.75rem; padding-bottom: 1.5rem; border-left: 2px solid ${complaint.status == 'resolved' ? '#10b981' : '#e2e8f0'};">
                            <div style="position: absolute; left: -7px; top: 0; width: 12px; height: 12px; border-radius: 50%; background-color: ${complaint.status != 'pending' ? (complaint.status == 'resolved' ? '#10b981' : '#2563eb') : '#ffffff'}; border: 2px solid ${complaint.status != 'pending' ? '#ffffff' : '#cbd5e1'}; ${complaint.status != 'pending' ? (complaint.status == 'resolved' ? 'box-shadow: 0 0 0 2px #10b981;' : 'box-shadow: 0 0 0 2px #2563eb;') : ''}"></div>
                            <span style="font-size: 0.85rem; font-weight: 700; color: ${complaint.status != 'pending' ? '#0f172a' : '#94a3b8'}; display: block;">In Progress</span>
                            <span style="font-size: 0.75rem; color: #64748b; font-weight: 500;">Assigned to municipal workers & being investigated</span>
                        </div>
                        <!-- Step 3: Resolved -->
                        <div style="position: relative; padding-left: 1.75rem;">
                            <div style="position: absolute; left: -7px; top: 0; width: 12px; height: 12px; border-radius: 50%; background-color: ${complaint.status == 'resolved' ? '#10b981' : '#ffffff'}; border: 2px solid ${complaint.status == 'resolved' ? '#ffffff' : '#cbd5e1'}; ${complaint.status == 'resolved' ? 'box-shadow: 0 0 0 2px #10b981;' : ''}"></div>
                            <span style="font-size: 0.85rem; font-weight: 700; color: ${complaint.status == 'resolved' ? '#10b981' : '#94a3b8'}; display: block;">Resolved</span>
                            <span style="font-size: 0.75rem; color: #64748b; font-weight: 500;">Action completed & verified</span>
                        </div>
                    </div>
                </div>

                <!-- DANGER ZONE Card -->
                <c:if test="${complaint.status != 'resolved'}">
                    <div class="admin-box" style="border: 1px solid #fee2e2; background-color: #fef2f2; border-radius: 12px;">
                        <h3 style="font-size: 1.1rem; color: #991b1b; margin-bottom: 1rem; font-weight: 700; border-bottom: 1px solid #fee2e2; padding-bottom: 0.75rem; display: flex; align-items: center; gap: 8px;">
                            <i class="fas fa-exclamation-triangle" style="color: #ef4444;"></i> DANGER ZONE
                        </h3>
                        <p style="font-size: 0.8rem; color: #7f1d1d; line-height: 1.4; margin-bottom: 1.25rem;">
                            Deleting this complaint will permanently remove it from the system, database, and erase all related files from disk storage. This action cannot be undone.
                        </p>
                        <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST" onsubmit="return confirm('Are you sure you want to delete this complaint? This action cannot be undone.');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${complaint.id}">
                            <button type="submit" class="btn-danger" style="width: 100%; border-radius: 8px; padding: 10px; font-weight: 700; cursor: pointer;">
                                <i class="fas fa-trash-alt" style="margin-right: 6px;"></i> Delete Complaint
                            </button>
                        </form>
                    </div>
                </c:if>
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
