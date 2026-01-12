<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="css/navbar-fixed.css">
<nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="<%= application.getContextPath() %>/">HEG - Météo</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="navbar-nav me-auto mb-2 mb-md-0">
                <li class="nav-item"> <a class="nav-link <% if("index".equals(activePage)){%> active <%}%>" aria-current="page" href="<%= application.getContextPath() %>/">Accueil</a> </li>
                <li class="nav-item"> <a class="nav-link <% if("ajouter".equals(activePage)){%> active <%}%>" href="<%= application.getContextPath() %>/ajouter-station.jsp">Ajouter une station météo</a> </li>
            </ul>
        </div>
    </div>
</nav>