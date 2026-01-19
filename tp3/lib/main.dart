import 'package:flutter/material.dart';
import 'movie_list_page.dart';
import 'service/movie_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP3 - Liste de films',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MovieListPage(
        movieService: MovieService(),
      ),
    );
  }
}
