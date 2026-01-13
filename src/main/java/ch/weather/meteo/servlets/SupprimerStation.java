package ch.weather.meteo.servlets;

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
 * Servlet pour la suppression d'une station météo.
 */
@WebServlet(name = "supprimerStation", value = "/supprimer-station")
public class SupprimerStation extends HttpServlet {

    private MeteoService meteoService;

    @Override
    public void init() throws ServletException {
        super.init();
        meteoService = new MeteoService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() +
                    "/stations?error=" + URLEncoder.encode("ID de station manquant", StandardCharsets.UTF_8));
            return;
        }

        try {
            Integer stationId = Integer.parseInt(idStr.trim());

            // Supprimer la station via le service
            meteoService.deleteStation(stationId);

            response.sendRedirect(request.getContextPath() +
                    "/stations?success=" + URLEncoder.encode("Station supprimee avec succes!", StandardCharsets.UTF_8));

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() +
                    "/stations?error=" + URLEncoder.encode("ID de station invalide", StandardCharsets.UTF_8));
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() +
                    "/stations?error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() +
                    "/stations?error=" + URLEncoder.encode("Erreur lors de la suppression: " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }
}