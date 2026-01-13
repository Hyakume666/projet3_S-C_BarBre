package ch.weather.meteo.servlets;

import ch.weather.meteo.business.StationMeteo;
import ch.weather.meteo.service.MeteoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet pour l'ajout d'une nouvelle station météo.
 * Reçoit les coordonnées GPS, interroge l'API OpenWeatherMap,
 * et persiste les données en base.
 */
@WebServlet(name = "ajouterStation", value = "/ajouter-station")
public class AjouterStation extends HttpServlet {
    
    private MeteoService meteoService;

    @Override
    public void init() throws ServletException {
        super.init();
        meteoService = new MeteoService();
    }

    /**
     * Affiche le formulaire d'ajout de station.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/ajouter-station.jsp").forward(request, response);
    }

    /**
     * Traite la soumission du formulaire d'ajout de station.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String latitudeStr = request.getParameter("latitude");
        String longitudeStr = request.getParameter("longitude");
        
        // Validation des paramètres
        if (latitudeStr == null || latitudeStr.trim().isEmpty() 
            || longitudeStr == null || longitudeStr.trim().isEmpty()) {
            request.setAttribute("error", "Latitude et longitude sont requises.");
            request.getRequestDispatcher("/ajouter-station.jsp").forward(request, response);
            return;
        }

        Double latitude;
        Double longitude;

        try {
            latitude = Double.parseDouble(latitudeStr.trim());
            longitude = Double.parseDouble(longitudeStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format invalide pour latitude ou longitude.");
            request.getRequestDispatcher("/ajouter-station.jsp").forward(request, response);
            return;
        }

        // Validation des plages
        if (latitude < -90 || latitude > 90) {
            request.setAttribute("error", "La latitude doit être comprise entre -90 et 90.");
            request.getRequestDispatcher("/ajouter-station.jsp").forward(request, response);
            return;
        }
        if (longitude < -180 || longitude > 180) {
            request.setAttribute("error", "La longitude doit être comprise entre -180 et 180.");
            request.getRequestDispatcher("/ajouter-station.jsp").forward(request, response);
            return;
        }

        try {
            // Créer la station via le service
            StationMeteo station = meteoService.createStation(latitude, longitude);
            
            if (station != null && station.getNumero() != null) {
                // Succès - rediriger vers l'accueil avec message
                response.sendRedirect(request.getContextPath() + 
                    "/stations?success=Station '" + encodeForUrl(station.getNom()) + "' ajoutée avec succès!");
            } else {
                request.setAttribute("error", "Erreur lors de la création de la station.");
                request.getRequestDispatcher("/ajouter-station.jsp").forward(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/ajouter-station.jsp").forward(request, response);
        } catch (RuntimeException e) {
            request.setAttribute("error", "Erreur technique: " + e.getMessage());
            request.getRequestDispatcher("/ajouter-station.jsp").forward(request, response);
        }
    }

    /**
     * Encode une chaîne pour utilisation dans une URL.
     */
    private String encodeForUrl(String value) {
        if (value == null) return "";
        try {
            return java.net.URLEncoder.encode(value, "UTF-8");
        } catch (Exception e) {
            return value.replaceAll("[^a-zA-Z0-9]", "_");
        }
    }
}
