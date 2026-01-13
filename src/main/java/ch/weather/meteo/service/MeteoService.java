package ch.weather.meteo.service;

import ch.weather.meteo.business.Meteo;
import ch.weather.meteo.business.Pays;
import ch.weather.meteo.business.StationMeteo;
import ch.weather.meteo.persistance.dao.MeteoDAO;
import ch.weather.meteo.persistance.dao.PaysDAO;
import ch.weather.meteo.persistance.dao.StationMeteoDAO;
import ch.weather.meteo.web.APIClass;

import java.util.List;

/**
 * Service métier pour la gestion des stations météo.
 * Orchestre les appels API et la persistance en base de données.
 */
public class MeteoService {

    /**
     * Crée une nouvelle station météo à partir de coordonnées GPS.
     * 1. Appelle l'API OpenWeatherMap pour obtenir les données
     * 2. Récupère/crée le pays via le webservice HE-Arc
     * 3. Persiste la station et ses mesures météo
     *
     * @param latitude  la latitude (-90 à 90)
     * @param longitude la longitude (-180 à 180)
     * @return la station créée avec son numéro, ou null en cas d'erreur
     * @throws IllegalArgumentException si les coordonnées sont invalides
     * @throws RuntimeException si l'API ou la DB échoue
     */
    public StationMeteo createStation(Double latitude, Double longitude) {
        // Validation des coordonnées
        if (latitude == null || longitude == null) {
            throw new IllegalArgumentException("Latitude et longitude sont requises");
        }
        if (latitude < -90 || latitude > 90) {
            throw new IllegalArgumentException("Latitude doit être entre -90 et 90");
        }
        if (longitude < -180 || longitude > 180) {
            throw new IllegalArgumentException("Longitude doit être entre -180 et 180");
        }

        // Créer un objet temporaire pour l'appel API
        StationMeteo tempStation = new StationMeteo();
        tempStation.setLatitude(latitude);
        tempStation.setLongitude(longitude);

        // Appeler l'API OpenWeatherMap
        APIClass api = new APIClass();
        StationMeteo stationFromApi = api.getStationMeteoData(tempStation);
        Meteo meteoFromApi = api.getMeteoData(tempStation);

        if (stationFromApi == null || stationFromApi.isNull()) {
            throw new RuntimeException("Impossible de récupérer les données depuis OpenWeatherMap");
        }

        // Si le nom est vide, refuser l'ajout
        if (stationFromApi.getNom() == null || stationFromApi.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Aucune station meteo connue a ces coordonnees. Veuillez verifier la latitude et la longitude.");
        }

        // Vérifier si la station existe déjà (par OpenWeatherMap ID)
        StationMeteo existingStation = StationMeteoDAO.researchByOpenWeatherMapId(stationFromApi.getOpenWeatherMapId());
        if (existingStation != null) {
            // La station existe déjà, on ajoute juste les nouvelles mesures
            if (meteoFromApi != null) {
                Meteo existingMeteo = MeteoDAO.researchByDateAndStation(
                        meteoFromApi.getDateMesure(),
                        existingStation.getNumero()
                );
                if (existingMeteo == null) {
                    MeteoDAO.create(meteoFromApi, existingStation.getNumero());
                }
            }
            // Charger les mesures existantes
            existingStation.setDonneesMeteo(MeteoDAO.researchByStation(existingStation.getNumero()));
            return existingStation;
        }

        // Récupérer ou créer le pays
        Pays pays = getOrCreatePays(stationFromApi.getPays().getCode());
        stationFromApi.setPays(pays);

        // Persister la station
        Integer stationNumero = StationMeteoDAO.create(stationFromApi);
        if (stationNumero == null) {
            throw new RuntimeException("Erreur lors de la création de la station en base de données");
        }
        stationFromApi.setNumero(stationNumero);

        // Persister les données météo
        if (meteoFromApi != null) {
            Integer meteoNumero = MeteoDAO.create(meteoFromApi, stationNumero);
            if (meteoNumero != null) {
                meteoFromApi.setNumero(meteoNumero);
                stationFromApi.addDonnesMeteo(meteoFromApi);
            }
        }

        return stationFromApi;
    }

    /**
     * Rafraîchit les données météo d'une station existante.
     *
     * @param stationNumero le numéro de la station à rafraîchir
     * @return la mesure météo ajoutée, ou null si pas de nouvelle mesure
     */
    public Meteo refreshStation(Integer stationNumero) {
        StationMeteo station = StationMeteoDAO.findByNumero(stationNumero);
        if (station == null) {
            throw new IllegalArgumentException("Station non trouvée: " + stationNumero);
        }

        // Appeler l'API pour les nouvelles données
        APIClass api = new APIClass();
        Meteo meteoFromApi = api.getMeteoData(station);

        if (meteoFromApi == null) {
            return null;
        }

        // Vérifier si cette mesure existe déjà
        Meteo existingMeteo = MeteoDAO.researchByDateAndStation(
                meteoFromApi.getDateMesure(),
                stationNumero
        );

        if (existingMeteo != null) {
            // Mesure déjà présente
            return existingMeteo;
        }

        // Persister la nouvelle mesure
        Integer meteoNumero = MeteoDAO.create(meteoFromApi, stationNumero);
        if (meteoNumero != null) {
            meteoFromApi.setNumero(meteoNumero);
        }

        return meteoFromApi;
    }

    /**
     * Rafraîchit les données météo de toutes les stations.
     *
     * @return le nombre de stations rafraîchies avec succès
     */
    public int refreshAllStations() {
        List<StationMeteo> stations = StationMeteoDAO.researchAll();
        int count = 0;

        for (StationMeteo station : stations) {
            try {
                Meteo meteo = refreshStation(station.getNumero());
                if (meteo != null) {
                    count++;
                }
            } catch (Exception e) {
                // Log l'erreur mais continue avec les autres stations
                System.err.println("Erreur lors du rafraîchissement de la station "
                        + station.getNumero() + ": " + e.getMessage());
            }
        }

        return count;
    }

    /**
     * Récupère toutes les stations avec leurs mesures.
     *
     * @return la liste des stations
     */
    public List<StationMeteo> getAllStations() {
        List<StationMeteo> stations = StationMeteoDAO.researchAll();
        // Charger les mesures pour chaque station
        for (StationMeteo station : stations) {
            station.setDonneesMeteo(MeteoDAO.researchByStation(station.getNumero()));
        }
        return stations;
    }

    /**
     * Récupère une station par son numéro avec ses mesures.
     *
     * @param numero le numéro de la station
     * @return la station ou null si non trouvée
     */
    public StationMeteo getStationByNumero(Integer numero) {
        StationMeteo station = StationMeteoDAO.findByNumero(numero);
        if (station != null) {
            station.setDonneesMeteo(MeteoDAO.researchByStation(numero));
        }
        return station;
    }

    /**
     * Récupère ou crée un pays à partir de son code ISO.
     *
     * @param code le code ISO Alpha-2 du pays
     * @return le pays existant ou nouvellement créé
     */
    private Pays getOrCreatePays(String code) {
        if (code == null || code.isEmpty()) {
            return null;
        }

        // Chercher le pays existant
        Pays existingPays = PaysDAO.findByCode(code);
        if (existingPays != null) {
            return existingPays;
        }

        // Récupérer les infos du pays via le webservice HE-Arc
        APIClass api = new APIClass();
        Pays paysFromApi = api.getCountryDatas(code, "fr");

        if (paysFromApi == null) {
            // Créer un pays minimal si le WS échoue
            paysFromApi = new Pays();
            paysFromApi.setCode(code);
            paysFromApi.setNom(code); // Utiliser le code comme nom par défaut
        }

        // Persister le nouveau pays
        Integer paysNumero = PaysDAO.create(paysFromApi);
        if (paysNumero != null) {
            paysFromApi.setNumero(paysNumero);
        }

        return paysFromApi;
    }

    /**
     * Récupère les N stations les plus chaudes selon leur dernière mesure.
     *
     * @param limit le nombre maximum de stations à retourner
     * @return une liste de paires [Meteo, StationMeteo] triées par température décroissante
     */
    public List<Object[]> getHottestStations(int limit) {
        List<Object[]> allStations = MeteoDAO.getLatestMeasurementPerStation();
        // Déjà trié par température décroissante dans la requête SQL
        if (allStations.size() > limit) {
            return allStations.subList(0, limit);
        }
        return allStations;
    }

    /**
     * Récupère les N stations les plus froides selon leur dernière mesure.
     *
     * @param limit le nombre maximum de stations à retourner
     * @return une liste de paires [Meteo, StationMeteo] triées par température croissante
     */
    public List<Object[]> getColdestStations(int limit) {
        List<Object[]> allStations = MeteoDAO.getLatestMeasurementPerStation();
        // Inverser l'ordre (la requête SQL trie par DESC)
        java.util.Collections.reverse(allStations);
        if (allStations.size() > limit) {
            return allStations.subList(0, limit);
        }
        return allStations;
    }

    /**
     * Récupère toutes les stations avec leur dernière mesure pour le classement.
     *
     * @return une liste de paires [Meteo, StationMeteo] triées par température décroissante
     */
    public List<Object[]> getAllStationsWithLatestMeasurement() {
        return MeteoDAO.getLatestMeasurementPerStation();
    }

    /**
     * Supprime une station et toutes ses mesures météo.
     *
     * @param stationNumero le numéro de la station à supprimer
     * @throws IllegalArgumentException si la station n'existe pas
     */
    public void deleteStation(Integer stationNumero) {
        StationMeteo station = StationMeteoDAO.findByNumero(stationNumero);
        if (station == null) {
            throw new IllegalArgumentException("Station non trouvee: " + stationNumero);
        }

        // Supprimer d'abord les mesures météo associées
        MeteoDAO.deleteByStation(stationNumero);

        // Puis supprimer la station
        StationMeteoDAO.delete(station);
    }
}