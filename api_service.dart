// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/posts'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Error al cargar los posts de la API: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> createHabit(String title, String body, int userId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'body': body,
        'userId': userId,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al crear el post (hábito): ${response.statusCode}');
    }
  }

  // Este método debe estar presente
  Future<Map<String, dynamic>> registerUser(String? username, String email) async { // username es String? aquí también
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username, // Pasa el username (puede ser null)
        'email': email,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al registrar usuario: ${response.statusCode}');
    }
  }
}