<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ajouter une station - HEG Météo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
</head>
<body>
<% String activePage = "ajouter"; %>
<%@ include file="menu.jsp" %>

<main class="container-fluid">
    <div class="p-5 rounded">
        <h2 class="mb-4">Ajouter une station météo</h2>

        <%-- Affichage des messages de succès --%>
        <% String success = (String) request.getAttribute("success"); %>
        <% if (success != null && !success.isEmpty()) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>✅ Succès!</strong> <%= success %>
            <%
                ch.weather.meteo.business.StationMeteo station =
                        (ch.weather.meteo.business.StationMeteo) request.getAttribute("station");
                if (station != null) {
            %>
            <hr>
            <p class="mb-0">
                <a href="<%= application.getContextPath() %>/station?id=<%= station.getNumero() %>" class="alert-link">
                    Voir les détails de la station →
                </a>
            </p>
            <% } %>
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

        <p class="text-muted mb-4">
            Entrez les coordonnées GPS de la station météo que vous souhaitez ajouter.
            Les données seront récupérées automatiquement depuis OpenWeatherMap.
        </p>

        <form action="ajouter-station" method="post" class="needs-validation" novalidate>
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="latitude" class="form-label">Latitude</label>
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
                        <div class="form-text">Valeur entre -90 et 90</div>
                        <div class="invalid-feedback">
                            Veuillez entrer une latitude valide.
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="longitude" class="form-label">Longitude</label>
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
                        <div class="form-text">Valeur entre -180 et 180</div>
                        <div class="invalid-feedback">
                            Veuillez entrer une longitude valide.
                        </div>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <button type="submit" class="btn btn-primary">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search me-1" viewBox="0 0 16 16">
                        <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
                    </svg>
                    Rechercher et ajouter la station météo
                </button>
            </div>
        </form>

        <hr class="my-4">

        <div class="card bg-light">
            <div class="card-body">
                <h5 class="card-title">Exemples de coordonnées</h5>
                <ul class="list-unstyled mb-0">
                    <li><strong>La Chaux-de-Fonds:</strong> 47.0997, 6.8261</li>
                    <li><strong>Neuchâtel:</strong> 46.9920, 6.9311</li>
                    <li><strong>Genève:</strong> 46.2044, 6.1432</li>
                    <li><strong>Zurich:</strong> 47.3769, 8.5417</li>
                    <li><strong>Paris:</strong> 48.8566, 2.3522</li>
                </ul>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>

<script>
    // Validation côté client Bootstrap
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
