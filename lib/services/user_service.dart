import 'dart:convert';
import 'package:encuentrame_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:encuentrame_app/models/user.dart';
import '../config.dart';

class UserService {
  final String baseUrl = '${AppConfig.baseUrl}/users';

  final AuthService _authService = AuthService();

  Future<User> getUserById(int id) async {
    
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Usuario no encontrado');
    }
  }
}