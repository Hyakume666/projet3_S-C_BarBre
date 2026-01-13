<%@ page import="ch.weather.meteo.business.StationMeteo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Stations Météo - HEG Météo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
</head>
<body>
    <% String activePage = "index"; %>
    <%@ include file="menu.jsp" %>
    
    <main class="container-fluid">
        <div class="p-5 rounded">
            <h2 class="mb-4">Liste des stations météo</h2>
            
            <%-- Affichage des messages de succès --%>
            <% String success = (String) request.getAttribute("success"); %>
            <% if (success != null && !success.isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <strong>Succès!</strong> <%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <%-- Affichage des messages d'erreur --%>
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Erreur:</strong> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <%-- Récupération des stations depuis la servlet --%>
            <% 
                @SuppressWarnings("unchecked")
                List<StationMeteo> stations = (List<StationMeteo>) request.getAttribute("stations");
                if (stations == null) {
                    stations = new ArrayList<>();
                }
            %>
            
            <% if (stations.isEmpty()) { %>
                <div class="alert alert-info" role="alert">
                    Aucune station météo enregistrée. 
                    <a href="<%= application.getContextPath() %>/ajouter-station" class="alert-link">
                        Ajouter une station
                    </a>
                </div>
            <% } else { %>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="text-muted"><%= stations.size() %> station(s) enregistrée(s)</span>
                    <div>
                        <a href="<%= application.getContextPath() %>/refresh?all=true" class="btn btn-outline-primary btn-sm">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-clockwise me-1" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2z"/>
                                <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466"/>
                            </svg>
                            Rafraîchir toutes les stations
                        </a>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>Nom</th>
                                <th>Pays</th>
                                <th>Latitude</th>
                                <th>Longitude</th>
                                <th>Nb mesures</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (StationMeteo station : stations) { %>
                                <tr>
                                    <td>
                                        <a href="<%= application.getContextPath() %>/station?id=<%= station.getNumero() %>" 
                                           class="text-decoration-none fw-bold">
                                            <%= station.getNom() %>
                                        </a>
                                    </td>
                                    <td>
                                        <% if (station.getPays() != null) { %>
                                            <%= station.getPays().getNom() %>
                                            <small class="text-muted">(<%= station.getPays().getCode() %>)</small>
                                        <% } else { %>
                                            <span class="text-muted">-</span>
                                        <% } %>
                                    </td>
                                    <td><%= String.format("%.4f", station.getLatitude()) %></td>
                                    <td><%= String.format("%.4f", station.getLongitude()) %></td>
                                    <td>
                                        <span class="badge bg-secondary">
                                            <%= station.getDonneesMeteo() != null ? station.getDonneesMeteo().size() : 0 %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="<%= application.getContextPath() %>/station?id=<%= station.getNumero() %>" 
                                           class="btn btn-sm btn-outline-info" title="Voir détails">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye" viewBox="0 0 16 16">
                                                <path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5s3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5s-3.879-1.168-5.168-2.457A13 13 0 0 1 1.172 8z"/>
                                                <path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/>
                                            </svg>
                                        </a>
                                        <a href="<%= application.getContextPath() %>/refresh?id=<%= station.getNumero() %>" 
                                           class="btn btn-sm btn-outline-success" title="Rafraîchir">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-clockwise" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2z"/>
                                                <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466"/>
                                            </svg>
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>
