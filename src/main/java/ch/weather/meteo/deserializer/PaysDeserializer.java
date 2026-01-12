package ch.weather.meteo.deserializer;

import ch.weather.meteo.business.Pays;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.IOException;

public class PaysDeserializer extends JsonDeserializer<Pays> {
    @Override
    public Pays deserialize(JsonParser jsonParser, DeserializationContext deserializationContext) throws IOException {
        JsonNode node = jsonParser.getCodec().readTree(jsonParser);
        String code = node.get("code").asText();
        String nom = node.get("name").asText();
        return new Pays(null, code, nom);
    }
}
