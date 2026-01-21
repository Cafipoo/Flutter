// Modèle simplifié pour la liste des films
class MovieListItem {
  final int id;
  final String title;
  final int year;

  MovieListItem({
    required this.id,
    required this.title,
    required this.year,
  });

  factory MovieListItem.fromJson(Map<String, dynamic> json) {
    return MovieListItem(
      id: json['id'],
      title: json['title'] ?? 'Sans titre',
      year: json['year'] ?? 0,
    );
  }
}

// Modèle complet pour les détails d'un film
class Movie {
  final int id;
  final String title;
  final String plotOverview;
  final int year;
  final String? poster;
  final String? backdrop;
  final double userRating;
  final List<String> genreNames;
  final String? trailer;

  Movie({
    required this.id,
    required this.title,
    required this.plotOverview,
    required this.year,
    this.poster,
    this.backdrop,
    required this.userRating,
    required this.genreNames,
    this.trailer,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'Sans titre',
      plotOverview: json['plot_overview'] ?? 'Aucune description disponible',
      year: json['year'] ?? 0,
      poster: json['poster'],
      backdrop: json['backdrop'],
      userRating: (json['user_rating'] ?? 0).toDouble(),
      genreNames: (json['genre_names'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      trailer: json['trailer'],
    );
  }

  String get posterUrl =>
      poster ?? 'https://placehold.co/600x400';

  String get backdropUrl =>
      backdrop ?? 'https://placehold.co/600x400';
}

// Modèle pour une plateforme de streaming
class StreamingSource {
  final String name;
  final String type; // sub, buy, rent, free
  final String? webUrl;
  final String? iosUrl;
  final String? androidUrl;

  StreamingSource({
    required this.name,
    required this.type,
    this.webUrl,
    this.iosUrl,
    this.androidUrl,
  });

  factory StreamingSource.fromJson(Map<String, dynamic> json) {
    return StreamingSource(
      name: json['name'] ?? 'Inconnu',
      type: json['type'] ?? '',
      webUrl: json['web_url'],
      iosUrl: json['ios_url'],
      androidUrl: json['android_url'],
    );
  }

  // Retourne l'URL la plus appropriée
  String? get bestUrl => webUrl ?? iosUrl ?? androidUrl;

  // Retourne le type formaté en français
  String get typeLabel {
    switch (type) {
      case 'sub':
        return 'Abonnement';
      case 'buy':
        return 'Achat';
      case 'rent':
        return 'Location';
      case 'free':
        return 'Gratuit';
      default:
        return type;
    }
  }
}

// Modèle pour un membre du casting
class CastMember {
  final int personId;
  final String fullName;
  final String? headShotUrl;
  final String? role; // pour les acteurs: nom du personnage
  final String type; // Actor, Director, Writer, etc.

  CastMember({
    required this.personId,
    required this.fullName,
    this.headShotUrl,
    this.role,
    required this.type,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    // Gère les différents formats de l'API
    final name = json['full_name'] ?? json['name'] ?? json['fullName'] ?? 'Inconnu';
    final photo = json['headshot_url'] ?? json['headshotUrl'] ?? json['image'] ?? json['photo'];
    final characterRole = json['role'] ?? json['character'] ?? json['character_name'];
    final memberType = json['type'] ?? json['role_type'] ?? json['job'] ?? '';
    
    return CastMember(
      personId: json['person_id'] ?? json['id'] ?? 0,
      fullName: name.toString(),
      headShotUrl: photo?.toString(),
      role: characterRole?.toString(),
      type: memberType.toString(),
    );
  }
}