package ch.weather.meteo.servlets;

import ch.weather.meteo.service.MeteoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet pour l'affichage du classement des stations les plus chaudes/froides.
 * Fonctionnalité bonus du projet.
 */
@WebServlet(name = "topStationsServlet", value = "/top-stations")
public class TopStationsServlet extends HttpServlet {
    
    private static final int DEFAULT_LIMIT = 5;
    private MeteoService meteoService;

    @Override
    public void init() throws ServletException {
        super.init();
        meteoService = new MeteoService();
    }

    /**
     * Affiche le classement des stations.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Paramètre optionnel pour le nombre de stations à afficher
        int limit = DEFAULT_LIMIT;
        String limitParam = request.getParameter("limit");
        if (limitParam != null && !limitParam.trim().isEmpty()) {
            try {
                limit = Integer.parseInt(limitParam.trim());
                if (limit < 1) limit = DEFAULT_LIMIT;
                if (limit > 20) limit = 20; // Maximum 20
            } catch (NumberFormatException e) {
                // Garder la valeur par défaut
            }
        }
        
        try {
            // Récupérer les stations les plus chaudes
            List<Object[]> hottestStations = meteoService.getHottestStations(limit);
            request.setAttribute("hottestStations", hottestStations);
            
            // Récupérer les stations les plus froides
            List<Object[]> coldestStations = meteoService.getColdestStations(limit);
            request.setAttribute("coldestStations", coldestStations);
            
            request.setAttribute("limit", limit);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des données: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Forward vers la JSP
        request.getRequestDispatcher("/top-stations.jsp").forward(request, response);
    }
}
