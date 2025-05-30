import 'dart:convert';
import 'package:http/http.dart' as http;

/// Modelo para contener un match de Rekognition
class RekognitionMatch {
  final String faceId;
  final String externalImageId;
  final double confidence;

  RekognitionMatch({
    required this.faceId,
    required this.externalImageId,
    required this.confidence,
  });
}

/// Llama a tu endpoint REST y parsea la respuesta
Future<List<RekognitionMatch>> identifyFaces(String key) async {
  final url = Uri.parse(
    'https://mltd978p26.execute-api.us-east-2.amazonaws.com/dev/match',
  );
  final resp = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'bucket': 'encuentreme-bucket-rekognition',
      'key': key, // p.ej. 'faces/12345.jpg'
      'collectionId': 'MiColeccionDesaparecidos',
    }),
  );

  if (resp.statusCode != 200) {
    throw Exception(
      'Error en servidor (${resp.statusCode}): ${resp.body}',
    );
  }

  final data = jsonDecode(resp.body) as Map<String, dynamic>;
  return (data['matches'] as List<dynamic>).map((m) {
    return RekognitionMatch(
      faceId: m['faceId'] as String,
      externalImageId: m['externalImageId'] as String,
      confidence: (m['similarity'] as num).toDouble(),
    );
  }).toList();
}
