package ch.weather.meteo.persistance.dao;

import ch.weather.meteo.business.Meteo;
import ch.weather.meteo.business.StationMeteo;
import ch.weather.meteo.persistance.dataSource.DBDataSource;
import oracle.jdbc.OraclePreparedStatement;
import oracle.jdbc.OracleTypes;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MeteoDAO {
    // CREATE
    public static Integer create(Meteo meteo, Integer station_num){
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        Integer rNumero = null;

        try{
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement)c.prepareStatement("INSERT INTO METEO (DATEMESURE, TEMPERATURE, DESCRIPTION, PRESSION, HUMIDITE, VISIBILITE, PRECIPITATION, NUM_STATIONMETEO) VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING NUMERO INTO ?");
            pstmt.setDate(1, toSQLDate(meteo.getDateMesure()));
            pstmt.setDouble(2, meteo.getTemperature());
            pstmt.setString(3, meteo.getDescription());
            pstmt.setDouble(4, meteo.getPression());
            pstmt.setDouble(5, meteo.getHumidite());
            pstmt.setInt(6, meteo.getVisibilite());
            pstmt.setDouble(7, meteo.getPrecipitation());
            pstmt.setInt(8, station_num);

            pstmt.registerReturnParameter(9, OracleTypes.NUMBER);

            pstmt.executeUpdate();
            c.commit();

            rs = pstmt.getReturnResultSet();
            if(rs.next()){
                rNumero = rs.getInt(1);
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs != null){rs.close();}
                if(pstmt != null){pstmt.close();}
                if(c != null){c.close();}
                DBDataSource.closeConnection();
            }catch(Exception e){
                e.printStackTrace();
            }

            return rNumero;
        }
    }

    // RESEARCH BY DATE AND STATION
    public static Meteo researchByDateAndStation(Date date, Integer station_num){
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        Meteo meteo = null;

        try{
            c = DBDataSource.getConnection();
            pstmt = (OraclePreparedStatement)c.prepareStatement("SELECT * FROM METEO WHERE DATEMESURE = ? AND NUM_STATIONMETEO = ?");
            pstmt.setDate(1, toSQLDate(date));
            pstmt.setInt(2, station_num);

            rs = pstmt.executeQuery();
            if(rs.next()){
                meteo = new Meteo(rs.getInt("NUMERO"), toUtilDate(rs.getDate("DATEMESURE")), rs.getDouble("TEMPERATURE"), rs.getString("DESCRIPTION"), rs.getDouble("PRESSION"), rs.getDouble("HUMIDITE"), rs.getInt("VISIBILITE"), rs.getDouble("PRECIPITATION"));
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs != null){rs.close();}
                if(pstmt != null){pstmt.close();}
                if(c != null){c.close();}
                DBDataSource.closeConnection();
            }catch(Exception e){
                e.printStackTrace();
            }

            return meteo;
        }
    }

    // RESEARCH BY STATION
    public static Map<Date, Meteo> researchByStation(Integer station_num){
        Map<Date, Meteo> map = new HashMap<Date, Meteo>();

        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        try{
            c = DBDataSource.getConnection();
            pstmt = (OraclePreparedStatement)c.prepareStatement("SELECT * FROM METEO WHERE NUM_STATIONMETEO = ?");
            pstmt.setInt(1, station_num);

            rs = pstmt.executeQuery();
            while(rs.next()){
                Meteo meteo = new Meteo(rs.getInt("NUMERO"), toUtilDate(rs.getDate("DATEMESURE")), rs.getDouble("TEMPERATURE"), rs.getString("DESCRIPTION"), rs.getDouble("PRESSION"), rs.getDouble("HUMIDITE"), rs.getInt("VISIBILITE"), rs.getDouble("PRECIPITATION"));
                map.put(meteo.getDateMesure(), meteo);
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs != null){rs.close();}
                if(pstmt != null){pstmt.close();}
                if(c != null){c.close();}
                DBDataSource.closeConnection();
            }catch(Exception e){
                e.printStackTrace();
            }

            return map;
        }
    }

    // DELETE BY DATE AND STATION
    public static void deleteByDateAndStation(Date date, Integer station_num) {
        Connection c = null;
        OraclePreparedStatement pstmt = null;

        try {
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement) c.prepareStatement("DELETE FROM METEO WHERE DATEMESURE = ? AND NUM_STATIONMETEO = ?");
            pstmt.setDate(1, toSQLDate(date));
            pstmt.setInt(2, station_num);

            pstmt.executeUpdate();
            c.commit();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) {pstmt.close();}
                if (c != null) {c.close();}
                DBDataSource.closeConnection();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Récupère la dernière mesure de chaque station avec les infos de la station.
     * Utilisé pour le classement des stations les plus chaudes/froides.
     * @return une liste de tableaux [Meteo, StationMeteo] triée par température décroissante
     */
    public static List<Object[]> getLatestMeasurementPerStation() {
        List<Object[]> results = new ArrayList<>();
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            c = DBDataSource.getConnection();
            // Requête SQL pour obtenir la dernière mesure de chaque station
            String sql = """
                SELECT m.NUMERO, m.DATEMESURE, m.TEMPERATURE, m.DESCRIPTION, 
                       m.PRESSION, m.HUMIDITE, m.VISIBILITE, m.PRECIPITATION,
                       s.NUMERO as STATION_NUMERO, s.NOM, s.LATITUDE, s.LONGITUDE, 
                       s.OPENWEATHERMAPID, s.NUM_PAYS
                FROM METEO m
                INNER JOIN STATIONMETEO s ON m.NUM_STATIONMETEO = s.NUMERO
                WHERE m.DATEMESURE = (
                    SELECT MAX(m2.DATEMESURE) 
                    FROM METEO m2 
                    WHERE m2.NUM_STATIONMETEO = m.NUM_STATIONMETEO
                )
                ORDER BY m.TEMPERATURE DESC
            """;
            pstmt = (OraclePreparedStatement) c.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                // Créer l'objet Meteo
                Meteo meteo = new Meteo(
                    rs.getInt("NUMERO"),
                    toUtilDate(rs.getDate("DATEMESURE")),
                    rs.getDouble("TEMPERATURE"),
                    rs.getString("DESCRIPTION"),
                    rs.getDouble("PRESSION"),
                    rs.getDouble("HUMIDITE"),
                    rs.getInt("VISIBILITE"),
                    rs.getDouble("PRECIPITATION")
                );

                // Créer l'objet StationMeteo
                StationMeteo station = new StationMeteo();
                station.setNumero(rs.getInt("STATION_NUMERO"));
                station.setNom(rs.getString("NOM"));
                station.setLatitude(rs.getDouble("LATITUDE"));
                station.setLongitude(rs.getDouble("LONGITUDE"));
                station.setOpenWeatherMapId(rs.getInt("OPENWEATHERMAPID"));
                station.setPays(PaysDAO.findByNumero(rs.getInt("NUM_PAYS")));

                results.add(new Object[]{meteo, station});
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (c != null) c.close();
                DBDataSource.closeConnection();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return results;
    }

    // JAVA.UTIL.DATE TO SQL.DATE
    private static java.sql.Date toSQLDate(Date date){
        return new java.sql.Date(date.getTime());
    }

    // SQL.DATE TO JAVA.UTIL.DATE
    private static Date toUtilDate(java.sql.Date date){
        return new Date(date.getTime());
    }
}
