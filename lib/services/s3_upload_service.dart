import 'dart:io';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:path/path.dart' as path;

Future<String> uploadImageToS3(String filePath) async {
  // Validación: archivo existe
  if (!File(filePath).existsSync()) {
    throw Exception('❌ El archivo no existe: $filePath');
  }

  // Generar nombre limpio y único
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = 'foto_$timestamp.jpg';

  const bucketName = 'encuentreme-bucket-rekognition';
  const region = 'us-east-2';
  const accessKey = 'accesskey, solicitar';
  const secretKey = 'secretKey, solicitar';

  print('🟡 Subiendo archivo: $filePath');
  print('🧾 Nombre generado: $fileName');

  final uploaded = await AwsS3.uploadFile(
    file: File(filePath),
    destDir: 'faces',
    bucket: bucketName,
    region: region,
    accessKey: accessKey,
    secretKey: secretKey,
    metadata: {},
  );

  print('📤 Resultado: $uploaded');

  if (uploaded == null) {
    throw Exception(
        '❌ El SDK aws_s3_upload no pudo subir el archivo (resultado nulo)');
  }

  if (!uploaded.contains('http')) {
    throw Exception('❌ El SDK devolvió un resultado no válido: $uploaded');
  }

  print('✅ Imagen subida correctamente a S3: $uploaded');
  return 'faces/$fileName'; // Esto es lo que espera Rekognition
}
