package ch.weather.meteo.deserializer;

import ch.weather.meteo.business.Meteo;
import ch.weather.meteo.business.Pays;
import ch.weather.meteo.business.StationMeteo;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class StationMeteoDeserializer extends JsonDeserializer<StationMeteo> {
    @Override
    public StationMeteo deserialize(JsonParser jsonParser, DeserializationContext deserializationContext) throws IOException {
        JsonNode node = jsonParser.getCodec().readTree(jsonParser);

        Double latitude = node.get("coord").get("lat").asDouble();
        Double longitude = node.get("coord").get("lon").asDouble();
        String nom = node.get("name").asText();
        Integer openWeatherMapId = node.get("id").asInt();
        String code = "";
        try{
            code = node.get("sys").get("country").asText();
        } catch (Exception e) {
            System.out.println("Erreur lors de la récupération du code pays");
        }

        Map<Date, Meteo> donneesMeteo = new HashMap<>();

        Pays pays = new Pays();
        pays.setCode(code);

        return new StationMeteo(null, latitude, longitude,  nom, pays, openWeatherMapId, donneesMeteo);
    }
}