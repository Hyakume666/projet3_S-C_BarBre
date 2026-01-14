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
    <title>MorphéoMétéo - Stations Météo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --pokemon-red: #E3350D;
            --pokemon-blue: #3B5CA8;
            --pokemon-yellow: #FFCB05;
            --pokemon-gold: #B69E31;
            --morpheo-normal: #9CA0A8;
            --morpheo-sun: #F89B Pokemon24;
            --morpheo-rain: #6390F0;
            --morpheo-snow: #99D8D8;
            --morpheo-sun: #F7A831;
        }

        * {
            font-family: 'Nunito', sans-serif;
        }

        body {
            background: linear-gradient(180deg, #87CEEB 0%, #E0F6FF 50%, #fff 100%);
            min-height: 100vh;
        }

        /* Hero Section Style Pokémon */
        .hero-pokemon {
            background: linear-gradient(135deg, #3B5CA8 0%, #1E3A6E 100%);
            border-bottom: 5px solid var(--pokemon-yellow);
            padding: 2.5rem 0;
            position: relative;
            overflow: hidden;
        }

        .hero-pokemon::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Ccircle cx='50' cy='50' r='45' fill='none' stroke='rgba(255,255,255,0.03)' stroke-width='2'/%3E%3Cline x1='50' y1='5' x2='50' y2='95' stroke='rgba(255,255,255,0.03)' stroke-width='2'/%3E%3Ccircle cx='50' cy='50' r='12' fill='rgba(255,255,255,0.03)'/%3E%3C/svg%3E") repeat;
            background-size: 60px 60px;
            animation: pokeball-float 30s linear infinite;
        }

        @keyframes pokeball-float {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .app-title {
            color: var(--pokemon-yellow);
            font-weight: 800;
            text-shadow: 3px 3px 0 #2A4A7C,
            -1px -1px 0 #2A4A7C,
            1px -1px 0 #2A4A7C,
            -1px 1px 0 #2A4A7C;
            font-size: 2.8rem;
        }

        .morpheo-hero {
            width: 120px;
            height: 120px;
            animation: bounce 2s ease-in-out infinite;
            filter: drop-shadow(0 10px 20px rgba(0,0,0,0.3));
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }

        /* Stat Cards */
        .stat-pokemon {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 1.2rem;
            text-align: center;
            border: 3px solid var(--pokemon-yellow);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            transition: transform 0.3s ease;
        }

        .stat-pokemon:hover {
            transform: scale(1.05);
        }

        .stat-pokemon .stat-number {
            font-size: 2rem;
            font-weight: 800;
            color: var(--pokemon-blue);
        }

        .stat-pokemon .stat-label {
            color: #666;
            font-weight: 600;
            font-size: 0.85rem;
        }

        /* Boutons style Pokémon */
        .btn-pokemon-primary {
            background: linear-gradient(180deg, #E3350D 0%, #B22D0D 100%);
            border: 3px solid #8B1E08;
            color: white;
            font-weight: 700;
            border-radius: 30px;
            padding: 0.8rem 1.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 4px 0 #8B1E08;
            transition: all 0.2s ease;
        }

        .btn-pokemon-primary:hover {
            background: linear-gradient(180deg, #FF4520 0%, #E3350D 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 #8B1E08;
        }

        .btn-pokemon-primary:active {
            transform: translateY(2px);
            box-shadow: 0 2px 0 #8B1E08;
        }

        .btn-pokemon-secondary {
            background: linear-gradient(180deg, var(--pokemon-yellow) 0%, #D4A904 100%);
            border: 3px solid #A68500;
            color: #333;
            font-weight: 700;
            border-radius: 30px;
            padding: 0.8rem 1.8rem;
            box-shadow: 0 4px 0 #A68500;
            transition: all 0.2s ease;
        }

        .btn-pokemon-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 0 #A68500;
            color: #333;
        }

        /* Station Cards - Style Pokémon Card */
        .pokemon-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            transition: all 0.3s ease;
            height: 100%;
            border: 3px solid #e0e0e0;
        }

        .pokemon-card:hover {
            transform: translateY(-10px) rotate(1deg);
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
            border-color: var(--pokemon-yellow);
        }

        .pokemon-card.type-sun {
            border-top: 8px solid #F7A831;
        }

        .pokemon-card.type-rain {
            border-top: 8px solid #6390F0;
        }

        .pokemon-card.type-snow {
            border-top: 8px solid #99D8D8;
        }

        .pokemon-card.type-normal {
            border-top: 8px solid #9CA0A8;
        }

        .card-header-pokemon {
            padding: 1.5rem;
            text-align: center;
            position: relative;
        }

        .type-sun .card-header-pokemon {
            background: linear-gradient(180deg, #FFF8E7 0%, #FFE8B8 100%);
        }

        .type-rain .card-header-pokemon {
            background: linear-gradient(180deg, #E8F4FF 0%, #B8D8FF 100%);
        }

        .type-snow .card-header-pokemon {
            background: linear-gradient(180deg, #F0FFFF 0%, #D8F5F5 100%);
        }

        .type-normal .card-header-pokemon {
            background: linear-gradient(180deg, #F8F8F8 0%, #E8E8E8 100%);
        }

        .morpheo-sprite {
            width: 96px;
            height: 96px;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        .pokemon-card .temperature {
            font-size: 2.5rem;
            font-weight: 800;
            margin: 0.5rem 0;
        }

        .type-sun .temperature { color: #E67E00; }
        .type-rain .temperature { color: #3A6BC6; }
        .type-snow .temperature { color: #5BBDBD; }
        .type-normal .temperature { color: #6B6F78; }

        .pokemon-card .city-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 0.25rem;
        }

        .pokemon-card .country-badge {
            display: inline-block;
            background: var(--pokemon-blue);
            color: white;
            padding: 0.2rem 0.8rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .pokemon-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.5rem;
            padding: 1rem;
            background: #f8f9fa;
        }

        .pokemon-stat {
            background: white;
            border-radius: 10px;
            padding: 0.6rem;
            text-align: center;
            border: 2px solid #eee;
        }

        .pokemon-stat .label {
            font-size: 0.65rem;
            color: #888;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .pokemon-stat .value {
            font-size: 1rem;
            font-weight: 700;
            color: #333;
        }

        .card-actions {
            display: flex;
            gap: 0.5rem;
            padding: 1rem;
            border-top: 2px solid #eee;
        }

        .card-actions .btn {
            flex: 1;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        /* Empty State */
        .empty-state-pokemon {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 20px;
            border: 3px dashed #ddd;
            margin: 2rem 0;
        }

        .empty-state-pokemon .morpheo-sad {
            width: 150px;
            opacity: 0.8;
            animation: sad-bounce 2s ease-in-out infinite;
        }

        @keyframes sad-bounce {
            0%, 100% { transform: translateY(0) rotate(-5deg); }
            50% { transform: translateY(-10px) rotate(5deg); }
        }

        /* Section Title */
        .section-title-pokemon {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .section-title-pokemon h2 {
            font-weight: 800;
            color: var(--pokemon-blue);
            margin: 0;
            text-shadow: 2px 2px 0 rgba(59, 92, 168, 0.1);
        }

        .pokeball-icon {
            width: 40px;
            height: 40px;
        }

        /* Footer */
        footer {
            background: linear-gradient(180deg, #2A4A7C 0%, #1E3A6E 100%);
            border-top: 5px solid var(--pokemon-yellow);
            color: white;
            padding: 2rem 0;
            margin-top: 3rem;
        }

        footer a {
            color: var(--pokemon-yellow);
        }

        footer h5 {
            color: var(--pokemon-yellow);
            font-weight: 700;
        }

        /* Alerts */
        .alert-pokemon-success {
            background: linear-gradient(90deg, #78C850 0%, #5CA935 100%);
            border: none;
            color: white;
            border-radius: 15px;
            font-weight: 600;
        }

        .alert-pokemon-danger {
            background: linear-gradient(90deg, #E3350D 0%, #B22D0D 100%);
            border: none;
            color: white;
            border-radius: 15px;
            font-weight: 600;
        }

        .measurements-badge {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: var(--pokemon-blue);
            color: white;
            padding: 0.2rem 0.6rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 700;
        }

        .last-update-badge {
            font-size: 0.75rem;
            color: #888;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
<% String activePage = "index"; %>
<%@ include file="menu.jsp" %>

<%-- Récupération des données --%>
<%
    @SuppressWarnings("unchecked")
    List<StationMeteo> stations = (List<StationMeteo>) request.getAttribute("stations");
    if (stations == null) {
        stations = new ArrayList<>();
    }

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
<section class="hero-pokemon">
    <div class="container hero-content">
        <div class="row align-items-center">
            <div class="col-lg-7 text-white mb-4 mb-lg-0">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/351.png"
                         alt="Morphéo" class="morpheo-hero">
                    <div>
                        <h1 class="app-title mb-0">MorphéoMétéo</h1>
                        <p class="mb-0 opacity-75">Votre assistant météo qui s'adapte au temps !</p>
                    </div>
                </div>
                <p class="lead mb-4 opacity-90">
                    Comme Morphéo change de forme selon la météo, suivez vos stations et découvrez
                    les conditions atmosphériques en temps réel !
                </p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="<%= application.getContextPath() %>/ajouter-station" class="btn btn-pokemon-primary">
                        + Capturer une station
                    </a>
                    <% if (!stations.isEmpty()) { %>
                    <a href="<%= application.getContextPath() %>/refresh?all=true" class="btn btn-pokemon-secondary">
                        ↻ Rafraîchir tout
                    </a>
                    <% } %>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="row g-3">
                    <div class="col-6">
                        <div class="stat-pokemon">
                            <div class="stat-number"><%= totalStations %></div>
                            <div class="stat-label">Stations</div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="stat-pokemon">
                            <div class="stat-number"><%= totalMeasurements %></div>
                            <div class="stat-label">Mesures</div>
                        </div>
                    </div>
                    <% if (maxTemp != null) { %>
                    <div class="col-6">
                        <div class="stat-pokemon">
                            <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10013.png"
                                 width="40" alt="Soleil">
                            <div class="stat-number" style="color: #E67E00;"><%= String.format("%.1f", maxTemp) %>°</div>
                            <div class="stat-label"><%= hottestCity %></div>
                        </div>
                    </div>
                    <% } %>
                    <% if (minTemp != null) { %>
                    <div class="col-6">
                        <div class="stat-pokemon">
                            <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10015.png"
                                 width="40" alt="Neige">
                            <div class="stat-number" style="color: #5BBDBD;"><%= String.format("%.1f", minTemp) %>°</div>
                            <div class="stat-label"><%= coldestCity %></div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</section>

<main class="container py-4">
    <%-- Messages --%>
    <% String success = (String) request.getAttribute("success"); %>
    <% if (success != null && !success.isEmpty()) { %>
    <div class="alert alert-pokemon-success alert-dismissible fade show" role="alert">
        ✨ <strong>Super !</strong> <%= success %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null && !error.isEmpty()) { %>
    <div class="alert alert-pokemon-danger alert-dismissible fade show" role="alert">
        ⚠️ <strong>Oups !</strong> <%= error %>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (stations.isEmpty()) { %>
    <%-- État vide --%>
    <div class="empty-state-pokemon">
        <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/351.png"
             alt="Morphéo triste" class="morpheo-sad mb-4">
        <h2 class="mb-3" style="color: var(--pokemon-blue);">Aucune station capturée !</h2>
        <p class="text-muted mb-4">
            Morphéo attend impatiemment de découvrir la météo de nouvelles villes.<br>
            Capturez votre première station pour commencer l'aventure !
        </p>
        <a href="<%= application.getContextPath() %>/ajouter-station" class="btn btn-pokemon-primary btn-lg">
            + Capturer ma première station
        </a>
    </div>
    <% } else { %>
    <%-- Liste des stations --%>
    <div class="section-title-pokemon">
        <svg class="pokeball-icon" viewBox="0 0 100 100">
            <circle cx="50" cy="50" r="45" fill="#E3350D" stroke="#333" stroke-width="3"/>
            <rect x="5" y="47" width="90" height="6" fill="#333"/>
            <circle cx="50" cy="50" r="45" fill="#fff" clip-path="polygon(0 50%, 100% 50%, 100% 100%, 0 100%)"/>
            <circle cx="50" cy="50" r="45" fill="none" stroke="#333" stroke-width="3"/>
            <circle cx="50" cy="50" r="15" fill="#fff" stroke="#333" stroke-width="3"/>
            <circle cx="50" cy="50" r="8" fill="#fff" stroke="#333" stroke-width="2"/>
        </svg>
        <h2>Mes Stations (<%= totalStations %>)</h2>
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
        <div class="col-md-6 col-lg-4">
            <div class="pokemon-card type-<%= morpheoType %>">
                <div class="card-header-pokemon">
                    <% if (mesures != null && !mesures.isEmpty()) { %>
                    <span class="measurements-badge">
                                    <%= mesures.size() %> mesure<%= mesures.size() > 1 ? "s" : "" %>
                                </span>
                    <% } %>

                    <img src="<%= morpheoSprite %>" alt="Morphéo" class="morpheo-sprite">

                    <% if (latestMeteo != null) { %>
                    <div class="temperature">
                        <%= String.format("%.1f", latestMeteo.getTemperature()) %>°C
                    </div>
                    <div class="text-muted"><%= latestMeteo.getDescription() != null ? latestMeteo.getDescription() : "—" %></div>
                    <% } else { %>
                    <div class="temperature" style="color: #999;">—°C</div>
                    <div class="text-muted">Aucune donnée</div>
                    <% } %>

                    <div class="city-name mt-2"><%= station.getNom() %></div>

                    <% if (station.getPays() != null) { %>
                    <span class="country-badge"><%= station.getPays().getNom() %></span>
                    <% } %>

                    <% if (latestDate != null) { %>
                    <div class="last-update-badge">🕐 <%= dateFormat.format(latestDate) %></div>
                    <% } %>
                </div>

                <% if (latestMeteo != null) { %>
                <div class="pokemon-stats">
                    <div class="pokemon-stat">
                        <div class="label">Humidité</div>
                        <div class="value">💧 <%= String.format("%.0f", latestMeteo.getHumidite()) %>%</div>
                    </div>
                    <div class="pokemon-stat">
                        <div class="label">Pression</div>
                        <div class="value">⬇️ <%= String.format("%.0f", latestMeteo.getPression()) %></div>
                    </div>
                    <div class="pokemon-stat">
                        <div class="label">Visibilité</div>
                        <div class="value">👁️ <%= latestMeteo.getVisibilite() / 1000.0 %> km</div>
                    </div>
                    <div class="pokemon-stat">
                        <div class="label">Pluie</div>
                        <div class="value">🌧️ <%= String.format("%.1f", latestMeteo.getPrecipitation()) %> mm</div>
                    </div>
                </div>
                <% } %>

                <div class="card-actions">
                    <a href="<%= application.getContextPath() %>/station?id=<%= station.getNumero() %>" class="btn btn-outline-primary">
                        👁️ Détails
                    </a>
                    <a href="<%= application.getContextPath() %>/refresh?id=<%= station.getNumero() %>" class="btn btn-outline-success">
                        ↻ Rafraîchir
                    </a>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <%-- Lien classement --%>
    <div class="text-center mt-5">
        <a href="<%= application.getContextPath() %>/top-stations" class="btn btn-pokemon-secondary btn-lg">
            Voir le classement Chaud / Froid
        </a>
    </div>
    <% } %>
</main>

<%-- Footer --%>
<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5>🌤️ MorphéoMétéo</h5>
                <p class="opacity-75">
                    Application météo inspirée par Morphéo, le Pokémon qui change de forme selon le temps !
                    Projet Services et Composants - HE-Arc Neuchâtel.
                </p>
            </div>
            <div class="col-md-3">
                <h6 class="text-white">Navigation</h6>
                <ul class="list-unstyled">
                    <li><a href="<%= application.getContextPath() %>/stations">Accueil</a></li>
                    <li><a href="<%= application.getContextPath() %>/ajouter-station">Ajouter</a></li>
                    <li><a href="<%= application.getContextPath() %>/top-stations">Classement</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h6 class="text-white">Crédits</h6>
                <ul class="list-unstyled">
                    <li><a href="https://openweathermap.org/" target="_blank">OpenWeatherMap</a></li>
                    <li><a href="https://pokeapi.co/" target="_blank">PokéAPI</a></li>
                </ul>
            </div>
        </div>
        <hr class="my-4 opacity-25">
        <div class="text-center opacity-50">
            <small>© 2025-2026 HE-Arc - Pokémon et Morphéo sont des marques de Nintendo/Game Freak</small>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
