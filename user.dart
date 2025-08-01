// lib/models/user.dart
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String? username; // <-- Debe ser String? para permitir null

  @HiveField(1)
  late String email;

  User({this.username, required this.email}); // Constructor ajustado
}