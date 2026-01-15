import 'package:flutter/material.dart';
import 'dart:async';
import 'models.dart';
import 'widgets/question_text.dart';
import 'widgets/answer_button.dart';
import 'widgets/progress_counter.dart';
import 'widgets/timer_widget.dart';
import 'widgets/next_button.dart';
import 'widgets/result_screen.dart';
import 'high_scores_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}
class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswerIndex; // Index de la réponse sélectionnée
  bool isAnswerValidated = false; // Indique si la réponse a été validée
  Timer? _timer;
  AnimationController? _animationController;
  Animation<double>? _progressAnimation;
  int _timeRemaining = 10; // Temps en secondes
  static const int _totalTime = 10;
  DateTime? _quizStartTime; // Temps de début du quiz

  final List<Question> questions = [
    Question(
      question: 'Quelle entreprise développe Flutter ?',
      answers: [
        Answer(text: 'Google', isCorrect: true),
        Answer(text: 'Apple', isCorrect: false),
        Answer(text: 'Microsoft', isCorrect: false),
      ],
    ),
    Question(
      question: 'Quel langage est utilisé avec Flutter ?',
      answers: [
        Answer(text: 'Kotlin', isCorrect: false),
        Answer(text: 'Dart', isCorrect: true),
        Answer(text: 'Swift', isCorrect: false),
      ],
    ),
    Question(
      question: 'Dans quel club le footballeur Aubameyang a-t-il explosé ?',
      answers: [
        Answer(text: 'Arsenal', isCorrect: false),
        Answer(text: 'Manchester United', isCorrect: false),
        Answer(text: 'Saint-Etienne', isCorrect: true),
      ],
    ),
    Question(
      question: 'Quel est le plus petit club de Ligue 1 ?',
      answers: [
        Answer(text: 'Saint-Etienne', isCorrect: false),
        Answer(text: 'Paris', isCorrect: false),
        Answer(text: 'Lyon', isCorrect: true),
      ],
    ),
  ];

  void _startTimer() {
    _timeRemaining = _totalTime;
    
    // Arrêter les timers précédents
    _timer?.cancel();
    _animationController?.stop();
    _animationController?.reset();
    _animationController?.dispose();
    
    // Créer une nouvelle animation controller pour une animation fluide
    _animationController = AnimationController(
      duration: const Duration(seconds: _totalTime),
      vsync: this,
    );
    
    // Créer une animation qui va de 1.0 à 0.0 (plein à vide)
    _progressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
    
    // Mettre à jour le temps restant toutes les 100ms pour un affichage fluide
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || _animationController == null) {
        timer.cancel();
        return;
      }
      
      final elapsed = _animationController!.value * _totalTime;
      final remaining = (_totalTime - elapsed).ceil();
      
      if (remaining != _timeRemaining) {
        setState(() {
          _timeRemaining = remaining;
        });
      }
      
      // Si l'animation est terminée, valider automatiquement si une réponse est sélectionnée
      if (_animationController!.isCompleted) {
        timer.cancel();
        if (selectedAnswerIndex != null && !isAnswerValidated) {
          // Si une réponse est sélectionnée, la valider automatiquement
          validateAnswer();
        } else {
          // Sinon, passer à la question suivante sans donner de point
          _moveToNextQuestion();
        }
      }
    });
    
    // Démarrer l'animation
    _animationController!.forward();
  }

  void _moveToNextQuestion() {
    _timer?.cancel();
    _animationController?.stop();
    setState(() {
      currentQuestion++;
      selectedAnswerIndex = null; // Réinitialiser pour la prochaine question
      isAnswerValidated = false; // Réinitialiser la validation
      _timeRemaining = _totalTime;
    });
    // Démarrer le timer pour la nouvelle question
    if (currentQuestion < questions.length) {
      _startTimer();
    }
  }

  void selectAnswer(int answerIndex) {
    setState(() {
      selectedAnswerIndex = answerIndex;
      isAnswerValidated = false; // Réinitialiser la validation si on change de réponse
    });
  }

  void validateAnswer() {
    if (selectedAnswerIndex == null) return;
    
    final question = questions[currentQuestion];
    final selectedAnswer = question.answers[selectedAnswerIndex!];
    final isCorrect = selectedAnswer.isCorrect;
    
    setState(() {
      isAnswerValidated = true;
      if (isCorrect) {
        score++;
      }
    });
    
    // Attendre un peu pour montrer le feedback avant de passer à la question suivante
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _moveToNextQuestion();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _quizStartTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  void _restartQuiz() {
    _timer?.cancel();
    _animationController?.stop();
    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedAnswerIndex = null;
      isAnswerValidated = false;
      _timeRemaining = _totalTime;
      _quizStartTime = DateTime.now();
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= questions.length) {
      final timeElapsed = _quizStartTime != null
          ? DateTime.now().difference(_quizStartTime!)
          : Duration.zero;
      return ResultScreen(
        score: score,
        totalQuestions: questions.length,
        timeElapsed: timeElapsed,
        onRestart: _restartQuiz,
      );
    }

    final question = questions[currentQuestion];
    // Couleurs différentes pour chaque bouton de réponse
    final answerColors = [
      Colors.blue.shade400,
      Colors.purple.shade400,
      Colors.pink.shade400,
      Colors.orange.shade400,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Flutter'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            tooltip: 'Meilleurs scores',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HighScoresPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade50,
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Compteur de progression
              ProgressCounter(
                currentQuestion: currentQuestion + 1,
                totalQuestions: questions.length,
              ),
              const SizedBox(height: 20),
              // Timer et barre de progression
              TimerWidget(
                timeRemaining: _timeRemaining,
                progressAnimation: _progressAnimation,
              ),
              const SizedBox(height: 30),
              // Question
              QuestionText(questionText: question.question),
              const SizedBox(height: 25),
              // Boutons de réponse
              ...question.answers.asMap().entries.map((entry) {
                final index = entry.key;
                final answer = entry.value;
                final isSelected = selectedAnswerIndex == index;
                
                // Déterminer la couleur du bouton
                Color buttonColor;
                
                if (isSelected) {
                  if (isAnswerValidated) {
                    // Après validation, montrer vert si correct, rouge si incorrect
                    buttonColor = answer.isCorrect
                        ? Colors.green.shade600
                        : Colors.red.shade600;
                  } else {
                    // Avant validation, montrer une couleur de sélection plus foncée
                    buttonColor = answerColors[index % answerColors.length]
                        .withOpacity(0.8);
                  }
                } else {
                  // Couleur par défaut pour les boutons non sélectionnés
                  buttonColor = answerColors[index % answerColors.length]
                      .withOpacity(0.6);
                }
                
                return AnswerButton(
                  answer: answer,
                  index: index,
                  isSelected: isSelected,
                  isAnswerValidated: isAnswerValidated,
                  buttonColor: buttonColor,
                  onPressed: isAnswerValidated
                      ? null
                      : () => selectAnswer(index),
                );
              }),
              const Spacer(), // Pousser le bouton Suivant en bas
              // Bouton Suivant
              NextButton(
                isEnabled: selectedAnswerIndex != null && !isAnswerValidated,
                onPressed: (selectedAnswerIndex == null || isAnswerValidated)
                    ? null
                    : () => validateAnswer(),
              ),
          ],
        ),
      ),
      ),
    );
  }
}