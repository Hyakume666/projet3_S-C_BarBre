package ch.weather.meteo.business;

import ch.weather.meteo.deserializer.StationMeteoDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@JsonDeserialize(using = StationMeteoDeserializer.class)
public class StationMeteo implements Serializable {
    private Integer numero;
    private Double latitude;
    private Double longitude;
    private String nom;
    private Pays pays;
    private Integer openWeatherMapId;

    private Map<Date,Meteo> donneesMeteo;

    public StationMeteo() {
        donneesMeteo = new HashMap<>();
    }

    public StationMeteo(Integer numero, Double latitude, Double longitude, String nom, Pays pays, Integer openWeatherMapId, Map<Date, Meteo> donneesMeteo) {
        this.numero = numero;
        this.latitude = latitude;
        this.longitude = longitude;
        this.nom = nom;
        this.pays = pays;
        this.openWeatherMapId = openWeatherMapId;
        this.donneesMeteo = donneesMeteo;
    }

    public Integer getNumero() {
        return numero;
    }

    public void setNumero(Integer numero) {
        this.numero = numero;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public Pays getPays() {
        return pays;
    }

    public void setPays(Pays pays) {
        this.pays = pays;
    }

    public Integer getOpenWeatherMapId() {
        return openWeatherMapId;
    }

    public void setOpenWeatherMapId(Integer openWeatherMapId) {
        this.openWeatherMapId = openWeatherMapId;
    }

    public Map<Date, Meteo> getDonneesMeteo() {
        return donneesMeteo;
    }

    public void setDonneesMeteo(Map<Date, Meteo> donneesMeteo) {
        this.donneesMeteo = donneesMeteo;
    }

    public void addDonnesMeteo(Meteo donnesMeteo){
        this.donneesMeteo.put(donnesMeteo.getDateMesure(), donnesMeteo);
    }

    // Test si tous les attributs de l'objets sont null (ou vide)
    public boolean isNull(){
        return this.numero == null
                && this.latitude == null
                && this.longitude == null
                && this.nom == null
                && this.pays == null
                && this.openWeatherMapId == null
                && this.donneesMeteo == null;
    }

    public String serialize(){
        try
        {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.writeValueAsString
                    (this);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    public  static StationMeteo deserialize(String jsonString){
        try
        {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue
                    (jsonString, StationMeteo.class);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public String toString() {
        return "StationMeteo{" +
                "numero=" + numero +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", nom='" + nom + '\'' +
                ", pays=" + pays +
                ", openWeatherMapId=" + openWeatherMapId +
                ", donneesMeteo=" + donneesMeteo +
                '}';
    }
}
