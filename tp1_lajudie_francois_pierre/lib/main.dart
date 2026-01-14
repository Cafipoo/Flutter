import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.barlowTextTheme()),
      title: 'Portfolio de Francois Pierre Lajudie',
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // On va ajouter nos widgets ici étape par étape
            // const Center(child: Text('Hello Portfolio!')),
              const ProfileHeader(
              backgroundImage: 'assets/images/background.jpg',
              profileImage: 'assets/images/profil.jpg',
            ),
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(16),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Carte d'info (légèrement tournée à gauche)
                    Expanded(
                      child: Transform.rotate(
                        angle: -0.10,
                        child: Transform.translate(
                          offset: const Offset(10, -3),
                          child: const InfoCard(
                            name: 'Lajudie',
                            birthDate: '08/11/2004',
                            city: 'Limoges',
                            profession: 'Développeur',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Carte QR Code (légèrement tournée à droite)
                    Expanded(
                      child: Transform.rotate(
                        angle: 0.14,
                        child: Transform.translate(
                          offset: const Offset(-10, 5),
                          child: const QrCard(
                            qrCodeImage: 'assets/images/qrcode.png',
                            label: 'Linkedin',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const TechIconsRow(),
            const Spacer(), 
            Image.asset('assets/images/logo.png', width: 80),
          ],
        ),
      ),
    );
  }
}
class ProfileHeader extends StatelessWidget {
  final String backgroundImage;
  final String profileImage;

  const ProfileHeader({
    super.key,
    required this.backgroundImage,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Image de fond
          Container(
            height: 300,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(100),
                    Colors.black.withAlpha(50),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Bouton partager en haut à droite
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white, size: 30),
              onPressed: () => _shareProfileImage(context),
            ),
          ),
          // Photo de profil qui déborde en bas
          Positioned(
            bottom: 0,
            child: Transform.translate(
              offset: const Offset(0, 80),
              child: Container(
                height: 250,
                width: 250,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(200),
                  image: DecorationImage(
                    image: AssetImage(profileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareProfileImage(BuildContext context) async {
    try {
      // Charger l'image depuis les assets
      final ByteData imageData = await rootBundle.load(profileImage);
      final Uint8List bytes = imageData.buffer.asUint8List();

      // Obtenir le répertoire temporaire
      final Directory tempDir = await getTemporaryDirectory();
      
      // Créer un nom de fichier unique
      final String fileName = path.basename(profileImage);
      final File tempFile = File(path.join(tempDir.path, fileName));

      // Écrire les bytes dans le fichier temporaire
      await tempFile.writeAsBytes(bytes);

      // Partager le fichier
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: 'Découvrez mon profil !',
      );
    } catch (e) {
      // Afficher un message d'erreur si le partage échoue
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du partage: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class InfoCard extends StatelessWidget {
  final String name;
  final String birthDate;
  final String city;
  final String profession;

  const InfoCard({
    super.key,
    required this.name,
    required this.birthDate,
    required this.city,
    required this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 163, 106, 218), Color.fromARGB(255, 171, 70, 238)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          InfoField(label: 'Date de naissance', value: birthDate),
          InfoField(label: 'Ville', value: city),
          InfoField(label: 'Profession', value: profession),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String label;
  final String value;

  const InfoField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade200),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class QrCard extends StatelessWidget {
  final String qrCodeImage;
  final String label;

  const QrCard({super.key, required this.qrCodeImage, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Image.asset(qrCodeImage, width: double.infinity),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
class TechIconsRow extends StatelessWidget {
  const TechIconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TechIcon(
            icon: FontAwesomeIcons.flutter,
            gradientColors: [Color(0xFFEA842B), Color.fromARGB(255, 237, 171, 114)],
            url: 'https://flutter.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.angular,
            gradientColors: [Color(0xffdd0031), Color.fromARGB(255, 239, 100, 79)],
            url: 'https://angular.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.react,
            gradientColors: [Color(0xFF43D6FF), Color.fromARGB(255, 130, 223, 250)],
            url: 'https://react.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.wordpress,
            gradientColors: [Color(0xfff05032), Color.fromARGB(255, 248, 130, 100)],
            url: 'https://wordpress.org',
          ),
          TechIcon(
            icon: FontAwesomeIcons.vuejs,
            gradientColors: [Color(0xff764abc), Color.fromARGB(255, 130, 100, 223)],
            url: 'https://vuejs.org',
          ),
        ],
      ),
    );
  }
}

class TechIcon extends StatefulWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final String url;

  const TechIcon({
    super.key,
    required this.icon,
    required this.gradientColors,
    required this.url,
  });

  @override
  State<TechIcon> createState() => _TechIconState();
}

class _TechIconState extends State<TechIcon> {
  bool _isPressed = false; // Variable pour suivre l'état du tap
  bool _isRotated = false; // Variable pour suivre l'état de la rotation

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        // Quand on appuie
        setState(() {
          _isPressed = true;
          _isRotated = true; // Activer la rotation au clic
        });
      },
      onTapUp: (_) {
        // Quand on relâche
        setState(() {
          _isPressed = false;
          _isRotated = false; // Désactiver la rotation
        });
        // Ouvrir l'URL
        _launchUrl();
      },
      onTapCancel: () {
        // Si on annule le tap
        setState(() {
          _isPressed = false;
          _isRotated = false; // Désactiver la rotation
        });
      },
      child: AnimatedRotation(
        // Rotation au clic : 0.1 radians ≈ 6 degrés, avec animation fluide
        turns: _isRotated ? 0.1 / (2 * 3.14159) : 0.0, // Convertir radians en tours
        duration: const Duration(milliseconds: 200),
        child: Transform.scale(
          // Animation de scale : 1.0 = taille normale, 0.9 = plus petit
          scale: _isPressed ? 0.9 : 1.0,
            child: AnimatedContainer(
              // AnimatedContainer anime automatiquement les changements
              duration: const Duration(milliseconds: 100), // Durée de l'animation
              width: 60,
              height: 60,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: LinearGradient(
                  colors: widget.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: FaIcon(widget.icon, color: Colors.white),
            ),
          ),
        ),
    );
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}