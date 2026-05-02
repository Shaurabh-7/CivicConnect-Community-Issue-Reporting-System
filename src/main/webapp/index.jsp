<% 
    // This file now redirects to the home servlet by default.
    // To view login/register, use the /login and /register URLs.
    response.sendRedirect(request.getContextPath() + "/home"); 
%>