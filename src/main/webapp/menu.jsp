<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    .navbar-pokemon {
        background: linear-gradient(180deg, #E3350D 0%, #B22D0D 100%);
        border-bottom: 4px solid #8B1E08;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        padding: 0.5rem 1rem;
    }

    .navbar-pokemon .navbar-brand {
        color: #FFCB05;
        font-weight: 800;
        font-size: 1.4rem;
        text-shadow: 2px 2px 0 rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .navbar-pokemon .navbar-brand:hover {
        color: #FFE066;
    }

    .navbar-pokemon .navbar-brand img {
        width: 40px;
        height: 40px;
        filter: drop-shadow(2px 2px 2px rgba(0,0,0,0.3));
    }

    .navbar-pokemon .nav-link {
        color: rgba(255,255,255,0.9) !important;
        font-weight: 600;
        padding: 0.5rem 1rem !important;
        border-radius: 20px;
        margin: 0 0.2rem;
        transition: all 0.2s ease;
    }

    .navbar-pokemon .nav-link:hover {
        color: #FFCB05 !important;
        background: rgba(255,255,255,0.1);
    }

    .navbar-pokemon .nav-link.active {
        color: #333 !important;
        background: #FFCB05;
    }

    .navbar-pokemon .navbar-toggler {
        border-color: rgba(255,255,255,0.5);
    }

    .navbar-pokemon .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 203, 5, 1%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }
</style>

<nav class="navbar navbar-expand-lg navbar-pokemon sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="<%= application.getContextPath() %>/stations">
            <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/351.png" alt="Morphéo">
            MorphéoMétéo
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link <%= "index".equals(activePage) ? "active" : "" %>" href="<%= application.getContextPath() %>/stations">
                        Accueil
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "ajouter".equals(activePage) ? "active" : "" %>" href="<%= application.getContextPath() %>/ajouter-station">
                        Capturer
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "top".equals(activePage) ? "active" : "" %>" href="<%= application.getContextPath() %>/top-stations">
                        Classement
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
