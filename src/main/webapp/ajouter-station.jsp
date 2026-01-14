<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Capturer une station - MorphéoMétéo</title>
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

        .capture-container {
            max-width: 600px;
            margin: 2rem auto;
        }

        .capture-card {
            background: white;
            border-radius: 20px;
            border: 4px solid var(--pokemon-blue);
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
            overflow: hidden;
        }

        .capture-header {
            background: linear-gradient(135deg, #3B5CA8 0%, #1E3A6E 100%);
            color: white;
            padding: 2rem;
            text-align: center;
            position: relative;
        }

        .morpheo-capture {
            width: 100px;
            animation: excited 0.5s ease-in-out infinite;
        }

        @keyframes excited {
            0%, 100% { transform: translateY(0) rotate(-3deg); }
            50% { transform: translateY(-10px) rotate(3deg); }
        }

        .capture-header h2 {
            color: var(--pokemon-yellow);
            font-weight: 800;
            text-shadow: 2px 2px 0 rgba(0,0,0,0.3);
            margin-top: 1rem;
        }

        .capture-body {
            padding: 2rem;
        }

        .form-label {
            font-weight: 700;
            color: var(--pokemon-blue);
        }

        .form-control {
            border: 3px solid #ddd;
            border-radius: 15px;
            padding: 0.8rem 1rem;
            font-size: 1.1rem;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            border-color: var(--pokemon-blue);
            box-shadow: 0 0 0 3px rgba(59, 92, 168, 0.2);
        }

        .btn-capture {
            background: linear-gradient(180deg, #E3350D 0%, #B22D0D 100%);
            border: 3px solid #8B1E08;
            color: white;
            font-weight: 700;
            border-radius: 30px;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 4px 0 #8B1E08;
            transition: all 0.2s ease;
            width: 100%;
        }

        .btn-capture:hover {
            background: linear-gradient(180deg, #FF4520 0%, #E3350D 100%);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 0 #8B1E08;
        }

        .btn-capture:active {
            transform: translateY(2px);
            box-shadow: 0 2px 0 #8B1E08;
        }

        .pokeball-divider {
            display: flex;
            align-items: center;
            margin: 1.5rem 0;
        }

        .pokeball-divider::before,
        .pokeball-divider::after {
            content: '';
            flex: 1;
            height: 3px;
            background: #eee;
        }

        .pokeball-divider svg {
            margin: 0 1rem;
            width: 30px;
            height: 30px;
        }

        .examples-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 1.5rem;
            border: 2px dashed #ccc;
        }

        .examples-card h5 {
            color: var(--pokemon-blue);
            font-weight: 700;
        }

        .example-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #ddd;
        }

        .example-item:last-child {
            border-bottom: none;
        }

        .example-item .city {
            font-weight: 600;
        }

        .example-item .coords {
            color: #666;
            font-family: monospace;
        }

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

        .success-pokemon {
            text-align: center;
            padding: 1rem;
        }

        .success-pokemon img {
            width: 80px;
            animation: celebrate 0.5s ease-in-out infinite;
        }

        @keyframes celebrate {
            0%, 100% { transform: scale(1) rotate(-5deg); }
            50% { transform: scale(1.1) rotate(5deg); }
        }
    </style>
</head>
<body>
<% String activePage = "ajouter"; %>
<%@ include file="menu.jsp" %>

<main class="container py-4">
    <div class="capture-container">

        <%-- Message de succès --%>
        <% String success = (String) request.getAttribute("success"); %>
        <% if (success != null && !success.isEmpty()) { %>
        <div class="alert alert-pokemon-success alert-dismissible fade show" role="alert">
            <div class="success-pokemon">
                <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/351.png" alt="Morphéo content">
            </div>
            <div class="text-center">
                <strong>🎉 Félicitations !</strong><br>
                <%= success %>
            </div>
            <%
                ch.weather.meteo.business.StationMeteo station =
                        (ch.weather.meteo.business.StationMeteo) request.getAttribute("station");
                if (station != null) {
            %>
            <hr>
            <div class="text-center">
                <a href="<%= application.getContextPath() %>/station?id=<%= station.getNumero() %>" class="btn btn-light btn-sm">
                    👁️ Voir la station capturée
                </a>
            </div>
            <% } %>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <%-- Message d'erreur --%>
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-pokemon-danger alert-dismissible fade show" role="alert">
            <strong>😢 La capture a échoué !</strong><br>
            <%= error %>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <div class="capture-card">
            <div class="capture-header">
                <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/351.png"
                     alt="Morphéo" class="morpheo-capture">
                <h2>Capturer une station</h2>
                <p class="mb-0 opacity-75">Entrez les coordonnées GPS pour découvrir la météo !</p>
            </div>

            <div class="capture-body">
                <form action="ajouter-station" method="post" class="needs-validation" novalidate>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="latitude" class="form-label">📍 Latitude</label>
                            <input type="number"
                                   class="form-control"
                                   id="latitude"
                                   name="latitude"
                                   required
                                   min="-90"
                                   max="90"
                                   step="0.000001"
                                   placeholder="Ex: 46.9480"
                                   value="<%= (request.getAttribute("success") == null && request.getParameter("latitude") != null) ? request.getParameter("latitude") : "" %>">
                            <div class="form-text">Entre -90 et 90</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="longitude" class="form-label">📍 Longitude</label>
                            <input type="number"
                                   class="form-control"
                                   id="longitude"
                                   name="longitude"
                                   required
                                   min="-180"
                                   max="180"
                                   step="0.000001"
                                   placeholder="Ex: 6.8981"
                                   value="<%= (request.getAttribute("success") == null && request.getParameter("longitude") != null) ? request.getParameter("longitude") : "" %>">
                            <div class="form-text">Entre -180 et 180</div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-capture mt-3">
                        Lancer la Pokéball !
                    </button>
                </form>

                <div class="pokeball-divider">
                    <svg viewBox="0 0 100 100">
                        <circle cx="50" cy="50" r="45" fill="#E3350D" stroke="#333" stroke-width="3"/>
                        <rect x="5" y="47" width="90" height="6" fill="#333"/>
                        <circle cx="50" cy="50" r="45" fill="#fff" style="clip-path: polygon(0 50%, 100% 50%, 100% 100%, 0 100%)"/>
                        <circle cx="50" cy="50" r="45" fill="none" stroke="#333" stroke-width="3"/>
                        <circle cx="50" cy="50" r="12" fill="#fff" stroke="#333" stroke-width="3"/>
                    </svg>
                </div>

                <div class="examples-card">
                    <h5>💡 Exemples de coordonnées</h5>
                    <div class="example-item">
                        <span class="city">🇨🇭 La Chaux-de-Fonds</span>
                        <span class="coords">47.0997, 6.8261</span>
                    </div>
                    <div class="example-item">
                        <span class="city">🇨🇭 Neuchâtel</span>
                        <span class="coords">46.9920, 6.9311</span>
                    </div>
                    <div class="example-item">
                        <span class="city">🇨🇭 Genève</span>
                        <span class="coords">46.2044, 6.1432</span>
                    </div>
                    <div class="example-item">
                        <span class="city">🇫🇷 Paris</span>
                        <span class="coords">48.8566, 2.3522</span>
                    </div>
                    <div class="example-item">
                        <span class="city">🇯🇵 Tokyo</span>
                        <span class="coords">35.6762, 139.6503</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()
</script>
</body>
</html>
