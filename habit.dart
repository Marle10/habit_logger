import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String? description; // <-- ¡ESTO ES CLAVE!

  @HiveField(2)
  late DateTime createdAt;

  @HiveField(3)
  late List<DateTime> completedDates;

  Habit({
    required this.name,
    this.description, // <-- ¡Y ESTO TAMBIÉN!
    required this.createdAt,
    this.completedDates = const [],
  });
}