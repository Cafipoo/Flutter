# 🧱 TP0 – Configuration de l'environnement et premiers pas

## 🎯 Objectifs
- Installer **Flutter** et **VS Code**
- Créer et lancer son premier projet "Hello World"
- Découvrir **Git et GitHub**

🕐 **Durée estimée : 1 heure**

---

## 🪜 Étape 1 — Installer Flutter

La méthode la plus simple est de suivre la documentation officielle en ligne. Vous pouvez également utiliser l'extension VS Code pour vous guider.

👉 **Documentation officielle** : https://docs.flutter.dev/get-started/install

### ✅ Checkpoint : Vérifie l'installation

Lance dans un terminal :
```bash
flutter doctor
```

Tu dois voir :
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] ou [!] Android toolchain / Chrome
```

**❌ Si `[✗] Flutter` :** Reprends l'installation et vérifie le PATH
**⚠️ Si `[!]` :** C'est normal, continue !

<img src="../img/flutter_doctor.png" width="400" alt="flutter doctor">

---

## 🪜 Étape 1 bis — Alternative avec FVM (Flutter Version Manager)

Si vous ne souhaitez pas installer Flutter "en dur" sur votre système ou si vous voulez gérer plusieurs versions facilement, vous pouvez utiliser **FVM**.

1. Installez FVM : https://fvm.app/docs/getting_started/installation
2. Installez la version stable de Flutter :
   ```bash
   fvm install stable
   fvm use stable --global
   ```
3. Pour utiliser Flutter avec FVM, préfixez vos commandes par `fvm` :
   ```bash
   fvm flutter doctor
   fvm flutter create mon_projet
   ```

---

## 🪜 Étape 2 — Installer VS Code

1. Télécharge VS Code : https://code.visualstudio.com/
2. Installe l'extension **Flutter** (Ctrl+Shift+X ou Cmd+Shift+X)
   - L'extension Dart s'installera automatiquement

<img src="../img/flutter_vscode.png" width="400" alt="vs code flutter">

---

## 🪜 Étape 3 — Installer Android Studio (utile pour les commandes adb)

Android Studio permet de lancer l'application sur un émulateur Android.

1. **Télécharge Android Studio** : https://developer.android.com/studio
2. **Installe-le** et lance-le
3. **Installe les Command-line Tools** (Indispensable) :
   - Allez dans les paramètres d'Android Studio (Settings ou Preferences).
   - Cherchez **Android SDK**.
   - Cliquez sur l'onglet **SDK Tools**.
   - Sélectionnez **Android SDK Command-line Tools (latest)**.
   - Cliquez sur **Apply** pour installer.

<img src="../img/watchmode_api.png" width="600" alt="Android SDK Tools">

4. **Accepte les licences** :
   ```bash
   flutter doctor --android-licenses
   ```
   (Tape `y` pour accepter toutes les licences)

5. **Crée un émulateur** :
   - Dans Android Studio, va dans **Tools > Device Manager**
   - Clique sur **Create Device**
   - Choisis un modèle (ex : **Pixel 6**)
   - Télécharge une image système (ex : **Android 13**)
   - Clique sur **Finish**

<img src="../img/device_manager.png" width="400" alt="Device manager">


6. **Lance l'émulateur** :
   - Dans Device Manager, clique sur le bouton ▶️ à côté de ton émulateur

### ✅ Checkpoint : Vérifie l'émulateur

Lance dans un terminal :
```bash
flutter devices
```

Tu dois voir ton émulateur dans la liste :
```
Android SDK built for x86 (mobile) • emulator-5554 • android-x86 • Android 13 (API 33)
```

**❌ Si l'émulateur n'apparaît pas :** Relance-le depuis Android Studio

---

## 🪜 Étape 4 — Créer ton premier projet

### ⚠️ Important sur Windows
**Évitez les accents dans vos chemins d'accès !**
Si votre nom d'utilisateur Windows ou vos dossiers contiennent des accents (ex: `C:\Users\Hélène\Projets`), Flutter risque de planter lors du lancement sur Android (erreur de caractères inconnus). Cela s'applique également aux dossiers parents.
Créez vos projets dans un dossier simple à la racine, comme `C:\dev` ou `C:\flutter_projects`.

1. Ouvre un terminal :
   ```bash
   cd ~/Localisation/De/Ton/Choix
   flutter create tp0_prenom_nom
   cd tp0_prenom_nom
   code .
   ```

2. Lance l'application :
   - Dans VS Code, ouvre la palette (Ctrl+Shift+P ou Cmd+Shift+P)
   - Tape "Flutter: Select Device"
   - Choisis un device :
     - **Chrome** (le plus simple pour débuter)
     - **Ton émulateur Android** (si tu as installé Android Studio)
   - Appuie sur **F5**

### ✅ Checkpoint : Vérifie le lancement

Tu dois voir une application avec un compteur qui s'incrémente quand tu cliques sur **+**

**Sur Chrome :** L'app s'ouvre dans le navigateur
**Sur Android :** L'app s'ouvre dans l'émulateur

**❌ Si erreur :** Lance `flutter devices` pour voir les devices disponibles

---

## 🪜 Étape 5 — Créer un "Hello World"

Remplace tout le contenu de `lib/main.dart` par :

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP0 - Hello World',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon premier TP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello World!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Je m'appelle [Ton Prénom]",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                print('Bouton cliqué !');
              },
              child: const Text('Clique-moi'),
            ),
          ],
        ),
      ),
    );
  }
}
```

<img src="../img/hello_world_flutter.png" width="300" alt="hello world flutter">

### ✅ Checkpoint : Teste le Hot Reload

1. Remplace `[Ton Prénom]` par ton vrai prénom
2. Sauvegarde (Ctrl+S ou Cmd+S)
3. L'app doit se mettre à jour instantanément

**❌ Si pas de mise à jour :** Appuie sur `R` dans le terminal pour forcer un Hot Restart

---

## 🪜 Étape 6 — Configurer Git et GitHub

### Installer et configurer Git

**Windows** : https://git-scm.com/download/win
**macOS** : Déjà installé

Configure ton identité :
```bash
git config --global user.name "Ton Nom"
git config --global user.email "ton.email@example.com"
```

### Créer un dépôt GitHub

1. Va sur https://github.com et connecte-toi
2. Clique sur "+" → "New repository"
3. Nomme-le `tp0-prenom-nom` et laisse-le **public**
4. **NE coche PAS** "Add a README"
5. Clique sur "Create repository"

### Pousser ton code

Dans le terminal de ton projet :
```bash
git add .
git commit -m "Initial commit - Hello World Flutter"
git remote add origin https://github.com/ton-username/tp0-prenom-nom.git
git branch -M main
git push -u origin main
```

---

## 🪜 Étape 7 — Faire une modification et la pousser

1. Modifie le code (change la couleur du bouton, ajoute du texte, etc.)
2. Commite et pousse :
   ```bash
   git add .
   git commit -m "modification de l'interface"
   git push
   ```

### ✅ Checkpoint : Vérifie le commit

Sur GitHub, tu dois voir ton nouveau commit dans l'historique.

---

## ✅ Validation finale (non noté)

Pour valider ce TP0, tu dois avoir :
- ✅ Flutter installé (`flutter doctor` fonctionne)
- ✅ VS Code avec l'extension Flutter
- ✅ Un projet Flutter qui se lance avec ton prénom
- ✅ Un dépôt GitHub avec au moins 2 commits

---

## 🔧 Dépannage rapide

### Flutter doctor affiche des erreurs
- **Android toolchain** : Lance `flutter doctor --android-licenses` pour accepter les licences
- **cmdline-tools** : Dans Android Studio → Settings → Android SDK → SDK Tools → Coche "Android SDK Command-line Tools"

### L'émulateur Android ne démarre pas
- Vérifie que la virtualisation est activée dans le BIOS (Windows)
- Relance Android Studio et ouvre Device Manager
- Essaie de créer un nouvel émulateur avec une image système plus récente

### L'application ne se lance pas
- Vérifie qu'un device est sélectionné : `flutter devices`
- Si tu utilises l'émulateur, assure-toi qu'il est bien lancé
- Essaie de lancer avec : `flutter run -d chrome` ou `flutter run -d <device-id>`

---

## 📚 Ressources utiles

- **Documentation Flutter** : https://docs.flutter.dev/
- **Dart Language Tour** : https://dart.dev/guides/language/language-tour
- **Widget Catalog** : https://docs.flutter.dev/ui/widgets

---

## 🎉 Félicitations !

Tu es maintenant prêt à attaquer les TPs suivants ! 🚀
