# Application Météo - Projet n°3

## HE-Arc - Services et Composants

Application web Java (Servlet + JSP) permettant de gérer des stations météo et de consulter les données météorologiques via l'API OpenWeatherMap.

---

## 👥 Membres du groupe

| Nom        | Prénom  |
|------------|---------|
| Barthoulot | Loïc    |
| Bressoud   | Jérémie |

---

## 🚀 Installation et Configuration

### Prérequis

- **Java JDK 24** ou supérieur
- **Apache Tomcat 11**
- **IntelliJ IDEA**
- **Oracle Database** (accès à db.ig.he-arc.ch)
- **Clé API OpenWeatherMap** (gratuite sur [openweathermap.org](https://openweathermap.org/api))

### Étape 1 : Cloner le projet

```bash
git clone https://github.com/Hyakume666/projet3_S-C_BarBre.git
cd projet3_S-C_BarBre
```

### Étape 2 : Configuration de la base de données

1. Connectez-vous à la base Oracle.

2. Exécutez le script de création des tables :
   ```
   @src/main/resources/schema.sql
   ```
   > ⚠️ Ce script peut être exécuté plusieurs fois sans erreur (idempotent)

3. Créez le fichier de configuration `src/main/resources/db.properties` :
   ```properties
   db.url=jdbc:oracle:thin:@db.ig.he-arc.ch:1521:ens
   db.schema=VOTRE_USERNAME
   db.password=VOTRE_PASSWORD
   ```
   > ⚠️ Ne pas commiter ce fichier (déjà dans .gitignore)

### Étape 3 : Configuration de l'API OpenWeatherMap

1. Créez le fichier `src/main/resources/api.properties` :
   ```properties
   owm.apikey=VOTRE_CLE_API_OPENWEATHERMAP
   ```
   > ⚠️ Ne pas commiter ce fichier (déjà dans .gitignore)

### Étape 4 : Configuration IntelliJ + Tomcat

1. **Ouvrir le projet** dans IntelliJ IDEA

2. **Configurer Tomcat** :
    - Menu `Run` → `Edit Configurations...`
    - Cliquer sur `+` → `Tomcat Server` → `Local`
    - Configurer le chemin vers votre installation Tomcat

3. **Ajouter l'artifact** :
    - Dans l'onglet `Deployment`, cliquer sur `+` → `Artifact...`
    - Sélectionner `Meteo:war exploded`
    - **Important** : Le champ `Application context` doit être `/meteo`

4. **Configurer l'URL** :
    - Retourner dans l'onglet `Server`
    - Modifier le champ `URL` : `http://localhost:8080/meteo/`

   > 💡 Le `pom.xml` contient `<finalName>meteo</finalName>` qui définit le nom du WAR

5. **Lancer l'application** :
    - Cliquer sur le bouton ▶️ (Run)
    - L'application sera accessible sur `http://localhost:8080/meteo/`

---

## 📋 Fonctionnalités

### Fonctionnalités communes
- ✅ Saisie d'une nouvelle station météo via coordonnées GPS
- ✅ Affichage de la liste des stations météos
- ✅ Affichage des détails d'une station et de ses mesures
- ✅ Rafraîchissement des données d'une station particulière
- ✅ Rafraîchissement des données de toutes les stations
- ✅ Suppression d'une station météo

### Fonctionnalité bonus
- 🌡️ **Lieux les plus chauds/froids** : Affichage d'un classement des stations par température (basé sur la dernière mesure de chaque station)

---

## 🛠️ Technologies utilisées

| Technologie | Version | Usage |
|-------------|---------|-------|
| Java | 24 | Langage principal |
| Jakarta Servlet | 6.1 | API Servlet |
| JSP | 3.1 | Pages web dynamiques |
| Jackson | 2.9.6 | Désérialisation JSON |
| OJDBC | 19.8 | Driver Oracle |
| Bootstrap | 5.3 | Framework CSS |
| Apache Tomcat | 11 | Serveur d'application |
| Oracle Database | - | Base de données |
| OpenWeatherMap API | 2.5 | Données météo |

---

## 📁 Structure du projet

```
projet3_S-C_BarBre/
├── src/main/
│   ├── java/ch/weather/meteo/
│   │   ├── business/          # Classes métier (Pays, StationMeteo, Meteo)
│   │   ├── config/            # Configuration (ConfigManager)
│   │   ├── deserializer/      # Désérialiseurs JSON
│   │   ├── persistance/
│   │   │   ├── dao/           # Data Access Objects
│   │   │   └── dataSource/    # Connexion DB
│   │   ├── service/           # Logique métier (MeteoService)
│   │   ├── servlets/          # Contrôleurs HTTP
│   │   └── web/               # Appels API (APIClass)
│   ├── resources/
│   │   ├── api.properties     # Config API (à créer)
│   │   ├── db.properties      # Config DB (à créer)
│   │   └── schema.sql         # Script création tables
│   └── webapp/
│       ├── WEB-INF/
│       │   └── web.xml
│       ├── css/
│       ├── index.jsp          # Liste des stations
│       ├── ajouter-station.jsp
│       └── menu.jsp           # Navigation
├── pom.xml
└── README.md
```

---

## 🗄️ Schéma de la base de données

```
┌─────────────┐       ┌─────────────────┐       ┌─────────────-┐
│    PAYS     │       │  STATIONMETEO   │       │    METEO     │
├─────────────┤       ├─────────────────┤       ├────────────-─┤
│ NUMERO (PK) │◄──────│ NUM_PAYS (FK)   │       │ NUMERO (PK)  │
│ CODE        │       │ NUMERO (PK)     │◄──────│ NUM_STATION  │
│ NOM         │       │ LATITUDE        │       │ DATEMESURE   │
└─────────────┘       │ LONGITUDE       │       │ TEMPERATURE  │
                      │ NOM             │       │ DESCRIPTION  │
                      │ OPENWEATHERMAPID│       │ PRESSION     │
                      └─────────────────┘       │ HUMIDITE     │
                                                │ VISIBILITE   │
                                                │ PRECIPITATION│
                                                └─────────────-┘
```

---

## 🔧 Dépannage

### Erreur 404 au lancement
- Vérifiez que l'`Application context` est bien `/meteo` dans la configuration Tomcat

### Erreur "ORA-01005: aucun mot de passe indiqué"
- Vérifiez que `db.properties` contient `db.schema` (pas `db.username`)

### Erreur "api.properties not found"
- Créez le fichier `src/main/resources/api.properties` avec votre clé API

### Les tables n'existent pas
- Exécutez `schema.sql` dans SQL Developer ou SQLcl
