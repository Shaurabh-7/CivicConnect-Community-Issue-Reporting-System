<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CivicConnect - Community Issue Reporting System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap');
        
        :root {
            --primary: #1e3a8a;
            --primary-hover: #172554;
            --accent-red: #ef4444;
            --bg-light: #f8fafc;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --text-slate: #334155;
            --border-color: #e2e8f0;
            --font-main: 'Inter', sans-serif;
            --font-display: 'Outfit', sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: var(--font-main);
            background-color: var(--bg-light);
            color: var(--text-slate);
            line-height: 1.6;
        }

        /* 1. Header/Navbar Styles */
        .public-navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: var(--primary);
            padding: 0.75rem 4rem;
            color: white;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .nav-left {
            display: flex;
            align-items: center;
            gap: 3rem;
        }

        .nav-logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
            color: white;
            font-family: var(--font-display);
            font-size: 1.5rem;
            font-weight: 700;
        }

        .logo-box {
            background-color: #3b82f6;
            color: white;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 800;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 1.75rem;
        }

        .nav-links a {
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            transition: color 0.2s;
            text-transform: uppercase;
            font-family: var(--font-display);
        }

        .nav-links a:hover, .nav-links a.active {
            color: white;
        }

        .nav-links a.active {
            border-bottom: 2px solid white;
            padding-bottom: 4px;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .btn-nav-login {
            background: transparent;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 0.5rem 1.25rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
            font-family: var(--font-display);
        }

        .btn-nav-login:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: white;
        }

        .btn-nav-register {
            background-color: var(--accent-red);
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: background-color 0.2s;
            font-family: var(--font-display);
        }

        .btn-nav-register:hover {
            background-color: #dc2626;
        }

        /* 2. Hero Section */
        .hero-section {
            background-color: white;
            padding: 3.5rem 4rem;
            border-bottom: 1px solid var(--border-color);
        }

        .hero-container {
            max-width: 1200px;
            margin: 0 auto;
            border-left: 5px solid var(--accent-red);
            padding-left: 2rem;
        }

        .hero-title {
            font-family: var(--font-display);
            font-size: 2.75rem;
            font-weight: 800;
            color: var(--text-dark);
            line-height: 1.15;
            margin-bottom: 1rem;
        }

        .hero-subtitle {
            font-size: 1.15rem;
            color: var(--text-muted);
            max-width: 800px;
            font-weight: 400;
        }

        /* 3. Search & Filter Bar */
        .search-filter-section {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 4rem;
        }

        .search-filter-card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 0.75rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);
        }

        .search-filter-form {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .search-input-wrapper {
            position: relative;
            flex-grow: 1;
        }

        .search-input-wrapper i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 1.05rem;
        }

        .search-input {
            width: 100%;
            padding: 0.8rem 1rem 0.8rem 2.75rem;
            border: 1px solid transparent;
            background-color: #f8fafc;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: var(--font-main);
            color: var(--text-dark);
            outline: none;
            transition: all 0.2s;
        }

        .search-input:focus {
            background-color: white;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .mun-select {
            padding: 0.8rem 2rem 0.8rem 1.25rem;
            border: 1px solid transparent;
            background-color: #f8fafc;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: var(--font-main);
            color: var(--text-dark);
            outline: none;
            cursor: pointer;
            min-width: 250px;
            transition: all 0.2s;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2364748b' stroke-width='2'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' d='M19 9l-7 7-7-7'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1.15rem;
        }

        .mun-select:focus {
            background-color: white;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .btn-search-submit {
            background-color: #3b82f6;
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            font-family: var(--font-display);
        }

        .btn-search-submit:hover {
            background-color: #2563eb;
        }

        /* 4. Main Grid Container */
        .main-grid {
            max-width: 1200px;
            margin: 0 auto 4rem auto;
            padding: 0 4rem;
            display: grid;
            grid-template-columns: 2.1fr 1fr;
            gap: 2rem;
        }

        /* 5. Left Column (Feed) */
        .feed-header {
            margin-bottom: 1.5rem;
        }

        .feed-header h2 {
            font-family: var(--font-display);
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }

        .tabs-container {
            display: flex;
            border-bottom: 1px solid var(--border-color);
            gap: 2rem;
        }

        .tab-item {
            color: var(--text-muted);
            text-decoration: none;
            padding-bottom: 0.75rem;
            font-weight: 600;
            font-size: 0.9rem;
            font-family: var(--font-display);
            transition: all 0.2s;
            border-bottom: 2px solid transparent;
        }

        .tab-item:hover {
            color: var(--text-dark);
        }

        .tab-item.active {
            color: #2563eb;
            border-bottom-color: #2563eb;
        }

        /* Feed Cards */
        .complaint-card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1.5rem;
            display: flex;
            gap: 1.5rem;
            transition: all 0.2s ease;
        }

        .complaint-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.04);
            border-color: #cbd5e1;
        }

        .upvote-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background-color: #f1f5f9;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 0.75rem;
            min-width: 64px;
            height: 64px;
            text-decoration: none;
            transition: all 0.2s;
        }

        .upvote-section:hover {
            background-color: #e2e8f0;
            border-color: #cbd5e1;
            transform: scale(1.03);
        }

        .upvote-section i {
            color: #2563eb;
            font-size: 1.1rem;
            margin-bottom: 2px;
        }

        .upvote-section .vote-count {
            font-weight: 700;
            font-size: 1.15rem;
            color: var(--text-dark);
        }

        .card-body {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .card-title-link {
            font-family: var(--font-display);
            font-size: 1.15rem;
            font-weight: 700;
            color: #1e3a8a;
            text-decoration: none;
            line-height: 1.4;
            margin-bottom: 0.5rem;
            display: inline-block;
            transition: color 0.15s;
        }

        .card-title-link:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        .card-snippet {
            font-size: 0.95rem;
            color: #475569;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .card-meta {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .meta-bullet {
            color: #cbd5e1;
        }

        .meta-author-anon {
            font-style: italic;
            color: #94a3b8;
            text-transform: none;
        }

        /* Category Badging */
        .admin-cat-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .cat-road-infrastructure, .cat-road { background: #fee2e2; color: #ef4444; }
        .cat-water-supply, .cat-water { background: #dbeafe; color: #3b82f6; }
        .cat-sanitation { background: #fef3c7; color: #d97706; }
        .cat-electricity { background: #e0f2fe; color: #0284c7; }
        .cat-corruption-misconduct, .cat-corruption { background: #f3e8ff; color: #a855f7; }
        .cat-health { background: #d1fae5; color: #059669; }
        .cat-general { background: #f1f5f9; color: #475569; }

        /* Status Badges */
        .admin-status-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .admin-status-pending { background-color: #fffbeb; color: #d97706; }
        .admin-status-in_progress { background-color: #eff6ff; color: #2563eb; }
        .admin-status-resolved { background-color: #f0fdf4; color: #16a34a; }

        /* 6. Right Column (Sidebar) */
        .sidebar-grid {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .sidebar-card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
        }

        .sidebar-card-title {
            font-family: var(--font-display);
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 1.25rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.75rem;
        }

        /* Top 5 Agenda list */
        .agenda-list {
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
        }

        .agenda-item {
            display: flex;
            gap: 1rem;
            align-items: flex-start;
        }

        .agenda-number {
            font-family: var(--font-display);
            font-size: 1.1rem;
            font-weight: 700;
            color: #94a3b8;
            min-width: 20px;
        }

        .agenda-content {
            display: flex;
            flex-direction: column;
        }

        .agenda-title-link {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--text-dark);
            text-decoration: none;
            line-height: 1.35;
            transition: color 0.15s;
        }

        .agenda-title-link:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        .agenda-supports {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-muted);
            margin-top: 2px;
            letter-spacing: 0.025em;
        }

        .agenda-view-more {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            color: #2563eb;
            font-weight: 700;
            font-size: 0.85rem;
            font-family: var(--font-display);
            margin-top: 1.5rem;
            transition: color 0.2s;
        }

        .agenda-view-more:hover {
            color: var(--primary-hover);
        }

        /* Quick Stats Styles */
        .stats-list {
            display: flex;
            flex-direction: column;
        }

        .stat-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .stat-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .stat-label {
            font-size: 0.9rem;
            color: var(--text-slate);
            font-weight: 500;
        }

        .stat-val {
            font-family: var(--font-display);
            font-weight: 700;
            font-size: 1.15rem;
            color: var(--text-dark);
        }

        .stat-val.resolved-green {
            color: #16a34a;
        }

        /* CTA Box */
        .cta-card {
            background-color: white;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 1.5rem;
        }

        .cta-title {
            font-family: var(--font-display);
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.75rem;
        }

        .cta-desc {
            font-size: 0.9rem;
            color: var(--text-slate);
            margin-bottom: 1.25rem;
            line-height: 1.45;
        }

        .btn-cta-full {
            display: block;
            width: 100%;
            background-color: #2563eb;
            color: white;
            border: none;
            text-align: center;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            text-decoration: none;
            transition: background-color 0.2s;
            font-family: var(--font-display);
        }

        .btn-cta-full:hover {
            background-color: var(--primary-hover);
        }

        /* 7. Footer Styles */
        .public-footer {
            background-color: var(--primary);
            color: rgba(255, 255, 255, 0.7);
            padding: 3rem 4rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .footer-left {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .footer-logo {
            color: white;
            font-family: var(--font-display);
            font-weight: 700;
            font-size: 1.25rem;
        }

        .footer-sub {
            font-size: 0.85rem;
        }

        .footer-links {
            display: flex;
            gap: 2rem;
        }

        .footer-links a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .footer-links a:hover {
            color: white;
        }

        /* Client Pagination */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }

        .pagination-btn {
            background: white;
            border: 1px solid var(--border-color);
            color: var(--text-slate);
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.2s;
            outline: none;
        }

        .pagination-btn:hover:not(:disabled) {
            background-color: #f1f5f9;
            border-color: #cbd5e1;
            color: var(--text-dark);
        }

        .pagination-btn.active {
            background-color: #2563eb;
            border-color: #2563eb;
            color: white;
        }

        .pagination-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }
    </style>
</head>
<body>

    <!-- 1. Header/Navbar -->
    <nav class="public-navbar">
        <div class="nav-left">
            <a href="<%= request.getContextPath() %>/home" class="nav-logo">
                <div class="logo-box">CC</div>
                <span>CivicConnect</span>
            </a>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home" class="active">Home</a>
                <a href="<%= request.getContextPath() %>/about">About</a>
                <a href="<%= request.getContextPath() %>/login">Login</a>
                <a href="<%= request.getContextPath() %>/register">Register</a>
            </div>
        </div>
        <div class="nav-actions">
            <a href="<%= request.getContextPath() %>/register" class="btn-nav-register">Register</a>
            <a href="<%= request.getContextPath() %>/login" class="btn-nav-login">Login</a>
        </div>
    </nav>

    <!-- 2. Hero Section -->
    <header class="hero-section">
        <div class="hero-container">
            <h1 class="hero-title">Citizen Voice for Better Governance<br>in Your Municipality.</h1>
            <p class="hero-subtitle">A structured digital channel for citizens to report local problems directly to their municipality — roads, water, sanitation, electricity, corruption, and more.</p>
        </div>
    </header>

    <!-- 3. Search & Filter Bar -->
    <section class="search-filter-section">
        <div class="search-filter-card">
            <form action="<%= request.getContextPath() %>/home" method="GET" class="search-filter-form">
                <div class="search-input-wrapper">
                    <i class="fas fa-search"></i>
                    <input type="text" name="search" value="<c:out value="${paramSearch}" />" placeholder="Search complaints by title or description..." class="search-input">
                </div>
                <select name="municipalityId" onchange="this.form.submit()" class="mun-select">
                    <option value="">All Municipalities</option>
                    <c:forEach var="m" items="${municipalities}">
                        <option value="${m.id}" ${m.id == paramMunicipalityId ? 'selected' : ''}><c:out value="${m.name}" /></option>
                    </c:forEach>
                </select>
                <input type="hidden" name="tab" value="<c:out value="${activeTab}" />">
                <button type="submit" class="btn-search-submit">Search</button>
            </form>
        </div>
    </section>

    <!-- 4. Main Grid Content -->
    <main class="main-grid">
        
        <!-- Left Column: Feed -->
        <section class="feed-column">
            <div class="feed-header">
                <h2>Citizen Issues Feed</h2>
                <div class="tabs-container">
                    <a href="?tab=latest&search=<c:out value="${paramSearch}"/>&municipalityId=<c:out value="${paramMunicipalityId}"/>" class="tab-item ${activeTab == 'latest' ? 'active' : ''}">LATEST SUBMISSIONS</a>
                    <a href="?tab=trending&search=<c:out value="${paramSearch}"/>&municipalityId=<c:out value="${paramMunicipalityId}"/>" class="tab-item ${activeTab == 'trending' ? 'active' : ''}">TRENDING</a>
                </div>
            </div>

            <div id="feed-container">
                <c:choose>
                    <c:when test="${empty complaints}">
                        <div class="complaint-card" style="justify-content: center; padding: 4rem; color: var(--text-muted); font-weight: 500;">
                            No issues match your filter criteria at the moment.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${complaints}">
                            <article class="complaint-card feed-row">
                                <!-- Upvote Box -->
                                <a href="<%= request.getContextPath() %>/login" class="upvote-section" title="Log in to support this issue">
                                    <i class="fas fa-caret-up"></i>
                                    <span class="vote-count"><c:out value="${c.voteCount}" /></span>
                                </a>
                                
                                <div class="card-body">
                                    <div>
                                        <a href="<%= request.getContextPath() %>/citizen/view-complaint?id=${c.id}" class="card-title-link">
                                            <c:out value="${c.title}" />
                                        </a>
                                        <p class="card-snippet"><c:out value="${c.description}" /></p>
                                    </div>
                                    <div class="card-meta">
                                        <c:choose>
                                            <c:when test="${c.anonymous}">
                                                <span class="meta-author-anon">Anonymous</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span><c:out value="${c.userName}" /></span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="meta-bullet">•</span>
                                        <span class="admin-cat-badge cat-${fn:replace(fn:toLowerCase(c.categoryName), '/', '-')}"><c:out value="${c.categoryName}" /></span>
                                        <span class="meta-bullet">•</span>
                                        <span><c:out value="${c.municipalityName}" /></span>
                                        <span class="meta-bullet">•</span>
                                        <span>Ward <c:out value="${c.wardNumber}" /></span>
                                        <span class="meta-bullet">•</span>
                                        <span class="admin-status-badge admin-status-${fn:toLowerCase(c.status)}">
                                            <c:choose>
                                                <c:when test="${c.status == 'pending'}">PENDING</c:when>
                                                <c:when test="${c.status == 'in_progress'}">IN PROGRESS</c:when>
                                                <c:when test="${c.status == 'resolved'}">RESOLVED</c:when>
                                                <c:otherwise><c:out value="${fn:toUpperCase(c.status)}" /></c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="meta-bullet">•</span>
                                        <span>Posted <c:out value="${c.formattedCreatedAt}" /></span>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Zero-Refresh Pagination Controls -->
            <div id="pagination-controls" class="pagination-container"></div>
        </section>

        <!-- Right Column: Sidebar -->
        <aside class="sidebar-column">
            <div class="sidebar-grid">
                
                <!-- Card 1: Public Agenda -->
                <div class="sidebar-card">
                    <h3 class="sidebar-card-title">Public Agenda — Most Supported</h3>
                    <div class="agenda-list">
                        <c:choose>
                            <c:when test="${empty topSupported}">
                                <div style="color: var(--text-muted); font-size: 0.9rem;">No supported complaints yet.</div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="tc" items="${topSupported}" varStatus="loop">
                                    <div class="agenda-item">
                                        <span class="agenda-number">0${loop.index + 1}</span>
                                        <div class="agenda-content">
                                            <a href="<%= request.getContextPath() %>/citizen/view-complaint?id=${tc.id}" class="agenda-title-link">
                                                <c:out value="${tc.title}" />
                                            </a>
                                            <span class="agenda-supports"><c:out value="${tc.voteCount}" /> SUPPORTS</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <a href="<%= request.getContextPath() %>/login" class="agenda-view-more">VIEW FULL AGENDA RECORD →</a>
                </div>

                <!-- Card 2: Quick Stats -->
                <div class="sidebar-card">
                    <h3 class="sidebar-card-title">Quick Stats</h3>
                    <div class="stats-list">
                        <div class="stat-item">
                            <span class="stat-label">Active Municipalities</span>
                            <span class="stat-val"><c:out value="${activeMunicipalitiesCount}" /></span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Total Complaints</span>
                            <span class="stat-val"><fmt:formatNumber value="${totalComplaintsCount}" /></span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Resolved Issues</span>
                            <span class="stat-val resolved-green"><fmt:formatNumber value="${resolvedCount}" /></span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-label">Registered Citizens</span>
                            <span class="stat-val"><fmt:formatNumber value="${totalCitizens}" /></span>
                        </div>
                    </div>
                </div>

                <!-- Card 3: CTA Box -->
                <div class="cta-card">
                    <h3 class="cta-title">Have an Issue?</h3>
                    <p class="cta-desc">Register as a citizen and submit your complaint directly to your municipality admin.</p>
                    <a href="<%= request.getContextPath() %>/register" class="btn-cta-full">Register Now</a>
                </div>

            </div>
        </aside>

    </main>

    <!-- 5. Footer -->
    <footer class="public-footer">
        <div class="footer-container">
            <div class="footer-left">
                <span class="footer-logo">CivicConnect</span>
                <span class="footer-sub">Municipality-Level Civic Issue Reporting · Nepal</span>
            </div>
            <div class="footer-links">
                <a href="<%= request.getContextPath() %>/about">About</a>
                <a href="#">Privacy</a>
                <a href="#">Contact</a>
            </div>
        </div>
    </footer>

    <!-- Zero-Refresh Pagination Script -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const rows = document.querySelectorAll(".feed-row");
            const totalRows = rows.length;
            const rowsPerPage = 5; // Clean sizing of 5 cards per page
            const totalPages = Math.ceil(totalRows / rowsPerPage);
            const controlsContainer = document.getElementById("pagination-controls");
            let currentPage = 1;

            if (totalRows <= rowsPerPage) {
                controlsContainer.style.display = "none";
                return;
            }

            function showPage(page) {
                if (page < 1 || page > totalPages) return;
                currentPage = page;
                const start = (page - 1) * rowsPerPage;
                const end = Math.min(start + rowsPerPage, totalRows);

                rows.forEach((row, index) => {
                    if (index >= start && index < end) {
                        row.style.display = "flex";
                    } else {
                        row.style.display = "none";
                    }
                });

                renderControls();
                window.scrollTo({ top: document.querySelector('.search-filter-section').offsetTop - 20, behavior: 'smooth' });
            }

            function renderControls() {
                controlsContainer.innerHTML = "";

                // Previous Button
                const prevBtn = document.createElement("button");
                prevBtn.className = "pagination-btn";
                prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
                prevBtn.disabled = currentPage === 1;
                prevBtn.addEventListener("click", () => showPage(currentPage - 1));
                controlsContainer.appendChild(prevBtn);

                // Page Number Buttons
                for (let i = 1; i <= totalPages; i++) {
                    const btn = document.createElement("button");
                    btn.className = "pagination-btn" + (i === currentPage ? " active" : "");
                    btn.textContent = i;
                    btn.addEventListener("click", () => showPage(i));
                    controlsContainer.appendChild(btn);
                }

                // Next Button
                const nextBtn = document.createElement("button");
                nextBtn.className = "pagination-btn";
                nextBtn.innerHTML = '<i class="fas fa-chevron-right"></i>';
                nextBtn.disabled = currentPage === totalPages;
                nextBtn.addEventListener("click", () => showPage(currentPage + 1));
                controlsContainer.appendChild(nextBtn);
            }

            // Init first page
            showPage(1);
        });
    </script>
</body>
</html>