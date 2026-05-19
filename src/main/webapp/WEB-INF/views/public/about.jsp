<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About - CivicConnect</title>
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

        /* 2. Main Page Layout */
        .page-container {
            max-width: 900px;
            margin: 3rem auto 6rem auto;
            padding: 0 2rem;
            display: flex;
            flex-direction: column;
            gap: 2.5rem;
        }

        /* Hero Header Details */
        .about-hero {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .about-hero-logo {
            background-color: #2563eb;
            color: white;
            width: 64px;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            font-size: 1.8rem;
            font-weight: 800;
            font-family: var(--font-display);
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.2);
        }

        .about-hero-text h1 {
            font-family: var(--font-display);
            font-size: 2.25rem;
            color: var(--text-dark);
            font-weight: 800;
            line-height: 1.1;
        }

        .about-hero-text p {
            color: var(--text-muted);
            font-size: 0.95rem;
            font-weight: 500;
            margin-top: 2px;
        }

        .about-intro-box {
            background: white;
            border-left: 5px solid var(--accent-red);
            padding: 1.5rem 2rem;
            border-radius: 4px 12px 12px 4px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.01);
            border-top: 1px solid var(--border-color);
            border-right: 1px solid var(--border-color);
            border-bottom: 1px solid var(--border-color);
        }

        .about-intro-box p {
            font-size: 1.15rem;
            color: var(--text-slate);
            line-height: 1.6;
        }

        /* 3. Section Cards */
        .section-card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02);
        }

        .section-title {
            font-family: var(--font-display);
            font-size: 1.35rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 2rem;
            position: relative;
        }

        /* Feature Grid Styles */
        .feature-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2.5rem 2rem;
        }

        .feature-item {
            display: flex;
            gap: 1.25rem;
            align-items: flex-start;
        }

        .feature-icon-wrapper {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 1.15rem;
        }

        .icon-pink { background-color: #fdf2f8; color: #db2777; }
        .icon-blue { background-color: #f0fdf4; color: #16a34a; }
        .icon-slate { background-color: #f1f5f9; color: #475569; }
        .icon-green { background-color: #eff6ff; color: #2563eb; }

        .feature-content h4 {
            font-family: var(--font-display);
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.35rem;
        }

        .feature-content p {
            font-size: 0.9rem;
            color: var(--text-muted);
            line-height: 1.45;
        }

        /* 4. Timeline Styles */
        .timeline-list {
            display: flex;
            flex-direction: column;
            gap: 1.75rem;
        }

        .timeline-item {
            display: flex;
            gap: 1.25rem;
            align-items: flex-start;
        }

        .timeline-number {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.95rem;
            font-family: var(--font-display);
            flex-shrink: 0;
        }

        .num-blue { background-color: #dbeafe; color: #1d4ed8; }
        .num-green { background-color: #d1fae5; color: #065f46; }

        .timeline-content h4 {
            font-family: var(--font-display);
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
        }

        .timeline-content p {
            font-size: 0.9rem;
            color: var(--text-muted);
            line-height: 1.45;
        }

        /* 5. Neutrality Alert Styles */
        .neutrality-box {
            background-color: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 16px;
            padding: 2rem 2.5rem;
            display: flex;
            gap: 1.5rem;
            align-items: flex-start;
        }

        .neutrality-icon-wrapper {
            background-color: #dbeafe;
            color: #1d4ed8;
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .neutrality-content h4 {
            font-family: var(--font-display);
            font-size: 1.05rem;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 0.5rem;
        }

        .neutrality-content p {
            font-size: 0.92rem;
            color: #1e40af;
            line-height: 1.5;
        }

        /* 6. Roles Box Styles */
        .roles-list {
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
        }

        .role-panel {
            border: 1px solid transparent;
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
            display: flex;
            gap: 1.25rem;
            align-items: flex-start;
        }

        .panel-guest { background-color: #f8fafc; border-color: #cbd5e1; }
        .panel-citizen { background-color: #faf5ff; border-color: #e9d5ff; }
        .panel-admin { background-color: #f0fdf4; border-color: #bbf7d0; }
        .panel-super { background-color: #fff7ed; border-color: #fed7aa; }

        .role-icon-box {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        .r-guest { background-color: #f1f5f9; color: #475569; }
        .r-citizen { background-color: #f3e8ff; color: #7e22ce; }
        .r-admin { background-color: #d1fae5; color: #047857; }
        .r-super { background-color: #ffedd5; color: #c2410c; }

        .role-body h4 {
            font-family: var(--font-display);
            font-size: 0.95rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }

        .role-body p {
            font-size: 0.88rem;
            color: var(--text-slate);
            line-height: 1.45;
        }

        .role-body.text-guest h4 { color: #475569; }
        .role-body.text-citizen h4 { color: #7e22ce; }
        .role-body.text-admin h4 { color: #047857; }
        .role-body.text-super h4 { color: #c2410c; }

        /* 7. Bottom CTA */
        .bottom-cta {
            text-align: center;
            padding: 3rem 0;
        }

        .bottom-cta h2 {
            font-family: var(--font-display);
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .bottom-cta p {
            color: var(--text-muted);
            font-size: 0.95rem;
            margin-bottom: 1.75rem;
        }

        .cta-btn-group {
            display: flex;
            justify-content: center;
            gap: 1rem;
            align-items: center;
        }

        .btn-cta-blue {
            background-color: #2563eb;
            color: white;
            padding: 0.75rem 1.75rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: background-color 0.2s;
            font-family: var(--font-display);
            box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
        }

        .btn-cta-blue:hover {
            background-color: var(--primary-hover);
        }

        .btn-cta-outline {
            border: 1px solid #cbd5e1;
            background-color: white;
            color: var(--text-slate);
            padding: 0.75rem 1.75rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.2s;
            font-family: var(--font-display);
        }

        .btn-cta-outline:hover {
            background-color: #f8fafc;
            border-color: #94a3b8;
            color: var(--text-dark);
        }

        /* 8. Footer Styles */
        .public-footer {
            background-color: var(--primary);
            color: rgba(255, 255, 255, 0.7);
            padding: 3rem 4rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .footer-container {
            max-width: 900px;
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
                <a href="<%= request.getContextPath() %>/home">Home</a>
                <a href="<%= request.getContextPath() %>/about" class="active">About</a>
                <a href="<%= request.getContextPath() %>/login">Login</a>
                <a href="<%= request.getContextPath() %>/register">Register</a>
            </div>
        </div>
        <div class="nav-actions">
            <a href="<%= request.getContextPath() %>/register" class="btn-nav-register">Register</a>
            <a href="<%= request.getContextPath() %>/login" class="btn-nav-login">Login</a>
        </div>
    </nav>

    <!-- 2. Main Page Container -->
    <div class="page-container">
        
        <!-- Hero Details Section -->
        <header>
            <div class="about-hero">
                <div class="about-hero-logo">CC</div>
                <div class="about-hero-text">
                    <h1>About CivicConnect</h1>
                    <p>Municipality-Level Civic Issue Reporting Platform</p>
                </div>
            </div>
            
            <div class="about-intro-box">
                <p>CivicConnect is a web-based civic issue reporting platform built for municipalities in Nepal. It provides a structured digital channel through which citizens can report local problems directly to the authority responsible for resolving them — their municipality admin.</p>
            </div>
        </header>

        <!-- Section 1: What CivicConnect Does -->
        <section class="section-card">
            <h3 class="section-title">What CivicConnect Does</h3>
            
            <div class="feature-grid">
                
                <!-- Citizens Report Issues -->
                <div class="feature-item">
                    <div class="feature-icon-wrapper icon-pink">
                        <i class="fas fa-bullhorn"></i>
                    </div>
                    <div class="feature-content">
                        <h4>Citizens Report Issues</h4>
                        <p>Any registered citizen can submit a complaint — road damage, water supply, sanitation, electricity, health, education, corruption, and more.</p>
                    </div>
                </div>

                <!-- Admins Take Action -->
                <div class="feature-item">
                    <div class="feature-icon-wrapper icon-slate">
                        <i class="fas fa-landmark"></i>
                    </div>
                    <div class="feature-content">
                        <h4>Admins Take Action</h4>
                        <p>Each municipality has a dedicated admin who reviews complaints, updates their status, and ensures accountability at the local level.</p>
                    </div>
                </div>

                <!-- Community Voting -->
                <div class="feature-item">
                    <div class="feature-icon-wrapper icon-slate">
                        <i class="fas fa-box-archive"></i>
                    </div>
                    <div class="feature-content">
                        <h4>Community Voting</h4>
                        <p>Citizens can support any complaint from any municipality — giving the most pressing issues national visibility and democratic weight.</p>
                    </div>
                </div>

                <!-- Transparent Resolution -->
                <div class="feature-item">
                    <div class="feature-icon-wrapper icon-blue">
                        <i class="fas fa-square-check"></i>
                    </div>
                    <div class="feature-content">
                        <h4>Transparent Resolution</h4>
                        <p>Every complaint is publicly visible from the moment it's submitted. Status updates (Pending → In Progress → Resolved) are shown in real time.</p>
                    </div>
                </div>

            </div>
        </section>

        <!-- Section 2: How It Works -->
        <section class="section-card">
            <h3 class="section-title">How It Works</h3>
            
            <div class="timeline-list">
                
                <!-- 1 -->
                <div class="timeline-item">
                    <div class="timeline-number num-blue">1</div>
                    <div class="timeline-content">
                        <h4>Register as a Citizen</h4>
                        <p>Select your municipality and ward, provide your details, and create your account. Registration is instant and requires no admin approval.</p>
                    </div>
                </div>

                <!-- 2 -->
                <div class="timeline-item">
                    <div class="timeline-number num-blue">2</div>
                    <div class="timeline-content">
                        <h4>Submit Your Complaint</h4>
                        <p>Describe the issue, select a category, specify the ward and location, and optionally attach a photo. You can submit anonymously if preferred.</p>
                    </div>
                </div>

                <!-- 3 -->
                <div class="timeline-item">
                    <div class="timeline-number num-blue">3</div>
                    <div class="timeline-content">
                        <h4>Goes Public Immediately</h4>
                        <p>Your complaint appears on the public home page instantly — no approval queue. Other citizens across Nepal can view and support it.</p>
                    </div>
                </div>

                <!-- 4 -->
                <div class="timeline-item">
                    <div class="timeline-number num-blue">4</div>
                    <div class="timeline-content">
                        <h4>Admin Reviews & Acts</h4>
                        <p>Your municipality admin sees the complaint on their dashboard and updates the status as work progresses — from Pending to In Progress.</p>
                    </div>
                </div>

                <!-- 5 -->
                <div class="timeline-item">
                    <div class="timeline-number num-green">5</div>
                    <div class="timeline-content">
                        <h4>Issue Resolved</h4>
                        <p>Once resolved, the status is updated to Resolved — publicly visible to all. The complaint remains in the archive for transparency.</p>
                    </div>
                </div>

            </div>
        </section>

        <!-- Section 3: Political Neutrality -->
        <section class="neutrality-box">
            <div class="neutrality-icon-wrapper">
                <i class="fas fa-balance-scale"></i>
            </div>
            <div class="neutrality-content">
                <h4>Political Neutrality</h4>
                <p>CivicConnect is a strictly non-partisan platform. It does not endorse, support, or oppose any political party, candidate, or ideology. The platform exists solely to improve civic accountability at the municipality level. All complaints are treated equally regardless of the political affiliation of the submitter or the municipality administration.</p>
            </div>
        </section>

        <!-- Section 4: Platform Roles -->
        <section class="section-card">
            <h3 class="section-title">Platform Roles</h3>
            
            <div class="roles-list">
                
                <!-- Guest -->
                <div class="role-panel panel-guest">
                    <div class="role-icon-box r-guest">
                        <i class="fas fa-eye"></i>
                    </div>
                    <div class="role-body text-guest">
                        <h4>Guest</h4>
                        <p>Can browse all public complaints, search, filter by municipality, and view complaint details. No account needed.</p>
                    </div>
                </div>

                <!-- Citizen -->
                <div class="role-panel panel-citizen">
                    <div class="role-icon-box r-citizen">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="role-body text-citizen">
                        <h4>Citizen</h4>
                        <p>Registered users tied to one municipality. Can submit, edit (if Pending), and delete own complaints, and vote on any complaint across any municipality.</p>
                    </div>
                </div>

                <!-- Municipality Admin -->
                <div class="role-panel panel-admin">
                    <div class="role-icon-box r-admin">
                        <i class="fas fa-landmark"></i>
                    </div>
                    <div class="role-body text-admin">
                        <h4>Municipality Admin</h4>
                        <p>Assigned to one municipality. Manages complaints (view, status update, delete), manages citizens (activate/deactivate), and views analytics reports.</p>
                    </div>
                </div>

                <!-- Super Admin -->
                <div class="role-panel panel-super">
                    <div class="role-icon-box r-super">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <div class="role-body text-super">
                        <h4>Super Admin</h4>
                        <p>Platform-wide administrator. Manages municipalities, assigns municipality admins (strict 1:1), and manages complaint categories.</p>
                    </div>
                </div>

            </div>
        </section>

        <!-- Section 5: Bottom CTA -->
        <section class="bottom-cta">
            <h2>Ready to make your municipality better?</h2>
            <p>Register for free and report your first civic issue today.</p>
            <div class="cta-btn-group">
                <a href="<%= request.getContextPath() %>/register" class="btn-cta-blue">Register as Citizen</a>
                <a href="<%= request.getContextPath() %>/home" class="btn-cta-outline">Browse Issues</a>
            </div>
        </section>

    </div>

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

</body>
</html>
