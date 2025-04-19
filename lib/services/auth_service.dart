import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.18.11:8080'; // Replace with your actual API base URL

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

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
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
        final bool emailTaken = response.body.toLowerCase() == 'true'; //jsonDecode(response.body)
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
    required String lastName,
    required String phone,
    required String birthDate,
    required String documentType,
    required String documentNumber,
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
          'lastName': lastName,
          'phone': phone,
          'birthDate': birthDate,
          'documentType': documentType,
          'documentNumber': documentNumber,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
} 