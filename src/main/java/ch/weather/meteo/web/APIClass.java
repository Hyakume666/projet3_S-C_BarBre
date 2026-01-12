package ch.weather.meteo.web;

import ch.weather.meteo.business.Meteo;
import ch.weather.meteo.business.Pays;
import ch.weather.meteo.business.StationMeteo;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import ch.weather.meteo.config.ConfigManager;

public class APIClass {
    private static String OWM_API_KEY = ConfigManager.getOwmApiKey();
    private String owmResponse;

    public APIClass() {
        this.owmResponse = "";
    }

    public Pays getCountryDatas(String code, String lang){
        if(code == null || code.isEmpty()) return null;

        if(lang==null) lang = "fr";
        String BASE_URL = "https://db.ig.he-arc.ch/ens/scl/ws/country/" + code.toLowerCase() + "?lang=" + lang;

        //System.out.println(BASE_URL);

        return Pays.deserialize(getWS(BASE_URL));
    }

    public StationMeteo getStationMeteoData(StationMeteo sm){
        if(owmResponse.isEmpty()){
            owmResponse = getOWMDatas(sm);
        }

        return StationMeteo.deserialize(owmResponse);
    }

    public Meteo getMeteoData(StationMeteo sm){
        if(owmResponse.isEmpty()){
            owmResponse = getOWMDatas(sm);
        }

        return Meteo.deserialize(owmResponse);
    }

    private String getOWMDatas(StationMeteo sm){
        String url = "https://api.openweathermap.org/data/2.5/weather?"
                + "lat=" + sm.getLatitude()
                + "&lon=" + sm.getLongitude()
                + "&units=metric"
                + "&appid=" + OWM_APIKEY;

        //System.out.println(url);

        return getWS(url);
    }

    private String getWS(String BASE_URL){
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL))
                .build();
        HttpResponse<String> response;

        //System.out.println("Requesting: " + BASE_URL);

        try (HttpClient client = HttpClient.newHttpClient()){
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException(e);
        }

        return response.body();
    }
}
