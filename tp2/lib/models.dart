// lib/models.dart
class Answer {
  final String text;
  final bool isCorrect;

  Answer({required this.text, required this.isCorrect});
}

class Question {
  final String question;
  final List<Answer> answers;

  Question({required this.question, required this.answers});
}

class ScoreRecord {
  final int score;
  final int totalQuestions;
  final Duration timeElapsed;
  final DateTime date;

  ScoreRecord({
    required this.score,
    required this.totalQuestions,
    required this.timeElapsed,
    required this.date,
  });

  // Convertir en Map pour le stockage JSON
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
      'timeElapsed': timeElapsed.inMilliseconds,
      'date': date.toIso8601String(),
    };
  }

  // Créer depuis un Map (pour la lecture depuis JSON)
  factory ScoreRecord.fromJson(Map<String, dynamic> json) {
    return ScoreRecord(
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      timeElapsed: Duration(milliseconds: json['timeElapsed'] as int),
      date: DateTime.parse(json['date'] as String),
    );
  }

  // Pour l'affichage du temps formaté
  String get formattedTime {
    final minutes = timeElapsed.inMinutes;
    final seconds = timeElapsed.inSeconds % 60;
    final milliseconds = (timeElapsed.inMilliseconds % 1000) ~/ 10;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s ${milliseconds.toString().padLeft(2, '0')}ms';
    }
  }
}
