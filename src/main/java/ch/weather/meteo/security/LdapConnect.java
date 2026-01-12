package ch.weather.meteo.security;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.InitialDirContext;
import java.util.Hashtable;

public class LdapConnect {
    // URL du serveur LDAP
    private final String URL = "ldap://ldap.forumsys.com:389";

    // Base DN (Distinguished Name)
    private final String BASE_DN = "dc=example,dc=com";

    // Clé stockant les identifiants
    private final String KEY = "uid";

    // Context de sécurité
    private final String INITIAL_CONTEXT_FACTORY = "com.sun.jndi.ldap.LdapCtxFactory";
    private final String SECURITY_AUTHENTICATION = "simple";

    private InitialDirContext ctx;

    public LdapConnect() {
    }

    public boolean connect(String username, String passsword) {
        Hashtable<String,String> env = new Hashtable<String,String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, INITIAL_CONTEXT_FACTORY);
        env.put(Context.PROVIDER_URL, URL);
        env.put(Context.SECURITY_AUTHENTICATION, SECURITY_AUTHENTICATION);
        env.put(Context.SECURITY_PRINCIPAL, KEY + "=" + username + "," + BASE_DN);
        env.put(Context.SECURITY_CREDENTIALS, passsword);
        try {
            ctx = new InitialDirContext(env);
        } catch (NamingException e) {
            e.printStackTrace();
        }

        if (ctx != null) {
            System.out.println("Connected to LDAP server");
            return true;
        } else {
            System.out.println("Failed to connect to LDAP server");
            return false;
        }
    }

    public void disconnect() {
        try {
            if (ctx != null) {
                ctx.close();
            }
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }
}

