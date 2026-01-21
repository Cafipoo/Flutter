import 'package:flutter_test/flutter_test.dart';
import 'package:tp4/models/movie.dart';

void main() {
  group('MovieListItem Tests', () {
    test('Parse correctement un JSON valide', () {
      // Arrange : Préparer des données JSON
      final json = {
        'id': 123,
        'title': 'Test Movie',
        'year': 2024,
      };

      // Act : Créer un MovieListItem à partir du JSON
      final movie = MovieListItem.fromJson(json);

      // Assert : Vérifier que les valeurs sont correctes
      expect(movie.id, 123);
      expect(movie.title, 'Test Movie');
      expect(movie.year, 2024);
    });

    test('Gère les valeurs nulles avec des valeurs par défaut', () {
      // JSON avec des champs manquants
      final json = {
        'id': 456,
      };

      final movie = MovieListItem.fromJson(json);

      // Vérifie que les valeurs par défaut sont appliquées
      expect(movie.id, 456);
      expect(movie.title, 'Sans titre');
      expect(movie.year, 0);
    });

    test('Gère les valeurs null explicitement', () {
      // JSON avec des valeurs null
      final json = {
        'id': 789,
        'title': null,
        'year': null,
      };

      final movie = MovieListItem.fromJson(json);

      expect(movie.id, 789);
      expect(movie.title, 'Sans titre');
      expect(movie.year, 0);
    });

    test('Parse correctement un JSON avec année 0', () {
      final json = {
        'id': 999,
        'title': 'Movie Without Year',
        'year': 0,
      };

      final movie = MovieListItem.fromJson(json);

      expect(movie.id, 999);
      expect(movie.title, 'Movie Without Year');
      expect(movie.year, 0);
    });
  });

  group('Movie Tests', () {
    test('Parse correctement un JSON valide complet', () {
      final json = {
        'id': 123,
        'title': 'Test Movie',
        'plot_overview': 'A great test movie',
        'year': 2024,
        'poster': 'https://example.com/poster.jpg',
        'backdrop': 'https://example.com/backdrop.jpg',
        'user_rating': 8.5,
        'genre_names': ['Action', 'Drama'],
        'trailer': 'https://youtube.com/watch?v=test',
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 123);
      expect(movie.title, 'Test Movie');
      expect(movie.plotOverview, 'A great test movie');
      expect(movie.year, 2024);
      expect(movie.poster, 'https://example.com/poster.jpg');
      expect(movie.backdrop, 'https://example.com/backdrop.jpg');
      expect(movie.userRating, 8.5);
      expect(movie.genreNames, ['Action', 'Drama']);
      expect(movie.trailer, 'https://youtube.com/watch?v=test');
    });

    test('Gère les valeurs nulles avec des valeurs par défaut', () {
      final json = {
        'id': 456,
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 456);
      expect(movie.title, 'Sans titre');
      expect(movie.plotOverview, 'Aucune description disponible');
      expect(movie.year, 0);
      expect(movie.poster, null);
      expect(movie.backdrop, null);
      expect(movie.userRating, 0.0);
      expect(movie.genreNames, []);
      expect(movie.trailer, null);
    });

    test('Parse correctement les genres avec différents types', () {
      final json = {
        'id': 789,
        'title': 'Genre Test Movie',
        'plot_overview': 'Test',
        'year': 2024,
        'user_rating': 7.0,
        'genre_names': ['Action', 123, 'Drama', null],
      };

      final movie = Movie.fromJson(json);

      expect(movie.genreNames.length, 4);
      expect(movie.genreNames[0], 'Action');
      expect(movie.genreNames[1], '123');
      expect(movie.genreNames[2], 'Drama');
      expect(movie.genreNames[3], 'null');
    });

    test('Gère un genre_names null', () {
      final json = {
        'id': 999,
        'title': 'No Genres Movie',
        'plot_overview': 'Test',
        'year': 2024,
        'user_rating': 5.0,
        'genre_names': null,
      };

      final movie = Movie.fromJson(json);

      expect(movie.genreNames, []);
    });

    test('posterUrl retourne le poster si disponible', () {
      final movie = Movie(
        id: 1,
        title: 'Test',
        plotOverview: 'Test',
        year: 2024,
        poster: 'https://example.com/poster.jpg',
        userRating: 7.0,
        genreNames: [],
      );

      expect(movie.posterUrl, 'https://example.com/poster.jpg');
    });

    test('posterUrl retourne une URL par défaut si poster est null', () {
      final movie = Movie(
        id: 1,
        title: 'Test',
        plotOverview: 'Test',
        year: 2024,
        poster: null,
        userRating: 7.0,
        genreNames: [],
      );

      expect(movie.posterUrl, 'https://placehold.co/600x400');
    });

    test('backdropUrl retourne le backdrop si disponible', () {
      final movie = Movie(
        id: 1,
        title: 'Test',
        plotOverview: 'Test',
        year: 2024,
        backdrop: 'https://example.com/backdrop.jpg',
        userRating: 7.0,
        genreNames: [],
      );

      expect(movie.backdropUrl, 'https://example.com/backdrop.jpg');
    });

    test('backdropUrl retourne une URL par défaut si backdrop est null', () {
      final movie = Movie(
        id: 1,
        title: 'Test',
        plotOverview: 'Test',
        year: 2024,
        backdrop: null,
        userRating: 7.0,
        genreNames: [],
      );

      expect(movie.backdropUrl, 'https://placehold.co/600x400');
    });

    test('Gère user_rating null ou manquant', () {
      final json1 = {
        'id': 1,
        'title': 'Test',
        'plot_overview': 'Test',
        'year': 2024,
        'user_rating': null,
      };

      final movie1 = Movie.fromJson(json1);
      expect(movie1.userRating, 0.0);

      final json2 = {
        'id': 2,
        'title': 'Test',
        'plot_overview': 'Test',
        'year': 2024,
      };

      final movie2 = Movie.fromJson(json2);
      expect(movie2.userRating, 0.0);
    });
  });
}
