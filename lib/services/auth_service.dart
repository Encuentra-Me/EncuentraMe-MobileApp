import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.18.11:8080'; // Replace with your actual API base URL
  static const String _tokenKey = 'auth_token';

  // Store token after successful login
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get stored token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Clear token on logout
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      //print("response.statusCode ${response.statusCode}");
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Store the token
        if (responseData['token'] != null) {
          await _saveToken(responseData['token']);
        }
        return responseData;
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Invalid credentials');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Internal Server Error');
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Invalid credentials')) {
        throw Exception('Credenciales inválidas');
      }
      throw Exception('Error interno de la aplicación');
    }
  }

  Future<bool> isEmailUnique(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/check-email?email=$email'),
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
      throw Exception('Error checking email: $e');
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
        Uri.parse('$baseUrl/api/auth/register'),
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
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<void> logout() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/logout'),
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
      throw Exception('Error during logout: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRoles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/roles'),
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
      throw Exception('Error fetching roles: $e');
    }
  }
} 