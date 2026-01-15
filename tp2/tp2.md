# 🧱 TP2 – Quiz interactif avec score

## 🎯 Objectifs
- Découvrir la gestion de l’état avec `setState()`  
- Manipuler des listes et des modèles de données simples  
- Créer une interface de quiz à choix multiples  
- Calculer et afficher un score final  

🕐 **Durée estimée : 2 à 3 heures**

<img src="../img/tp2_1.png" width="300" alt="Quiz Flutter">

---

## 🪜 Étape 1 — Préparer la structure du quiz

Pour garder un code propre et maintenable, nous allons séparer notre application en plusieurs petits fichiers. C'est ce qu'on appelle la **composition**.

### 1. Les modèles de données
Crée `lib/models.dart`. Ce fichier contient la description de nos données (sans aucun widget). Dans un gros projet il faudrait les mettre dans un dossier `models/` et créer un fichier par modèle, mais pour ce TP un seul fichier suffira.

```dart
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
```

### 2. Les composants graphiques (Widgets)
Au lieu de tout mettre dans un seul fichier, nous allons extraire certains éléments dans des widgets séparés.

Crée `lib/question_text.dart` pour l'affichage de la question :
```dart
import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  final String questionText;

  const QuestionText({
    super.key,
    required this.questionText,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      questionText,
      style: const TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );
  }
}
```

### 3. La page principale du Quiz
Maintenant, nous assemblons le tout dans `lib/quiz_page.dart`.

```dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'question_text.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;

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
  ];

  void answerQuestion(bool isCorrect) {
    setState(() {
      if (isCorrect) score++;
      currentQuestion++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Résultat')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Score final : $score / ${questions.length}',
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentQuestion = 0;
                    score = 0;
                  });
                },
                child: const Text('Rejouer'),
              )
            ],
          ),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Flutter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuestionText(questionText: question.question),
            const SizedBox(height: 20),
            // On génère les boutons de réponse directement ici
            ...question.answers.map((answer) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () => answerQuestion(answer.isCorrect),
                  child: Text(answer.text),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
```

> **💡 Pourquoi StatefulWidget ?**
> Un **StatefulWidget** est un widget qui peut "se souvenir" de choses et changer au fil du temps. Ici, ton quiz doit se souvenir de la question actuelle et du score. C'est différent d'un **StatelessWidget** qui est figé et ne change jamais. Pense à StatefulWidget comme une page avec un compteur qui bouge, et StatelessWidget comme une pancarte fixe.

> **💡 Notions clés :**
> - **Composition** : On extrait les parties répétitives ou complexes dans des widgets séparés (comme `QuestionText`) pour garder un code propre.
> - **setState()** : Dit à Flutter "j'ai changé quelque chose, redessine l'écran !". Sans `setState()`, même si tu modifies `currentQuestion`, l'interface ne se met pas à jour.
> - **Cycle de vie - initState() vs build()** :
>   - `initState()` : Appelé **une seule fois** quand le widget est créé. Parfait pour charger des données initiales ou configurer des écouteurs.
>   - `build()` : Appelé **à chaque fois** que le widget doit se redessiner (après chaque `setState()`). C'est ici que tu construis ton interface.
>   - *Règle d'or* : Ce qui doit se faire qu'une fois → `initState()`. Ce qui décrit l'interface → `build()`.
> - **`...` (spread operator)** : "Décompresse" une liste pour en étaler les éléments. Utilisé ici pour afficher tous les boutons de réponses.
> - **`.map()`** : Transforme chaque élément d'une liste. Pour chaque réponse, on crée un bouton.

Enfin, n'oublie pas de mettre à jour ton `lib/main.dart` :

```dart
import 'package:flutter/material.dart';
import 'quiz_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP2 - Quiz Flutter',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const QuizPage(),
    );
  }
}
```

✅ Teste ton quiz. Tu devrais pouvoir répondre à plusieurs questions et obtenir un score final.

---

## 🪜 Étape 2 — Améliorer l’expérience utilisateur

Pour l'instant, le quiz passe tout de suite à la question suivante dès qu'on clique. C'est un peu brutal !
Nous allons ajouter une étape de validation et du feedback.

**Tes missions :**
1.  Ajoute un **compteur de progression** (ex: “Question 2 sur 3”) en haut de la page.
2.  Modifie le comportement pour que le clic sur une réponse la **sélectionne** (changement de couleur) mais ne passe pas encore à la suite.
3.  Ajoute un bouton **"Suivant"** en bas de l'écran :
    *   Il doit être **désactivé (grisé)** tant que l'utilisateur n'a pas choisi de réponse.
    *   Quand on clique dessus, il valide la réponse et passe à la question suivante.
4.  Ajoute un **feedback visuel** lors de la validation pour indiquer si la réponse était bonne ou mauvaise (via un `SnackBar` ou un changement de couleur temporaire).

> **💡 Comment afficher un message rapide ?**
> Tu peux utiliser un `SnackBar` pour donner un feedback immédiat :
> ```dart
> ScaffoldMessenger.of(context).showSnackBar(
>   SnackBar(content: Text(isCorrect ? 'Bonne réponse !' : 'Mauvaise réponse...')),
> );
> ```

> **💡 Indice pour le bouton désactivé** :
> Dans un `ElevatedButton`, si `onPressed` vaut `null`, le bouton devient automatiquement grisé et inactif !
> ```dart
> ElevatedButton(
>   onPressed: selectedAnswer == null ? null : () { ... },
>   child: const Text('Suivant'),
> )
> ```

---

## 🪜 Étape 3 — Ajouter un design plus travaillé

Quelques idées :
- Une couleur différente par question  
- Un fond avec un `LinearGradient`  
- Des icônes (`Icons.check`, `Icons.close`) pour rendre le quiz plus visuel  

Inspire-toi des guidelines Material Design !

---

## ✅ Objectif final

À la fin du TP, ton application doit :
- Afficher une série de **questions à choix multiples**
- Gérer la **progression et le score**
- Demander une **confirmation** via un bouton "Suivant" avant de changer de question
- Afficher un **écran de résultat** clair et redémarrer le quiz
- Avoir un **design personnalisé et agréable**

<img src="../img/tp2_2.png" width="300" alt="Quiz Flutter">

---

## 💾 Rendu attendu

- Projet Flutter complet nommé : **`tp2_nom_prenom`**  
- Capture d’écran du quiz en cours (avec une sélection active) et du score final  
- Lien GitHub

---

## 🧮 Barème de notation

| Critère | Détails | Points |
|----------|----------|--------|
| **Structure du projet** | Organisation des fichiers (modèles, widgets), code clair | 3 |
| **Gestion d’état (`setState`)** | Bonne utilisation de la logique et mise à jour de l’UI | 3 |
| **Logique de sélection** | Sélection visuelle d'une réponse + Bouton Suivant actif/inactif | 3 |
| **Affichage et Progression** | Liste des questions, compteur "Question X/Y" | 2 |
| **Calcul du score** | Score exact et affiché correctement | 2 |
| **Design et ergonomie** | UI soignée, marges, cohérence visuelle | 3 |
| **Code et bonnes pratiques** | Respect des conventions Flutter/Dart, typage fort | 2 |
| **Créativité** | Améliorations visuelles, animations, styles | 2 |
| **Total** |  | **/20** |

---

### 🎁 Bonus (+1.5 points possibles)

#### Bonus 1 : Timer (+0.5 point)
Ajouter un **timer** pour chaque question (compte à rebours) et passer automatiquement à la suivante si le temps est écoulé (sans donner de point).

#### Bonus 2 : Meilleurs scores (+1 point)
Créer une **page “Meilleurs scores”** qui affiche les meilleurs résultats enregistrés localement avec `shared_preferences`.

---

## 💡 Conseils
- Commence simple, vérifie que la logique fonctionne avant d'ajouter du style.
- Si ton quiz plante, affiche des `print()` pour suivre les valeurs.
- Découpe ton code en widgets pour plus de clarté (`QuestionWidget`, `AnswerButton`, etc.).
- Si tu veux aller plus loin : transforme le quiz en un mini-jeu à thèmes (culture, cinéma, dev...).

### 📚 Aller plus loin : Quand dépasser `setState()` ?
Dans ce TP, `setState()` est parfait pour gérer l'état local simple (score, question actuelle). Mais il montre ses limites quand :
- Tu dois partager des données entre plusieurs pages (ex : score accessible partout)
- Ton état devient complexe avec beaucoup de variables interdépendantes
- Tu veux séparer la logique métier de l'interface

Pour des applications plus grandes, explore des solutions de gestion d'état comme **Provider**, **Riverpod** ou **Bloc**. Mais pour ce TP, `setState()` reste le bon choix !

---

## 📚 Ressources utiles

- **StatefulWidget** : https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
- **SetState** : https://api.flutter.dev/flutter/widgets/State-class.html#setState
- **Material Design Guidelines** : https://m3.material.io/