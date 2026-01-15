<%@ page import="ch.weather.meteo.business.StationMeteo" %>
<%@ page import="ch.weather.meteo.business.Meteo" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Détail Station - MorphéoMétéo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --pokemon-red: #E3350D;
            --pokemon-blue: #3B5CA8;
            --pokemon-yellow: #FFCB05;
        }

        * { font-family: 'Nunito', sans-serif; }

        body {
            background: linear-gradient(180deg, #87CEEB 0%, #E0F6FF 50%, #fff 100%);
            min-height: 100vh;
        }

        .station-hero {
            padding: 2rem 0;
            position: relative;
        }

        .station-hero.type-sun { background: linear-gradient(180deg, #FFF8E7 0%, #FFE8B8 100%); }
        .station-hero.type-rain { background: linear-gradient(180deg, #E8F4FF 0%, #B8D8FF 100%); }
        .station-hero.type-snow { background: linear-gradient(180deg, #F0FFFF 0%, #D8F5F5 100%); }
        .station-hero.type-normal { background: linear-gradient(180deg, #F8F8F8 0%, #E8E8E8 100%); }

        .morpheo-detail {
            width: 150px;
            height: 150px;
            animation: float 3s ease-in-out infinite;
            filter: drop-shadow(0 10px 20px rgba(0,0,0,0.2));
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }

        .station-name {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--pokemon-blue);
        }

        .country-badge {
            background: var(--pokemon-blue);
            color: white;
            padding: 0.3rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            display: inline-block;
        }

        .temperature-hero {
            font-size: 5rem;
            font-weight: 800;
            line-height: 1;
        }

        .type-sun .temperature-hero { color: #E67E00; }
        .type-rain .temperature-hero { color: #3A6BC6; }
        .type-snow .temperature-hero { color: #5BBDBD; }
        .type-normal .temperature-hero { color: #6B6F78; }

        .weather-description {
            font-size: 1.3rem;
            color: #666;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }

        .stat-box {
            background: white;
            border-radius: 15px;
            padding: 1.2rem;
            text-align: center;
            border: 3px solid #eee;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .stat-box .icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .stat-box .value {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--pokemon-blue);
        }

        .stat-box .label {
            font-size: 0.8rem;
            color: #888;
            text-transform: uppercase;
            font-weight: 600;
        }

        .history-section {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-top: 2rem;
            border: 3px solid #eee;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
        }

        .history-title {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .history-title h3 {
            font-weight: 800;
            color: var(--pokemon-blue);
            margin: 0;
        }

        .history-table {
            border-radius: 10px;
            overflow: hidden;
        }

        .history-table thead {
            background: linear-gradient(90deg, var(--pokemon-blue) 0%, #2A4A7C 100%);
            color: white;
        }

        .history-table thead th {
            font-weight: 700;
            padding: 1rem;
            border: none;
        }

        .history-table tbody tr {
            transition: all 0.2s ease;
        }

        .history-table tbody tr:hover {
            background: #f8f9fa;
            transform: scale(1.01);
        }

        .history-table td {
            padding: 0.8rem 1rem;
            vertical-align: middle;
        }

        .temp-badge {
            display: inline-block;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-weight: 700;
        }

        .temp-hot { background: #FFE8D6; color: #E67E00; }
        .temp-warm { background: #FFF8E7; color: #B8860B; }
        .temp-cool { background: #E8F4FF; color: #3A6BC6; }
        .temp-cold { background: #D8F5F5; color: #5BBDBD; }

        .btn-pokemon {
            background: linear-gradient(180deg, #E3350D 0%, #B22D0D 100%);
            border: 3px solid #8B1E08;
            color: white;
            font-weight: 700;
            border-radius: 30px;
            padding: 0.6rem 1.5rem;
            box-shadow: 0 3px 0 #8B1E08;
            transition: all 0.2s ease;
        }

        .btn-pokemon:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 0 #8B1E08;
        }

        .btn-pokemon-secondary {
            background: linear-gradient(180deg, var(--pokemon-yellow) 0%, #D4A904 100%);
            border: 3px solid #A68500;
            color: #333;
            font-weight: 700;
            border-radius: 30px;
            padding: 0.6rem 1.5rem;
            box-shadow: 0 3px 0 #A68500;
        }

        .btn-pokemon-secondary:hover {
            color: #333;
            transform: translateY(-2px);
        }

        .coords-info {
            font-family: monospace;
            background: rgba(0,0,0,0.05);
            padding: 0.3rem 0.8rem;
            border-radius: 8px;
            font-size: 0.9rem;
        }

        .alert-pokemon-success {
            background: linear-gradient(90deg, #78C850 0%, #5CA935 100%);
            border: none;
            color: white;
            border-radius: 15px;
            font-weight: 600;
        }
    </style>
</head>
<body>
<% String activePage = ""; %>
<%@ include file="menu.jsp" %>

<%
    StationMeteo station = (StationMeteo) request.getAttribute("station");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    // Trouver la dernière mesure
    Meteo latestMeteo = null;
    Date latestDate = null;
    Map<Date, Meteo> mesures = station != null ? station.getDonneesMeteo() : null;

    if (mesures != null && !mesures.isEmpty()) {
        for (Map.Entry<Date, Meteo> entry : mesures.entrySet()) {
            if (latestDate == null || entry.getKey().after(latestDate)) {
                latestDate = entry.getKey();
                latestMeteo = entry.getValue();
            }
        }
    }

    // Déterminer le type Morphéo
    String morpheoType = "normal";
    String morpheoSprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/351.png";

    if (latestMeteo != null) {
        double temp = latestMeteo.getTemperature();
        String desc = latestMeteo.getDescription() != null ? latestMeteo.getDescription().toLowerCase() : "";

        if (desc.contains("neige") || desc.contains("snow") || temp < 0) {
            morpheoType = "snow";
            morpheoSprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10015.png";
        } else if (desc.contains("pluie") || desc.contains("rain") || desc.contains("drizzle") || desc.contains("averse")) {
            morpheoType = "rain";
            morpheoSprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10014.png";
        } else if (temp >= 25 || desc.contains("soleil") || desc.contains("sun") || desc.contains("clear") || desc.contains("clair")) {
            morpheoType = "sun";
            morpheoSprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10013.png";
        }
    }
%>

<% if (station == null) { %>
<div class="container py-5 text-center">
    <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/351.png"
         width="150" alt="Morphéo triste" style="opacity: 0.5;">
    <h2 class="mt-4" style="color: var(--pokemon-blue);">Station introuvable !</h2>
    <p class="text-muted">Cette station n'existe pas ou a été supprimée.</p>
    <a href="<%= application.getContextPath() %>/stations" class="btn btn-pokemon mt-3">
        ← Retour à l'accueil
    </a>
</div>
<% } else { %>

<%-- Messages --%>
<div class="container mt-3">
    <% String success = (String) request.getAttribute("success"); %>
    <% if (success != null && !success.isEmpty()) { %>
    <div class="alert alert-pokemon-success alert-dismissible fade show" role="alert">
        ✨ <%= success %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
</div>

<%-- Hero Section --%>
<section class="station-hero type-<%= morpheoType %>">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-4 text-center mb-4 mb-md-0">
                <img src="<%= morpheoSprite %>" alt="Morphéo" class="morpheo-detail">
            </div>
            <div class="col-md-8">
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="<%= application.getContextPath() %>/stations">Accueil</a></li>
                        <li class="breadcrumb-item active"><%= station.getNom() %></li>
                    </ol>
                </nav>

                <h1 class="station-name"><%= station.getNom() %></h1>

                <% if (station.getPays() != null) { %>
                <span class="country-badge mb-2"><%= station.getPays().getNom() %></span>
                <% } %>

                <div class="coords-info mt-2 d-inline-block">
                    📍 <%= String.format("%.4f", station.getLatitude()) %>, <%= String.format("%.4f", station.getLongitude()) %>
                </div>

                <% if (latestMeteo != null) { %>
                <div class="mt-4">
                    <div class="temperature-hero">
                        <%= String.format("%.1f", latestMeteo.getTemperature()) %>°C
                    </div>
                    <div class="weather-description">
                        <%= latestMeteo.getDescription() != null ? latestMeteo.getDescription() : "" %>
                    </div>
                    <% if (latestDate != null) { %>
                    <small class="text-muted">🕐 Dernière mise à jour : <%= dateFormat.format(latestDate) %></small>
                    <% } %>
                </div>
                <% } else { %>
                <div class="mt-4">
                    <div class="temperature-hero" style="color: #999;">—°C</div>
                    <div class="weather-description">Aucune mesure disponible</div>
                </div>
                <% } %>

                <div class="mt-4 d-flex gap-2 flex-wrap">
                    <a href="<%= application.getContextPath() %>/refresh?id=<%= station.getNumero() %>" class="btn btn-pokemon">
                        ↻ Rafraîchir les données
                    </a>
                    <a href="<%= application.getContextPath() %>/stations" class="btn btn-pokemon-secondary">
                        ← Retour à la liste
                    </a>
                </div>
            </div>
        </div>

        <% if (latestMeteo != null) { %>
        <div class="stats-grid">
            <div class="stat-box">
                <div class="icon">💧</div>
                <div class="value"><%= String.format("%.0f", latestMeteo.getHumidite()) %>%</div>
                <div class="label">Humidité</div>
            </div>
            <div class="stat-box">
                <div class="icon">⬇️</div>
                <div class="value"><%= String.format("%.0f", latestMeteo.getPression()) %></div>
                <div class="label">Pression (hPa)</div>
            </div>
            <div class="stat-box">
                <div class="icon">👁️</div>
                <div class="value"><%= latestMeteo.getVisibilite() / 1000.0 %></div>
                <div class="label">Visibilité (km)</div>
            </div>
            <div class="stat-box">
                <div class="icon">🌧️</div>
                <div class="value"><%= String.format("%.1f", latestMeteo.getPrecipitation()) %></div>
                <div class="label">Précipitations (mm)</div>
            </div>
        </div>
        <% } %>
    </div>
</section>

<%-- Historique --%>
<div class="container">
    <div class="history-section">
        <div class="history-title">
            <h3>Historique des mesures (<%= mesures != null ? mesures.size() : 0 %>)</h3>
        </div>

        <% if (mesures != null && !mesures.isEmpty()) { %>
        <%
            // Trier les dates par ordre décroissant
            List<Date> sortedDates = new ArrayList<>(mesures.keySet());
            Collections.sort(sortedDates, Collections.reverseOrder());
        %>
        <div class="table-responsive">
            <table class="table history-table">
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Température</th>
                    <th>Description</th>
                    <th>Humidité</th>
                    <th>Pression</th>
                </tr>
                </thead>
                <tbody>
                <% for (Date date : sortedDates) {
                    Meteo m = mesures.get(date);
                    String tempClass = "temp-cool";
                    if (m.getTemperature() >= 30) tempClass = "temp-hot";
                    else if (m.getTemperature() >= 20) tempClass = "temp-warm";
                    else if (m.getTemperature() < 5) tempClass = "temp-cold";
                %>
                <tr>
                    <td><strong><%= dateFormat.format(date) %></strong></td>
                    <td>
                                    <span class="temp-badge <%= tempClass %>">
                                        <%= String.format("%.1f", m.getTemperature()) %>°C
                                    </span>
                    </td>
                    <td><%= m.getDescription() != null ? m.getDescription() : "—" %></td>
                    <td>💧 <%= String.format("%.0f", m.getHumidite()) %>%</td>
                    <td><%= String.format("%.0f", m.getPression()) %> hPa</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="text-center py-4">
            <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/351.png"
                 width="80" alt="Morphéo" style="opacity: 0.5;">
            <p class="text-muted mt-3">Aucune mesure enregistrée pour cette station.</p>
            <a href="<%= application.getContextPath() %>/refresh?id=<%= station.getNumero() %>" class="btn btn-pokemon">
                ↻ Récupérer les données
            </a>
        </div>
        <% } %>
    </div>
</div>

<% } %>

<div class="py-4"></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
