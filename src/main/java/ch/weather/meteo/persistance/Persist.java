package ch.weather.meteo.persistance;

import ch.weather.meteo.business.Meteo;
import ch.weather.meteo.business.Pays;
import ch.weather.meteo.business.StationMeteo;
import ch.weather.meteo.persistance.dao.MeteoDAO;
import ch.weather.meteo.persistance.dao.PaysDAO;
import ch.weather.meteo.persistance.dao.StationMeteoDAO;

import java.util.Date;
import java.util.Map;

public class Persist {
    public static StationMeteo save(StationMeteo stationMeteo) {
        //Vérification de l'existence du pays
        Pays pays = null;
        if(stationMeteo.getPays() != null) {
            pays = PaysDAO.findByCode(stationMeteo.getPays().getCode());

            if(pays == null){
                //Si le pays n'existe pas, on le crée
                Integer numPays = PaysDAO.create(stationMeteo.getPays());
                stationMeteo.getPays().setNumero(numPays);
            }else{
                //Si le pays existe, alors on met ses informations dans l'objet stationMeteo
                stationMeteo.setPays(pays);
            }
        }

        // Vérification de l'existence de la station météo
        StationMeteo stationMeteoExistante = StationMeteoDAO.researchByOpenWeatherMapId(stationMeteo.getOpenWeatherMapId());

        if(stationMeteoExistante == null){
            //Si la station météo n'existe pas, on la crée
            Integer numStation = StationMeteoDAO.create(stationMeteo);
            System.out.println("StationMeteoDAO.create: " + numStation);
            stationMeteo.setNumero(numStation);
        }else{
            //Si la station météo existe, alors on met ses informations dans l'objet stationMeteo
            stationMeteo.setNumero(stationMeteoExistante.getNumero());
        }

        // Vérification de l'existence des mesures météo
        // On récupére la première mesure météo de la station météo
        Meteo meteo = stationMeteo.getDonneesMeteo().values().iterator().next();

        // On vérifie si la mesure météo existe
        Meteo meteoExistante = MeteoDAO.researchByDateAndStation(meteo.getDateMesure(), stationMeteo.getNumero());

        if(meteoExistante == null){
            //Si la mesure météo n'existe pas, on la crée
            MeteoDAO.create(meteo, stationMeteo.getNumero());
            System.out.println("MeteoDAO.create: " + meteo);
        }

        // On récupères toutes les mesures météo de la station météo
        Map<Date, Meteo> donneesMeteo = MeteoDAO.researchByStation(stationMeteo.getNumero());
        System.out.println("MeteoDAO.researchByStation: " + donneesMeteo.size());

        // On met à jour les mesures météo de la station météo
        stationMeteo.setDonneesMeteo(donneesMeteo);

        return stationMeteo;
    }
}
