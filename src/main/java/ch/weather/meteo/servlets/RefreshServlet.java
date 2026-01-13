package ch.weather.meteo.servlets;

import ch.weather.meteo.business.Meteo;
import ch.weather.meteo.service.MeteoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Servlet pour rafraîchir les données météo.
 * Permet de rafraîchir une station spécifique ou toutes les stations.
 */
@WebServlet(name = "refreshServlet", value = "/refresh")
public class RefreshServlet extends HttpServlet {
    
    private MeteoService meteoService;

    @Override
    public void init() throws ServletException {
        super.init();
        meteoService = new MeteoService();
    }

    /**
     * Rafraîchit les données météo.
     * Paramètres possibles:
     * - id=X : rafraîchit la station avec le numéro X
     * - all=true : rafraîchit toutes les stations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        String allParam = request.getParameter("all");
        
        // Cas 1: Rafraîchir toutes les stations
        if ("true".equalsIgnoreCase(allParam)) {
            try {
                int count = meteoService.refreshAllStations();
                String message = count + " station(s) mise(s) à jour avec succès!";
                response.sendRedirect(request.getContextPath() + "/stations?success=" + 
                    URLEncoder.encode(message, StandardCharsets.UTF_8));
            } catch (Exception e) {
                String errorMsg = "Erreur lors du rafraîchissement: " + e.getMessage();
                response.sendRedirect(request.getContextPath() + "/stations?error=" + 
                    URLEncoder.encode(errorMsg, StandardCharsets.UTF_8));
            }
            return;
        }
        
        // Cas 2: Rafraîchir une station spécifique
        if (idParam != null && !idParam.trim().isEmpty()) {
            Integer stationId;
            try {
                stationId = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/stations?error=" + 
                    URLEncoder.encode("ID de station invalide", StandardCharsets.UTF_8));
                return;
            }
            
            try {
                Meteo newMeteo = meteoService.refreshStation(stationId);
                String message;
                if (newMeteo != null) {
                    message = "Données météo mises à jour!";
                } else {
                    message = "Aucune nouvelle donnée disponible.";
                }
                response.sendRedirect(request.getContextPath() + "/station?id=" + stationId + 
                    "&success=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
            } catch (IllegalArgumentException e) {
                response.sendRedirect(request.getContextPath() + "/stations?error=" + 
                    URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));
            } catch (Exception e) {
                String errorMsg = "Erreur lors du rafraîchissement: " + e.getMessage();
                response.sendRedirect(request.getContextPath() + "/station?id=" + stationId + 
                    "&error=" + URLEncoder.encode(errorMsg, StandardCharsets.UTF_8));
            }
            return;
        }
        
        // Aucun paramètre valide
        response.sendRedirect(request.getContextPath() + "/stations?error=" + 
            URLEncoder.encode("Paramètre manquant: id ou all=true", StandardCharsets.UTF_8));
    }
}
