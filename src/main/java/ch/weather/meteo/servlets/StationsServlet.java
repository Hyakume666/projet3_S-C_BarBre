package ch.weather.meteo.servlets;

import ch.weather.meteo.business.StationMeteo;
import ch.weather.meteo.service.MeteoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet pour l'affichage de la liste des stations météo.
 * Point d'entrée principal de l'application (page d'accueil).
 */
@WebServlet(name = "stationsServlet", urlPatterns = {"/stations", ""})
public class StationsServlet extends HttpServlet {
    
    private MeteoService meteoService;

    @Override
    public void init() throws ServletException {
        super.init();
        meteoService = new MeteoService();
    }

    /**
     * Affiche la liste des stations météo.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Récupérer le message de succès éventuel (après ajout d'une station)
        String success = request.getParameter("success");
        if (success != null && !success.isEmpty()) {
            request.setAttribute("success", success);
        }
        
        // Récupérer le message d'erreur éventuel
        String error = request.getParameter("error");
        if (error != null && !error.isEmpty()) {
            request.setAttribute("error", error);
        }
        
        try {
            // Charger toutes les stations via le service
            List<StationMeteo> stations = meteoService.getAllStations();
            request.setAttribute("stations", stations);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des stations: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Forward vers la JSP
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
