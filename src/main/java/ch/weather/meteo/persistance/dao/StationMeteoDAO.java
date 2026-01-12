package ch.weather.meteo.persistance.dao;

import ch.weather.meteo.business.StationMeteo;
import ch.weather.meteo.persistance.dataSource.DBDataSource;
import oracle.jdbc.OraclePreparedStatement;
import oracle.jdbc.OracleTypes;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StationMeteoDAO {
    // CREATE
    public static Integer create(StationMeteo stationMeteo){
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        Integer rNumero = null;

        try{
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement)c.prepareStatement("INSERT INTO STATIONMETEO (LATITUDE, LONGITUDE, NOM, NUM_PAYS, OPENWEATHERMAPID) VALUES (?, ?, ?, ?, ?) RETURNING NUMERO INTO ?");
            pstmt.setDouble(1, stationMeteo.getLatitude());
            pstmt.setDouble(2, stationMeteo.getLongitude());
            pstmt.setString(3, stationMeteo.getNom());
            if(stationMeteo.getPays() != null) {
                pstmt.setInt(4, stationMeteo.getPays().getNumero());
            }else{
                pstmt.setNull(4,OracleTypes.NULL);
            }
            pstmt.setInt(5, stationMeteo.getOpenWeatherMapId());

            pstmt.registerReturnParameter(6, OracleTypes.NUMBER);

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

    // RESEARCH BY OPENWEATHERMAP ID
    public static StationMeteo researchByOpenWeatherMapId(Integer openWeatherMapId){
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        StationMeteo stationMeteo = null;

        try{
            c = DBDataSource.getConnection();
            pstmt = (OraclePreparedStatement)c.prepareStatement("SELECT * FROM STATIONMETEO WHERE OPENWEATHERMAPID = ?");
            pstmt.setInt(1, openWeatherMapId);

            rs = pstmt.executeQuery();
            if(rs.next()){
                stationMeteo = new StationMeteo();
                stationMeteo.setNumero(rs.getInt("NUMERO"));
                stationMeteo.setLatitude(rs.getDouble("LATITUDE"));
                stationMeteo.setLongitude(rs.getDouble("LONGITUDE"));
                stationMeteo.setNom(rs.getString("NOM"));
                stationMeteo.setPays(PaysDAO.findByNumero(rs.getInt("NUM_PAYS")));
                stationMeteo.setOpenWeatherMapId(rs.getInt("OPENWEATHERMAPID"));
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

            return stationMeteo;
        }
    }

    // RESERCH ALL STATIONS
    public static List<StationMeteo> researchAll(){
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        List<StationMeteo> list = new ArrayList<>();

        try{
            c = DBDataSource.getConnection();
            pstmt = (OraclePreparedStatement)c.prepareStatement("SELECT * FROM STATIONMETEO");
            rs = pstmt.executeQuery();

            while(rs.next()){
                StationMeteo stationMeteo = new StationMeteo();
                stationMeteo.setNumero(rs.getInt("NUMERO"));
                stationMeteo.setLatitude(rs.getDouble("LATITUDE"));
                stationMeteo.setLongitude(rs.getDouble("LONGITUDE"));
                stationMeteo.setNom(rs.getString("NOM"));
                stationMeteo.setPays(PaysDAO.findByNumero(rs.getInt("NUM_PAYS")));
                stationMeteo.setOpenWeatherMapId(rs.getInt("OPENWEATHERMAPID"));

                list.add(stationMeteo);
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

            return list;
        }
    }

    // UPDATE
    public static void update(StationMeteo stationMeteo){
        Connection c = null;
        OraclePreparedStatement pstmt = null;

        try{
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement)c.prepareStatement("UPDATE STATIONMETEO SET LATITUDE = ?, LONGITUDE = ?, NOM = ?, NUM_PAYS = ?, OPENWEATHERMAPID = ? WHERE NUMERO = ?");
            pstmt.setDouble(1, stationMeteo.getLatitude());
            pstmt.setDouble(2, stationMeteo.getLongitude());
            pstmt.setString(3, stationMeteo.getNom());
            pstmt.setInt(4, stationMeteo.getPays().getNumero());
            pstmt.setInt(5, stationMeteo.getOpenWeatherMapId());
            pstmt.setInt(6, stationMeteo.getNumero());

            pstmt.executeUpdate();
            c.commit();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(pstmt != null){pstmt.close();}
                if(c != null){c.close();}
                DBDataSource.closeConnection();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
    }

    // DELETE
    public static void delete(StationMeteo stationMeteo){
        Connection c = null;
        OraclePreparedStatement pstmt = null;

        try{
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement)c.prepareStatement("DELETE FROM STATIONMETEO WHERE NUMERO = ?");
            pstmt.setInt(1, stationMeteo.getNumero());

            pstmt.executeUpdate();
            c.commit();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(pstmt != null){pstmt.close();}
                if(c != null){c.close();}
                DBDataSource.closeConnection();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
    }
}
