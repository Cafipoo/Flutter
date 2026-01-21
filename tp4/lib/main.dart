import 'package:flutter/material.dart';
import 'pages/movie_list_page.dart';
import 'services/movie_service.dart';

// Instance globale du service partagée dans toute l'application
final movieService = MovieService();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP4 - Films Watchmode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MovieListPage(movieService: movieService),
    );
  }
}