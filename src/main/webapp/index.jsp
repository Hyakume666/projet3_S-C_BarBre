<%@ page import="ch.weather.meteo.business.StationMeteo" %>
<%@ page import="java.util.List" %>
<%@ page import="ch.weather.meteo.persistance.dao.StationMeteoDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>HEG - Meteo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
</head>
<% // Récupération de la liste des stations météo depuis la base de données
    List<StationMeteo> stations = new ArrayList<>(StationMeteoDAO.researchAll()); %>
<body>
    <% String activePage = "index"; %>
    <%@ include file="menu.jsp" %>
    <main class="container-fluid">
        <div class="p-5 rounded">
        <!-- Affichage de la liste des stations météo -->
        <table class="table">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Pays</th>
                    <th>Latitude</th>
                    <th>Longitude</th>
                    <th>OpenWeatherMap ID</th>
                </tr>
            </thead>
            <tbody>
                <% for (StationMeteo station : stations) { %>
                    <tr>
                        <td><%= station.getNom()%></td>
                        <td><%= station.getPays().getNom() %></td>
                        <td><%= station.getLatitude() %></td>
                        <td><%= station.getLongitude() %></td>
                        <td><%= station.getOpenWeatherMapId() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>