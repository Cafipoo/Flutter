import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models.dart';

/// Service pour gérer le stockage et la récupération des scores
class ScoreService {
  static const String _scoresKey = 'high_scores';

  /// Sauvegarder un nouveau score
  static Future<void> saveScore(ScoreRecord score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getScores();
    
    // Ajouter le nouveau score
    scores.add(score);
    
    // Trier par score décroissant, puis par temps croissant (meilleur temps = meilleur)
    scores.sort((a, b) {
      if (a.score != b.score) {
        return b.score.compareTo(a.score); // Score décroissant
      }
      return a.timeElapsed.compareTo(b.timeElapsed); // Temps croissant
    });
    
    // Garder seulement les 10 meilleurs scores
    if (scores.length > 10) {
      scores.removeRange(10, scores.length);
    }
    
    // Sauvegarder
    final jsonList = scores.map((s) => s.toJson()).toList();
    await prefs.setString(_scoresKey, jsonEncode(jsonList));
  }

  /// Récupérer tous les scores
  static Future<List<ScoreRecord>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_scoresKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => ScoreRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Effacer tous les scores
  static Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoresKey);
  }
}
