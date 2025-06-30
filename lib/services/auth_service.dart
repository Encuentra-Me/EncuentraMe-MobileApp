import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService {
  //static const String baseUrl = 'http://192.168.18.11:8080'; // Replace with your actual API base URL
  static const String baseUrl = AppConfig.baseUrl;
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    print("tokencito: ${prefs.getString(_tokenKey)}");
    return prefs.getString(_tokenKey);
  }
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    print("userId: ${prefs.getInt(_userIdKey)}");
    return prefs.getInt(_userIdKey);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
 
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json',},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      //print("response.statusCode ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['token'] != null) {
          await _saveToken(responseData['token']);
        }
        if(responseData['userId'] != null) {
          await _saveUserId(responseData['userId']);
        }

        return responseData;

      } else if (response.statusCode == 401) {
        //final errorData = jsonDecode(response.body);
        throw Exception('Credenciales inválidas');//errorData['message'] ?? 'Invalid credentials');
      } else {
        //final errorData = jsonDecode(response.body);
        throw Exception('Error interno de la aplicación');//errorData['message'] ?? 'Internal Server Error');
      }

  }

  Future<bool> isEmailUnique(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/check-email?email=$email'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final bool emailTaken = response.body.toLowerCase() == 'true';
        return emailTaken;
      } else {
        throw Exception('Failed to check email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error verificando email: $e');
    }
  }

  Future<Map<String, dynamic>> registerComplete({
    required String email,
    required String password,
    required String firstName,
    required String paternalLastName,
    required String maternalLastName,
    required String documentType,
    required String documentNumber,
    required String birthDate,
    required String? countryCode,
    required String phone,
    required String? ubigeo,
    required int roleId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'paternalLastName': paternalLastName,
          'maternalLastName': maternalLastName,
          'documentType': documentType,
          'documentNumber': documentNumber,
          'birthDate': birthDate,
          'countryCode': countryCode,
          'phone': phone,
          'ubigeo': ubigeo,
          'roleId': roleId,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Store the token if it's included in the response
        if (responseData['token'] != null) {
          await _saveToken(responseData['token']);
        }
        return responseData;
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error registrando usuario: $e');
    }
  }

  Future<void> logout() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Clear the token after successful logout
        await _clearToken();
      } else {
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    } catch (e) {
      // Clear the token even if the logout request fails
      await _clearToken();
      throw Exception('Error cerrando sesión: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRoles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/roles'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> roles = jsonDecode(response.body);
        return roles.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch roles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error obteniendo roles: $e');
    }
  }
}
