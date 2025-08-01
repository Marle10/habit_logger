// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/habit.dart';
import '../services/api_service.dart';
import 'add_habit_dialog.dart'; // Asumiendo que tienes este diálogo

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;
  List<Habit> _habits = [];
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserDataAndHabits();
  }

  Future<void> _loadUserDataAndHabits() async {
    final userBox = await Hive.openBox<User>('userBox');
    final habitsBox = await Hive.openBox<Habit>('habitsBox');

    setState(() {
      _currentUser = userBox.isNotEmpty ? userBox.getAt(0) : null;
      _habits = habitsBox.values.toList().cast<Habit>();
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final userBox = await Hive.openBox<User>('userBox');
    await userBox.clear(); // Limpia el usuario logueado
    final habitsBox = await Hive.openBox<Habit>('habitsBox');
    await habitsBox.clear(); // Limpia también los hábitos
    Navigator.of(context).pushReplacementNamed('/login'); // Vuelve a la pantalla de login
  }

  Future<void> _addNewHabit(String habitName, String? description) async {
    if (habitName.isEmpty) return;

    final habitsBox = await Hive.openBox<Habit>('habitsBox');
    final newHabit = Habit(
      name: habitName,
      createdAt: DateTime.now(),
      completedDates: [],
      description: description,
    );
    await habitsBox.add(newHabit);
    _loadUserDataAndHabits();

    try {
      // Simula el envío a la API
      final response = await _apiService.createHabit(
        'Nuevo Hábito: $habitName',
        description ?? 'Sin descripción',
        1, // Asumiendo un userId fijo por ahora para la API de prueba
      );
      print('Hábito enviado a API (Post): $response');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hábito "$habitName" creado en API (Post ID: ${response['id'] ?? ''})')),
      );
    } catch (e) {
      print('Error al enviar hábito a API: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al sincronizar el hábito con la API: $e')),
      );
    }
  }

  Future<void> _deleteHabit(int index) async {
    final habitsBox = await Hive.openBox<Habit>('habitsBox');
    await habitsBox.deleteAt(index);
    _loadUserDataAndHabits();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hábito eliminado.')),
    );
  }

  Future<void> _editHabitDescription(int index, String newDescription) async {
    final habitsBox = await Hive.openBox<Habit>('habitsBox');
    final habitToEdit = habitsBox.getAt(index);
    if (habitToEdit != null) {
      habitToEdit.description = newDescription;
      await habitToEdit.save();
      _loadUserDataAndHabits();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descripción del hábito actualizada.')),
      );
    }
  }

  Future<void> _toggleHabitCompletion(int index, bool? isCompleted) async {
    final habitsBox = await Hive.openBox<Habit>('habitsBox');
    final habit = habitsBox.getAt(index);
    if (habit != null) {
      final today = DateTime.now();
      final todayWithoutTime = DateTime(today.year, today.month, today.day);

      if (isCompleted == true) {
        if (!habit.completedDates.any((date) =>
            DateTime(date.year, date.month, date.day) == todayWithoutTime)) {
          habit.completedDates.add(todayWithoutTime);
        }
      } else {
        habit.completedDates.removeWhere((date) =>
            DateTime(date.year, date.month, date.day) == todayWithoutTime);
      }
      await habit.save();
      _loadUserDataAndHabits();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hábito "${habit.name}" ${isCompleted == true ? 'completado' : 'desmarcado'}.')),
      );
    }
  }

  // Se elimina la función _resetHabits, ya no la necesitamos
  // Future<void> _resetHabits() async {
  //   final habitsBox = await Hive.openBox<Habit>('habitsBox');
  //   await habitsBox.clear();
  //   _loadUserDataAndHabits();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Hábitos reiniciados.')),
  //   );
  // }

  Future<void> _fetchApiData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await _apiService.fetchPosts();
      print('Posts obtenidos de API: ${posts.length} posts');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se obtuvieron ${posts.length} posts de la API.')),
      );
    } catch (e) {
      print('Error al obtener datos de API: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener datos de API: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showEditDescriptionDialog(int index, String? currentDescription) {
    final TextEditingController descriptionController = TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Descripción'),
          content: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Nueva descripción'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.black54)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
              ),
              child: const Text('Aceptar'),
              onPressed: () {
                _editHabitDescription(index, descriptionController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min, // <-- Cambio aquí: centrar el Row
          children: [
            // Saludo: "Hola, usuario 👋"
            Row(
              mainAxisSize: MainAxisSize.min, // Para que la fila ocupe el mínimo espacio
              children: [
                Text(
                  'Hola, ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  _currentUser?.username ?? 'usuario',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  '👋',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ],
        ),
        // Aquí es donde se ponen los iconos de la derecha si el title es solo el saludo
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed('/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _logout,
          ),
        ],
      ),
      // --- Fin de refactorización de AppBar ---
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
              ? Center(
                  child: Text(
                    'No tiene hábitos aún.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                      child: Text(
                        'Hábitos',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _habits.length,
                        itemBuilder: (context, index) {
                          final habit = _habits[index];
                          final today = DateTime.now();
                          final todayWithoutTime = DateTime(today.year, today.month, today.day);
                          final isCompletedToday = habit.completedDates.any((date) =>
                              DateTime(date.year, date.month, date.day) == todayWithoutTime);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Checkbox(
                                value: isCompletedToday,
                                onChanged: (bool? newValue) {
                                  _toggleHabitCompletion(index, newValue);
                                },
                                activeColor: Colors.green,
                              ),
                              title: Text(
                                habit.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: habit.description != null && habit.description!.isNotEmpty
                                  ? Text(habit.description!)
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteHabit(index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _showEditDescriptionDialog(index, habit.description);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Botón de Link (izquierdo)
              FloatingActionButton(
                heroTag: "api_call",
                onPressed: _fetchApiData,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                ),
                child: const Icon(Icons.link, color: Colors.black),
              ),
              FloatingActionButton(
                heroTag: "add_habit",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddHabitDialog(
                        onHabitAdded: (name, description) {
                          _addNewHabit(name, description);
                        },
                      );
                    },
                  );
                },
                backgroundColor: const Color(0xFFC7BCEF), // Color morado claro
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.add, color: Colors.black), // <--- Símbolo de +
              ),
            ],
          ),
        ),
      ),
    );
  }
}