<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home - CivicConnect</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    </head>

    <body>
        <nav class="navbar">
            <div class="nav-logo">
                <div class="logo-box">CC</div>
                <span>CivicConnect</span>
            </div>
            <div class="nav-links">
                <a href="<%= request.getContextPath() %>/home" class="active">Home</a>
                <a href="<%= request.getContextPath() %>/WEB-INF/views/public/about.jsp">About</a>
                <a href="<%= request.getContextPath() %>/login">Login</a>
                <a href="<%= request.getContextPath() %>/register" class="btn-nav">Register</a>
            </div>
        </nav>

        <div style="padding: 2rem; text-align: center;">
            <h1 style="font-size: 2.5rem; margin-bottom: 1rem;">Citizen Voice for Better Governance</h1>
            <p style="color: var(--text-muted); font-size: 1.2rem; max-width: 800px; margin: 0 auto;">
                Report issues in your municipality and track their resolution in real-time.
            </p>

            <div style="margin-top: 3rem; display: flex; justify-content: center; gap: 1rem;">
                <a href="<%= request.getContextPath() %>/login" class="btn-primary"
                    style="text-decoration: none; width: auto; padding: 0.75rem 2rem;">Get Started</a>
                <a href="<%= request.getContextPath() %>/register" class="btn-outline"
                    style="text-decoration: none; width: auto; padding: 0.75rem 2rem;">Create Account</a>
            </div>
        </div>

        <div style="padding: 2rem; text-align: center;">
            <h1 style="font-size: 2.5rem; margin-bottom: 1rem;">Here are all the pages for just testing the page preview
            </h1>
            <a href="<%= request.getContextPath() %>/public/home.jsp">Home</a>
            <a href="<%= request.getContextPath() %>/public/about.jsp">About</a>
            <a href="<%= request.getContextPath() %>/public/login.jsp">Login</a>
            <a href="<%= request.getContextPath() %>/public/register.jsp">Register</a>
            <a href="<%= request.getContextPath() %>/error/404.jsp">404</a>
            <a href="<%= request.getContextPath() %>/error/500.jsp">500</a>
            <a href="<%= request.getContextPath() %>/error/unauthorized.jsp">403</a>
        </div>
    </body>
    </html>