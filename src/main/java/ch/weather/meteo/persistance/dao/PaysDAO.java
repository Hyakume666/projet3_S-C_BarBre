package ch.weather.meteo.persistance.dao;

import ch.weather.meteo.business.Pays;
import ch.weather.meteo.persistance.dataSource.DBDataSource;
import oracle.jdbc.OraclePreparedStatement;
import oracle.jdbc.OracleTypes;

import java.sql.Connection;
import java.sql.ResultSet;

public class PaysDAO {
    // CREATE
    public static Integer create(Pays pays) {
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        Integer rNumero = null;

        try{
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement)c.prepareStatement("INSERT INTO PAYS (CODE, NOM) VALUES (?, ?) RETURNING NUMERO INTO ?");
            pstmt.setString(1, pays.getCode());
            pstmt.setString(2, pays.getNom());
            pstmt.registerReturnParameter(3, OracleTypes.NUMBER);

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

    // RESEARCH BY CODE
    public static Pays findByCode(String code) {
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        Pays pays = null;

        try{
            c = DBDataSource.getConnection();
            pstmt = (OraclePreparedStatement)c.prepareStatement("SELECT * FROM PAYS WHERE CODE = ?");
            pstmt.setString(1, code);

            rs = pstmt.executeQuery();

            if(rs.next()){
                pays = new Pays(rs.getInt("NUMERO"), rs.getString("CODE"), rs.getString("NOM"));
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

            return pays;
        }
    }

    // RESEARCH BY NUMERO
    public static Pays findByNumero(Integer numero) {
        Connection c = null;
        OraclePreparedStatement pstmt = null;
        ResultSet rs = null;

        Pays pays = null;

        try{
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement)c.prepareStatement("SELECT * FROM PAYS WHERE NUMERO = ?");
            pstmt.setInt(1, numero);

            rs = pstmt.executeQuery();

            if(rs.next()){
                pays = new Pays(rs.getInt("NUMERO"), rs.getString("CODE"), rs.getString("NOM"));
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

            return pays;
        }
    }

    // UPDATE
    public static void update(Pays pays) {
        Connection c = null;
        OraclePreparedStatement pstmt = null;

        try{
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement)c.prepareStatement("UPDATE PAYS SET CODE = ?, NOM = ? WHERE NUMERO = ?");
            pstmt.setString(1, pays.getCode());
            pstmt.setString(2, pays.getNom());
            pstmt.setInt(3, pays.getNumero());

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
    public static void delete(Pays pays) {
        Connection c = null;
        OraclePreparedStatement pstmt = null;

        try{
            c = DBDataSource.getConnection();
            c.setAutoCommit(false);
            pstmt = (OraclePreparedStatement)c.prepareStatement("DELETE FROM PAYS WHERE NUMERO = ?");
            pstmt.setInt(1, pays.getNumero());

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
