<%@ page import="ch.weather.meteo.business.StationMeteo" %>
<%@ page import="ch.weather.meteo.business.Meteo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Classement - MorphéoMétéo</title>
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

        .ranking-header {
            background: linear-gradient(135deg, #3B5CA8 0%, #1E3A6E 100%);
            color: white;
            padding: 2rem 0;
            border-bottom: 5px solid var(--pokemon-yellow);
            text-align: center;
        }

        .ranking-header h1 {
            color: var(--pokemon-yellow);
            font-weight: 800;
            text-shadow: 2px 2px 0 rgba(0,0,0,0.3);
        }

        .morpheo-vs {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 2rem;
            margin: 1.5rem 0;
        }

        .morpheo-vs img {
            width: 80px;
            filter: drop-shadow(0 5px 15px rgba(0,0,0,0.3));
        }

        .morpheo-vs img:first-child {
            animation: bounce-left 1s ease-in-out infinite;
        }

        .morpheo-vs img:last-child {
            animation: bounce-right 1s ease-in-out infinite;
        }

        @keyframes bounce-left {
            0%, 100% { transform: translateX(0) rotate(-5deg); }
            50% { transform: translateX(-10px) rotate(5deg); }
        }

        @keyframes bounce-right {
            0%, 100% { transform: translateX(0) rotate(5deg); }
            50% { transform: translateX(10px) rotate(-5deg); }
        }

        .vs-text {
            font-size: 2rem;
            font-weight: 800;
            color: var(--pokemon-yellow);
            text-shadow: 2px 2px 0 rgba(0,0,0,0.3);
        }

        .ranking-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 2rem;
            padding: 2rem 0;
        }

        .ranking-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
            border: 3px solid #eee;
        }

        .ranking-card.hot {
            border-top: 8px solid #F7A831;
        }

        .ranking-card.cold {
            border-top: 8px solid #99D8D8;
        }

        .ranking-card-header {
            padding: 1.5rem;
            text-align: center;
        }

        .ranking-card.hot .ranking-card-header {
            background: linear-gradient(135deg, #FFF8E7 0%, #FFE8B8 100%);
        }

        .ranking-card.cold .ranking-card-header {
            background: linear-gradient(135deg, #F0FFFF 0%, #D8F5F5 100%);
        }

        .ranking-card-header img {
            width: 70px;
            animation: float 2s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        .ranking-card-header h3 {
            font-weight: 800;
            margin-top: 0.5rem;
            margin-bottom: 0;
        }

        .ranking-card.hot .ranking-card-header h3 { color: #E67E00; }
        .ranking-card.cold .ranking-card-header h3 { color: #5BBDBD; }

        .ranking-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .ranking-item {
            display: flex;
            align-items: center;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #eee;
            transition: all 0.2s ease;
            text-decoration: none;
            color: inherit;
        }

        .ranking-item:hover {
            background: #f8f9fa;
            transform: translateX(5px);
        }

        .ranking-item:last-child {
            border-bottom: none;
        }

        .rank-badge {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 1.1rem;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .rank-1 { background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%); color: #333; }
        .rank-2 { background: linear-gradient(135deg, #E8E8E8 0%, #C0C0C0 100%); color: #333; }
        .rank-3 { background: linear-gradient(135deg, #CD7F32 0%, #8B4513 100%); color: white; }
        .rank-other { background: #e9ecef; color: #666; }

        .station-info {
            flex-grow: 1;
        }

        .station-info .name {
            font-weight: 700;
            color: #333;
            font-size: 1.1rem;
        }

        .station-info .country {
            font-size: 0.85rem;
            color: #888;
        }

        .station-temp {
            font-size: 1.5rem;
            font-weight: 800;
            text-align: right;
        }

        .ranking-card.hot .station-temp { color: #E67E00; }
        .ranking-card.cold .station-temp { color: #5BBDBD; }

        .limit-selector {
            background: white;
            border-radius: 30px;
            padding: 0.5rem;
            display: inline-flex;
            gap: 0.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .limit-btn {
            padding: 0.5rem 1.2rem;
            border-radius: 20px;
            border: none;
            background: transparent;
            font-weight: 700;
            color: #666;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .limit-btn:hover {
            background: #f0f0f0;
        }

        .limit-btn.active {
            background: var(--pokemon-blue);
            color: white;
        }

        .empty-ranking {
            text-align: center;
            padding: 3rem;
        }

        .empty-ranking img {
            width: 100px;
            opacity: 0.5;
        }

        .btn-pokemon {
            background: linear-gradient(180deg, #E3350D 0%, #B22D0D 100%);
            border: 3px solid #8B1E08;
            color: white;
            font-weight: 700;
            border-radius: 30px;
            padding: 0.8rem 2rem;
            box-shadow: 0 4px 0 #8B1E08;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-pokemon:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 #8B1E08;
        }
    </style>
</head>
<body>
<% String activePage = "top"; %>
<%@ include file="menu.jsp" %>

<%
    @SuppressWarnings("unchecked")
    List<Object[]> hottestStations = (List<Object[]>) request.getAttribute("hottestStations");
    @SuppressWarnings("unchecked")
    List<Object[]> coldestStations = (List<Object[]>) request.getAttribute("coldestStations");
    Integer limit = (Integer) request.getAttribute("limit");
    if (limit == null) limit = 5;
%>

<%-- Header --%>
<section class="ranking-header">
    <div class="container">
        <div class="morpheo-vs">
            <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10013.png" alt="Morphéo Soleil">
            <span class="vs-text">VS</span>
            <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10015.png" alt="Morphéo Neige">
        </div>
        <h1>Classement des Stations</h1>
        <p class="opacity-75 mb-4">Qui sera la plus chaude ? La plus froide ?</p>

        <%-- Sélecteur de limite --%>
        <form method="get" class="d-inline-block">
            <div class="limit-selector">
                <button type="submit" name="limit" value="3" class="limit-btn <%= limit == 3 ? "active" : "" %>">Top 3</button>
                <button type="submit" name="limit" value="5" class="limit-btn <%= limit == 5 ? "active" : "" %>">Top 5</button>
                <button type="submit" name="limit" value="10" class="limit-btn <%= limit == 10 ? "active" : "" %>">Top 10</button>
            </div>
        </form>
    </div>
</section>

<main class="container py-4">
    <% if ((hottestStations == null || hottestStations.isEmpty()) && (coldestStations == null || coldestStations.isEmpty())) { %>
    <div class="empty-ranking">
        <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/351.png" alt="Morphéo">
        <h3 class="mt-4" style="color: var(--pokemon-blue);">Aucune donnée disponible</h3>
        <p class="text-muted mb-4">Capturez des stations et récupérez leurs données pour voir le classement !</p>
        <a href="<%= application.getContextPath() %>/ajouter-station" class="btn-pokemon">
            + Capturer une station
        </a>
    </div>
    <% } else { %>

    <div class="ranking-container">
        <%-- Classement Chaud --%>
        <div class="ranking-card hot">
            <div class="ranking-card-header">
                <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10013.png" alt="Morphéo Soleil">
                <h3>🔥 Les plus chaudes</h3>
            </div>

            <% if (hottestStations != null && !hottestStations.isEmpty()) { %>
            <ul class="ranking-list">
                <%
                    int rankHot = 1;
                    for (Object[] data : hottestStations) {
                        Meteo meteo = (Meteo) data[0];
                        StationMeteo station = (StationMeteo) data[1];
                        String rankClass = rankHot <= 3 ? "rank-" + rankHot : "rank-other";
                %>
                <a href="<%= application.getContextPath() %>/station?id=<%= station.getNumero() %>" class="ranking-item">
                    <span class="rank-badge <%= rankClass %>"><%= rankHot %></span>
                    <div class="station-info">
                        <div class="name"><%= station.getNom() %></div>
                        <% if (station.getPays() != null) { %>
                        <div class="country"><%= station.getPays().getNom() %></div>
                        <% } %>
                    </div>
                    <div class="station-temp">
                        <%= String.format("%.1f", meteo.getTemperature()) %>°C
                    </div>
                </a>
                <% rankHot++; } %>
            </ul>
            <% } else { %>
            <div class="empty-ranking">
                <p class="text-muted">Aucune donnée</p>
            </div>
            <% } %>
        </div>

        <%-- Classement Froid --%>
        <div class="ranking-card cold">
            <div class="ranking-card-header">
                <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10015.png" alt="Morphéo Neige">
                <h3>❄️ Les plus froides</h3>
            </div>

            <% if (coldestStations != null && !coldestStations.isEmpty()) { %>
            <ul class="ranking-list">
                <%
                    int rankCold = 1;
                    for (Object[] data : coldestStations) {
                        Meteo meteo = (Meteo) data[0];
                        StationMeteo station = (StationMeteo) data[1];
                        String rankClass = rankCold <= 3 ? "rank-" + rankCold : "rank-other";
                %>
                <a href="<%= application.getContextPath() %>/station?id=<%= station.getNumero() %>" class="ranking-item">
                    <span class="rank-badge <%= rankClass %>"><%= rankCold %></span>
                    <div class="station-info">
                        <div class="name"><%= station.getNom() %></div>
                        <% if (station.getPays() != null) { %>
                        <div class="country"><%= station.getPays().getNom() %></div>
                        <% } %>
                    </div>
                    <div class="station-temp">
                        <%= String.format("%.1f", meteo.getTemperature()) %>°C
                    </div>
                </a>
                <% rankCold++; } %>
            </ul>
            <% } else { %>
            <div class="empty-ranking">
                <p class="text-muted">Aucune donnée</p>
            </div>
            <% } %>
        </div>
    </div>

    <%-- Bouton rafraîchir --%>
    <div class="text-center mt-4">
        <a href="<%= application.getContextPath() %>/refresh?all=true" class="btn-pokemon">
            ↻ Rafraîchir toutes les données
        </a>
    </div>

    <% } %>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
