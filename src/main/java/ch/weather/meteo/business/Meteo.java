package ch.weather.meteo.business;

import ch.weather.meteo.deserializer.MeteoDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.io.Serializable;
import java.util.Date;

@JsonDeserialize(using = MeteoDeserializer.class)
public class Meteo implements Serializable {
    private Integer numero;
    private Date dateMesure;
    private Double temperature;
    private String description;
    private Double pression;
    private Double humidite;
    private Integer visibilite;
    private Double precipitation;
    private StationMeteo stationMeteo;

    public Meteo() {
    }

    public Meteo(Integer numero, Date dateMesure, Double temperature, String description, Double pression, Double humidite, Integer visibilite, Double precipitation) {
        this.numero = numero;
        this.dateMesure = dateMesure;
        this.temperature = temperature;
        this.description = description;
        this.pression = pression;
        this.humidite = humidite;
        this.visibilite = visibilite;
        this.precipitation = precipitation;
    }

    public Integer getNumero() {
        return numero;
    }

    public void setNumero(Integer numero) {
        this.numero = numero;
    }

    public Date getDateMesure() {
        return dateMesure;
    }

    public void setDateMesure(Date dateMesure) {
        this.dateMesure = dateMesure;
    }

    public Double getTemperature() {
        return temperature;
    }

    public void setTemperature(Double temperature) {
        this.temperature = temperature;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getPression() {
        return pression;
    }

    public void setPression(Double pression) {
        this.pression = pression;
    }

    public Double getHumidite() {
        return humidite;
    }

    public void setHumidite(Double humidite) {
        this.humidite = humidite;
    }

    public Integer getVisibilite() {
        return visibilite;
    }

    public void setVisibilite(Integer visibilite) {
        this.visibilite = visibilite;
    }

    public Double getPrecipitation() {
        return precipitation;
    }

    public void setPrecipitation(Double precipitation) {
        this.precipitation = precipitation;
    }

    public String serialize(){
        try{
            ObjectMapper mapper = new ObjectMapper();
            return mapper.writeValueAsString(this);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }

    public static Meteo deserialize(String jsonString){
        try{
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(jsonString, Meteo.class);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public String toString() {
        return "Meteo{" +
                "numero=" + numero +
                ", dateMesure=" + dateMesure +
                ", temperature=" + temperature +
                ", description='" + description + '\'' +
                ", pression=" + pression +
                ", humidite=" + humidite +
                ", visibilite=" + visibilite +
                ", precipitation=" + precipitation +
                '}';
    }
}
