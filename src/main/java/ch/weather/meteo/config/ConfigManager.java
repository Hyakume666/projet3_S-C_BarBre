package ch.weather.meteo.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Gestionnaire centralisé pour les fichiers de configuration.
 * Lit les propriétés depuis les fichiers .properties dans resources.
 */
public class ConfigManager {
    
    private static Properties apiProperties;
    private static Properties dbProperties;
    
    /**
     * Récupère la clé API OpenWeatherMap depuis api.properties.
     * @return la clé API ou null si non trouvée
     */
    public static String getOwmApiKey() {
        return getApiProperty("owm.apikey");
    }
    
    /**
     * Récupère une propriété depuis api.properties.
     * @param key la clé de la propriété
     * @return la valeur ou null si non trouvée
     */
    public static String getApiProperty(String key) {
        if (apiProperties == null) {
            apiProperties = loadProperties("api.properties");
        }
        return apiProperties != null ? apiProperties.getProperty(key) : null;
    }
    
    /**
     * Récupère une propriété depuis db.properties.
     * @param key la clé de la propriété
     * @return la valeur ou null si non trouvée
     */
    public static String getDbProperty(String key) {
        if (dbProperties == null) {
            dbProperties = loadProperties("db.properties");
        }
        return dbProperties != null ? dbProperties.getProperty(key) : null;
    }
    
    /**
     * Charge un fichier properties depuis le classpath.
     * @param filename le nom du fichier
     * @return les propriétés chargées ou null en cas d'erreur
     */
    private static Properties loadProperties(String filename) {
        Properties props = new Properties();
        try (InputStream input = ConfigManager.class.getClassLoader().getResourceAsStream(filename)) {
            if (input == null) {
                System.err.println("Configuration file not found: " + filename);
                System.err.println("Please copy " + filename.replace(".properties", ".template.properties") 
                    + " to " + filename + " and fill in your credentials.");
                return null;
            }
            props.load(input);
            return props;
        } catch (IOException e) {
            System.err.println("Error loading configuration file: " + filename);
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Force le rechargement des configurations (utile pour les tests).
     */
    public static void reload() {
        apiProperties = null;
        dbProperties = null;
    }
}
