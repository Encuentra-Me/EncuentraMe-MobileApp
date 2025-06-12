import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report.dart';

class ReportApiService {
  // Asegúrate de que esta IP y puerto coincidan con tu backend Spring Boot en AWS
  final String baseUrl = 'http://192.168.18.12:8080/api/v1/reports';

  Future<List<ReportMP>> getAllReports() async {
    final response = await http.get(Uri.parse(baseUrl));

    print('Response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => ReportMP.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener reportes: ${response.statusCode}');
    }
  }

  Future<void> createReport(ReportMP report) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(report.toMap()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear el reporte: ${response.body}');
    }
  }

  Future<void> deleteReport(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar el reporte: ${response.body}');
    }
  }

  Future<ReportMP> getReportById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return ReportMP.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Reporte no encontrado');
    }
  }

  Future<void> updateReport(int id, ReportMP report) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(report.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el reporte: ${response.body}');
    }
  }
}
