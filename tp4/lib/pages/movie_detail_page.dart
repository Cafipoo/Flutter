import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieService movieService;
  final int movieId;

  const MovieDetailPage({
    super.key,
    required this.movieService,
    required this.movieId,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Movie? movie;
  List<StreamingSource> sources = [];
  List<CastMember> cast = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Charge toutes les données en une seule fois (détails + sources + casting)
      final fullDetails = await widget.movieService.getMovieFullDetails(widget.movieId);
      setState(() {
        movie = fullDetails.movie;
        sources = fullDetails.sources;
        cast = fullDetails.cast;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _openTrailer() async {
    if (movie?.trailer == null) return;

    final uri = Uri.parse(movie!.trailer!);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d\'ouvrir la bande-annonce'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie?.title ?? 'Chargement...'),
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
                        onPressed: _loadMovieDetails,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image du poster
                      Image.network(
                        movie!.posterUrl,
                        width: double.infinity,
                        height: 500,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 500,
                          color: Colors.grey[300],
                          child: const Icon(Icons.movie, size: 100),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Note et année
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 28),
                                const SizedBox(width: 8),
                                Text(
                                  movie!.userRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '/ 10',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${movie!.year}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Genres
                            if (movie!.genreNames.isNotEmpty) ...[
                              Wrap(
                                spacing: 8,
                                children: movie!.genreNames
                                    .map((genre) => Chip(
                                          label: Text(genre),
                                          backgroundColor: Colors.blue[100],
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                            ],
                            // Plateformes de streaming
                            if (sources.isNotEmpty) ...[
                              const Text(
                                'Où regarder',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: sources.map((source) => _buildSourceChip(source)).toList(),
                              ),
                              const SizedBox(height: 24),
                            ],
                            // Casting
                            const Text(
                              'Casting',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (cast.isNotEmpty)
                              SizedBox(
                                height: 140,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cast.length,
                                  itemBuilder: (context, index) => _buildCastCard(cast[index]),
                                ),
                              )
                            else
                              Text(
                                'Casting non disponible',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            const SizedBox(height: 24),
                            // Synopsis
                            const Text(
                              'Synopsis',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movie!.plotOverview,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                            // Bouton bande-annonce si disponible
                            if (movie!.trailer != null) ...[
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: _openTrailer,
                                icon: const Icon(Icons.play_circle_outline),
                                label: const Text('Voir la bande-annonce'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSourceChip(StreamingSource source) {
    return ActionChip(
      avatar: Icon(
        _getSourceIcon(source.name),
        size: 18,
        color: _getSourceColor(source.name),
      ),
      label: Text(
        source.name,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[800],
        ),
      ),
      backgroundColor: _getSourceColor(source.name).withOpacity(0.1),
      side: BorderSide(color: _getSourceColor(source.name).withOpacity(0.3)),
      onPressed: source.bestUrl != null
          ? () async {
              final uri = Uri.parse(source.bestUrl!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
          : null,
    );
  }

  IconData _getSourceIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('netflix')) return Icons.play_circle_filled;
    if (lowerName.contains('amazon') || lowerName.contains('prime')) return Icons.shopping_bag;
    if (lowerName.contains('disney')) return Icons.castle;
    if (lowerName.contains('apple')) return Icons.apple;
    if (lowerName.contains('hbo') || lowerName.contains('max')) return Icons.movie;
    if (lowerName.contains('hulu')) return Icons.tv;
    if (lowerName.contains('youtube')) return Icons.play_arrow;
    if (lowerName.contains('google')) return Icons.play_arrow;
    return Icons.live_tv;
  }

  Color _getSourceColor(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('netflix')) return Colors.red;
    if (lowerName.contains('amazon') || lowerName.contains('prime')) return Colors.blue;
    if (lowerName.contains('disney')) return Colors.indigo;
    if (lowerName.contains('apple')) return Colors.black;
    if (lowerName.contains('hbo') || lowerName.contains('max')) return Colors.purple;
    if (lowerName.contains('hulu')) return Colors.green;
    if (lowerName.contains('youtube') || lowerName.contains('google')) return Colors.red[700]!;
    return Colors.teal;
  }

  Widget _buildCastCard(CastMember member) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            backgroundImage: member.headShotUrl != null
                ? NetworkImage(member.headShotUrl!)
                : null,
            child: member.headShotUrl == null
                ? Text(
                    member.fullName.isNotEmpty ? member.fullName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            member.fullName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (member.role != null) ...[
            const SizedBox(height: 2),
            Text(
              member.role!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}