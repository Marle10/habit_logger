import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Lista simulada de notificaciones
  final List<Map<String, String>> _notifications = [
    {'title': '¡Hábito completado!', 'body': '¡Felicidades por completar tu hábito de hoy!'},
    {'title': 'Recordatorio: Beber Agua', 'body': 'Es hora de hidratarte, ¡no olvides tu hábito de beber agua!'},
    {'title': 'Nuevo Hábito Sugerido', 'body': 'Hemos encontrado un nuevo hábito que podría interesarte: "Meditación diaria".'},
  ];

  void _addNotification() {
    // Función para simular la adición de una nueva notificación
    setState(() {
      _notifications.insert(0, { // Agrega la notificación al principio de la lista
        'title': 'Nueva Notificación',
        'body': 'Esta es una notificación generada por el usuario.',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nueva notificación agregada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EF), // Color de fondo consistente
      appBar: AppBar(
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Color del icono de retroceso
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text(
                'No tienes notificaciones.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: const Icon(Icons.notifications_active, color: Colors.orange),
                    title: Text(
                      notification['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(notification['body']!),
                    onTap: () {
                      // Puedes añadir lógica para manejar la notificación al tocarla
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tocaste la notificación: ${notification['title']}')),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _notifications.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notificación eliminada.')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNotification,
        backgroundColor: const Color(0xFFE6A760), // Color naranja del botón
        child: const Icon(Icons.add_alert, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}