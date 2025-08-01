import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'screens/second_page.dart'; // ¡NUEVA IMPORTACIÓN!
import 'models/user.dart'; // Importa User model para Hive adapter
import 'models/habit.dart'; // Importa Habit model para Hive adapter


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Registrar adaptadores de Hive (¡MUY IMPORTANTE!)
  // Asegúrate de que los typeId sean únicos y consistentes.
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(HabitAdapter());
  }

  // Puedes abrir tus cajas aquí si ya sabes cuáles vas a usar
  await Hive.openBox<User>('userBox');
  await Hive.openBox<Habit>('habitsBox'); // Para guardar los hábitos

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Logger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat', // Puedes cambiar por la fuente que uses
        // Puedes definir más estilos de texto, colores, etc. aquí
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/notifications': (context) => const NotificationPage(), // ¡NUEVA RUTA!
      },
    );
  }
}