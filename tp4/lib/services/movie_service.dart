import 'package:dio/dio.dart';
import '../models/movie.dart';

class MovieService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.watchmode.com/v1';

  // Cache en mémoire pour éviter les appels API inutiles
  final Map<int, Movie> _cache = {};

  // Récupère la clé API depuis les variables d'environnement
  static const String _apiKey = String.fromEnvironment(
    'WATCHMODE_API_KEY',
    defaultValue: '', // Valeur par défaut si la clé n'est pas fournie
  );

  Future<List<MovieListItem>> getMovies({int limit = 20}) async {
    // Vérifie que la clé API est bien fournie
    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app avec --dart-define=WATCHMODE_API_KEY=ta_clé'
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/list-titles/',
        queryParameters: {
          'apiKey': _apiKey,
          'types': 'movie',
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> titles = response.data['titles'];
        return titles.map((json) => MovieListItem.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors du chargement des films');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    // Vérifier si le film est dans le cache
    if (_cache.containsKey(movieId)) {
      return _cache[movieId]!;
    }

    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app avec --dart-define=WATCHMODE_API_KEY=ta_clé'
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/title/$movieId/details/',
        queryParameters: {
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final loadedMovie = Movie.fromJson(response.data);
        // Stocker dans le cache avant de retourner
        _cache[movieId] = loadedMovie;
        return loadedMovie;
      } else {
        throw Exception('Erreur lors du chargement des détails');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  // Récupère les plateformes de streaming où le film est disponible
  Future<List<StreamingSource>> getMovieSources(int movieId) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app avec --dart-define=WATCHMODE_API_KEY=ta_clé'
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/title/$movieId/sources/',
        queryParameters: {
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> sources = response.data;
        // Filtrer pour ne garder que les sources uniques par nom
        final Map<String, StreamingSource> uniqueSources = {};
        for (var json in sources) {
          final source = StreamingSource.fromJson(json);
          // Prioriser les abonnements et gratuits
          if (!uniqueSources.containsKey(source.name) ||
              (source.type == 'sub' || source.type == 'free')) {
            uniqueSources[source.name] = source;
          }
        }
        return uniqueSources.values.toList();
      } else {
        throw Exception('Erreur lors du chargement des sources');
      }
    } catch (e) {
      // En cas d'erreur, retourner une liste vide plutôt que de planter
      return [];
    }
  }

  // Récupère le casting du film
  Future<List<CastMember>> getMovieCast(int movieId) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Clé API manquante ! Lance l\'app avec --dart-define=WATCHMODE_API_KEY=ta_clé'
      );
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/title/$movieId/cast-crew/',
        queryParameters: {
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        // L'API peut retourner une liste directement ou un objet avec une clé
        List<dynamic> castList;
        if (response.data is List) {
          castList = response.data;
        } else if (response.data is Map) {
          // Essayer différentes clés possibles
          castList = response.data['cast_crew'] ?? 
                     response.data['cast'] ?? 
                     response.data['results'] ?? 
                     [];
        } else {
          castList = [];
        }
        
        if (castList.isEmpty) return [];
        
        final allMembers = castList.map((json) => CastMember.fromJson(json as Map<String, dynamic>)).toList();
        
        // Filtrer pour ne garder que les acteurs/actrices
        // L'API peut renvoyer "Actor", "Actress", "Cast" ou similaire
        final actors = allMembers.where((member) {
          final lowerType = member.type.toLowerCase();
          return lowerType.contains('actor') || 
                 lowerType.contains('actress') || 
                 lowerType.contains('cast') ||
                 lowerType == 'star' ||
                 lowerType.isEmpty; // Inclure si pas de type spécifié
        }).take(10).toList();
        
        // Si aucun acteur trouvé avec le filtre, prendre les 10 premiers
        if (actors.isEmpty && allMembers.isNotEmpty) {
          return allMembers.take(10).toList();
        }
        
        return actors;
      } else {
        return [];
      }
    } catch (e) {
      // En cas d'erreur, retourner une liste vide plutôt que de planter
      print('Erreur lors du chargement du casting: $e');
      return [];
    }
  }

  // Charge toutes les données d'un film en une seule fois (détails + sources + casting)
  Future<MovieFullDetails> getMovieFullDetails(int movieId) async {
    // Charger les 3 appels en parallèle pour optimiser le temps de chargement
    final results = await Future.wait([
      getMovieDetails(movieId),
      getMovieSources(movieId),
      getMovieCast(movieId),
    ]);

    return MovieFullDetails(
      movie: results[0] as Movie,
      sources: results[1] as List<StreamingSource>,
      cast: results[2] as List<CastMember>,
    );
  }
}

// Classe qui regroupe toutes les données d'un film
class MovieFullDetails {
  final Movie movie;
  final List<StreamingSource> sources;
  final List<CastMember> cast;

  MovieFullDetails({
    required this.movie,
    required this.sources,
    required this.cast,
  });
}