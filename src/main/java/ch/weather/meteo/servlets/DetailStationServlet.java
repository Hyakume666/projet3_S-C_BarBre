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
 * Servlet pour l'affichage du détail d'une station météo et de ses mesures.
 */
@WebServlet(name = "detailStationServlet", value = "/station")
public class DetailStationServlet extends HttpServlet {
    
    private MeteoService meteoService;

    @Override
    public void init() throws ServletException {
        super.init();
        meteoService = new MeteoService();
    }

    /**
     * Affiche les détails d'une station.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        // Validation du paramètre ID
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/stations?error=ID de station manquant");
            return;
        }
        
        Integer stationId;
        try {
            stationId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/stations?error=ID de station invalide");
            return;
        }
        
        // Récupérer le message de succès éventuel (après rafraîchissement)
        String success = request.getParameter("success");
        if (success != null && !success.isEmpty()) {
            request.setAttribute("success", success);
        }
        
        try {
            // Charger la station avec ses mesures
            StationMeteo station = meteoService.getStationByNumero(stationId);
            
            if (station == null) {
                response.sendRedirect(request.getContextPath() + "/stations?error=Station non trouvée");
                return;
            }
            
            request.setAttribute("station", station);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement de la station: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Forward vers la JSP de détail
        request.getRequestDispatcher("/detail-station.jsp").forward(request, response);
    }
}
