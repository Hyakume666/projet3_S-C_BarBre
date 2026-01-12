<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>HEG - Meteo</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
</head>
<body>
<% String activePage = "ajouter"; %>
<%@ include file="menu.jsp" %>
<main class="container-fluid">
  <div class="p-5 rounded">
    <form action="ajouter-station" method="post">
      <div class="mb-3">
        <label for="nom" class="form-label">Latitude</label>
        <!-- La latitude est un nombre décimal, compris entre -90 et 90 -->
        <input type="number" class="form-control" id="latitude" name="latitude" required min="-90" max="90" step="0.000001">
      </div>
      <div class="mb-3">
        <label for="nom" class="form-label">Longitude</label>
        <!-- La longitude est un nombre décimal, compris entre -180 et 180 -->
        <input type="text" class="form-control" id="longitude" name="longitude" required min="-180" max="180" step="0.000001">
      </div>
      <div class="mb-3">
        <button type="submit" class="btn btn-primary">Rechercher et ajouter la station météo</button>
      </div>
    </form>
  </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>
