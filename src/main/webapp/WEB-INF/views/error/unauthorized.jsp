<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 Unauthorized - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <style>
        .error-container {
            min-height: 80vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 2rem;
        }
        .error-code {
            font-size: 8rem;
            font-weight: 800;
            color: #f59e0b; /* Amber for unauthorized */
            line-height: 1;
            margin-bottom: 1rem;
        }
        .error-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .error-message {
            color: var(--text-muted);
            max-width: 500px;
            margin-bottom: 2.5rem;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-logo">
            <div class="logo-box">CC</div>
            <span>CivicConnect</span>
        </div>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/home">Home</a>
        </div>
    </nav>

    <div class="error-container">
        <div class="error-code">403</div>
        <h1 class="error-title">Unauthorized Access</h1>
        <p class="error-message">You do not have permission to access this page. Please log in with an authorized account or return to the home page.</p>
        <div style="display: flex; gap: 1rem;">
            <a href="<%= request.getContextPath() %>/login" class="btn-primary" style="text-decoration: none; width: auto; padding: 0.75rem 2rem;">Log In</a>
            <a href="<%= request.getContextPath() %>/home" class="btn-outline" style="text-decoration: none; width: auto; padding: 0.75rem 2rem;">Back to Home</a>
        </div>
    </div>
</body>
</html>
