import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  final MovieService movieService;

  const MovieListPage({super.key, required this.movieService});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<MovieListItem> movies = [];
  bool isLoading = true;
  String? errorMessage;
  final Set<int> favorites = {};

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedMovies = await widget.movieService.getMovies(limit: 30);
      setState(() {
        movies = loadedMovies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void toggleFavorite(int movieId) {
    setState(() {
      favorites.contains(movieId) ? favorites.remove(movieId) : favorites.add(movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Films récents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMovies,
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FavoritesPage(
                  movieService: widget.movieService,
                  favorites: favorites,
                  movies: movies,
                  toggleFavorite: toggleFavorite,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadMovies,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) => MovieListCard(
                    movieService: widget.movieService,
                    movie: movies[index],
                    isFavorite: favorites.contains(movies[index].id),
                    onFavoriteTap: () => toggleFavorite(movies[index].id),
                  ),
                ),
    );
  }
}

// TODO: Créer la classe FavoritesPage ici (voir TP3 pour référence)

class FavoritesPage extends StatefulWidget {
  final MovieService movieService;
  final Set<int> favorites;
  final List<MovieListItem> movies;
  final Function(int) toggleFavorite;

  const FavoritesPage({
    super.key,
    required this.movieService,
    required this.favorites,
    required this.movies,
    required this.toggleFavorite,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  void _handleToggleFavorite(int movieId) {
    // Appeler la fonction toggleFavorite du parent
    widget.toggleFavorite(movieId);
    // Mettre à jour l'affichage de cette page
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer la liste pour ne garder que les favoris
    final favoriteMovies = widget.movies
        .where((movie) => widget.favorites.contains(movie.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('⭐ Mes favoris'),
      ),
      body: favoriteMovies.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun film en favoris',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return MovieListCard(
                  movieService: widget.movieService,
                  movie: movie,
                  isFavorite: true,
                  onFavoriteTap: () => _handleToggleFavorite(movie.id),
                  favoriteIcon: Icons.delete,
                );
              },
            ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  final MovieService movieService;
  final MovieListItem movie;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final IconData? favoriteIcon;

  const MovieListCard({
    super.key,
    required this.movieService,
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.favoriteIcon,
  });

  // Génère une couleur basée sur la première lettre du titre
  Color _getColorFromLetter(String title) {
    if (title.isEmpty) return Colors.grey;

    final letter = title[0].toUpperCase();
    final colorIndex = letter.codeUnitAt(0) % 10;

    const colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.brown,
    ];

    return colors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(
              movieService: movieService,
              movieId: movie.id,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getColorFromLetter(movie.title),
            child: Text(
              movie.title.isNotEmpty ? movie.title[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          title: Text(movie.title),
          subtitle: Text('Année : ${movie.year}'),
          trailing: IconButton(
            icon: Icon(
              favoriteIcon ?? (isFavorite ? Icons.favorite : Icons.favorite_border),
              color: isFavorite && favoriteIcon == null ? Colors.red : null,
            ),
            onPressed: onFavoriteTap,
          ),
        ),
      ),
    );
  }
}