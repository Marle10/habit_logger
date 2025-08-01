// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart'; // Importa el modelo de usuario
import '../services/api_service.dart'; // Importa ApiService

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ApiService _apiService = ApiService(); // Instancia de ApiService

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validación de email más robusta
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  Future<void> _register() async {
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    if (password.length < 6) { // Ejemplo de validación de longitud
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres.')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un formato de correo válido (ej: usuario@dominio.com).')),
      );
      return;
    }

    // Asegurar que el adaptador de User esté registrado (aunque idealmente en main.dart)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    final userBox = await Hive.openBox<User>('userBox');

    // **Lógica de verificación de usuario existente en Hive (simplificada)**
    // En una app real con múltiples usuarios en Hive, buscarías por un ID único,
    // o simplemente no permitirías el registro si ya existe UN usuario "logueado" en la caja principal.
    if (userBox.isNotEmpty) {
      // Si ya hay un usuario en la caja, asumimos que no se puede registrar otro
      // a menos que sea una app multi-usuario con lógica diferente.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya existe un usuario registrado localmente. Por favor, inicia sesión.')),
      );
      Navigator.of(context).pushReplacementNamed('/login'); // Redirige a login
      return;
    }

    try {
      // 1. Intentar registrar en la API (simulado)
      // Pasamos el username (puede ser String? si así lo definiste en User y ApiService)
      final apiResponse = await _apiService.registerUser(username, email);
      print('Usuario registrado en API (simulado): $apiResponse');

      // Si la API responde exitosamente, entonces guardamos en Hive
      // Si la API tiene un ID de usuario, podríamos guardarlo en el modelo User también.
      final newUser = User(username: username, email: email); // Aquí no se guarda la contraseña por seguridad
      await userBox.add(newUser); // Guarda en Hive

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso. ID en API: ${apiResponse['id'] ?? 'N/A'}')),
      );

      // Navegar a la pantalla principal después del registro
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('Error al registrar usuario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
      // En caso de error en la API, no guardamos en Hive
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EF),
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack( // Usamos Stack para las ondas decorativas
        children: [
          // Ondas decorativas - Añadidas aquí para consistencia con LoginScreen
          Positioned(
            top: 10,
            left: -50,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.orange.withOpacity(0.3), width: 3),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: -50,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                  border: Border.all(color: Colors.orange.withOpacity(0.3), width: 3),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Transform.rotate(
              angle: 0.7,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(125),
                  border: Border.all(color: Colors.orange.withOpacity(0.3), width: 3),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Crea tu cuenta',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de Usuario',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6A760), // Color naranja para el botón de registro
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 18, color: Colors.white), // Texto blanco
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login'); // <-- Cambio aquí: vuelve a login
                    },
                    child: const Text(
                      '¿Ya tienes una cuenta? Inicia Sesión',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}