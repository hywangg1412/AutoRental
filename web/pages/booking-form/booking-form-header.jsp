<%-- Document : booking-form-header Created on : Jun 15, 2025, 9:25:22 AM Author
: admin --%> <%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Entity.User" %> <% User user = (User)
session.getAttribute("user"); String username = user != null ?
user.getUsername() : "Account"; %>
<header class="header">
    <div class="container">
        <div class="header-content">
            <div class="logo">
                <a href="<%= request.getContextPath() %>/pages/index.jsp"
                   ><h1>AUTO<span>RENTAL</span></h1></a
                >
            </div>
            <nav class="nav">
                <a
                    href="<%= request.getContextPath() %>/pages/index.jsp"
                    class="nav-link"
                    >Home</a
                >
                <a href="#" class="nav-link">My Booking</a>
                <div class="user-menu">
                    <i class="fas fa-bell"></i>
                    <i class="fas fa-comment"></i>
                    <div class="user-avatar">
                        <span><%= username %></span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>
            </nav>
        </div>
    </div>
</header>
