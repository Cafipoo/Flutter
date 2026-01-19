# 🧱 TP2 – Quiz interactif avec score

## 📋 Description

Application Flutter de quiz interactif avec gestion de score, timer, sélection de réponses, validation et page des meilleurs scores. Le projet est organisé avec des modèles, des widgets réutilisables et un design moderne.

## ✅ État d'avancement

**TP complété à 100% avec tous les bonus** 🎉

### Fonctionnalités principales (TP2 de base)
- ✅ Structure du projet organisée (modèles, widgets séparés)
- ✅ Gestion d'état avec `setState()`
- ✅ Logique de sélection visuelle des réponses
- ✅ Bouton "Suivant" actif/inactif selon la sélection
- ✅ Compteur de progression "Question X/Y"
- ✅ Calcul et affichage du score final
- ✅ Design moderne et coloré avec gradients
- ✅ Écran de résultat avec pourcentage

### Bonus implémentés
- ✅ **Bonus 1 : Timer** (+0.5 point)
  - Timer de 10 secondes par question
  - Barre de progression animée
  - Validation automatique si une réponse est sélectionnée quand le timer atteint 0
  - Changement de couleur quand le temps est critique (rouge)
  
- ✅ **Bonus 2 : Meilleurs scores** (+1 point)
  - Page dédiée aux meilleurs scores
  - Stockage local avec `shared_preferences`
  - Affichage du score, du temps écoulé et de la date
  - Possibilité de supprimer les scores
  - Tri par score décroissant

## 📸 Captures d'écran

### Écran du quiz en cours
![Quiz en cours](https://github.com/Cafipoo/Flutter/raw/main/tp2/result%20app/quiz.png)

### Écran de résultat
![Résultat](https://github.com/Cafipoo/Flutter/raw/main/tp2/result%20app/result.png)

### Page des meilleurs scores
![Meilleurs scores](https://github.com/Cafipoo/Flutter/raw/main/tp2/result%20app/score.png)

## 🚀 Fonctionnalités détaillées

### Quiz principal
- **Sélection de réponse** : Clic sur une réponse la sélectionne (couleur bleue) sans passer à la suite
- **Bouton "Suivant"** : Désactivé tant qu'aucune réponse n'est sélectionnée
- **Validation** : Affichage visuel (vert/rouge) après validation
- **Timer** : Compte à rebours avec barre de progression animée
- **Progression** : Compteur "Question X sur Y" en haut de l'écran

### Écran de résultat
- Affichage du score final (X/Y)
- Pourcentage de bonnes réponses
- Icône dynamique selon le score (célébration, pouce, triste)
- Temps écoulé affiché
- Sauvegarde automatique du score
- Boutons pour voir les meilleurs scores ou rejouer

### Page des meilleurs scores
- Liste des meilleurs scores triés par score décroissant
- Affichage du score, temps et date pour chaque résultat
- Bouton pour supprimer tous les scores
- Design cohérent avec le reste de l'application

## 📦 Dépendances

- `shared_preferences: ^2.5.4` : Pour le stockage local des scores

## 🏗️ Structure du projet

```
tp2/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   ├── models.dart                  # Modèles (Answer, Question, ScoreRecord)
│   ├── quiz_page.dart              # Page principale du quiz
│   ├── high_scores_page.dart       # Page des meilleurs scores
│   ├── services/
│   │   └── score_service.dart      # Service de gestion des scores
│   └── widgets/
│       ├── answer_button.dart      # Widget bouton de réponse
│       ├── next_button.dart        # Widget bouton "Suivant"
│       ├── progress_counter.dart   # Widget compteur de progression
│       ├── question_text.dart      # Widget affichage de la question
│       ├── result_screen.dart      # Widget écran de résultat
│       └── timer_widget.dart       # Widget timer et barre de progression
└── pubspec.yaml
```

## 🔧 Fonctionnalités techniques

### Timer
- Animation fluide avec `AnimationController`
- Mise à jour toutes les 100ms pour un affichage précis
- Validation automatique si réponse sélectionnée à la fin du timer
- Changement visuel (rouge) quand le temps est critique

### Gestion des scores
- Stockage persistant avec `SharedPreferences`
- Modèle `ScoreRecord` avec sérialisation JSON
- Service dédié pour la gestion des scores
- Tri automatique par score décroissant

### Architecture
- Modèles séparés dans `models.dart`
- Widgets réutilisables dans le dossier `widgets/`
- Service de données dans `services/`
- Code modulaire et maintenable

## 📚 Technologies utilisées

- **Flutter** : Framework de développement
- **Dart** : Langage de programmation
- **Material Design** : Design system
- **SharedPreferences** : Stockage local
- **Animations** : Pour le timer et les transitions

## 🔗 Lien GitHub

[Voir le projet sur GitHub](https://github.com/Cafipoo/Flutter/tree/main/tp2)

