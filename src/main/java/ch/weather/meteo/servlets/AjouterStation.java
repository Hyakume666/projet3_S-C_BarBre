package ch.weather.meteo.servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ajouterStation", value = "/ajouter-station")
public class AjouterStation extends HttpServlet {
    public void init() {

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Double latitude;
        Double longitude;

        try{
            latitude = Double.valueOf(request.getParameter("latitude"));
            longitude = Double.valueOf(request.getParameter("longitude"));
        } catch (NumberFormatException e) {
            latitude = null;
            longitude = null;
        }

        if(latitude == null || longitude == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Latitude et Longitude sont requises.");
            response.sendRedirect(request.getContextPath() + "/ajouter-station.jsp?error=missing_fields");
        }else{
            // Traitement pour ajouter la station météo (Recherche auprès du service web et sauvegarde en base de données)



            response.sendRedirect(request.getContextPath() + "/index.jsp?success=station_added");
        }
    }

    public void destroy() {
    }
}
