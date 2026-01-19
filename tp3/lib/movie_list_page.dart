import 'package:flutter/material.dart';
import 'service/movie_service.dart';

class MovieListPage extends StatefulWidget {
  final MovieService movieService;

  const MovieListPage({super.key, required this.movieService});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<Movie> movies = [];
  final Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final loadedMovies = await widget.movieService.loadLocalMovies();
    setState(() => movies = loadedMovies);
  }

  void toggleFavorite(String title) {
    setState(() {
      favorites.contains(title) ? favorites.remove(title) : favorites.add(title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Liste de films'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FavoritesPage(
                  favorites: favorites,
                  movies: movies,
                  toggleFavorite: toggleFavorite,
                ),
              ),
            ),
          ),
        ],
      ),
      body: movies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) => MovieCard(
                movie: movies[index],
                isFavorite: favorites.contains(movies[index].title),
                onFavoriteTap: () => toggleFavorite(movies[index].title),
              ),
            ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  final Set<String> favorites;
  final List<Movie> movies;
  final Function(String) toggleFavorite;

  const FavoritesPage({
    super.key,
    required this.favorites,
    required this.movies,
    required this.toggleFavorite,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  void _handleToggleFavorite(String title) {
    // Appeler la fonction toggleFavorite du parent
    widget.toggleFavorite(title);
    // Mettre à jour l'affichage de cette page
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer la liste pour ne garder que les favoris
    final favoriteMovies = widget.movies
        .where((movie) => widget.favorites.contains(movie.title))
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
                return MovieCard(
                  movie: movie,
                  isFavorite: true,
                  onFavoriteTap: () => _handleToggleFavorite(movie.title),
                  favoriteIcon: Icons.delete,
                );
              },
            ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final IconData? favoriteIcon;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.favoriteIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            movie.poster,
            width: 50,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 50,
              height: 75,
              color: Colors.grey[300],
              child: const Icon(Icons.movie),
            ),
          ),
        ),
        title: Text(movie.title),
        subtitle: Text('${movie.year}'),
        trailing: IconButton(
          icon: Icon(
            favoriteIcon ?? (isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite && favoriteIcon == null ? Colors.red : null,
          ),
          onPressed: onFavoriteTap,
        ),
      ),
    );
  }
}