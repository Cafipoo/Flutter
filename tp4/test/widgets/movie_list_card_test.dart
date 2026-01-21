import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tp4/models/movie.dart';
import 'package:tp4/pages/movie_list_page.dart';
import 'package:tp4/services/movie_service.dart';

void main() {
  group('MovieListCard Widget Tests', () {
    testWidgets("Affiche correctement le titre et l'année d'un film",
        (WidgetTester tester) async {
      // Créer un film de test
      final testMovie = MovieListItem(
        id: 1,
        title: 'Test Movie',
        year: 2024,
      );

      // Construire le widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Assert : Vérifier que le titre et l'année sont affichés
      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('Année : 2024'), findsOneWidget);
    });

    testWidgets("Affiche l'icône favorite quand le film est favori",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Favorite Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: true,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Vérifier que l'icône favorite pleine est affichée
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets("Affiche l'icône favorite_border quand isFavorite est false",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Not Favorite Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Vérifier que l'icône favorite_border est affichée
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets("Affiche le CircleAvatar avec la première lettre du titre",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Avatar Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Vérifier que le CircleAvatar contient la première lettre
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets("Affiche '?' dans le CircleAvatar si le titre est vide",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: '',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Vérifier que '?' est affiché
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets("Appelle onFavoriteTap quand on clique sur l'icône favorite",
        (WidgetTester tester) async {
      bool wasTapped = false;

      final testMovie = MovieListItem(
        id: 1,
        title: 'Tappable Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Trouver et cliquer sur l'icône favorite
      final favoriteIcon = find.byIcon(Icons.favorite_border);
      expect(favoriteIcon, findsOneWidget);
      await tester.tap(favoriteIcon);
      await tester.pump();

      // Vérifier que le callback a été appelé
      expect(wasTapped, true);
    });

    testWidgets("Utilise favoriteIcon si fourni au lieu de l'icône par défaut",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Custom Icon Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
              favoriteIcon: Icons.delete,
            ),
          ),
        ),
      );

      // Vérifier que l'icône personnalisée est affichée
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets("Affiche la couleur rouge pour l'icône favorite quand isFavorite est true",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Red Favorite Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: true,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Trouver l'icône favorite
      final favoriteIcon = find.byIcon(Icons.favorite);
      expect(favoriteIcon, findsOneWidget);

      // Vérifier que l'icône a la couleur rouge
      final iconWidget = tester.widget<Icon>(favoriteIcon);
      expect(iconWidget.color, Colors.red);
    });
  });
}

// Mock (simulation) du MovieService pour les tests
// Permet de créer un MovieListCard sans avoir besoin d'une vraie connexion API
// Dans ces tests, on ne teste que l'affichage, donc ces méthodes ne sont jamais appelées
class MockMovieService extends MovieService {
  @override
  Future<List<MovieListItem>> getMovies({int limit = 20}) async {
    return []; // Retourne une liste vide (non utilisée dans ces tests)
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    // Lance une erreur car non implémenté (non utilisé dans ces tests)
    throw UnimplementedError();
  }
}
