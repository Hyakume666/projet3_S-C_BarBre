package ch.weather.meteo.persistance.dataSource;

import oracle.jdbc.pool.OracleDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.util.Properties;

// Source de données Oracle
public class DBDataSource {
    private static final String DRIVER_TYPE = "thin";
    private static final String SERVER_NAME = "db.ig.he-arc.ch";
    private static final Integer PORT = 1521;
    private static final String DATABASE_NAME = "ens";
    private static String USER = "";
    private static String PASSWORD = "";

    private static OracleDataSource ds;

    public static Connection getConnection() {
        Properties props = new Properties();

        //InputStream input = new FileInputStream("src/main/resources/db.properties")) {
        InputStream input = DBDataSource.class.getClassLoader().getResourceAsStream("db.properties");
        try {
            props.load(input);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        USER = props.getProperty("db.schema");
        PASSWORD = props.getProperty("db.password");

        try {
            if (ds == null || ds.getConnection() == null) {
                ds = new OracleDataSource();
                ds.setDriverType(DRIVER_TYPE);
                ds.setServerName(SERVER_NAME);
                ds.setPortNumber(PORT);
                ds.setDatabaseName(DATABASE_NAME);
                ds.setUser(USER);
                ds.setPassword(PASSWORD);
            }

            return ds.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void closeConnection(){
        if (ds != null) {
            try {
                ds.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
