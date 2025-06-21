import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config.dart';

class RekognitionMatch {
  final String externalId;
  final double similarity;

  RekognitionMatch({
    required this.externalId,
    required this.similarity,
  });

  factory RekognitionMatch.fromJson(Map<String, dynamic> json) {
    return RekognitionMatch(
      externalId: json['externalId'],
      similarity: json['similarity'].toDouble(),
    );
  }
}

class RekognitionHttpService {
  //final String baseUrl = 'http://192.168.18.12:8080/api/v1/rekognition';
  final String baseUrl = '${AppConfig.baseUrl}/v1/rekognition';

  /// Buscar coincidencias faciales en una colección
  Future<List<RekognitionMatch>> searchFace({
    required File imageFile,
    required String collectionId,
  }) async {
    final uri = Uri.parse('$baseUrl/search-face/$collectionId');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: _getMediaTypeFromExtension(imageFile.path),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      try {
        final errorJson = jsonDecode(response.body);
        final message =
            errorJson['message'] ?? 'Error al buscar coincidencias.';
        throw Exception(message);
      } catch (_) {
        throw Exception(
            'Error al buscar coincidencias: ${response.statusCode}');
      }
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => RekognitionMatch.fromJson(json)).toList();
  }

  /// Registrar un rostro en la colección (indexar)
  Future<void> indexFace({
    required File imageFile,
    required String collectionId,
    required String externalId,
  }) async {
    final uri =
        Uri.parse('$baseUrl/index-face/$collectionId?externalId=$externalId');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final response = await request.send();

    if (response.statusCode != 200) {
      final body = await http.Response.fromStream(response);
      throw Exception('Error al indexar rostro: ${body.body}');
    }
  }

  /// Determinar el tipo MIME según la extensión del archivo
  MediaType _getMediaTypeFromExtension(String path) {
    final extension = path.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      default:
        return MediaType('application', 'octet-stream'); // por defecto
    }
  }
}
