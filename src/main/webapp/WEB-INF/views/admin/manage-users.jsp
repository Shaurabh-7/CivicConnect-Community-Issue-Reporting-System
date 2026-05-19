<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="admin-main-content">
        <div class="admin-page-header">
            <h1>Manage Users</h1>
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
            <form action="<%= request.getContextPath() %>/admin/manage-users" method="GET" class="admin-filter-form" style="display: flex; gap: 12px; width: 100%;">
                <input type="text" name="search" placeholder="Search by name, email, or phone..." value="<c:out value='${paramSearch}'/>" style="flex: 1;">
                <button type="submit" class="btn-filter-submit"><i class="fas fa-search" style="margin-right: 6px;"></i>Search</button>
                <a href="<%= request.getContextPath() %>/admin/manage-users" class="btn-filter-clear"><i class="fas fa-undo" style="margin-right: 6px;"></i>Clear</a>
            </form>
        </section>

        <!-- Users List Container -->
        <section class="list-container content-card" style="margin-top: 1.5rem;">
            <c:choose>
                <c:when test="${empty citizens}">
                    <div style="text-align: center; padding: 4rem 2rem; color: #64748b;">
                        <i class="fas fa-users-slash" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 1rem;"></i>
                        <p style="font-size: 1rem; font-weight: 500;">No citizens found.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Ward</th>
                                    <th>Status</th>
                                    <th>Date Registered</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${citizens}">
                                    <tr>
                                        <td style="color: #94a3b8; font-weight: 500;">
                                            #<fmt:formatNumber value="${user.id}" minIntegerDigits="2" />
                                        </td>
                                        <td style="font-weight: 700; color: #1e293b;">
                                            <c:out value="${user.fullName}" />
                                        </td>
                                        <td>
                                            <a href="mailto:${user.email}" style="color: #2563eb; text-decoration: none; font-weight: 500;"><c:out value="${user.email}" /></a>
                                        </td>
                                        <td style="color: #475569; font-weight: 500;"><c:out value="${user.phone}" /></td>
                                        <td style="font-weight: 600;">Ward <c:out value="${user.wardNumber}" /></td>
                                        <td>
                                            <span class="admin-status-badge admin-status-${user.status == 'active' ? 'resolved' : 'pending'}">
                                                <c:out value="${user.status == 'active' ? 'ACTIVE' : 'INACTIVE'}" />
                                            </span>
                                        </td>
                                        <td style="color: #64748b; font-size: 0.875rem;"><c:out value="${user.formattedCreatedAt}" /></td>
                                        <td>
                                            <form action="<%= request.getContextPath() %>/admin/manage-users" method="POST" style="margin: 0; display: inline-block; width: 100%; max-width: 120px;">
                                                <input type="hidden" name="userId" value="${user.id}">
                                                <c:choose>
                                                    <c:when test="${user.status == 'active'}">
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <button type="submit" class="btn-danger" style="width: 100%; padding: 6px 12px; font-size: 0.75rem; border-radius: 6px;" onclick="return confirm('Are you sure you want to deactivate this user?');">
                                                            <i class="fas fa-user-slash" style="margin-right: 4px;"></i> Deactivate
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="action" value="activate">
                                                        <button type="submit" class="btn-action-resolve" style="width: 100%; padding: 6px 12px; font-size: 0.75rem; border-radius: 6px;">
                                                            <i class="fas fa-user-check" style="margin-right: 4px;"></i> Activate
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
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
                    
                    infoDiv.textContent = `Showing ${start + 1} to ${end} of ${totalRows} users`;
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
