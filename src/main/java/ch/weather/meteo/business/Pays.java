package ch.weather.meteo.business;

import ch.weather.meteo.deserializer.PaysDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.io.Serializable;

@JsonDeserialize(using = PaysDeserializer.class)
public class Pays implements Serializable {
    private Integer numero;
    private String code; // Alpha-2
    private String nom; // en français

    public Pays() {
    }

    public Pays(Integer numero, String code, String nom) {
        this.numero = numero;
        this.code = code;
        this.nom = nom;
    }

    public Integer getNumero() {
        return numero;
    }

    public void setNumero(Integer numero) {
        this.numero = numero;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
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

    public static Pays deserialize(String jsonString){
        try{
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(jsonString, Pays.class);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public String toString() {
        return "Pays{" +
                "numero=" + numero +
                ", code='" + code + '\'' +
                ", nom='" + nom + '\'' +
                '}';
    }
}
