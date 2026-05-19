<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Complaints - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="admin-main-content">
        <div class="admin-page-header">
            <h1>Manage Complaints</h1>
            <p>Admin Control Panel &middot; <c:out value="${sessionScope.municipalityDistrict}" /> District, <c:out value="${sessionScope.municipalityProvince}" /></p>
        </div>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success" style="margin-bottom: 2rem;">
                <c:out value="${param.success}" />
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" style="margin-bottom: 2rem;">
                <c:out value="${param.error}" />
            </div>
        </c:if>

        <!-- Horizontal Filter Bar Card -->
        <section class="admin-filter-section">
            <form action="<%= request.getContextPath() %>/admin/manage-complaints" method="GET" class="admin-filter-form">
                <input type="text" name="search" placeholder="Search title or description..." value="<c:out value='${paramSearch}'/>">
                
                <select name="categoryId">
                    <option value="">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${paramCategoryId == cat.id ? 'selected' : ''}>
                            <c:out value="${cat.name}" />
                        </option>
                    </c:forEach>
                </select>

                <input type="number" name="wardNumber" placeholder="Ward Number" min="1" max="33" value="<c:out value='${paramWard}'/>">

                <select name="status">
                    <option value="">All Statuses</option>
                    <option value="pending" ${paramStatus == 'pending' ? 'selected' : ''}>Pending</option>
                    <option value="in_progress" ${paramStatus == 'in_progress' ? 'selected' : ''}>In Progress</option>
                    <option value="resolved" ${paramStatus == 'resolved' ? 'selected' : ''}>Resolved</option>
                </select>
                
                <select name="sortBy">
                    <option value="date_desc" ${paramSortBy == 'date_desc' ? 'selected' : ''}>Newest First</option>
                    <option value="date_asc" ${paramSortBy == 'date_asc' ? 'selected' : ''}>Oldest First</option>
                    <option value="votes_desc" ${paramSortBy == 'votes_desc' ? 'selected' : ''}>Most Supported</option>
                    <option value="votes_asc" ${paramSortBy == 'votes_asc' ? 'selected' : ''}>Least Supported</option>
                </select>

                <button type="submit" class="btn-filter-submit"><i class="fas fa-filter" style="margin-right: 6px;"></i>Filter</button>
                <a href="<%= request.getContextPath() %>/admin/manage-complaints" class="btn-filter-clear"><i class="fas fa-undo" style="margin-right: 6px;"></i>Clear</a>
            </form>
        </section>

        <!-- Complaints List Container -->
        <section class="list-container content-card" style="margin-top: 1.5rem;">
            <c:choose>
                <c:when test="${empty complaints}">
                    <div style="text-align: center; padding: 4rem 2rem; color: #64748b;">
                        <i class="fas fa-folder-open" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 1rem;"></i>
                        <p style="font-size: 1rem; font-weight: 500;">No complaints found matching your criteria.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Submitted By</th>
                                    <th>Category</th>
                                    <th>Ward</th>
                                    <th>Status</th>
                                    <th>Votes</th>
                                    <th>Date Submitted</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="complaint" items="${complaints}">
                                    <tr>
                                        <td style="color: #94a3b8; font-weight: 500;">
                                            #<fmt:formatNumber value="${complaint.id}" minIntegerDigits="2" />
                                        </td>
                                        <td>
                                            <a href="<%= request.getContextPath() %>/admin/complaint-detail?id=${complaint.id}" class="admin-table-title-link">
                                                <c:out value="${complaint.title}" />
                                            </a>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${complaint.anonymous}">
                                                    <span style="color: #94a3b8; font-style: italic;">Anonymous</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${complaint.userName}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="admin-cat-badge cat-${fn:toLowerCase(complaint.categoryName)}">
                                                <c:out value="${complaint.categoryName}" />
                                            </span>
                                        </td>
                                        <td><c:out value="${complaint.wardNumber}" /></td>
                                        <td>
                                            <span class="admin-status-badge admin-status-${fn:toLowerCase(complaint.status)}">
                                                <c:choose>
                                                    <c:when test="${complaint.status == 'pending'}">PENDING</c:when>
                                                    <c:when test="${complaint.status == 'in_progress'}">IN PROGRESS</c:when>
                                                    <c:when test="${complaint.status == 'resolved'}">RESOLVED</c:when>
                                                    <c:otherwise><c:out value="${fn:toUpperCase(complaint.status)}" /></c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td style="font-weight: 700; color: #2563eb;"><c:out value="${complaint.voteCount}" /></td>
                                        <td><c:out value="${complaint.formattedCreatedAt}" /></td>
                                        <td>
                                            <div style="display: flex; flex-direction: column; gap: 6px; align-items: stretch; max-width: 150px;">
                                                <div style="display: flex; gap: 6px;">
                                                    <a href="<%= request.getContextPath() %>/admin/complaint-detail?id=${complaint.id}" class="btn-view-outline" style="flex: 1; justify-content: center; padding: 4px 8px; font-size: 0.75rem;">View</a>
                                                    
                                                    <c:choose>
                                                        <c:when test="${complaint.status == 'pending'}">
                                                            <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST" style="margin:0; display:flex; flex: 1;">
                                                                <input type="hidden" name="action" value="updateStatus">
                                                                <input type="hidden" name="id" value="${complaint.id}">
                                                                <input type="hidden" name="status" value="in_progress">
                                                                <button type="submit" class="btn-action-transition" style="padding: 4px 8px; width: 100%; justify-content: center; font-size: 0.75rem;" title="Move to In Progress">→ Progress</button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${complaint.status == 'in_progress'}">
                                                            <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST" style="margin:0; display:flex; flex: 1;">
                                                                <input type="hidden" name="action" value="updateStatus">
                                                                <input type="hidden" name="id" value="${complaint.id}">
                                                                <input type="hidden" name="status" value="resolved">
                                                                <button type="submit" class="btn-action-resolve" style="padding: 4px 8px; width: 100%; justify-content: center; font-size: 0.75rem;" title="Move to Resolved">✓ Resolve</button>
                                                            </form>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                                
                                                <c:if test="${complaint.status != 'resolved'}">
                                                    <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete this complaint? This cannot be undone.');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${complaint.id}">
                                                        <button type="submit" class="btn-danger" style="width: 100%; padding: 4px 8px; font-size: 0.75rem; border-radius: 6px;">Delete</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Client-Side Pagination Script -->
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const rowsPerPage = 10;
                const tableBody = document.querySelector(".data-table tbody");
                if (!tableBody) return;
                
                const rows = Array.from(tableBody.querySelectorAll("tr"));
                const totalRows = rows.length;
                if (totalRows === 0) return;
                
                let currentPage = 1;
                const totalPages = Math.ceil(totalRows / rowsPerPage);
                
                // Create pagination container
                const listContainer = document.querySelector(".list-container");
                const paginationContainer = document.createElement("div");
                paginationContainer.className = "pagination-container";
                
                const infoDiv = document.createElement("div");
                infoDiv.className = "pagination-info";
                
                const buttonsDiv = document.createElement("div");
                buttonsDiv.className = "pagination-buttons";
                
                paginationContainer.appendChild(infoDiv);
                paginationContainer.appendChild(buttonsDiv);
                listContainer.appendChild(paginationContainer);
                
                function showPage(page) {
                    currentPage = page;
                    const start = (page - 1) * rowsPerPage;
                    const end = Math.min(start + rowsPerPage, totalRows);
                    
                    rows.forEach((row, index) => {
                        if (index >= start && index < end) {
                            row.style.display = "";
                        } else {
                            row.style.display = "none";
                        }
                    });
                    
                    infoDiv.textContent = `Showing ${start + 1} to ${end} of ${totalRows} complaints`;
                    renderButtons();
                }
                
                function renderButtons() {
                    buttonsDiv.innerHTML = "";
                    
                    // Previous button
                    const prevBtn = document.createElement("button");
                    prevBtn.className = "pagination-btn";
                    prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
                    prevBtn.disabled = currentPage === 1;
                    prevBtn.addEventListener("click", () => showPage(currentPage - 1));
                    buttonsDiv.appendChild(prevBtn);
                    
                    // Page numbers
                    for (let i = 1; i <= totalPages; i++) {
                        const pageBtn = document.createElement("button");
                        pageBtn.className = "pagination-btn" + (i === currentPage ? " active" : "");
                        pageBtn.textContent = i;
                        pageBtn.addEventListener("click", () => showPage(i));
                        buttonsDiv.appendChild(pageBtn);
                    }
                    
                    // Next button
                    const nextBtn = document.createElement("button");
                    nextBtn.className = "pagination-btn";
                    nextBtn.innerHTML = '<i class="fas fa-chevron-right"></i>';
                    nextBtn.disabled = currentPage === totalPages;
                    nextBtn.addEventListener("click", () => showPage(currentPage + 1));
                    buttonsDiv.appendChild(nextBtn);
                }
                
                showPage(1);
            });
        </script>
    </main>>

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
