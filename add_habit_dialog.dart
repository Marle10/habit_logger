import 'package:flutter/material.dart';

// Definimos una interfaz (typedef) para el callback
typedef OnHabitAdded = void Function(String name, String? description);

class AddHabitDialog extends StatefulWidget {
  final OnHabitAdded onHabitAdded;

  const AddHabitDialog({
    super.key,
    required this.onHabitAdded,
  });

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _habitNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo hábito'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _habitNameController,
            decoration: const InputDecoration(hintText: 'Nombre del hábito'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(hintText: 'Descripción (Opcional)'),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
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
            final String name = _habitNameController.text.trim();
            // Aseguramos que la descripción sea null si está vacía, de lo contrario String
            final String? description = _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(); // <-- This line is crucial

            if (name.isNotEmpty) {
              widget.onHabitAdded(name, description); // Pass String? to callback
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('El nombre del hábito no puede estar vacío.')),
              );
            }
          },
        ),
      ],
    );
  }
}