<%@ page import="civicconnect.model.Municipality" %>
<%@ page import="java.util.ArrayList" %>
<%
    String retainFullName = (String) request.getAttribute("retainFullName");
    String retainEmail = (String) request.getAttribute("retainEmail");
    String retainPhone = (String) request.getAttribute("retainPhone");
    String retainWard = (String) request.getAttribute("retainWard");
    
    String errorFullName = (String) request.getAttribute("errorFullName");
    String errorEmail = (String) request.getAttribute("errorEmail");
    String errorPhone = (String) request.getAttribute("errorPhone");
    String errorMunicipality = (String) request.getAttribute("errorMunicipality");
    String errorWard = (String) request.getAttribute("errorWard");
    String errorPassword = (String) request.getAttribute("errorPassword");
    String errorConfirmPassword = (String) request.getAttribute("errorConfirmPassword");
    String errorMessage = (String) request.getAttribute("errorMessage");

    ArrayList<Municipality> municipalities = (ArrayList<Municipality>) request.getAttribute("municipalities");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - CivicConnect</title>
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
            <a href="<%= request.getContextPath() %>/login">Login</a>
            <a href="<%= request.getContextPath() %>/register" class="btn-nav active">Register</a>
        </div>
    </nav>

    <div class="auth-container">
        <div class="auth-card register-card">
            <div class="auth-header">
                <div class="logo-box">CC</div>
                <h1>Create your account</h1>
                <p>Register as a citizen to submit and track complaints</p>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-danger"><%= errorMessage %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">Full Name <span class="required">*</span></label>
                        <input type="text" id="fullName" name="fullName" placeholder="Ramesh Sharma" 
                               class="<%= errorFullName != null ? "input-error" : "" %>"
                               value="<%= retainFullName != null ? retainFullName : "" %>" required>
                        <% if (errorFullName != null) { %> <div class="error-text"><%= errorFullName %></div> <% } %>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number <span class="required">*</span></label>
                        <input type="text" id="phone" name="phone" placeholder="9812345678" 
                               class="<%= errorPhone != null ? "input-error" : "" %>"
                               value="<%= retainPhone != null ? retainPhone : "" %>" required>
                        <% if (errorPhone != null) { %> <div class="error-text"><%= errorPhone %></div> <% } %>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Email Address <span class="required">*</span></label>
                    <input type="email" id="email" name="email" placeholder="example@email.com" 
                           class="<%= errorEmail != null ? "input-error" : "" %>"
                           value="<%= retainEmail != null ? retainEmail : "" %>" required>
                    <% if (errorEmail != null) { %> <div class="error-text"><%= errorEmail %></div> <% } %>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="municipalityId">Municipality <span class="required">*</span></label>
                        <select id="municipalityId" name="municipalityId" class="<%= errorMunicipality != null ? "input-error" : "" %>" required>
                            <option value="">Select Municipality...</option>
                            <% if (municipalities != null) { 
                                for (Municipality m : municipalities) { %>
                                    <option value="<%= m.getId() %>"><%= m.getName() %></option>
                            <%  } 
                               } %>
                        </select>
                        <% if (errorMunicipality != null) { %> <div class="error-text"><%= errorMunicipality %></div> <% } %>
                    </div>
                    <div class="form-group">
                        <label for="wardNumber">Ward Number <span class="required">*</span></label>
                        <input type="number" id="wardNumber" name="wardNumber" placeholder="1-33" min="1" max="33"
                               class="<%= errorWard != null ? "input-error" : "" %>"
                               value="<%= retainWard != null ? retainWard : "" %>" required>
                        <div class="help-text">Enter a number between 1 and 33</div>
                        <% if (errorWard != null) { %> <div class="error-text"><%= errorWard %></div> <% } %>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password <span class="required">*</span></label>
                        <input type="password" id="password" name="password" placeholder="••••••••" 
                               class="<%= errorPassword != null ? "input-error" : "" %>" required>
                        <div class="help-text">Min 8 chars, 1 uppercase, 1 lowercase, 1 number</div>
                        <% if (errorPassword != null) { %> <div class="error-text"><%= errorPassword %></div> <% } %>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Repeat password" 
                               class="<%= errorConfirmPassword != null ? "input-error" : "" %>" required>
                        <% if (errorConfirmPassword != null) { %> <div class="error-text"><%= errorConfirmPassword %></div> <% } %>
                    </div>
                </div>

                <button type="submit" class="btn-primary">Create Account</button>
            </form>

            <div class="divider">or</div>

            <div class="auth-footer">
                Already have an account? <a href="<%= request.getContextPath() %>/login">Sign in</a>
            </div>
        </div>
    </div>
</body>
</html>
