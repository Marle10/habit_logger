import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Abrir la caja de usuario. Asegúrate de registrar el adaptador User antes en main.dart
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    final userBox = await Hive.openBox<User>('userBox');

    await Future.delayed(const Duration(seconds: 3)); // Simula un tiempo de carga

    if (userBox.isNotEmpty) {
      // Si hay un usuario logueado, ir a la pantalla de inicio
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Si no hay usuario, ir a la pantalla de login
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EF), // Color de fondo de la imagen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_box_outlined, // Icono de check (puedes buscar uno más parecido)
                    size: 80,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Habit\nLogger',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      height: 1.0, // Ajusta la altura de línea si es necesario
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

