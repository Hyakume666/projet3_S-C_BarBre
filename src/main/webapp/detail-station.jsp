<%@ page import="ch.weather.meteo.business.StationMeteo" %>
<%@ page import="ch.weather.meteo.business.Meteo" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Détail Station - HEG Météo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <style>
        .weather-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
        }
        .temp-display {
            font-size: 3rem;
            font-weight: bold;
        }
        .weather-icon {
            font-size: 4rem;
        }
    </style>
</head>
<body>
    <% String activePage = "detail"; %>
    <%@ include file="menu.jsp" %>
    
    <main class="container-fluid">
        <div class="p-5 rounded">
            
            <%-- Récupération de la station --%>
            <% 
                StationMeteo station = (StationMeteo) request.getAttribute("station");
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            %>
            
            <% if (station == null) { %>
                <div class="alert alert-danger" role="alert">
                    Station non trouvée.
                    <a href="<%= application.getContextPath() %>/stations" class="alert-link">Retour à la liste</a>
                </div>
            <% } else { %>
            
                <%-- Affichage des messages de succès --%>
                <% String success = (String) request.getAttribute("success"); %>
                <% if (success != null && !success.isEmpty()) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Succès!</strong> <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>
                
                <%-- Breadcrumb --%>
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="<%= application.getContextPath() %>/stations">Stations</a>
                        </li>
                        <li class="breadcrumb-item active" aria-current="page"><%= station.getNom() %></li>
                    </ol>
                </nav>
                
                <%-- En-tête avec infos station --%>
                <div class="row mb-4">
                    <div class="col-md-8">
                        <h2>
                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-geo-alt me-2" viewBox="0 0 16 16">
                                <path d="M12.166 8.94c-.524 1.062-1.234 2.12-1.96 3.07A32 32 0 0 1 8 14.58a32 32 0 0 1-2.206-2.57c-.726-.95-1.436-2.008-1.96-3.07C3.304 7.867 3 6.862 3 6a5 5 0 0 1 10 0c0 .862-.305 1.867-.834 2.94M8 16s6-5.686 6-10A6 6 0 0 0 2 6c0 4.314 6 10 6 10"/>
                                <path d="M8 8a2 2 0 1 1 0-4 2 2 0 0 1 0 4m0 1a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>
                            </svg>
                            <%= station.getNom() %>
                        </h2>
                        <p class="text-muted">
                            <% if (station.getPays() != null) { %>
                                <%= station.getPays().getNom() %> (<%= station.getPays().getCode() %>)
                            <% } %>
                            &bull; 
                            Lat: <%= String.format("%.4f", station.getLatitude()) %>, 
                            Lon: <%= String.format("%.4f", station.getLongitude()) %>
                            &bull;
                            OWM ID: <%= station.getOpenWeatherMapId() %>
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <a href="<%= application.getContextPath() %>/refresh?id=<%= station.getNumero() %>" 
                           class="btn btn-primary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-clockwise me-1" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2z"/>
                                <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466"/>
                            </svg>
                            Rafraîchir les données
                        </a>
                    </div>
                </div>
                
                <%-- Carte météo actuelle (dernière mesure) --%>
                <% 
                    Map<Date, Meteo> mesuresMap = station.getDonneesMeteo();
                    List<Meteo> mesures = new ArrayList<>();
                    if (mesuresMap != null) {
                        mesures.addAll(mesuresMap.values());
                        mesures.sort(Comparator.comparing(Meteo::getDateMesure).reversed());
                    }
                    Meteo derniereMesure = mesures.isEmpty() ? null : mesures.get(0);
                %>
                
                <% if (derniereMesure != null) { %>
                    <div class="card weather-card mb-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-4 text-center">
                                    <div class="weather-icon">🌤️</div>
                                    <p class="mb-0"><%= derniereMesure.getDescription() %></p>
                                </div>
                                <div class="col-md-4 text-center">
                                    <div class="temp-display">
                                        <%= String.format("%.1f", derniereMesure.getTemperature()) %>°C
                                    </div>
                                    <p class="mb-0">Température actuelle</p>
                                </div>
                                <div class="col-md-4">
                                    <ul class="list-unstyled mb-0">
                                        <li>
                                            <strong>Humidité:</strong> 
                                            <%= String.format("%.0f", derniereMesure.getHumidite()) %>%
                                        </li>
                                        <li>
                                            <strong>Pression:</strong> 
                                            <%= String.format("%.0f", derniereMesure.getPression()) %> hPa
                                        </li>
                                        <li>
                                            <strong>Visibilité:</strong> 
                                            <%= derniereMesure.getVisibilite() / 1000.0 %> km
                                        </li>
                                        <li>
                                            <strong>Précipitations:</strong> 
                                            <%= String.format("%.1f", derniereMesure.getPrecipitation()) %> mm
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="text-end mt-2">
                                <small>Dernière mise à jour: <%= dateFormat.format(derniereMesure.getDateMesure()) %></small>
                            </div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="alert alert-info mb-4" role="alert">
                        Aucune mesure météo disponible. 
                        <a href="<%= application.getContextPath() %>/refresh?id=<%= station.getNumero() %>" class="alert-link">
                            Rafraîchir les données
                        </a>
                    </div>
                <% } %>
                
                <%-- Historique des mesures --%>
                <h4 class="mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-clock-history me-2" viewBox="0 0 16 16">
                        <path d="M8.515 1.019A7 7 0 0 0 8 1V0a8 8 0 0 1 .589.022zm2.004.45a7 7 0 0 0-.985-.299l.219-.976q.576.129 1.126.342zm1.37.71a7 7 0 0 0-.439-.27l.493-.87a8 8 0 0 1 .979.654l-.615.789a7 7 0 0 0-.418-.302zm1.834 1.79a7 7 0 0 0-.653-.796l.724-.69q.406.429.747.91zm.744 1.352a7 7 0 0 0-.214-.468l.893-.45a8 8 0 0 1 .45 1.088l-.95.313a7 7 0 0 0-.179-.483m.53 2.507a7 7 0 0 0-.1-1.025l.985-.17q.1.58.116 1.17zm-.131 1.538q.05-.254.081-.51l.993.123a8 8 0 0 1-.23 1.155l-.964-.267q.069-.247.12-.501m-.952 2.379q.276-.436.486-.908l.914.405q-.24.54-.555 1.038zm-.964 1.205q.183-.183.35-.378l.758.653a8 8 0 0 1-.401.432z"/>
                        <path d="M8 1a7 7 0 1 0 4.95 11.95l.707.707A8.001 8.001 0 1 1 8 0z"/>
                        <path d="M7.5 3a.5.5 0 0 1 .5.5v5.21l3.248 1.856a.5.5 0 0 1-.496.868l-3.5-2A.5.5 0 0 1 7 9V3.5a.5.5 0 0 1 .5-.5"/>
                    </svg>
                    Historique des mesures
                    <span class="badge bg-secondary"><%= mesures.size() %></span>
                </h4>
                
                <% if (mesures.isEmpty()) { %>
                    <p class="text-muted">Aucune mesure enregistrée.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Date</th>
                                    <th>Température</th>
                                    <th>Description</th>
                                    <th>Humidité</th>
                                    <th>Pression</th>
                                    <th>Visibilité</th>
                                    <th>Précipitations</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Meteo mesure : mesures) { %>
                                    <tr>
                                        <td><%= dateFormat.format(mesure.getDateMesure()) %></td>
                                        <td>
                                            <strong><%= String.format("%.1f", mesure.getTemperature()) %>°C</strong>
                                        </td>
                                        <td><%= mesure.getDescription() %></td>
                                        <td><%= String.format("%.0f", mesure.getHumidite()) %>%</td>
                                        <td><%= String.format("%.0f", mesure.getPression()) %> hPa</td>
                                        <td><%= mesure.getVisibilite() / 1000.0 %> km</td>
                                        <td><%= String.format("%.1f", mesure.getPrecipitation()) %> mm</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
                
                <div class="mt-4">
                    <a href="<%= application.getContextPath() %>/stations" class="btn btn-outline-secondary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-left me-1" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8"/>
                        </svg>
                        Retour à la liste
                    </a>
                </div>
                
            <% } %>
        </div>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>
