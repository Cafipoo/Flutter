# 🧱 TP3 – Liste de films avec favoris (JSON local)

## 📋 Description

Application Flutter de gestion de films avec chargement depuis un JSON local, système de favoris, recherche, tri, vues multiples (liste/grille) et lecteur vidéo YouTube pour les bandes-annonces. Le projet est organisé avec des services, des widgets réutilisables et un design moderne.

## ✅ État d'avancement

**TP complété à 100% avec tous les bonus** 🎉

### Fonctionnalités principales (TP3 de base)
- ✅ Structure du projet organisée (service, pages, widgets)
- ✅ Chargement des données depuis JSON local
- ✅ Affichage de la liste des films avec `ListView.builder`
- ✅ Gestion des favoris (ajout/suppression)
- ✅ Page dédiée aux favoris (`FavoritesPage`)
- ✅ Page de détails avec synopsis, année et poster
- ✅ Gestion des erreurs de chargement d'images avec placeholder
- ✅ Navigation fluide entre les pages

### Bonus implémentés
- ✅ **Bonus 2 : GridView avec plusieurs modes d'affichage** (+0.5 point)
  - Basculement entre vue liste et vue grille
  - Bouton dans l'AppBar pour changer de mode
  - Widget `MovieGridCard` pour la vue grille avec poster en grand
  - Grille responsive avec 2 colonnes

- ✅ **Bonus 3 : Ajout de filtres et tri** (+0.5 point)
  - Barre de recherche pour filtrer par titre (recherche en temps réel)
  - Menu déroulant pour trier par titre (alphabétique) ou par année (plus récent en premier)
  - Message "Aucun film trouvé" si aucun résultat

### Améliorations supplémentaires
- ✅ **Lecteur vidéo YouTube** : Intégration de `youtube_player_flutter` pour afficher les bandes-annonces
- ✅ **Animations sur les favoris** : Utilisation de `AnimatedSwitcher` pour des transitions fluides
- ✅ **Design amélioré** : Interface moderne avec recherche, tri et vues multiples

## 📸 Captures d'écran

### Liste de films (vue liste)
![Liste de films](https://github.com/Cafipoo/Flutter/raw/main/tp3/result%20app/listedefilm.png)

### Liste de films (vue grille)
![Liste de films grille](https://github.com/Cafipoo/Flutter/raw/main/tp3/result%20app/listedefilm2.png)

### Page des favoris
![Favoris](https://github.com/Cafipoo/Flutter/raw/main/tp3/result%20app/favoris.png)

### Menu de tri
![Tri](https://github.com/Cafipoo/Flutter/raw/main/tp3/result%20app/tri.png)

## 🚀 Fonctionnalités détaillées

### Page principale (MovieListPage)
- **Barre de recherche** : Filtrage en temps réel par titre
- **Tri** : Menu déroulant pour trier par titre ou année
- **Vue liste** : Affichage horizontal avec `ListView.builder` et `MovieCard`
- **Vue grille** : Affichage en grille 2 colonnes avec `GridView.builder` et `MovieGridCard`
- **Basculement** : Bouton dans l'AppBar pour changer entre liste et grille
- **Favoris** : Animation fluide lors de l'ajout/suppression avec `AnimatedSwitcher`
- **Navigation** : Accès rapide à la page des favoris depuis l'AppBar

### Page des favoris (FavoritesPage)
- Liste filtrée des films favoris uniquement
- Utilisation de `.where()` pour filtrer la liste
- Message "Aucun film en favoris" si la liste est vide
- Bouton delete pour retirer un favori
- Mise à jour automatique après suppression

### Page de détails (MovieDetailPage)
- **Lecteur vidéo YouTube** : Bande-annonce en haut de la page (remplace le poster)
- **Poster de fallback** : Affiche le poster si pas de bande-annonce
- **Informations** : Année, synopsis complet
- **Favoris** : Bouton pour ajouter/retirer des favoris depuis la page de détails
- **Design** : Layout scrollable avec informations bien organisées

### Widgets réutilisables
- **MovieCard** : Carte pour la vue liste avec poster, titre, année et bouton favori animé
- **MovieGridCard** : Carte pour la vue grille avec poster en grand et bouton favori en overlay

## 📦 Dépendances

- `youtube_player_flutter: ^9.0.0` : Pour le lecteur vidéo YouTube des bandes-annonces

## 🏗️ Structure du projet

```
tp3/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   ├── movie_list_page.dart        # Page principale avec liste/grille, recherche, tri
│   └── service/
│       └── movie_service.dart      # Service de chargement des données JSON
├── assets/
│   └── data/
│       └── movies.json             # Données des films (titre, année, poster, description, trailer)
└── pubspec.yaml
```


## 🔗 Lien GitHub

[Voir le projet sur GitHub](https://github.com/Cafipoo/Flutter/tree/main/tp3)

