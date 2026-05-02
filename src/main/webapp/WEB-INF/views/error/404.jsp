<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Not Found - CivicConnect</title>
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
            color: var(--primary-color);
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
        <div class="error-code">404</div>
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-message">Oops! The page you are looking for doesn't exist or has been moved.</p>
        <a href="<%= request.getContextPath() %>/home" class="btn-primary" style="text-decoration: none; width: auto; padding: 0.75rem 2rem;">Back to Home</a>
    </div>
</body>
</html>
