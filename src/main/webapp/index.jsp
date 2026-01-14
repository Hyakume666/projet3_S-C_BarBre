<%@ page import="ch.weather.meteo.business.StationMeteo" %>
<%@ page import="ch.weather.meteo.business.Meteo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Stations Météo - HEG Météo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <style>
        :root {
            --weather-primary: #4facfe;
            --weather-secondary: #00f2fe;
            --weather-warm: #fa709a;
            --weather-cold: #667eea;
        }

        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Ccircle cx='50' cy='50' r='40' fill='rgba(255,255,255,0.05)'/%3E%3C/svg%3E") repeat;
            background-size: 100px 100px;
            animation: float 20s linear infinite;
        }

        @keyframes float {
            0% { transform: translateX(0) translateY(0); }
            100% { transform: translateX(-100px) translateY(-100px); }
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .station-card {
            border: none;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            height: 100%;
        }

        .station-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
        }

        .station-card .card-header {
            background: linear-gradient(135deg, var(--weather-primary) 0%, var(--weather-secondary) 100%);
            color: white;
            border: none;
            padding: 1.5rem;
        }

        .station-card.warm .card-header {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }

        .station-card.cold .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .station-card.neutral .card-header {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .weather-icon {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }

        .temperature-display {
            font-size: 2.5rem;
            font-weight: 700;
        }

        .weather-details {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            padding: 1rem 0;
        }

        .weather-detail-item {
            text-align: center;
            padding: 0.5rem;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .weather-detail-item .label {
            font-size: 0.75rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .weather-detail-item .value {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            padding-top: 1rem;
            border-top: 1px solid #eee;
        }

        .action-buttons .btn {
            flex: 1;
            border-radius: 10px;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            border-radius: 20px;
            margin: 2rem 0;
        }

        .empty-state-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
        }

        .quick-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }

        .quick-action-btn {
            padding: 1rem 2rem;
            border-radius: 15px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .quick-action-btn:hover {
            transform: scale(1.05);
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            font-weight: 700;
            color: #333;
        }

        .section-title-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--weather-primary) 0%, var(--weather-secondary) 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .no-data-badge {
            background: #e9ecef;
            color: #6c757d;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
        }

        .last-update {
            font-size: 0.8rem;
            color: rgba(255, 255, 255, 0.8);
        }

        .country-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            display: inline-block;
            margin-top: 0.5rem;
        }

        .coords {
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .measurements-count {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(0, 0, 0, 0.3);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        footer {
            background: #2d3436;
            color: white;
            padding: 2rem 0;
            margin-top: 3rem;
        }

        footer a {
            color: #74b9ff;
        }
    </style>
</head>
<body class="bg-light">
<% String activePage = "index"; %>
<%@ include file="menu.jsp" %>

<%-- Récupération des données --%>
<%
    @SuppressWarnings("unchecked")
    List<StationMeteo> stations = (List<StationMeteo>) request.getAttribute("stations");
    if (stations == null) {
        stations = new ArrayList<>();
    }

    // Calculer les statistiques
    int totalStations = stations.size();
    int totalMeasurements = 0;
    Double maxTemp = null;
    Double minTemp = null;
    String hottestCity = "";
    String coldestCity = "";

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    for (StationMeteo s : stations) {
        Map<Date, Meteo> mesures = s.getDonneesMeteo();
        if (mesures != null) {
            totalMeasurements += mesures.size();
            for (Meteo m : mesures.values()) {
                if (maxTemp == null || m.getTemperature() > maxTemp) {
                    maxTemp = m.getTemperature();
                    hottestCity = s.getNom();
                }
                if (minTemp == null || m.getTemperature() < minTemp) {
                    minTemp = m.getTemperature();
                    coldestCity = s.getNom();
                }
            }
        }
    }
%>

<%-- Hero Section --%>
<section class="hero-section">
    <div class="container hero-content">
        <div class="row align-items-center">
            <div class="col-lg-6 mb-4 mb-lg-0">
                <h1 class="display-4 fw-bold mb-3">
                    🌤️ HEG Météo
                </h1>
                <p class="lead mb-4">
                    Votre tableau de bord météorologique personnel.
                    Suivez en temps réel les conditions météo de vos stations favorites.
                </p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="<%= application.getContextPath() %>/ajouter-station" class="btn btn-light btn-lg quick-action-btn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                        </svg>
                        Ajouter une station
                    </a>
                    <% if (!stations.isEmpty()) { %>
                    <a href="<%= application.getContextPath() %>/refresh?all=true" class="btn btn-outline-light btn-lg quick-action-btn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2z"/>
                            <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466"/>
                        </svg>
                        Tout rafraîchir
                    </a>
                    <% } %>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="stat-card">
                            <div class="stat-number"><%= totalStations %></div>
                            <div class="stat-label">Stations</div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="stat-card">
                            <div class="stat-number"><%= totalMeasurements %></div>
                            <div class="stat-label">Mesures</div>
                        </div>
                    </div>
                    <% if (maxTemp != null) { %>
                    <div class="col-6">
                        <div class="stat-card">
                            <div class="stat-number" style="color: #fee140;">🔥 <%= String.format("%.1f", maxTemp) %>°</div>
                            <div class="stat-label"><%= hottestCity %></div>
                        </div>
                    </div>
                    <% } %>
                    <% if (minTemp != null) { %>
                    <div class="col-6">
                        <div class="stat-card">
                            <div class="stat-number" style="color: #74b9ff;">❄️ <%= String.format("%.1f", minTemp) %>°</div>
                            <div class="stat-label"><%= coldestCity %></div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<main class="container">
    <%-- Messages de succès/erreur --%>
    <% String success = (String) request.getAttribute("success"); %>
    <% if (success != null && !success.isEmpty()) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong>✅ Succès!</strong> <%= success %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null && !error.isEmpty()) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <strong>⚠️ Erreur:</strong> <%= error %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <% if (stations.isEmpty()) { %>
    <%-- État vide --%>
    <div class="empty-state">
        <div class="empty-state-icon">🌍</div>
        <h2 class="mb-3">Aucune station météo</h2>
        <p class="text-muted mb-4">
            Commencez par ajouter votre première station météo pour suivre les conditions en temps réel.
        </p>
        <a href="<%= application.getContextPath() %>/ajouter-station" class="btn btn-primary btn-lg">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
            </svg>
            Ajouter ma première station
        </a>
    </div>
    <% } else { %>
    <%-- Liste des stations --%>
    <div class="section-title">
        <div class="section-title-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
                <path d="M8 16a6 6 0 0 0 6-6c0-1.655-1.122-2.904-2.432-4.362C10.254 4.176 8.75 2.503 8 0c0 0-6 5.686-6 10a6 6 0 0 0 6 6M6.646 4.646l.708.708c-.29.29-1.128 1.311-1.907 2.87l-.894-.448c.82-1.641 1.717-2.753 2.093-3.13"/>
            </svg>
        </div>
        <h2 class="mb-0">Mes stations (<%= totalStations %>)</h2>
    </div>

    <div class="row g-4">
        <%
            for (StationMeteo station : stations) {
                Map<Date, Meteo> mesures = station.getDonneesMeteo();
                Meteo latestMeteo = null;
                Date latestDate = null;

                if (mesures != null && !mesures.isEmpty()) {
                    for (Map.Entry<Date, Meteo> entry : mesures.entrySet()) {
                        if (latestDate == null || entry.getKey().after(latestDate)) {
                            latestDate = entry.getKey();
                            latestMeteo = entry.getValue();
                        }
                    }
                }

                // Déterminer la classe de température
                String tempClass = "neutral";
                String weatherIcon = "🌡️";
                if (latestMeteo != null) {
                    double temp = latestMeteo.getTemperature();
                    if (temp >= 25) {
                        tempClass = "warm";
                        weatherIcon = "☀️";
                    } else if (temp <= 5) {
                        tempClass = "cold";
                        weatherIcon = "❄️";
                    } else if (temp > 15) {
                        weatherIcon = "🌤️";
                    } else {
                        weatherIcon = "🌥️";
                    }

                    // Adapter l'icône selon la description
                    String desc = latestMeteo.getDescription() != null ? latestMeteo.getDescription().toLowerCase() : "";
                    if (desc.contains("pluie") || desc.contains("rain")) {
                        weatherIcon = "🌧️";
                    } else if (desc.contains("neige") || desc.contains("snow")) {
                        weatherIcon = "🌨️";
                    } else if (desc.contains("orage") || desc.contains("thunder")) {
                        weatherIcon = "⛈️";
                    } else if (desc.contains("brouillard") || desc.contains("fog") || desc.contains("mist")) {
                        weatherIcon = "🌫️";
                    } else if (desc.contains("nuage") || desc.contains("cloud") || desc.contains("couvert")) {
                        weatherIcon = "☁️";
                    }
                }
        %>
        <div class="col-md-6 col-lg-4">
            <div class="card station-card <%= tempClass %>">
                <div class="card-header position-relative">
                    <% if (mesures != null) { %>
                    <span class="measurements-count">
                                    📊 <%= mesures.size() %> mesure<%= mesures.size() > 1 ? "s" : "" %>
                                </span>
                    <% } %>

                    <div class="weather-icon"><%= weatherIcon %></div>

                    <% if (latestMeteo != null) { %>
                    <div class="temperature-display">
                        <%= String.format("%.1f", latestMeteo.getTemperature()) %>°C
                    </div>
                    <div><%= latestMeteo.getDescription() != null ? latestMeteo.getDescription() : "" %></div>
                    <% } else { %>
                    <div class="temperature-display">--°C</div>
                    <div class="no-data-badge">Aucune mesure</div>
                    <% } %>

                    <h5 class="mt-3 mb-0"><%= station.getNom() %></h5>

                    <% if (station.getPays() != null) { %>
                    <span class="country-badge">
                                    🏳️ <%= station.getPays().getNom() %>
                                </span>
                    <% } %>

                    <div class="coords mt-2">
                        📍 <%= String.format("%.4f", station.getLatitude()) %>, <%= String.format("%.4f", station.getLongitude()) %>
                    </div>

                    <% if (latestDate != null) { %>
                    <div class="last-update mt-2">
                        🕐 <%= dateFormat.format(latestDate) %>
                    </div>
                    <% } %>
                </div>

                <div class="card-body">
                    <% if (latestMeteo != null) { %>
                    <div class="weather-details">
                        <div class="weather-detail-item">
                            <div class="label">Humidité</div>
                            <div class="value">💧 <%= String.format("%.0f", latestMeteo.getHumidite()) %>%</div>
                        </div>
                        <div class="weather-detail-item">
                            <div class="label">Pression</div>
                            <div class="value">🔽 <%= String.format("%.0f", latestMeteo.getPression()) %> hPa</div>
                        </div>
                        <div class="weather-detail-item">
                            <div class="label">Visibilité</div>
                            <div class="value">👁️ <%= latestMeteo.getVisibilite() / 1000.0 %> km</div>
                        </div>
                        <div class="weather-detail-item">
                            <div class="label">Précipitations</div>
                            <div class="value">🌧️ <%= String.format("%.1f", latestMeteo.getPrecipitation()) %> mm</div>
                        </div>
                    </div>
                    <% } else { %>
                    <p class="text-muted text-center my-4">
                        Aucune donnée disponible.<br>
                        Cliquez sur rafraîchir pour obtenir les données.
                    </p>
                    <% } %>

                    <div class="action-buttons">
                        <a href="<%= application.getContextPath() %>/station?id=<%= station.getNumero() %>" class="btn btn-outline-primary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="me-1" viewBox="0 0 16 16">
                                <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0"/>
                                <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8m8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7"/>
                            </svg>
                            Détails
                        </a>
                        <a href="<%= application.getContextPath() %>/refresh?id=<%= station.getNumero() %>" class="btn btn-outline-success">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="me-1" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2z"/>
                                <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466"/>
                            </svg>
                            Rafraîchir
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <%-- Lien vers le classement --%>
    <div class="text-center mt-5">
        <a href="<%= application.getContextPath() %>/top-stations" class="btn btn-lg btn-outline-primary">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="me-2" viewBox="0 0 16 16">
                <path d="M9.5 12.5a1.5 1.5 0 1 1-2-1.415V6.5a.5.5 0 0 1 1 0v4.585a1.5 1.5 0 0 1 1 1.415"/>
                <path d="M5.5 2.5a2.5 2.5 0 0 1 5 0v7.55a3.5 3.5 0 1 1-5 0zM8 1a1.5 1.5 0 0 0-1.5 1.5v7.987l-.167.15a2.5 2.5 0 1 0 3.333 0l-.166-.15V2.5A1.5 1.5 0 0 0 8 1"/>
            </svg>
            Voir le classement chaud/froid
        </a>
    </div>
    <% } %>
</main>

<%-- Footer --%>
<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5>🌤️ HEG Météo</h5>
                <p class="text-white-50">
                    Application de suivi météorologique développée dans le cadre du cours
                    Services et Composants - HE-Arc Neuchâtel.
                </p>
            </div>
            <div class="col-md-3">
                <h6>Liens rapides</h6>
                <ul class="list-unstyled">
                    <li><a href="<%= application.getContextPath() %>/stations">Accueil</a></li>
                    <li><a href="<%= application.getContextPath() %>/ajouter-station">Ajouter</a></li>
                    <li><a href="<%= application.getContextPath() %>/top-stations">Classement</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h6>Données</h6>
                <ul class="list-unstyled">
                    <li><a href="https://openweathermap.org/" target="_blank">OpenWeatherMap</a></li>
                </ul>
            </div>
        </div>
        <hr class="my-4 bg-white-50">
        <div class="text-center text-white-50">
            <small>© 2025-2026 HE-Arc - Projet Services et Composants</small>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>
