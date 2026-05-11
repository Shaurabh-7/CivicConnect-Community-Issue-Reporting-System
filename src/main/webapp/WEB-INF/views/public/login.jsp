<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie" %>

<% String rememberedEmail = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie :
                cookies) {
            if ("rememberedEmail".equals(cookie.getName())) {
                rememberedEmail = cookie.getValue();
                break;
            }
        }
    }

    String retainEmail = (String) request.getAttribute("retainEmail");
    if (retainEmail == null)
        retainEmail = rememberedEmail;
    String errorMessage = (String) request.getAttribute("errorMessage");
    String
            successMessage = request.getParameter("success");
    String infoMessage = request.getParameter("message"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
</head>

<body>
<nav class="navbar">
    <div class="nav-logo">
        <div class="logo-box">CC</div>
        <span>CivicConnect</span>
    </div>
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/home">Home</a>
        <a href="<%= request.getContextPath() %>/about">About</a>
        <a href="<%= request.getContextPath() %>/login" class="active">Login</a>
        <a href="<%= request.getContextPath() %>/register" class="btn-nav">Register</a>
    </div>
</nav>

<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <div class="logo-box">CC</div>
            <h1>Welcome back</h1>
            <p>Sign in to your CivicConnect account</p>
        </div>

        <% if (errorMessage != null) { %>
        <div class="alert alert-danger">
            <%= errorMessage %>
        </div>
        <% } %>
        <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <%= successMessage %>
        </div>
        <% } %>
        <% if (infoMessage != null) { %>
        <div class="alert alert-success">
            <%= infoMessage %>
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="POST">
            <div class="form-group">
                <label for="email">Email Address <span
                        class="required">*</span></label>
                <input type="email" id="email" name="email"
                       placeholder="you@example.com"
                       value="<%= retainEmail != null ? retainEmail : "" %>"
                       required>
            </div>

            <div class="form-group">
                <label for="password">Password <span
                        class="required">*</span></label>
                <input type="password" id="password" name="password"
                       placeholder="••••••••" required>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="rememberMe" name="rememberMe"
                    <%=!rememberedEmail.isEmpty() ? "checked" : "" %>>
                <label for="rememberMe">Remember me for 7 days</label>
            </div>

            <button type="submit" class="btn-primary">Sign In</button>
        </form>

        <div class="auth-footer">
            Don't have an account? <a
                href="<%= request.getContextPath() %>/register">Register
            here</a>
        </div>

    </div>
</div>
</body>

</html>